// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Accu-Check Viewer';

  @override
  String get welcomeTitle => 'Accu-Check Instant history viewer';

  @override
  String get welcomeDescription =>
      'Sync measurements over Bluetooth and track glucose trends with clear charts.';

  @override
  String get completeSetup => 'Complete initial setup';

  @override
  String get welcomeNote =>
      'On first launch, registration and sign-in work locally on the device using biometrics or a PIN/password.';

  @override
  String get checklistBluetooth => 'Enable Bluetooth on your smartphone';

  @override
  String get checklistAccount => 'Add a local account through signup';

  @override
  String get checklistSync =>
      'After signing in, sync measurements from the glucose meter';

  @override
  String get automaticAuthFailed =>
      'Automatic authorization failed. Please try again.';

  @override
  String get automaticAuthFailedShort => 'Automatic authorization failed.';

  @override
  String get tryAgain => 'Try again';
}
