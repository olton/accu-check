import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'ble_sync_controller.dart';

class DeviceScanSheet extends ConsumerWidget {
  const DeviceScanSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final devicesAsync = ref.watch(bleScanProvider);
    final syncState = ref.watch(bleSyncControllerProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCDD7D6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.scanTitle,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (syncState.isSyncing) const LinearProgressIndicator(),
            if (syncState.errorMessage != null) ...[
              const SizedBox(height: 12),
              _ErrorMessage(text: syncState.errorMessage!),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: devicesAsync.when(
                data: (devices) {
                  if (devices.isEmpty) {
                    return _EmptyState(text: l10n.scanEmpty);
                  }

                  return ListView.separated(
                    itemCount: devices.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return _DeviceTile(
                        device: device,
                        busy: syncState.isSyncing,
                        onTap: () async {
                          final l10n = AppLocalizations.of(context)!;
                          await ref
                              .read(bleSyncControllerProvider.notifier)
                              .syncDevice(device, l10n);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text(
                    l10n.scanError(error.toString()),
                    style: const TextStyle(color: Color(0xFF8B2F12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.device,
    required this.onTap,
    required this.busy,
  });

  final BleSyncDevice device;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = device.name.isEmpty ? l10n.unknownDevice : device.name;

    return ListTile(
      enabled: !busy,
      leading: const Icon(Icons.monitor_heart_outlined),
      title: Text(title),
      subtitle: Text(device.id),
      trailing: device.isSaved
          ? const Icon(Icons.bookmark, color: Color(0xFF0A6B63))
          : Text(
              device.rssi == null ? '' : l10n.deviceSignal(device.rssi!),
              style: const TextStyle(color: Color(0xFF516664)),
            ),
      onTap: onTap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF5F7371)),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2ED),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0B9A4)),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF7A3A1D))),
    );
  }
}
