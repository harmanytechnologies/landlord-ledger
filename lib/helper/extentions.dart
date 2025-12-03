// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// extension FirestoreDocumentExtension on DocumentReference {
//   Future<DocumentSnapshot> getDocumentStream() async {
//     try {
//       DocumentSnapshot? ds = await this.get(GetOptions(source: Source.cache));
//       if (ds == null) return this.get(GetOptions(source: Source.server));
//       return ds;
//     } catch (_) {
//       return this.get(GetOptions(source: Source.server));
//     }
//   }
// }

// extension FirestoreQueryExtension on Query {
//   Future<QuerySnapshot> getCollectionStream() async {
//     try {
//       QuerySnapshot qs = await this.get(GetOptions(source: Source.cache));
//       if (qs.docs.isEmpty) return this.get(GetOptions(source: Source.server));
//       return qs;
//     } catch (_) {
//       return this.get(GetOptions(source: Source.server));
//     }
//   }
// }

// extension StringExtension on String {
//     String capitalize() {
//       return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
//     }
// }
