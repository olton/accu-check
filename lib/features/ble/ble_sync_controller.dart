import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/glucose_repository.dart';
import 'ble_sync_service.dart';

import '../../l10n/app_localizations.dart';

final bleScanProvider = StreamProvider<List<BleSyncDevice>>((ref) async* {
  final service = ref.watch(bleSyncServiceProvider);

  final savedDevices = await service.getSavedDevices();
  if (savedDevices.isNotEmpty) {
    yield savedDevices
        .map(
          (device) =>
              BleSyncDevice(id: device.id, name: device.name, isSaved: true),
        )
        .toList(growable: false);
    return;
  }

  final seen = <String, DiscoveredDevice>{};

  yield* service.scanMeters().map((device) {
    seen[device.id] = device;
    final list = seen.values.toList(growable: false)
      ..sort((a, b) => b.rssi.compareTo(a.rssi));
    return list
        .map(
          (item) => BleSyncDevice(
            id: item.id,
            name: item.name,
            rssi: item.rssi,
            isSaved: false,
          ),
        )
        .toList(growable: false);
  });
});

final bleSyncControllerProvider =
    NotifierProvider<BleSyncController, BleSyncState>(BleSyncController.new);

class BleSyncController extends Notifier<BleSyncState> {
  @override
  BleSyncState build() {
    return const BleSyncState();
  }

  Future<void> syncDevice(BleSyncDevice device, AppLocalizations l10n) async {
    state = state.copyWith(isSyncing: true, errorMessage: null);

    try {
      final service = ref.read(bleSyncServiceProvider);
      final repository = ref.read(glucoseRepositoryProvider);
      final readings = await service.syncFromDevice(deviceId: device.id);
      await repository.upsertMany(readings);
      await service.savePairedDevice(
        deviceId: device.id,
        deviceName: device.name.isEmpty ? device.id : device.name,
      );

      state = state.copyWith(
        isSyncing: false,
        lastSyncedCount: readings.length,
      );
    } on BleException catch (error) {
      state = state.copyWith(isSyncing: false, errorMessage: error.message);
    } catch (error) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: '${l10n.syncError} $error',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

class BleSyncDevice {
  const BleSyncDevice({
    required this.id,
    required this.name,
    required this.isSaved,
    this.rssi,
  });

  final String id;
  final String name;
  final bool isSaved;
  final int? rssi;
}

class BleSyncState {
  const BleSyncState({
    this.isSyncing = false,
    this.lastSyncedCount = 0,
    this.errorMessage,
  });

  final bool isSyncing;
  final int lastSyncedCount;
  final String? errorMessage;

  BleSyncState copyWith({
    bool? isSyncing,
    int? lastSyncedCount,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BleSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedCount: lastSyncedCount ?? this.lastSyncedCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
