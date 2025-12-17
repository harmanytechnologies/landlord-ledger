import 'dart:async';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../helper/hive_keys.dart';
import '../models/subscription_plan.dart';

class SubscriptionController extends GetxController {
  static const String _planKey = 'current_subscription_tier';
  static const String _purchaseIdKey = 'purchase_id';
  static const String _purchaseTokenKey = 'purchase_token';
  static const String _deviceIdKey = 'device_id';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  final Rx<SubscriptionPlanTier> _currentTier = SubscriptionPlanTier.units1to5.obs;
  final RxBool isAvailable = false.obs;
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  SubscriptionPlanTier get currentTier => _currentTier.value;
  SubscriptionPlan get currentPlan => SubscriptionPlan.fromTier(currentTier);

  @override
  void onInit() {
    super.onInit();
    _loadFromHive();
    if (Platform.isAndroid) {
      _initializeBilling();
    }
  }

  Future<void> _initializeBilling() async {
    final bool available = await _inAppPurchase.isAvailable();
    isAvailable.value = available;

    if (available) {
      loadProducts();
      _subscription = _inAppPurchase.purchaseStream.listen(
        _onPurchaseUpdate,
        onDone: () => _subscription.cancel(),
        onError: (error) {
          errorMessage.value = error.toString();
        },
      );
    }
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final Set<String> productIds = SubscriptionPlan.allPlans.map((plan) => plan.productId).toSet();

      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(productIds);

      if (response.error != null) {
        errorMessage.value = response.error!.message;
        isLoading.value = false;
        return;
      }

      if (response.productDetails.isEmpty) {
        errorMessage.value = 'No products found';
        isLoading.value = false;
        return;
      }

      products.value = response.productDetails;
      isLoading.value = false;
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  Future<void> purchaseSubscription(SubscriptionPlan plan) async {
    if (!isAvailable.value) {
      EasyLoading.showError('In-app purchases are not available');
      return;
    }

    final ProductDetails? productDetails = products.firstWhereOrNull(
      (product) => product.id == plan.productId,
    );

    if (productDetails == null) {
      EasyLoading.showError('Product not found. Please try again.');
      await loadProducts();
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: 'Processing purchase...');

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );

    try {
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );

      if (!success) {
        isLoading.value = false;
        EasyLoading.dismiss();
        EasyLoading.showError('Purchase failed. Please try again.');
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showError('Error: ${e.toString()}');
    }
  }

  Future<void> restorePurchases() async {
    if (!isAvailable.value) {
      EasyLoading.showError('In-app purchases are not available');
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: 'Restoring purchases...');

    try {
      await _inAppPurchase.restorePurchases();
      // The restore will trigger _onPurchaseUpdate
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showError('Error restoring purchases: ${e.toString()}');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
        EasyLoading.show(status: 'Purchase pending...');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          isLoading.value = false;
          EasyLoading.dismiss();
          EasyLoading.showError(
            purchaseDetails.error?.message ?? 'Purchase failed',
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased || purchaseDetails.status == PurchaseStatus.restored) {
          // Verify and process the purchase
          await _handlePurchaseSuccess(purchaseDetails);
        }

        if (Platform.isAndroid) {
          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      }
    }
  }

  Future<void> _handlePurchaseSuccess(PurchaseDetails purchaseDetails) async {
    try {
      // Get the plan from product ID
      final SubscriptionPlan? plan = SubscriptionPlan.fromProductId(purchaseDetails.productID);

      if (plan == null) {
        EasyLoading.showError('Invalid product ID');
        return;
      }

      // Update local subscription tier
      setTier(plan.tier);

      // Save purchase details
      final box = Hive.box(HiveKeys.mainBox);
      box.put(_purchaseIdKey, purchaseDetails.purchaseID);

      if (Platform.isAndroid) {
        final GooglePlayPurchaseDetails? googlePurchase = purchaseDetails as GooglePlayPurchaseDetails?;
        if (googlePurchase != null && googlePurchase.verificationData.serverVerificationData.isNotEmpty) {
          // Store verification data which contains purchase token
          box.put(_purchaseTokenKey, googlePurchase.verificationData.serverVerificationData);
        }
      }

      // Sync with Firebase
      await _syncSubscriptionToFirebase(plan, purchaseDetails);

      isLoading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showSuccess('Subscription activated successfully!');
    } catch (e) {
      isLoading.value = false;
      EasyLoading.dismiss();
      EasyLoading.showError('Error processing purchase: ${e.toString()}');
    }
  }

  Future<void> _syncSubscriptionToFirebase(
    SubscriptionPlan plan,
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      final deviceId = await _getOrCreateDeviceId();

      final Map<String, dynamic> subscriptionData = {
        'device_id': deviceId,
        'tier': plan.tier.index,
        'product_id': plan.productId,
        'purchase_id': purchaseDetails.purchaseID,
        'purchase_date': FieldValue.serverTimestamp(),
        'status': 'active',
      };

      if (Platform.isAndroid) {
        final GooglePlayPurchaseDetails? googlePurchase = purchaseDetails as GooglePlayPurchaseDetails?;
        if (googlePurchase != null && googlePurchase.verificationData.serverVerificationData.isNotEmpty) {
          subscriptionData['purchase_token'] = googlePurchase.verificationData.serverVerificationData;
        }
      }

      await FirebaseFirestore.instance.collection('subscriptions').doc(deviceId).set(subscriptionData, SetOptions(merge: true));
    } catch (e) {
      // Log error but don't fail the purchase
      print('Error syncing to Firebase: $e');
    }
  }

  Future<void> checkSubscriptionStatus() async {
    if (!Platform.isAndroid || !isAvailable.value) {
      return;
    }

    try {
      // Check Firebase for subscription status
      final deviceId = await _getOrCreateDeviceId();

      final doc = await FirebaseFirestore.instance.collection('subscriptions').doc(deviceId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final int? tierIndex = data['tier'] as int?;

        if (tierIndex != null && tierIndex >= 0 && tierIndex < SubscriptionPlanTier.values.length) {
          final tier = SubscriptionPlanTier.values[tierIndex];
          setTier(tier);
        }
      }
    } catch (e) {
      print('Error checking subscription status: $e');
    }
  }

  Future<String> _getOrCreateDeviceId() async {
    try {
      final box = Hive.box(HiveKeys.mainBox);
      final existing = box.get(_deviceIdKey);
      if (existing is String && existing.isNotEmpty) {
        return existing;
      }
      final newId = await AndroidId().getId();
      if (newId != null && newId.isNotEmpty) {
        box.put(_deviceIdKey, newId);
        return newId;
      } else {
        throw Exception("Failed to obtain device ID");
      }
    } catch (e) {
      print('Error getting or creating device ID: $e');
      rethrow;
    }
  }

  void _loadFromHive() {
    final box = Hive.box(HiveKeys.mainBox);
    final stored = box.get(_planKey);
    if (stored is int && stored >= 0 && stored < SubscriptionPlanTier.values.length) {
      _currentTier.value = SubscriptionPlanTier.values[stored];
    }
  }

  void setTier(SubscriptionPlanTier tier) {
    _currentTier.value = tier;
    final box = Hive.box(HiveKeys.mainBox);
    box.put(_planKey, tier.index);
  }

  bool canAddProperty(int currentPropertyCount) {
    return currentPlan.canAddUnit(currentPropertyCount);
  }

  SubscriptionPlan? getNextPlan() {
    final currentIndex = currentTier.index;
    if (currentIndex < SubscriptionPlanTier.values.length - 1) {
      return SubscriptionPlan.fromTier(
        SubscriptionPlanTier.values[currentIndex + 1],
      );
    }
    return null;
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
