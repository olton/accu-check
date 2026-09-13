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
  String get welcomeDescription => 'Sync measurements over Bluetooth and track glucose trends with clear charts.';

  @override
  String get completeSetup => 'Complete initial setup';

  @override
  String get welcomeNote => 'On first launch, registration and sign-in work locally on the device using biometrics or a PIN/password.';

  @override
  String get checklistBluetooth => 'Enable Bluetooth on your smartphone';

  @override
  String get checklistAccount => 'Add a local account through signup';

  @override
  String get checklistSync => 'After signing in, sync measurements from the glucose meter';

  @override
  String get measurements => 'measurements';

  @override
  String get automaticAuthFailed => 'Automatic authorization failed. Please try again.';

  @override
  String get automaticAuthFailedShort => 'Automatic authorization failed.';

  @override
  String get tryAgain => 'Try again';

  @override
  String get last24hours => '24H';

  @override
  String get last7days => '7 days';

  @override
  String get last30days => '30 days';

  @override
  String get trend => 'Trend for';

  @override
  String get glucose => 'Glucose';

  @override
  String get selectPeriod => 'Select period';

  @override
  String get changePeriod => 'Change period';

  @override
  String get lastSync => 'Last sync';

  @override
  String get lastUpdate => 'Last update';

  @override
  String get selectedPeriod => 'For the selected period';

  @override
  String get nothingToShow => 'No measurements.\nSelect a different period or sync the glucose meter.';

  @override
  String get pickerSelectPeriod => 'Select period';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get confirm => 'Apply';

  @override
  String get back => 'Back';

  @override
  String get noData => 'No measurements saved yet.\nTap the Bluetooth icon above to sync.';

  @override
  String get targetMax => 'Target maximum';

  @override
  String get targetMin => 'Target minimum';

  @override
  String get history => 'History';

  @override
  String get historyLoadError => 'Failed to load history';

  @override
  String get last => 'Last';
}
