import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

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

  Future<PasskeySession> signInWithSavedAccount() async {
    await _ensureLocalAuthSupported();

    final account = await _readAccount();
    if (account == null) {
      throw const PasskeySetupException(
        'Локальний passkey ще не створений. Спочатку виконайте signup.',
      );
    }

    final approved = await _authenticateOrThrow(
      localizedReason: 'Підтвердіть вхід у застосунок',
    );

    if (!approved) {
      throw const PasskeyAuthCancelledException();
    }

    return PasskeySession(
      userId: account.userId,
      displayName: account.displayName,
    );
  }

  Future<PasskeySession> signUp({
    required String username,
    required String displayName,
  }) async {
    await _ensureLocalAuthSupported();

    final approved = await _authenticateOrThrow(
      localizedReason: 'Підтвердіть створення локального passkey',
    );

    if (!approved) {
      throw const PasskeySetupException('Реєстрацію скасовано користувачем.');
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

  Future<PasskeySession> signIn({required String username}) async {
    await _ensureLocalAuthSupported();

    final account = await _readAccount();
    if (account == null) {
      throw const PasskeySetupException(
        'Локальний passkey ще не створений. Спочатку виконайте signup.',
      );
    }

    final incoming = username.trim().toLowerCase();
    if (incoming != account.username) {
      throw const PasskeySetupException(
        'Для входу вкажіть той самий username, що використовувався при signup.',
      );
    }

    final approved = await _authenticateOrThrow(
      localizedReason: 'Підтвердіть вхід у застосунок',
    );

    if (!approved) {
      throw const PasskeyAuthCancelledException();
    }

    return PasskeySession(
      userId: account.userId,
      displayName: account.displayName,
    );
  }

  Future<void> _ensureLocalAuthSupported() async {
    try {
      final supported = await localAuth.isDeviceSupported();

      if (!supported) {
        throw const PasskeySetupException(
          'На цьому пристрої недоступна біометрія/локальний захист екрану.',
        );
      }
    } on PlatformException catch (error) {
      throw PasskeySetupException(_mapLocalAuthError(error));
    }
  }

  Future<bool> _authenticateOrThrow({required String localizedReason}) async {
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
        throw const PasskeyAuthCancelledException();
      }
      throw PasskeySetupException(_mapLocalAuthError(error));
    }
  }

  String _mapLocalAuthError(PlatformException error) {
    final code = error.code.toLowerCase();

    if (code.contains('no_fragment_activity')) {
      return 'Локальна авторизація недоступна через конфігурацію Android-екрана. Оновіть застосунок до останньої версії.';
    }

    if (code.contains('notenrolled')) {
      return 'На пристрої не налаштовано біометрію. Додайте відбиток/Face ID або використайте PIN/пароль екрана блокування.';
    }

    if (code.contains('passcodenotset')) {
      return 'На пристрої не встановлено PIN/пароль екрана блокування.';
    }

    if (code.contains('lockedout') || code.contains('permanentlylockedout')) {
      return 'Біометрію тимчасово заблоковано. Розблокуйте пристрій PIN/паролем і спробуйте знову.';
    }

    if (code.contains('notavailable')) {
      return 'Біометрія або локальний захист зараз недоступні на цьому пристрої.';
    }

    return 'Не вдалося завершити локальну авторизацію. Перевірте біометрію або PIN/пароль пристрою.';
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
  const PasskeyAuthCancelledException()
    : super('Авторизацію скасовано користувачем.');
}
