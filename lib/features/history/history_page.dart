import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../auth/passkey_auth_service.dart';
import '../ble/ble_sync_controller.dart';
import '../ble/device_scan_sheet.dart';
import '../glucose/glucose_reading.dart';
import '../storage/glucose_repository.dart';

enum HistoryPeriod {
  lastDay(days: 1, title: '24H'),
  last7Days(days: 7, title: '7 днів'),
  last30Days(days: 30, title: '30 днів');

  const HistoryPeriod({required this.days, required this.title});

  final int days;
  final String title;
}

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({required this.session, super.key});

  final PasskeySession session;

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  HistoryPeriod _selectedPeriod = HistoryPeriod.last7Days;
  DateTimeRange? _customRange;

  @override
  Widget build(BuildContext context) {
    final readingsAsync = ref.watch(glucoseReadingsStreamProvider);
    final syncState = ref.watch(bleSyncControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Історія: ${widget.session.displayName}'),
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
                    'Тренд за ${_currentPeriodLabel()}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Глюкоза, mmol/L',
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
                    segments: const [
                      ButtonSegment<HistoryPeriod>(
                        value: HistoryPeriod.lastDay,
                        label: Text('24H'),
                      ),
                      ButtonSegment<HistoryPeriod>(
                        value: HistoryPeriod.last7Days,
                        label: Text('7 днів'),
                      ),
                      ButtonSegment<HistoryPeriod>(
                        value: HistoryPeriod.last30Days,
                        label: Text('30 днів'),
                      ),
                    ],
                    selected: <HistoryPeriod>{_selectedPeriod},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _selectedPeriod = selection.first;
                        _customRange = null;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filledTonal(
                  tooltip: _customRange == null
                      ? 'Обрати кастомний період'
                      : 'Змінити кастомний період',
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
            Text(
              syncState.lastSyncedCount > 0
                  ? 'Остання синхронізація: +${syncState.lastSyncedCount} вимірювань'
                  : 'Останнє оновлення: ${DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now())}',
              style: const TextStyle(color: Color(0xFF516664), fontSize: 12),
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
            message:
                'За обраний період (${_currentPeriodLabel()}) вимірювань немає.\nОберіть інший період або синхронізуйте глюкометр.',
          );
        }

        final chartPoints = _removeConsecutiveDuplicates(
          filteredReadings.reversed.toList(growable: false),
        );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
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
          'Помилка завантаження історії: $error',
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
      helpText: 'Оберіть період',
      cancelText: 'Скасувати',
      confirmText: 'Застосувати',
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
  }

  String _currentPeriodLabel() {
    if (_customRange == null) {
      return 'останні ${_selectedPeriod.title}';
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

  Widget _emptyCard({
    String message = 'Ще немає збережених вимірювань.\nНатисніть іконку Bluetooth зверху для синхронізації.',
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Text(
          message,
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
            reservedSize: 44,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= points.length) {
                return const SizedBox.shrink();
              }

              final measuredAt = points[index].measuredAt;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${DateFormat('dd.MM').format(measuredAt)}\n${DateFormat('HH:mm').format(measuredAt)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.1,
                    color: Color(0xFF5F7371),
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
              labelResolver: (_) => 'Ціль max',
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
              labelResolver: (_) => 'Ціль min',
              style: const TextStyle(fontSize: 10, color: Color(0xFFE0972E)),
            ),
          ),
        ],
      ),
    );
  }
}
