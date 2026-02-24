/// Demo-mode toggles and constants.
///
/// Enable with: `flutter run --dart-define=DEMO_MODE=true`
const bool kDemoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);

const String kDemoUserId = 'demo-user';
const String kDemoDisplayName = 'Demo User';
const String kDemoEmail = 'demo@example.com';
