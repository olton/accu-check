import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../history/history_page.dart';
import 'passkey_auth_service.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthUiState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() {
    return const AuthUiState();
  }

  Future<void> signInWithPasskey(String username) async {
    if (username.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Вкажіть username або e-mail.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final service = ref.read(passkeyAuthServiceProvider);
      final session = await service.signIn(username: username);
      state = state.copyWith(isLoading: false, session: session);
    } on PasskeySetupException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Локальний вхід не завершився. Перевірте, що на пристрої увімкнено біометрію або PIN/пароль.',
      );
    }
  }

  Future<void> signUpWithPasskey({
    required String username,
    required String displayName,
  }) async {
    if (username.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Вкажіть username або e-mail.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final service = ref.read(passkeyAuthServiceProvider);
      final session = await service.signUp(
        username: username,
        displayName: displayName,
      );
      state = state.copyWith(isLoading: false, session: session);
    } on PasskeySetupException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Локальну реєстрацію не завершено. Перевірте біометрію або PIN/пароль пристрою.',
      );
    }
  }

  void continueInDemoMode(String username) {
    final normalized = username.trim().isEmpty ? 'Demo User' : username.trim();
    state = state.copyWith(
      session: PasskeySession(userId: 'demo-user', displayName: normalized),
      errorMessage: null,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> resetLocalAccount() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final service = ref.read(passkeyAuthServiceProvider);
      await service.resetLocalAccount();
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Не вдалося скинути локальний акаунт.',
      );
      return false;
    }
  }
}

class AuthUiState {
  const AuthUiState({this.isLoading = false, this.errorMessage, this.session});

  final bool isLoading;
  final String? errorMessage;
  final PasskeySession? session;

  AuthUiState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    PasskeySession? session,
  }) {
    return AuthUiState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      session: session ?? this.session,
    );
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _displayNameController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthUiState>(authControllerProvider, (previous, next) {
      final session = next.session;
      if (session == null || previous?.session == session) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => HistoryPage(session: session)),
      );
    });

    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Увійдіть через passkey',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF143B39),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Вкажіть username/e-mail. Реєстрація та вхід виконуються локально на пристрої.',
              style: TextStyle(fontSize: 14, color: Color(0xFF5A7572)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Username або e-mail',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display name (для signup)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithPasskey(_usernameController.text.trim());
                      },
                icon: const Icon(Icons.fingerprint),
                label: Text(
                  state.isLoading ? 'Авторизація...' : 'Увійти по Passkey',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0A6B63),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: state.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        final displayName =
                            _displayNameController.text.trim().isEmpty
                            ? _usernameController.text.trim()
                            : _displayNameController.text.trim();

                        ref
                            .read(authControllerProvider.notifier)
                            .signUpWithPasskey(
                              username: _usernameController.text.trim(),
                              displayName: displayName,
                            );
                      },
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Створити Passkey (signup)'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: state.isLoading
                    ? null
                    : () {
                        ref
                            .read(authControllerProvider.notifier)
                            .continueInDemoMode(_usernameController.text);
                      },
                child: const Text('Продовжити в демо-режимі'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final ok = await ref
                            .read(authControllerProvider.notifier)
                            .resetLocalAccount();
                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? 'Локальний акаунт скинуто. Можна виконати signup знову.'
                                  : 'Скидання не вдалося.',
                            ),
                          ),
                        );
                      },
                child: const Text('Скинути локальний акаунт'),
              ),
            ),
            const SizedBox(height: 10),
            if (state.errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2ED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFF0B9A4)),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Color(0xFF7A3A1D)),
                ),
              ),
            const Spacer(),
            const Text(
              'Режим без бекенда: обліковий запис і перевірка доступу зберігаються локально на девайсі.',
              style: TextStyle(fontSize: 12, color: Color(0xFF647D7B)),
            ),
          ],
        ),
      ),
    );
  }
}
