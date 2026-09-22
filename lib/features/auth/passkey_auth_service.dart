import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../../l10n/app_localizations.dart';

final passkeyAuthServiceProvider = Provider<PasskeyAuthService>((ref) {
  return PasskeyAuthService(
    localAuth: LocalAuthentication(),
    secureStorage: const FlutterSecureStorage(),
  );
});

class PasskeyAuthService {
  PasskeyAuthService({required this.localAuth, required this.secureStorage});

  final LocalAuthentication localAuth;
  final FlutterSecureStorage secureStorage;

  static const _accountKey = 'accu_check.local_passkey_account.v1';

  Future<bool> hasLocalAccount() async {
    final account = await _readAccount();
    return account != null;
  }

  Future<void> resetLocalAccount() async {
    await secureStorage.delete(key: _accountKey);
  }

  Future<PasskeySession> signInWithSavedAccount(AppLocalizations l10n) async {
    await _ensureLocalAuthSupported(l10n);

    final account = await _readAccount();
    if (account == null) {
      throw PasskeySetupException(l10n.passkeyNotCreated);
    }

    final approved = await _authenticateOrThrow(
      localizedReason: l10n.authReasonSignIn,
      l10n: l10n,
    );

    if (!approved) {
      throw PasskeyAuthCancelledException(l10n.authCancelled);
    }

    return PasskeySession(
      userId: account.userId,
      displayName: account.displayName,
    );
  }

  Future<PasskeySession> signUp({
    required String username,
    required String displayName,
    required AppLocalizations l10n,
  }) async {
    await _ensureLocalAuthSupported(l10n);

    final approved = await _authenticateOrThrow(
      localizedReason: l10n.authReasonSignUp,
      l10n: l10n,
    );

    if (!approved) {
      throw PasskeySetupException(l10n.signupCancelled);
    }

    final normalizedUser = username.trim().toLowerCase();
    final normalizedName = displayName.trim().isEmpty
        ? username.trim()
        : displayName.trim();

    final account = _StoredAccount(
      userId: normalizedUser,
      username: normalizedUser,
      displayName: normalizedName,
    );

    await secureStorage.write(
      key: _accountKey,
      value: jsonEncode(account.toJson()),
    );

    return PasskeySession(
      userId: account.userId,
      displayName: account.displayName,
    );
  }

  Future<PasskeySession> signIn({
    required String username,
    required AppLocalizations l10n,
  }) async {
    await _ensureLocalAuthSupported(l10n);

    final account = await _readAccount();
    if (account == null) {
      throw PasskeySetupException(l10n.passkeyNotCreated);
    }

    final incoming = username.trim().toLowerCase();
    if (incoming != account.username) {
      throw PasskeySetupException(l10n.usernameMismatch);
    }

    final approved = await _authenticateOrThrow(
      localizedReason: l10n.authReasonSignIn,
      l10n: l10n,
    );

    if (!approved) {
      throw PasskeyAuthCancelledException(l10n.authCancelled);
    }

    return PasskeySession(
      userId: account.userId,
      displayName: account.displayName,
    );
  }

  Future<void> _ensureLocalAuthSupported(AppLocalizations l10n) async {
    try {
      final supported = await localAuth.isDeviceSupported();

      if (!supported) {
        throw PasskeySetupException(l10n.localAuthUnavailable);
      }
    } on PlatformException catch (error) {
      throw PasskeySetupException(_mapLocalAuthError(error, l10n));
    }
  }

  Future<bool> _authenticateOrThrow({
    required String localizedReason,
    required AppLocalizations l10n,
  }) async {
    try {
      return await localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (error) {
      final code = error.code.toLowerCase();
      if (code.contains('canceled') || code.contains('cancelled')) {
        throw PasskeyAuthCancelledException(l10n.authCancelled);
      }
      throw PasskeySetupException(_mapLocalAuthError(error, l10n));
    }
  }

  String _mapLocalAuthError(PlatformException error, AppLocalizations l10n) {
    final code = error.code.toLowerCase();

    if (code.contains('no_fragment_activity')) {
      return l10n.androidAuthConfigError;
    }

    if (code.contains('notenrolled')) {
      return l10n.biometricsNotEnrolled;
    }

    if (code.contains('passcodenotset')) {
      return l10n.passcodeNotSet;
    }

    if (code.contains('lockedout') || code.contains('permanentlylockedout')) {
      return l10n.biometricsLocked;
    }

    if (code.contains('notavailable')) {
      return l10n.localAuthNotAvailable;
    }

    return l10n.localAuthFailed;
  }

  Future<_StoredAccount?> _readAccount() async {
    final raw = await secureStorage.read(key: _accountKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    return _StoredAccount.fromJson(decoded);
  }
}

class _StoredAccount {
  const _StoredAccount({
    required this.userId,
    required this.username,
    required this.displayName,
  });

  final String userId;
  final String username;
  final String displayName;

  factory _StoredAccount.fromJson(Map<String, dynamic> json) {
    return _StoredAccount(
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'username': username, 'displayName': displayName};
  }
}

class PasskeySession {
  const PasskeySession({required this.userId, required this.displayName});

  final String userId;
  final String displayName;
}

class PasskeySetupException implements Exception {
  const PasskeySetupException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class PasskeyAuthCancelledException extends PasskeySetupException {
  const PasskeyAuthCancelledException(super.message);
}
