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
}
