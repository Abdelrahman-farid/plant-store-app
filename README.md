# 🌱 Plant Store App (Flutter)

A beautiful and modern plant shopping application built with **Flutter**. Browse plants by category, manage your favorites, shop with ease, and customize your profile - all within a clean green-themed interface.

## 📥 Download APK

**[Download Latest Release (v1.0.0)](https://github.com/Abdelrahman-farid/plant-store-app/releases/download/v1.0.0/app-release.apk)**

### ✅ Latest Stability Update (v1.0.2)
- Fixed removing items from cart
- Fixed subtotal updates after cart changes
- Stabilized checkout navigation flow (address/payment/cart -> checkout)
- Fixed immediate UI update after removing favorites (no need to reopen page)
- Fixed cart visibility for items added from the legacy product details flow

---

## ⚠️ Current Limitations (Important)

- **Email/Password Sign In and Sign Up are in demo mode** right now. The buttons currently navigate to the app directly (Firebase email/password call is disabled in UI code).
- **Forgot Password screen is UI-only** at the moment (reset action is not connected to backend logic).
- **Address map is a simulated picker**, not a live Google Maps integration yet.
- **Real payment gateway is not integrated**. Saved cards are local app data for UI/demo flow.
- **Checkout review does not support quantity +/- controls** yet (quantity updates are currently done from Cart page).
- **Map/Billing note**: Enabling production map services may require a billing-enabled account/card in USD depending on provider setup.

---

## ✨ Features

### 🔐 Authentication
- **Sign In / Sign Up** with email and password (currently demo mode)
- **Google Sign-In** integration
- **Guest Mode** for browsing without authentication
- **Forgot Password** functionality (backend reset flow not connected yet)

### 🏠 Home & Browse
- **Category Filtering**: Browse plants by Indoor, Outdoor, Garden, or Recommended
- **Beautiful UI**: Clean green theme (#296e48) with smooth animations
- **Product Cards**: View plant images, names, prices, and ratings
- **Add to Favorites**: Heart icon to save your favorite plants

### 🔍 Advanced Search
- **Search Bar**: Find plants by name
- **Category Filter**: Filter by All, Indoor, Outdoor, Garden, Recommended
- **Sort Options**: Sort by Name, Price (Low to High), Price (High to Low), Rating
- **Price Range Slider**: Filter plants from $0 to $100
- **Real-time Filtering**: Instant results as you type
- **Reset Filters**: Clear all filters with one tap

### 🛒 Shopping Cart
- **Add to Cart**: Add plants with quantity selection
- **Remove Items**: Delete products from cart
- **Subtotal Calculation**: Real-time price updates
- **Checkout**: Complete checkout flow with address and payment

### ❤️ Favorites
- **Wishlist Management**: Save your favorite plants
- **Quick Access**: View all favorites in one place
- **Add/Remove**: Toggle favorite status from any screen

### 👤 Profile & Settings
- **Profile Photo**: Edit photo from camera or gallery
- **Edit Name & Email**: Update profile information
- **My Orders**: View shopping history
- **Addresses**: Manage shipping addresses
- **Payment Methods**: Store payment information
- **Settings**: App preferences and configurations
- **Notifications Toggle**: Enable/disable notifications
- **Data Persistence**: All profile data saved locally

## 🧰 Tech Stack

- **Flutter** (Material Design 3)
- **State Management**: `flutter_bloc` (Cubit pattern)
- **Firebase**:
  - `firebase_core` (v4.4.0)
  - `firebase_auth` (v6.1.4)
  - `cloud_firestore`
  - `firebase_messaging`
- **Authentication**:
  - `google_sign_in` (v7.2.0)
  - `flutter_facebook_auth` (v7.1.5)
- **UI & UX**:
  - `animated_bottom_navigation_bar` (v1.3.3)
  - `page_transition` (v2.1.0)
- **Media & Storage**:
  - `image_picker` (v1.0.7)
  - `shared_preferences` (v2.2.2)
- **Other Features**:
  - `url_launcher` (v6.2.5)
  - `share_plus` (v7.2.2)
  - `mobile_scanner` (v5.2.3)

## 🏗️ Project Structure

```
lib/
├── main.dart                       # App entry point + Firebase initialization
├── firebase_options.dart           # Firebase configuration
├── models/
│   ├── plants.dart                # Plant data model
│   ├── add_to_card_model.dart     # Cart model
│   └── product_item_model.dart    # Product model
├── services/
│   ├── auth_serviecies.dart       # Authentication services
│   ├── fire_store_serviecies.dart # Firestore operations
│   └── home_servecies.dart        # Home page services
├── view_models/                   # BLoC/Cubit state management
│   ├── auth_cubit/               # Authentication state
│   ├── cart_cubit/               # Shopping cart state
│   ├── favourite_cubit/          # Favorites state
│   └── ...
├── utilies/
│   ├── constants.dart            # App constants (colors, strings)
│   ├── app_router.dart           # Navigation routes
│   └── app_colors.dart           # Color palette
└── views/
    ├── pages/
    │   ├── signin_page.dart      # Login screen
    │   ├── signup_page.dart      # Registration screen
    │   ├── home_page.dart        # Browse plants by category
    │   ├── search_page.dart      # Advanced search & filters
    │   ├── favorite_page.dart    # Wishlist
    │   ├── cart_page.dart        # Shopping cart
    │   ├── profile_page.dart     # User profile & settings
    │   ├── plant_checkout_page.dart  # Checkout flow
    │   └── root_page.dart        # Main navigation
    └── widgets/
        ├── plant_widget.dart     # Plant card component
        ├── profile_widget.dart   # Profile options widget
        └── custom_textfield.dart # Custom input field
```

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (stable channel)
- **Dart SDK**
- **Android Studio** or **VS Code** with Flutter extensions
- **Android Emulator** or physical Android device

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/Abdelrahman-farid/plant-store-app.git
cd plant-store-app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Building APK

To build a release APK:
```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## 🔥 Firebase Setup (Optional)

This app is configured to work without Firebase authentication (guest mode). However, if you want to enable full Firebase features:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password, Google, Facebook)
3. Download `google-services.json` and place in `android/app/`
4. Run FlutterFire CLI to regenerate `firebase_options.dart`:
```bash
flutterfire configure
```

## 🎨 App Theme

- **Primary Color**: Green (#296e48) - representing nature and plants
- **Design Style**: Modern, clean, minimalist
- **Navigation**: Animated bottom navigation bar with floating action button
- **Typography**: Material Design 3 text styles

## 📱 Screenshots

The app features:
- 🌿 Beautiful plant cards with images
- 💚 Green nature-inspired theme
- 🎯 Smooth category switching
- 🔍 Comprehensive search and filtering
- 📸 Camera/gallery integration for profile photos
- ✨ Smooth animations and transitions

## 🤝 Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m "Add my feature"`)
4. Push (`git push origin feature/my-feature`)
5. Open a Pull Request

## 👨‍💻 Author

**Abdelrahman Farid**
- GitHub: https://github.com/Abdelrahman-farid

