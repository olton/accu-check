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
  String get welcomeDescription =>
      'Синхронізуйте вимірювання через Bluetooth та відстежуйте динаміку глюкози на зрозумілих графіках.';

  @override
  String get completeSetup => 'Завершити стартове налаштування';

  @override
  String get welcomeNote =>
      'Перший запуск: реєстрація та вхід працюють локально на девайсі через біометрію або PIN/пароль.';

  @override
  String get checklistBluetooth => 'Увімкніть Bluetooth на смартфоні';

  @override
  String get checklistAccount => 'Додайте локальний акаунт через signup';

  @override
  String get checklistSync =>
      'Після входу синхронізуйте вимірювання з глюкометра';

  @override
  String get automaticAuthFailed =>
      'Не вдалося виконати автоматичну авторизацію. Спробуйте ще раз.';

  @override
  String get automaticAuthFailedShort =>
      'Не вдалося виконати автоматичну авторизацію.';

  @override
  String get tryAgain => 'Спробувати ще раз';
}
