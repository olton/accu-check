import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../history/history_page.dart';
import '../storage/glucose_repository.dart';
import 'passkey_auth_service.dart';

final authControllerProvider = NotifierProvider<AuthController, AuthUiState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthUiState> {
  @override
  AuthUiState build() {
    return const AuthUiState();
  }

  Future<void> signInWithPasskey(String username, AppLocalizations l10n) async {
    if (username.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: l10n.usernameRequired,
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final service = ref.read(passkeyAuthServiceProvider);
      final session = await service.signIn(username: username, l10n: l10n);
      state = state.copyWith(isLoading: false, session: session);
    } on PasskeySetupException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: l10n.localSignInFailed,
      );
    }
  }

  Future<void> signUpWithPasskey({
    required String username,
    required String displayName,
    required AppLocalizations l10n,
  }) async {
    if (username.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: l10n.usernameRequired,
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final service = ref.read(passkeyAuthServiceProvider);
      final session = await service.signUp(
        username: username,
        displayName: displayName,
        l10n: l10n,
      );
      state = state.copyWith(isLoading: false, session: session);
    } on PasskeySetupException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: l10n.localSignUpFailed,
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<bool> resetLocalAccount(AppLocalizations l10n) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await ref.read(glucoseRepositoryProvider).clearAll();
      final service = ref.read(passkeyAuthServiceProvider);
      await service.resetLocalAccount();
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: l10n.localAccountResetFailed,
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
    final l10n = AppLocalizations.of(context)!;
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
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.loginHeading,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Color(0xFF143B39),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.loginDescription,
              style: TextStyle(fontSize: 14, color: Color(0xFF5A7572)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.usernameLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: l10n.displayNameLabel,
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
                            .signInWithPasskey(
                              _usernameController.text.trim(),
                              l10n,
                            );
                      },
                icon: const Icon(Icons.fingerprint),
                label: Text(
                  state.isLoading ? l10n.authenticating : l10n.signInPasskey,
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
                              l10n: l10n,
                            );
                      },
                icon: const Icon(Icons.person_add_alt_1),
                label: Text(l10n.createPasskey),
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
                            .resetLocalAccount(l10n);
                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? l10n.accountResetSuccess
                                  : l10n.accountResetFailed,
                            ),
                          ),
                        );
                      },
                child: Text(l10n.resetLocalAccount),
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
            Text(
              l10n.offlineModeNote,
              style: TextStyle(fontSize: 12, color: Color(0xFF647D7B)),
            ),
          ],
        ),
      ),
    );
  }
}
