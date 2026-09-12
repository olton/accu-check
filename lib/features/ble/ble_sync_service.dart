import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../glucose/glucose_reading.dart';
import 'glucose_ble_parser.dart';

final bleSyncServiceProvider = Provider<BleSyncService>((ref) {
  return BleSyncService(
    ble: FlutterReactiveBle(),
    parser: const GlucoseBleParser(),
  );
});

class BleSyncService {
  BleSyncService({required this._ble, required this._parser});

  final FlutterReactiveBle _ble;
  final GlucoseBleParser _parser;

  static final Uuid _glucoseServiceUuid = Uuid.parse(
    '00001808-0000-1000-8000-00805f9b34fb',
  );
  static final Uuid _measurementCharUuid = Uuid.parse(
    '00002A18-0000-1000-8000-00805f9b34fb',
  );
  static final Uuid _racpCharUuid = Uuid.parse(
    '00002A52-0000-1000-8000-00805f9b34fb',
  );

  Stream<DiscoveredDevice> scanMeters() async* {
    final granted = await ensurePermissions();
    if (!granted) {
      throw const BleException(
        'Потрібно надати Bluetooth permissions для сканування глюкометра.',
      );
    }

    await _ensureBleReady();

    yield* _ble
        .scanForDevices(
          withServices: const [],
          scanMode: ScanMode.lowLatency,
          requireLocationServicesEnabled: false,
        )
        .where(
          (device) => device.name.trim().toLowerCase().startsWith('meter+'),
        );
  }

  Future<List<GlucoseReading>> syncFromDevice({
    required String deviceId,
  }) async {
    final granted = await ensurePermissions();
    if (!granted) {
      throw const BleException(
        'Потрібно надати Bluetooth permissions для синхронізації.',
      );
    }

    await _ensureBleReady();

    final completer = Completer<List<GlucoseReading>>();
    final readings = <GlucoseReading>[];

    StreamSubscription<ConnectionStateUpdate>? connectionSub;
    StreamSubscription<List<int>>? measurementSub;
    StreamSubscription<List<int>>? racpSub;

    Future<void> finish() async {
      await measurementSub?.cancel();
      await racpSub?.cancel();
      await connectionSub?.cancel();
    }

    connectionSub = _ble
        .connectToDevice(
          id: deviceId,
          connectionTimeout: const Duration(seconds: 15),
        )
        .listen(
          (update) async {
            if (update.connectionState != DeviceConnectionState.connected) {
              return;
            }

            final measurement = QualifiedCharacteristic(
              serviceId: _glucoseServiceUuid,
              characteristicId: _measurementCharUuid,
              deviceId: deviceId,
            );
            final racp = QualifiedCharacteristic(
              serviceId: _glucoseServiceUuid,
              characteristicId: _racpCharUuid,
              deviceId: deviceId,
            );

            measurementSub = _ble.subscribeToCharacteristic(measurement).listen(
              (packet) {
                final parsed = _parser.parseMeasurement(
                  value: packet,
                  deviceId: deviceId,
                );
                if (parsed != null) {
                  readings.add(parsed.reading);
                }
              },
            );

            racpSub = _ble.subscribeToCharacteristic(racp).listen((
              packet,
            ) async {
              final isComplete =
                  packet.length >= 4 &&
                  packet[0] == 0x06 &&
                  packet[2] == 0x01 &&
                  packet[3] == 0x01;

              if (isComplete && !completer.isCompleted) {
                await finish();
                completer.complete(readings);
              }
            });

            await _ble.writeCharacteristicWithResponse(
              racp,
              value: const [0x01, 0x01],
            );
          },
          onError: (Object error, StackTrace stackTrace) async {
            if (!completer.isCompleted) {
              await finish();
              completer.completeError(
                BleException('Помилка зʼєднання BLE: $error'),
                stackTrace,
              );
            }
          },
        );

    try {
      return await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () => readings,
      );
    } finally {
      await finish();
    }
  }

  Future<bool> ensurePermissions() async {
    if (kIsWeb) {
      return false;
    }

    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    final bluetoothGranted = statuses.values.every((status) {
      return status == PermissionStatus.granted ||
          status == PermissionStatus.limited;
    });

    if (!bluetoothGranted) {
      return false;
    }

    // Some devices/OS builds still expect runtime location permission for BLE scan.
    await Permission.locationWhenInUse.request();
    return true;
  }

  Future<void> _ensureBleReady() async {
    final current = _ble.status;
    if (current == BleStatus.ready) {
      return;
    }

    final status = await _ble.statusStream.firstWhere(
      (value) => value != BleStatus.unknown,
      orElse: () => BleStatus.unknown,
    );

    if (status == BleStatus.ready) {
      return;
    }

    throw BleException(_statusMessage(status));
  }

  String _statusMessage(BleStatus status) {
    switch (status) {
      case BleStatus.unauthorized:
        return 'Додатку не надано доступ до Bluetooth. Перевірте дозволи Nearby devices.';
      case BleStatus.poweredOff:
        return 'Bluetooth вимкнено. Увімкніть Bluetooth і спробуйте ще раз.';
      case BleStatus.locationServicesDisabled:
        return 'На цьому пристрої для BLE-сканування потрібно увімкнути геолокацію (Location Services).';
      case BleStatus.unsupported:
        return 'Цей пристрій не підтримує BLE.';
      case BleStatus.unknown:
        return 'Не вдалося визначити стан Bluetooth. Спробуйте ще раз.';
      case BleStatus.ready:
        return '';
    }
  }
}

class BleException implements Exception {
  const BleException(this.message);

  final String message;

  @override
  String toString() => message;
}
