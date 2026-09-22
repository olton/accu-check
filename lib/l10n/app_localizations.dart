import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Accu-Check Viewer'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Accu-Check Instant history viewer'**
  String get welcomeTitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Sync measurements over Bluetooth and track glucose trends with clear charts.'**
  String get welcomeDescription;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete initial setup'**
  String get completeSetup;

  /// No description provided for @welcomeNote.
  ///
  /// In en, this message translates to:
  /// **'On first launch, registration and sign-in work locally on the device using biometrics or a PIN/password.'**
  String get welcomeNote;

  /// No description provided for @checklistBluetooth.
  ///
  /// In en, this message translates to:
  /// **'Enable Bluetooth on your smartphone'**
  String get checklistBluetooth;

  /// No description provided for @checklistAccount.
  ///
  /// In en, this message translates to:
  /// **'Add a local account through signup'**
  String get checklistAccount;

  /// No description provided for @checklistSync.
  ///
  /// In en, this message translates to:
  /// **'After signing in, sync measurements from the glucose meter'**
  String get checklistSync;

  /// No description provided for @measurements.
  ///
  /// In en, this message translates to:
  /// **'measurements'**
  String get measurements;

  /// No description provided for @automaticAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Automatic authorization failed. Please try again.'**
  String get automaticAuthFailed;

  /// No description provided for @automaticAuthFailedShort.
  ///
  /// In en, this message translates to:
  /// **'Automatic authorization failed.'**
  String get automaticAuthFailedShort;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @last24hours.
  ///
  /// In en, this message translates to:
  /// **'24H'**
  String get last24hours;

  /// No description provided for @last7days.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get last7days;

  /// No description provided for @last30days.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get last30days;

  /// No description provided for @trend.
  ///
  /// In en, this message translates to:
  /// **'Trend for'**
  String get trend;

  /// No description provided for @glucose.
  ///
  /// In en, this message translates to:
  /// **'Glucose'**
  String get glucose;

  /// No description provided for @selectPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select period'**
  String get selectPeriod;

  /// No description provided for @changePeriod.
  ///
  /// In en, this message translates to:
  /// **'Change period'**
  String get changePeriod;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get lastSync;

  /// No description provided for @lastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get lastUpdate;

  /// No description provided for @selectedPeriod.
  ///
  /// In en, this message translates to:
  /// **'For the selected period'**
  String get selectedPeriod;

  /// No description provided for @nothingToShow.
  ///
  /// In en, this message translates to:
  /// **'No measurements.\nSelect a different period or sync the glucose meter.'**
  String get nothingToShow;

  /// No description provided for @pickerSelectPeriod.
  ///
  /// In en, this message translates to:
  /// **'Select period'**
  String get pickerSelectPeriod;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No measurements saved yet.\nTap the Bluetooth icon above to sync.'**
  String get noData;

  /// No description provided for @targetMax.
  ///
  /// In en, this message translates to:
  /// **'Target maximum'**
  String get targetMax;

  /// No description provided for @targetMin.
  ///
  /// In en, this message translates to:
  /// **'Target minimum'**
  String get targetMin;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get historyLoadError;

  /// No description provided for @last.
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get last;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Failed to sync device:'**
  String get syncError;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Select an Accu-Chek to sync'**
  String get scanTitle;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Scan error: {error}'**
  String scanError(Object error);

  /// No description provided for @unknownDevice.
  ///
  /// In en, this message translates to:
  /// **'Unknown device'**
  String get unknownDevice;

  /// No description provided for @deviceSignal.
  ///
  /// In en, this message translates to:
  /// **'{rssi} dBm'**
  String deviceSignal(Object rssi);

  /// No description provided for @scanEmpty.
  ///
  /// In en, this message translates to:
  /// **'No devices found. Turn on the glucose meter and keep it nearby.'**
  String get scanEmpty;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a username or e-mail.'**
  String get usernameRequired;

  /// No description provided for @localSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Local sign-in failed. Check that biometrics or a device PIN/password is enabled.'**
  String get localSignInFailed;

  /// No description provided for @localSignUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Local registration failed. Check your device biometrics or PIN/password.'**
  String get localSignUpFailed;

  /// No description provided for @localAccountResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset the local account.'**
  String get localAccountResetFailed;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginHeading.
  ///
  /// In en, this message translates to:
  /// **'Sign in with passkey'**
  String get loginHeading;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a username/e-mail. Registration and sign-in are performed locally on the device.'**
  String get loginDescription;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username or e-mail'**
  String get usernameLabel;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name (for signup)'**
  String get displayNameLabel;

  /// No description provided for @authenticating.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get authenticating;

  /// No description provided for @signInPasskey.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Passkey'**
  String get signInPasskey;

  /// No description provided for @createPasskey.
  ///
  /// In en, this message translates to:
  /// **'Create Passkey (signup)'**
  String get createPasskey;

  /// No description provided for @accountResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Local account reset. You can run signup again.'**
  String get accountResetSuccess;

  /// No description provided for @accountResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset failed.'**
  String get accountResetFailed;

  /// No description provided for @resetLocalAccount.
  ///
  /// In en, this message translates to:
  /// **'Reset local account'**
  String get resetLocalAccount;

  /// No description provided for @offlineModeNote.
  ///
  /// In en, this message translates to:
  /// **'Backend-free mode: the account and access verification are stored locally on the device.'**
  String get offlineModeNote;

  /// No description provided for @passkeyNotCreated.
  ///
  /// In en, this message translates to:
  /// **'A local passkey has not been created yet. Run signup first.'**
  String get passkeyNotCreated;

  /// No description provided for @authReasonSignIn.
  ///
  /// In en, this message translates to:
  /// **'Confirm sign-in to the app'**
  String get authReasonSignIn;

  /// No description provided for @authReasonSignUp.
  ///
  /// In en, this message translates to:
  /// **'Confirm creation of the local passkey'**
  String get authReasonSignUp;

  /// No description provided for @signupCancelled.
  ///
  /// In en, this message translates to:
  /// **'Registration was cancelled by the user.'**
  String get signupCancelled;

  /// No description provided for @usernameMismatch.
  ///
  /// In en, this message translates to:
  /// **'Enter the same username that was used during signup.'**
  String get usernameMismatch;

  /// No description provided for @localAuthUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics or local screen protection are unavailable on this device.'**
  String get localAuthUnavailable;

  /// No description provided for @androidAuthConfigError.
  ///
  /// In en, this message translates to:
  /// **'Local authentication is unavailable due to the Android screen configuration. Update the app to the latest version.'**
  String get androidAuthConfigError;

  /// No description provided for @biometricsNotEnrolled.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are not set up on this device. Add a fingerprint/Face ID or use the screen lock PIN/password.'**
  String get biometricsNotEnrolled;

  /// No description provided for @passcodeNotSet.
  ///
  /// In en, this message translates to:
  /// **'A screen lock PIN/password is not set on this device.'**
  String get passcodeNotSet;

  /// No description provided for @biometricsLocked.
  ///
  /// In en, this message translates to:
  /// **'Biometrics are temporarily locked. Unlock the device with the PIN/password and try again.'**
  String get biometricsLocked;

  /// No description provided for @localAuthNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometrics or local protection are currently unavailable on this device.'**
  String get localAuthNotAvailable;

  /// No description provided for @localAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Local authentication could not be completed. Check the device biometrics or PIN/password.'**
  String get localAuthFailed;

  /// No description provided for @authCancelled.
  ///
  /// In en, this message translates to:
  /// **'Authentication was cancelled by the user.'**
  String get authCancelled;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'uk': return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
