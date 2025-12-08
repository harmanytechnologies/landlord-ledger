# Landlord Ledger

A Flutter application for landlords and property managers to track properties, tenants, expenses, ledgers, and reminders.

---

## Development Instructions

### How to Rebuild AAB (Android App Bundle)

1. **Build the AAB**:
   ```bash
   flutter build appbundle --release
   ```

2. **Find the AAB file**:
   - The generated AAB will be located at: `build/app/outputs/bundle/release/app-release.aab`

---

### How to Update App Icon

1. **Prepare your icon image**:
   - Create a single icon image (recommended: 1024x1024 pixels)
   - Save it as `assets/images/logo.png`

3. **Generate icons**:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```
   - This will automatically generate all required icon sizes for both Android and iOS

4. **Update notification icon** :
   - Replace `android/app/src/main/res/drawable/app_icon.png` with your notification icon
---

### How to Change Package Name


2. **Run the rename command**:
   ```bash
   flutter pub run rename setBundleId --bundleId com.yournewpackagename
   ```
   - Replace `com.yournewpackagename` with your desired package name
   - Example: `flutter pub run rename setBundleId --bundleId com.example.myapp`

---

### How to Edit Screens or Text

1. **Find the screen file**:
   - All screen files are located in `lib/views/` directory
   - Structure:
     - `lib/views/properties/` - Property-related screens
     - `lib/views/tenants/` - Tenant-related screens
     - `lib/views/expenses/` - Expense-related screens
     - `lib/views/ledgers/` - Ledger-related screens
     - `lib/views/reminders/` - Reminder-related screens

2. **Edit text content**:
   - Open the desired screen file (e.g., `property_list_view.dart`)
   - Find the `Text()` widget with the text you want to change
   - Update the string value directly in the code
   - Example:
     ```dart
     Text('Your New Text Here')
     ```

3. **Edit screen layout**:
   - Modify widgets, add/remove UI elements
   - Change colors in `lib/helper/colors.dart`
   - Update theme in `lib/helper/theme.dart`

4. **Common text locations**:
   - App title: `lib/views/properties/property_list_view.dart` (AppBar)
   - Button labels: Search for `Text('Button Label')` in respective view files
   - Form labels: Check form view files (e.g., `property_form_view.dart`)
   - Empty state messages: Look for "No X" or "Empty" text in list views

5. **Hot reload**:
   - After making changes, use hot reload (`r` in terminal) or hot restart (`R`)
   - Or save the file and the app will automatically reload

---

## Project Structure

```
lib/
├── bindings/          # GetX route bindings
├── controllers/       # State management controllers
├── helper/            # Utilities, colors, theme
├── models/            # Data models
├── views/             # UI screens
│   ├── properties/    # Property screens
│   ├── tenants/       # Tenant screens
│   ├── expenses/     # Expense screens
│   ├── ledgers/       # Ledger screens
│   └── reminders/    # Reminder screens
└── widgets/           # Reusable widgets
```

---

## Notes

- The app uses **Hive** for local data storage
- **GetX** is used for state management and routing
- Notifications are handled via **flutter_local_notifications**
- All data is stored locally (no API calls)
