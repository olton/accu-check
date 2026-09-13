import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/auth/passkey_auth_service.dart';
import 'features/history/history_page.dart';
import 'features/auth/login_page.dart';

import 'l10n/app_localizations.dart';

final _secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final _onboardingDoneProvider = FutureProvider<bool>((ref) async {
  final storage = ref.watch(_secureStorageProvider);
  final value = await storage.read(key: 'accu_check.onboarding_done.v1');
  return value == 'true';
});

final _startupAuthProvider = FutureProvider<_StartupAuthState>((ref) async {
  final service = ref.watch(passkeyAuthServiceProvider);
  final hasLocalAccount = await service.hasLocalAccount();
  if (!hasLocalAccount) {
    return const _StartupAuthState(showLogin: true);
  }

  try {
    final session = await service.signInWithSavedAccount();
    return _StartupAuthState(session: session);
  } on PasskeyAuthCancelledException {
    return const _StartupAuthState(showLogin: true);
  } on PasskeySetupException catch (error) {
    return _StartupAuthState(errorMessage: error.message);
  } catch (_) {
    return const _StartupAuthState();
  }
});

class AccuCheckApp extends ConsumerWidget {
  const AccuCheckApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return MaterialApp(
      title: l10n.appTitle,
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
      data: (done) => done ? const _StartupAuthPage() : const WelcomePage(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const WelcomePage(),
    );
  }
}

class _StartupAuthState {
  const _StartupAuthState({
    this.showLogin = false,
    this.session,
    this.errorMessage,
  });

  final bool showLogin;
  final PasskeySession? session;
  final String? errorMessage;
}

class _StartupAuthPage extends ConsumerWidget {
  const _StartupAuthPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final startupAuth = ref.watch(_startupAuthProvider);

    return startupAuth.when(
      data: (state) {
        if (state.showLogin) {
          return const LoginPage();
        }

        if (state.session != null) {
          return HistoryPage(session: state.session!);
        }

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage ?? l10n.automaticAuthFailedShort,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF7A3A1D)),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.invalidate(_startupAuthProvider),
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, _) => const LoginPage(),
    );
  }
}

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

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
                Text(
                  l10n.welcomeTitle,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                    color: Color(0xFF143B39),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.welcomeDescription,
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
                    child: Text(l10n.completeSetup),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.welcomeNote,
                  style: TextStyle(fontSize: 12, color: Color(0xFF5E7A78)),
                ),
                const SizedBox(height: 12),
                _OnboardingChecklist(
                  items: [
                    l10n.checklistBluetooth,
                    l10n.checklistAccount,
                    l10n.checklistSync,
                  ],
                ),
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
  const _OnboardingChecklist({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => _ChecklistItem(text: item))
          .toList(growable: false),
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
