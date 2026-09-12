import 'package:accu_check/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AccuCheckApp()));

    expect(find.text('Accu-Check Instant'), findsOneWidget);
    expect(find.text('Завершити стартове налаштування'), findsOneWidget);
  });
}
