import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../glucose/glucose_reading.dart' as domain;
import 'app_db.dart';

final appDbProvider = Provider<AppDb>((ref) {
  final db = AppDb();
  ref.onDispose(db.close);
  return db;
});

final glucoseRepositoryProvider = Provider<GlucoseRepository>((ref) {
  return GlucoseRepository(ref.watch(appDbProvider));
});

final glucoseReadingsStreamProvider =
    StreamProvider<List<domain.GlucoseReading>>((ref) {
      return ref.watch(glucoseRepositoryProvider).watchAll();
    });

class GlucoseRepository {
  GlucoseRepository(this._db);

  final AppDb _db;

  Stream<List<domain.GlucoseReading>> watchAll() {
    final query = (_db.select(_db.glucoseReadings)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.measuredAtEpochMs)]));

    return query.watch().map(
      (rows) => rows
          .map(
            (row) => domain.GlucoseReading(
              id: row.id,
              measuredAt: DateTime.fromMillisecondsSinceEpoch(
                row.measuredAtEpochMs,
              ),
              mmolL: row.mmolL,
              source: domain.GlucoseSource.values.firstWhere(
                (value) => value.name == row.source,
                orElse: () => domain.GlucoseSource.meter,
              ),
              deviceId: row.deviceId,
              syncedAt: row.syncedAtEpochMs == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(row.syncedAtEpochMs!),
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> clearAll() async {
    await _db.delete(_db.glucoseReadings).go();
  }

  Future<void> upsertMany(List<domain.GlucoseReading> readings) async {
    if (readings.isEmpty) {
      return;
    }

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.glucoseReadings,
        readings
            .map(
              (reading) => GlucoseReadingsCompanion.insert(
                id: reading.id,
                measuredAtEpochMs: reading.measuredAt.millisecondsSinceEpoch,
                mmolL: reading.mmolL,
                source: reading.source.name,
                deviceId: Value(reading.deviceId),
                syncedAtEpochMs: Value(
                  reading.syncedAt?.millisecondsSinceEpoch,
                ),
              ),
            )
            .toList(growable: false),
      );
    });
  }
}
