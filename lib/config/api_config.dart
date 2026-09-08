/// Base URL for the Keja backend. Overridden at build/CI time with:
///   flutter build apk --dart-define=API_BASE_URL=https://api.keja.co.ke
/// Defaults to a local dev server so `flutter run` works out of the box.
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000', // Android emulator -> host machine
  );
}
