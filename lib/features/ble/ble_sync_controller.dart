import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/glucose_repository.dart';
import 'ble_sync_service.dart';

final bleScanProvider = StreamProvider<List<DiscoveredDevice>>((ref) {
  final service = ref.watch(bleSyncServiceProvider);
  final seen = <String, DiscoveredDevice>{};

  return service.scanMeters().map((device) {
    seen[device.id] = device;
    final list = seen.values.toList(growable: false)
      ..sort((a, b) => b.rssi.compareTo(a.rssi));
    return list;
  });
});

final bleSyncControllerProvider =
    NotifierProvider<BleSyncController, BleSyncState>(BleSyncController.new);

class BleSyncController extends Notifier<BleSyncState> {
  @override
  BleSyncState build() {
    return const BleSyncState();
  }

  Future<void> syncDevice(String deviceId) async {
    state = state.copyWith(isSyncing: true, errorMessage: null);

    try {
      final service = ref.read(bleSyncServiceProvider);
      final repository = ref.read(glucoseRepositoryProvider);
      final readings = await service.syncFromDevice(deviceId: deviceId);
      await repository.upsertMany(readings);

      state = state.copyWith(
        isSyncing: false,
        lastSyncedCount: readings.length,
      );
    } on BleException catch (error) {
      state = state.copyWith(isSyncing: false, errorMessage: error.message);
    } catch (error) {
      state = state.copyWith(
        isSyncing: false,
        errorMessage: 'Не вдалося синхронізувати пристрій: $error',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
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
