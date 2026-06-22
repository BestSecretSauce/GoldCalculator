class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://gold-calculator-api-iy4k.onrender.com',
  );
}
