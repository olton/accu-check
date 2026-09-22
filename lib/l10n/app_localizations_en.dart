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

  @override
  String get syncError => 'Failed to sync device:';

  @override
  String get scanTitle => 'Select an Accu-Chek to sync';

  @override
  String scanError(Object error) {
    return 'Scan error: $error';
  }

  @override
  String get unknownDevice => 'Unknown device';

  @override
  String deviceSignal(Object rssi) {
    return '$rssi dBm';
  }

  @override
  String get scanEmpty => 'No devices found. Turn on the glucose meter and keep it nearby.';

  @override
  String get usernameRequired => 'Enter a username or e-mail.';

  @override
  String get localSignInFailed => 'Local sign-in failed. Check that biometrics or a device PIN/password is enabled.';

  @override
  String get localSignUpFailed => 'Local registration failed. Check your device biometrics or PIN/password.';

  @override
  String get localAccountResetFailed => 'Failed to reset the local account.';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginHeading => 'Sign in with passkey';

  @override
  String get loginDescription => 'Enter a username/e-mail. Registration and sign-in are performed locally on the device.';

  @override
  String get usernameLabel => 'Username or e-mail';

  @override
  String get displayNameLabel => 'Display name (for signup)';

  @override
  String get authenticating => 'Signing in...';

  @override
  String get signInPasskey => 'Sign in with Passkey';

  @override
  String get createPasskey => 'Create Passkey (signup)';

  @override
  String get accountResetSuccess => 'Local account reset. You can run signup again.';

  @override
  String get accountResetFailed => 'Reset failed.';

  @override
  String get resetLocalAccount => 'Reset local account';

  @override
  String get offlineModeNote => 'Backend-free mode: the account and access verification are stored locally on the device.';

  @override
  String get passkeyNotCreated => 'A local passkey has not been created yet. Run signup first.';

  @override
  String get authReasonSignIn => 'Confirm sign-in to the app';

  @override
  String get authReasonSignUp => 'Confirm creation of the local passkey';

  @override
  String get signupCancelled => 'Registration was cancelled by the user.';

  @override
  String get usernameMismatch => 'Enter the same username that was used during signup.';

  @override
  String get localAuthUnavailable => 'Biometrics or local screen protection are unavailable on this device.';

  @override
  String get androidAuthConfigError => 'Local authentication is unavailable due to the Android screen configuration. Update the app to the latest version.';

  @override
  String get biometricsNotEnrolled => 'Biometrics are not set up on this device. Add a fingerprint/Face ID or use the screen lock PIN/password.';

  @override
  String get passcodeNotSet => 'A screen lock PIN/password is not set on this device.';

  @override
  String get biometricsLocked => 'Biometrics are temporarily locked. Unlock the device with the PIN/password and try again.';

  @override
  String get localAuthNotAvailable => 'Biometrics or local protection are currently unavailable on this device.';

  @override
  String get localAuthFailed => 'Local authentication could not be completed. Check the device biometrics or PIN/password.';

  @override
  String get authCancelled => 'Authentication was cancelled by the user.';
}
