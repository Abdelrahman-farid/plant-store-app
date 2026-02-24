# 🛒 E-Commerce Application (Flutter)

A modern e-commerce mobile application built with **Flutter**, showcasing a full shopping experience: authentication, product browsing, favorites, cart, checkout, profile management, addresses, and payment methods.

## 🎥 Demo

- YouTube video: https://youtu.be/g6_bvhLJfEM

## ✨ Features

### Core Features
- **Authentication**: Email/Password + Google Sign-In + Facebook Sign-In
- **Browse Products**: Home feed + categories + product listing
- **Product Details**: Images, price, and details screen
- **Favorites (Wishlist)**: Add/remove products from favorites
- **Cart**: Add products, update quantities, view subtotal
- **Checkout Flow**:
  - Choose shipping address
  - Choose payment method
  - View order summary

### Profile & Account
- **Profile page** with quick actions
- **Edit Profile** dialog
- **My Orders** page
- **Addresses** management
- **Payment Methods** management
- **Settings / Help Center / About / Recently Viewed** pages

### Notifications
- **Firebase Cloud Messaging (FCM)**
  - Foreground notifications are shown using a dialog
  - When a notification includes `product_id`, the app navigates to product details

## 🧰 Tech Stack

- **Flutter** (Material 3)
- **State Management**: `flutter_bloc` (Cubit)
- **Firebase**:
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `firebase_messaging`
- **Other Packages**:
  - `cached_network_image` (images)
  - `shared_preferences` (local persistence for some features)

## 🏗️ Project Structure

```
lib/
├── main.dart                       # App entry point + Firebase init + FCM handling
├── firebase_options.dart           # FlutterFire generated options
├── models/                         # App data models
├── services/                       # Firebase / storage / business services
├── view_models/                    # Cubits (BLoC) and states
├── utilies/                        # Router, routes, constants, helpers
└── views/
    ├── pages/                      # UI screens (home, cart, checkout, profile, etc.)
    ├── widgets/                    # Reusable UI widgets
    └── dialogs/                    # Dialogs (e.g., edit profile)
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable)
- Dart SDK
- Android Studio / VS Code
- Android emulator or physical device

### Installation
1. Clone the repository

```bash
git clone https://github.com/Abdelrahman-farid/ecommerce-application.git
cd ecommerce-application
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the app

```bash
flutter run
```

## 🔥 Firebase Setup (Important)

This project uses Firebase.

- Android config file: `android/app/google-services.json`
- iOS config file (if enabled): `ios/Runner/GoogleService-Info.plist`

If you fork the project or use your own Firebase project, re-run FlutterFire and generate new `firebase_options.dart`.

## 🤝 Contributing

1. Fork the repository
2. Create a new branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m "Add my feature"`)
4. Push (`git push origin feature/my-feature`)
5. Open a Pull Request

## 👨‍💻 Author

**Abdelrahman Farid**
- GitHub: https://github.com/Abdelrahman-farid

