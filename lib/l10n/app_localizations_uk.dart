// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Accu-Check Viewer';

  @override
  String get welcomeTitle => 'Accu-Check Instant перегляд історії';

  @override
  String get welcomeDescription => 'Синхронізуйте вимірювання через Bluetooth та відстежуйте динаміку глюкози на зрозумілих графіках.';

  @override
  String get completeSetup => 'Завершити стартове налаштування';

  @override
  String get welcomeNote => 'Перший запуск: реєстрація та вхід працюють локально на девайсі через біометрію або PIN/пароль.';

  @override
  String get checklistBluetooth => 'Увімкніть Bluetooth на смартфоні';

  @override
  String get checklistAccount => 'Додайте локальний акаунт через signup';

  @override
  String get checklistSync => 'Після входу синхронізуйте вимірювання з глюкометра';

  @override
  String get measurements => 'вимірювань';

  @override
  String get automaticAuthFailed => 'Не вдалося виконати автоматичну авторизацію. Спробуйте ще раз.';

  @override
  String get automaticAuthFailedShort => 'Не вдалося виконати автоматичну авторизацію.';

  @override
  String get tryAgain => 'Спробувати ще раз';

  @override
  String get last24hours => '24Г';

  @override
  String get last7days => '7 днів';

  @override
  String get last30days => '30 днів';

  @override
  String get trend => 'Тренд за';

  @override
  String get glucose => 'Глюкоза';

  @override
  String get selectPeriod => 'Вибрати період';

  @override
  String get changePeriod => 'Змінити період';

  @override
  String get lastSync => 'Остання синхронізація';

  @override
  String get lastUpdate => 'Останнє оновлення';

  @override
  String get selectedPeriod => 'За обраний період';

  @override
  String get nothingToShow => 'вимірювань немає.\nОберіть інший період або синхронізуйте глюкометр.';

  @override
  String get pickerSelectPeriod => 'Оберіть період';

  @override
  String get cancel => 'Скасувати';

  @override
  String get ok => 'ОК';

  @override
  String get confirm => 'Застосувати';

  @override
  String get back => 'Назад';

  @override
  String get noData => 'Ще немає збережених вимірювань.\nНатисніть іконку Bluetooth зверху для синхронізації.';

  @override
  String get targetMax => 'Цільовий максимум';

  @override
  String get targetMin => 'Цільовий мінімум';

  @override
  String get history => 'Історія';

  @override
  String get historyLoadError => 'Помилка завантаження історії';

  @override
  String get last => 'Останні';

  @override
  String get syncError => 'Не вдалося синхронізувати пристрій:';

  @override
  String get scanTitle => 'Оберіть Accu-Chek для синхронізації';

  @override
  String scanError(Object error) {
    return 'Помилка сканування: $error';
  }

  @override
  String get unknownDevice => 'Невідомий пристрій';

  @override
  String deviceSignal(Object rssi) {
    return '$rssi дБм';
  }

  @override
  String get scanEmpty => 'Пристрої не знайдено. Увімкніть глюкометр і тримайте його поруч.';

  @override
  String get usernameRequired => 'Вкажіть username або e-mail.';

  @override
  String get localSignInFailed => 'Локальний вхід не завершився. Перевірте, що на пристрої увімкнено біометрію або PIN/пароль.';

  @override
  String get localSignUpFailed => 'Локальну реєстрацію не завершено. Перевірте біометрію або PIN/пароль пристрою.';

  @override
  String get localAccountResetFailed => 'Не вдалося скинути локальний акаунт.';

  @override
  String get loginTitle => 'Вхід';

  @override
  String get loginHeading => 'Увійдіть через passkey';

  @override
  String get loginDescription => 'Вкажіть username/e-mail. Реєстрація та вхід виконуються локально на пристрої.';

  @override
  String get usernameLabel => 'Username або e-mail';

  @override
  String get displayNameLabel => 'Display name (для signup)';

  @override
  String get authenticating => 'Авторизація...';

  @override
  String get signInPasskey => 'Увійти по Passkey';

  @override
  String get createPasskey => 'Створити Passkey (signup)';

  @override
  String get accountResetSuccess => 'Локальний акаунт скинуто. Можна виконати signup знову.';

  @override
  String get accountResetFailed => 'Скидання не вдалося.';

  @override
  String get resetLocalAccount => 'Скинути локальний акаунт';

  @override
  String get offlineModeNote => 'Режим без бекенда: обліковий запис і перевірка доступу зберігаються локально на девайсі.';

  @override
  String get passkeyNotCreated => 'Локальний passkey ще не створений. Спочатку виконайте signup.';

  @override
  String get authReasonSignIn => 'Підтвердіть вхід у застосунок';

  @override
  String get authReasonSignUp => 'Підтвердіть створення локального passkey';

  @override
  String get signupCancelled => 'Реєстрацію скасовано користувачем.';

  @override
  String get usernameMismatch => 'Для входу вкажіть той самий username, що використовувався при signup.';

  @override
  String get localAuthUnavailable => 'На цьому пристрої недоступна біометрія/локальний захист екрану.';

  @override
  String get androidAuthConfigError => 'Локальна авторизація недоступна через конфігурацію Android-екрана. Оновіть застосунок до останньої версії.';

  @override
  String get biometricsNotEnrolled => 'На пристрої не налаштовано біометрію. Додайте відбиток/Face ID або використайте PIN/пароль екрана блокування.';

  @override
  String get passcodeNotSet => 'На пристрої не встановлено PIN/пароль екрана блокування.';

  @override
  String get biometricsLocked => 'Біометрію тимчасово заблоковано. Розблокуйте пристрій PIN/паролем і спробуйте знову.';

  @override
  String get localAuthNotAvailable => 'Біометрія або локальний захист зараз недоступні на цьому пристрої.';

  @override
  String get localAuthFailed => 'Не вдалося завершити локальну авторизацію. Перевірте біометрію або PIN/пароль пристрою.';

  @override
  String get authCancelled => 'Авторизацію скасовано користувачем.';
}
