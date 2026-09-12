import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

class GlucoseReadings extends Table {
  TextColumn get id => text()();

  IntColumn get measuredAtEpochMs => integer()();

  RealColumn get mmolL => real()();

  TextColumn get source => text()();

  TextColumn get deviceId => text().nullable()();

  IntColumn get syncedAtEpochMs => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [GlucoseReadings])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'accu_check.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
