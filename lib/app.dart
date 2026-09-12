import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'features/auth/login_page.dart';

final _secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final _onboardingDoneProvider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(_secureStorageProvider);
  final value = await storage.read(key: 'accu_check.onboarding_done.v1');
  return value == 'true';
});

class AccuCheckApp extends ConsumerWidget {
  const AccuCheckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Accu-Check Sync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A6B63),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F8),
        fontFamily: 'Georgia',
      ),
      home: const _BootstrapPage(),
    );
  }
}

class _BootstrapPage extends ConsumerWidget {
  const _BootstrapPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboarding = ref.watch(_onboardingDoneProvider);

    return onboarding.when(
      data: (done) => done ? const LoginPage() : const WelcomePage(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const WelcomePage(),
    );
  }
}

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF6F4), Color(0xFFD8EEF0), Color(0xFFF4F7F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  'Accu-Check Instant',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: Color(0xFF143B39),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Синхронізуйте вимірювання через Bluetooth та відстежуйте динаміку глюкози на зрозумілих графіках.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF315B58),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      await ref
                          .read(_secureStorageProvider)
                          .write(
                            key: 'accu_check.onboarding_done.v1',
                            value: 'true',
                          );

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF0A6B63),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Завершити стартове налаштування'),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Перший запуск: реєстрація та вхід працюють локально на девайсі через біометрію або PIN/пароль.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF5E7A78)),
                ),
                const SizedBox(height: 12),
                const _OnboardingChecklist(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingChecklist extends StatelessWidget {
  const _OnboardingChecklist();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChecklistItem(text: 'Увімкніть Bluetooth на смартфоні'),
        _ChecklistItem(text: 'Додайте локальний акаунт через signup'),
        _ChecklistItem(
          text: 'Після входу синхронізуйте вимірювання з глюкометра',
        ),
      ],
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle_outline,
              size: 16,
              color: Color(0xFF0A6B63),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF315B58),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
