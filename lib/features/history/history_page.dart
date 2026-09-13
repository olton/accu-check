import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../auth/login_page.dart';
import '../auth/passkey_auth_service.dart';
import '../ble/ble_sync_controller.dart';
import '../ble/device_scan_sheet.dart';
import '../glucose/glucose_reading.dart';
import '../storage/glucose_repository.dart';

import '../../l10n/app_localizations.dart';

enum HistoryPeriod {
  lastDay(days: 1),
  last7Days(days: 7),
  last30Days(days: 30);

  const HistoryPeriod({required this.days});

  final int days;
}

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({required this.session, super.key});

  final PasskeySession session;

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  HistoryPeriod _selectedPeriod = HistoryPeriod.lastDay;
  DateTimeRange? _customRange;
  static const _intervalModeKey = 'accu_check.history.interval_mode.v1';
  static const _intervalPeriodKey = 'accu_check.history.interval_period.v1';
  static const _intervalCustomStartKey =
      'accu_check.history.interval_custom_start.v1';
  static const _intervalCustomEndKey =
      'accu_check.history.interval_custom_end.v1';
  final _storage = const FlutterSecureStorage();

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _restoreIntervalPreference();
  }

  Future<void> _restoreIntervalPreference() async {
    final mode = await _storage.read(key: _intervalModeKey);

    if (!mounted || mode == null) {
      return;
    }

    if (mode == 'custom') {
      final startRaw = await _storage.read(key: _intervalCustomStartKey);
      final endRaw = await _storage.read(key: _intervalCustomEndKey);
      final startMs = int.tryParse(startRaw ?? '');
      final endMs = int.tryParse(endRaw ?? '');

      if (startMs != null && endMs != null && startMs <= endMs) {
        setState(() {
          _customRange = DateTimeRange(
            start: DateTime.fromMillisecondsSinceEpoch(startMs),
            end: DateTime.fromMillisecondsSinceEpoch(endMs),
          );
        });
      }
      return;
    }

    final periodName = await _storage.read(key: _intervalPeriodKey);
    final savedPeriod = HistoryPeriod.values.where((period) {
      return period.name == periodName;
    }).firstOrNull;

    if (savedPeriod == null) {
      return;
    }

    setState(() {
      _selectedPeriod = savedPeriod;
      _customRange = null;
    });
  }

  Future<void> _savePresetInterval(HistoryPeriod period) async {
    await _storage.write(key: _intervalModeKey, value: 'preset');
    await _storage.write(key: _intervalPeriodKey, value: period.name);
    await _storage.delete(key: _intervalCustomStartKey);
    await _storage.delete(key: _intervalCustomEndKey);
  }

  Future<void> _saveCustomInterval(DateTimeRange range) async {
    await _storage.write(key: _intervalModeKey, value: 'custom');
    await _storage.write(
      key: _intervalCustomStartKey,
      value: range.start.millisecondsSinceEpoch.toString(),
    );
    await _storage.write(
      key: _intervalCustomEndKey,
      value: range.end.millisecondsSinceEpoch.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final readingsAsync = ref.watch(glucoseReadingsStreamProvider);
    final syncState = ref.watch(bleSyncControllerProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.history}: ${widget.session.displayName}'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Синхронізувати з глюкометром',
            onPressed: syncState.isSyncing
                ? null
                : () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const FractionallySizedBox(
                        heightFactor: 0.78,
                        child: DeviceScanSheet(),
                      ),
                    );
                  },
            icon: const Icon(Icons.bluetooth_searching),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A6B63), Color(0xFF1F8F85)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n.trend} ${_currentPeriodLabel()}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${l10n.glucose}, mmol/L',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<HistoryPeriod>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment<HistoryPeriod>(
                        value: HistoryPeriod.lastDay,
                        label: Text(l10n.last24hours),
                      ),
                      ButtonSegment<HistoryPeriod>(
                        value: HistoryPeriod.last7Days,
                        label: Text(l10n.last7days),
                      ),
                      ButtonSegment<HistoryPeriod>(
                        value: HistoryPeriod.last30Days,
                        label: Text(l10n.last30days),
                      ),
                    ],
                    selected: <HistoryPeriod>{_selectedPeriod},
                    onSelectionChanged: (selection) {
                      final selected = selection.first;
                      setState(() {
                        _selectedPeriod = selected;
                        _customRange = null;
                      });
                      _savePresetInterval(selected);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filledTonal(
                  tooltip: _customRange == null
                      ? l10n.selectPeriod
                      : l10n.changePeriod,
                  onPressed: _pickCustomRange,
                  icon: Icon(
                    Icons.calendar_month,
                    color: _customRange == null
                        ? const Color(0xFF355653)
                        : const Color(0xFF0A6B63),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildContent(readingsAsync)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: Text(
                syncState.lastSyncedCount > 0
                    ? '${l10n.lastSync}: +${syncState.lastSyncedCount} ${l10n.measurements}'
                    : '${l10n.lastUpdate}: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF000000), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<GlucoseReading>> readingsAsync) {
    return readingsAsync.when(
      data: (readings) {
        if (readings.isEmpty) {
          return _emptyCard();
        }

        final filteredReadings = _filterBySelectedPeriod(readings);
        if (filteredReadings.isEmpty) {
          return _emptyCard(
            message: '${l10n.nothingToShow}\n(${_currentPeriodLabel()})',
          );
        }

        final chartPoints = _removeConsecutiveDuplicates(
          filteredReadings.reversed.toList(growable: false),
        );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x220B3F3A),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: LineChart(_buildChartData(chartPoints)),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          '${l10n.historyLoadError}: $error',
          style: const TextStyle(color: Color(0xFF8B2F12)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<GlucoseReading> _filterBySelectedPeriod(List<GlucoseReading> readings) {
    if (_customRange != null) {
      final start = _startOfDay(_customRange!.start);
      final end = _endOfDay(_customRange!.end);

      return readings
          .where((reading) {
            return !reading.measuredAt.isBefore(start) &&
                !reading.measuredAt.isAfter(end);
          })
          .toList(growable: false);
    }

    final threshold = DateTime.now().subtract(
      Duration(days: _selectedPeriod.days),
    );
    return readings
        .where((reading) {
          return reading.measuredAt.isAfter(threshold) ||
              reading.measuredAt.isAtSameMomentAs(threshold);
        })
        .toList(growable: false);
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();
    final initialRange =
        _customRange ??
        DateTimeRange(start: now.subtract(const Duration(days: 6)), end: now);

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: initialRange,
      helpText: l10n.pickerSelectPeriod,
      cancelText: l10n.cancel,
      confirmText: l10n.confirm,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _customRange = DateTimeRange(
        start: _startOfDay(picked.start),
        end: _endOfDay(picked.end),
      );
    });

    await _saveCustomInterval(_customRange!);
  }

  String _currentPeriodLabel() {
    if (_customRange == null) {
      return '${l10n.last} ${switch (_selectedPeriod) {
        HistoryPeriod.lastDay => l10n.last24hours,
        HistoryPeriod.last7Days => l10n.last7days,
        HistoryPeriod.last30Days => l10n.last30days,
      }}';
    }

    final format = DateFormat('dd.MM.yy');
    final from = format.format(_customRange!.start);
    final to = format.format(_customRange!.end);
    return '$from - $to';
  }

  DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime _endOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day, 23, 59, 59, 999);
  }

  List<GlucoseReading> _removeConsecutiveDuplicates(
    List<GlucoseReading> points,
  ) {
    if (points.length < 2) {
      return points;
    }

    final result = <GlucoseReading>[points.first];
    for (var index = 1; index < points.length; index++) {
      final previous = result.last;
      final current = points[index];

      if (previous.mmolL != current.mmolL) {
        result.add(current);
      }
    }

    return result;
  }

  Widget _emptyCard({String? message}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          message ?? l10n.noData,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF5F7371), height: 1.4),
        ),
      ),
    );
  }

  LineChartData _buildChartData(List<GlucoseReading> points) {
    final dataMaxY = points
        .map((point) => point.mmolL)
        .reduce((current, next) => current > next ? current : next);
    final maxY = dataMaxY < 12 ? 12.0 : dataMaxY.ceilToDouble() + 1;

    final spots = points
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.mmolL))
        .toList();

    return LineChartData(
      minY: 0,
      maxY: maxY,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipColor: (_) => const Color(0xCC143B39),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              if (index < 0 || index >= points.length) {
                return null;
              }

              final measuredAt = points[index].measuredAt;
              final datePart = DateFormat('dd.MM.yyyy').format(measuredAt);
              final timePart = DateFormat('HH:mm').format(measuredAt);

              return LineTooltipItem(
                '${spot.y.toStringAsFixed(2)} mmol/L\n$datePart $timePart',
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
                textAlign: TextAlign.left,
              );
            }).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xFFE7EFEE), strokeWidth: 1);
        },
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              if (value != value.roundToDouble()) {
                return const SizedBox.shrink();
              }

              return Text(
                value.toStringAsFixed(0),
                style: const TextStyle(fontSize: 11, color: Color(0xFF5F7371)),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 74,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const maxVisibleLabels = 14;
              final labelStep = points.length <= maxVisibleLabels
                  ? 1
                  : (points.length + maxVisibleLabels - 1) ~/ maxVisibleLabels;

              final index = value.round();
              final isExactPoint = (value - index).abs() < 0.001;
              if (!isExactPoint) {
                return const SizedBox.shrink();
              }

              if (index < 0 || index >= points.length) {
                return const SizedBox.shrink();
              }

              final isBoundary = index == 0 || index == points.length - 1;
              final shouldShow = isBoundary || index % labelStep == 0;
              if (!shouldShow) {
                return const SizedBox.shrink();
              }

              final measuredAt = points[index].measuredAt;
              return SideTitleWidget(
                meta: meta,
                space: 8,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    '${DateFormat('dd.MM').format(measuredAt)} ${DateFormat('HH:mm').format(measuredAt)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF5F7371),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: const Color(0xFF0A6B63),
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x5515A597), Color(0x1115A597)],
            ),
          ),
          dotData: const FlDotData(show: true),
        ),
      ],
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          HorizontalLine(
            y: 7.8,
            color: const Color(0xFF6BAE3D),
            strokeWidth: 1,
            dashArray: [4, 3],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.topRight,
              labelResolver: (_) => l10n.targetMax,
              style: const TextStyle(fontSize: 10, color: Color(0xFF6BAE3D)),
            ),
          ),
          HorizontalLine(
            y: 4.4,
            color: const Color(0xFFE0972E),
            strokeWidth: 1,
            dashArray: [4, 3],
            label: HorizontalLineLabel(
              show: true,
              alignment: Alignment.bottomRight,
              labelResolver: (_) => l10n.targetMin,
              style: const TextStyle(fontSize: 10, color: Color(0xFFE0972E)),
            ),
          ),
        ],
      ),
    );
  }
}
