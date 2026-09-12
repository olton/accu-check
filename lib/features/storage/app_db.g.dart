// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $GlucoseReadingsTable extends GlucoseReadings
    with TableInfo<$GlucoseReadingsTable, GlucoseReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GlucoseReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtEpochMsMeta = const VerificationMeta(
    'measuredAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> measuredAtEpochMs = GeneratedColumn<int>(
    'measured_at_epoch_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mmolLMeta = const VerificationMeta('mmolL');
  @override
  late final GeneratedColumn<double> mmolL = GeneratedColumn<double>(
    'mmol_l',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedAtEpochMsMeta = const VerificationMeta(
    'syncedAtEpochMs',
  );
  @override
  late final GeneratedColumn<int> syncedAtEpochMs = GeneratedColumn<int>(
    'synced_at_epoch_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    measuredAtEpochMs,
    mmolL,
    source,
    deviceId,
    syncedAtEpochMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'glucose_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<GlucoseReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('measured_at_epoch_ms')) {
      context.handle(
        _measuredAtEpochMsMeta,
        measuredAtEpochMs.isAcceptableOrUnknown(
          data['measured_at_epoch_ms']!,
          _measuredAtEpochMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measuredAtEpochMsMeta);
    }
    if (data.containsKey('mmol_l')) {
      context.handle(
        _mmolLMeta,
        mmolL.isAcceptableOrUnknown(data['mmol_l']!, _mmolLMeta),
      );
    } else if (isInserting) {
      context.missing(_mmolLMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    }
    if (data.containsKey('synced_at_epoch_ms')) {
      context.handle(
        _syncedAtEpochMsMeta,
        syncedAtEpochMs.isAcceptableOrUnknown(
          data['synced_at_epoch_ms']!,
          _syncedAtEpochMsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GlucoseReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GlucoseReading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      measuredAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measured_at_epoch_ms'],
      )!,
      mmolL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mmol_l'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      ),
      syncedAtEpochMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}synced_at_epoch_ms'],
      ),
    );
  }

  @override
  $GlucoseReadingsTable createAlias(String alias) {
    return $GlucoseReadingsTable(attachedDatabase, alias);
  }
}

class GlucoseReading extends DataClass implements Insertable<GlucoseReading> {
  final String id;
  final int measuredAtEpochMs;
  final double mmolL;
  final String source;
  final String? deviceId;
  final int? syncedAtEpochMs;
  const GlucoseReading({
    required this.id,
    required this.measuredAtEpochMs,
    required this.mmolL,
    required this.source,
    this.deviceId,
    this.syncedAtEpochMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['measured_at_epoch_ms'] = Variable<int>(measuredAtEpochMs);
    map['mmol_l'] = Variable<double>(mmolL);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    if (!nullToAbsent || syncedAtEpochMs != null) {
      map['synced_at_epoch_ms'] = Variable<int>(syncedAtEpochMs);
    }
    return map;
  }

  GlucoseReadingsCompanion toCompanion(bool nullToAbsent) {
    return GlucoseReadingsCompanion(
      id: Value(id),
      measuredAtEpochMs: Value(measuredAtEpochMs),
      mmolL: Value(mmolL),
      source: Value(source),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      syncedAtEpochMs: syncedAtEpochMs == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAtEpochMs),
    );
  }

  factory GlucoseReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GlucoseReading(
      id: serializer.fromJson<String>(json['id']),
      measuredAtEpochMs: serializer.fromJson<int>(json['measuredAtEpochMs']),
      mmolL: serializer.fromJson<double>(json['mmolL']),
      source: serializer.fromJson<String>(json['source']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      syncedAtEpochMs: serializer.fromJson<int?>(json['syncedAtEpochMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'measuredAtEpochMs': serializer.toJson<int>(measuredAtEpochMs),
      'mmolL': serializer.toJson<double>(mmolL),
      'source': serializer.toJson<String>(source),
      'deviceId': serializer.toJson<String?>(deviceId),
      'syncedAtEpochMs': serializer.toJson<int?>(syncedAtEpochMs),
    };
  }

  GlucoseReading copyWith({
    String? id,
    int? measuredAtEpochMs,
    double? mmolL,
    String? source,
    Value<String?> deviceId = const Value.absent(),
    Value<int?> syncedAtEpochMs = const Value.absent(),
  }) => GlucoseReading(
    id: id ?? this.id,
    measuredAtEpochMs: measuredAtEpochMs ?? this.measuredAtEpochMs,
    mmolL: mmolL ?? this.mmolL,
    source: source ?? this.source,
    deviceId: deviceId.present ? deviceId.value : this.deviceId,
    syncedAtEpochMs: syncedAtEpochMs.present
        ? syncedAtEpochMs.value
        : this.syncedAtEpochMs,
  );
  GlucoseReading copyWithCompanion(GlucoseReadingsCompanion data) {
    return GlucoseReading(
      id: data.id.present ? data.id.value : this.id,
      measuredAtEpochMs: data.measuredAtEpochMs.present
          ? data.measuredAtEpochMs.value
          : this.measuredAtEpochMs,
      mmolL: data.mmolL.present ? data.mmolL.value : this.mmolL,
      source: data.source.present ? data.source.value : this.source,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncedAtEpochMs: data.syncedAtEpochMs.present
          ? data.syncedAtEpochMs.value
          : this.syncedAtEpochMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GlucoseReading(')
          ..write('id: $id, ')
          ..write('measuredAtEpochMs: $measuredAtEpochMs, ')
          ..write('mmolL: $mmolL, ')
          ..write('source: $source, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncedAtEpochMs: $syncedAtEpochMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    measuredAtEpochMs,
    mmolL,
    source,
    deviceId,
    syncedAtEpochMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GlucoseReading &&
          other.id == this.id &&
          other.measuredAtEpochMs == this.measuredAtEpochMs &&
          other.mmolL == this.mmolL &&
          other.source == this.source &&
          other.deviceId == this.deviceId &&
          other.syncedAtEpochMs == this.syncedAtEpochMs);
}

class GlucoseReadingsCompanion extends UpdateCompanion<GlucoseReading> {
  final Value<String> id;
  final Value<int> measuredAtEpochMs;
  final Value<double> mmolL;
  final Value<String> source;
  final Value<String?> deviceId;
  final Value<int?> syncedAtEpochMs;
  final Value<int> rowid;
  const GlucoseReadingsCompanion({
    this.id = const Value.absent(),
    this.measuredAtEpochMs = const Value.absent(),
    this.mmolL = const Value.absent(),
    this.source = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncedAtEpochMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GlucoseReadingsCompanion.insert({
    required String id,
    required int measuredAtEpochMs,
    required double mmolL,
    required String source,
    this.deviceId = const Value.absent(),
    this.syncedAtEpochMs = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       measuredAtEpochMs = Value(measuredAtEpochMs),
       mmolL = Value(mmolL),
       source = Value(source);
  static Insertable<GlucoseReading> custom({
    Expression<String>? id,
    Expression<int>? measuredAtEpochMs,
    Expression<double>? mmolL,
    Expression<String>? source,
    Expression<String>? deviceId,
    Expression<int>? syncedAtEpochMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (measuredAtEpochMs != null) 'measured_at_epoch_ms': measuredAtEpochMs,
      if (mmolL != null) 'mmol_l': mmolL,
      if (source != null) 'source': source,
      if (deviceId != null) 'device_id': deviceId,
      if (syncedAtEpochMs != null) 'synced_at_epoch_ms': syncedAtEpochMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GlucoseReadingsCompanion copyWith({
    Value<String>? id,
    Value<int>? measuredAtEpochMs,
    Value<double>? mmolL,
    Value<String>? source,
    Value<String?>? deviceId,
    Value<int?>? syncedAtEpochMs,
    Value<int>? rowid,
  }) {
    return GlucoseReadingsCompanion(
      id: id ?? this.id,
      measuredAtEpochMs: measuredAtEpochMs ?? this.measuredAtEpochMs,
      mmolL: mmolL ?? this.mmolL,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
      syncedAtEpochMs: syncedAtEpochMs ?? this.syncedAtEpochMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (measuredAtEpochMs.present) {
      map['measured_at_epoch_ms'] = Variable<int>(measuredAtEpochMs.value);
    }
    if (mmolL.present) {
      map['mmol_l'] = Variable<double>(mmolL.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncedAtEpochMs.present) {
      map['synced_at_epoch_ms'] = Variable<int>(syncedAtEpochMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GlucoseReadingsCompanion(')
          ..write('id: $id, ')
          ..write('measuredAtEpochMs: $measuredAtEpochMs, ')
          ..write('mmolL: $mmolL, ')
          ..write('source: $source, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncedAtEpochMs: $syncedAtEpochMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $GlucoseReadingsTable glucoseReadings = $GlucoseReadingsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [glucoseReadings];
}

typedef $$GlucoseReadingsTableCreateCompanionBuilder =
    GlucoseReadingsCompanion Function({
      required String id,
      required int measuredAtEpochMs,
      required double mmolL,
      required String source,
      Value<String?> deviceId,
      Value<int?> syncedAtEpochMs,
      Value<int> rowid,
    });
typedef $$GlucoseReadingsTableUpdateCompanionBuilder =
    GlucoseReadingsCompanion Function({
      Value<String> id,
      Value<int> measuredAtEpochMs,
      Value<double> mmolL,
      Value<String> source,
      Value<String?> deviceId,
      Value<int?> syncedAtEpochMs,
      Value<int> rowid,
    });

class $$GlucoseReadingsTableFilterComposer
    extends Composer<_$AppDb, $GlucoseReadingsTable> {
  $$GlucoseReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measuredAtEpochMs => $composableBuilder(
    column: $table.measuredAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get mmolL => $composableBuilder(
    column: $table.mmolL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncedAtEpochMs => $composableBuilder(
    column: $table.syncedAtEpochMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GlucoseReadingsTableOrderingComposer
    extends Composer<_$AppDb, $GlucoseReadingsTable> {
  $$GlucoseReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measuredAtEpochMs => $composableBuilder(
    column: $table.measuredAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get mmolL => $composableBuilder(
    column: $table.mmolL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncedAtEpochMs => $composableBuilder(
    column: $table.syncedAtEpochMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GlucoseReadingsTableAnnotationComposer
    extends Composer<_$AppDb, $GlucoseReadingsTable> {
  $$GlucoseReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get measuredAtEpochMs => $composableBuilder(
    column: $table.measuredAtEpochMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get mmolL =>
      $composableBuilder(column: $table.mmolL, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get syncedAtEpochMs => $composableBuilder(
    column: $table.syncedAtEpochMs,
    builder: (column) => column,
  );
}

class $$GlucoseReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $GlucoseReadingsTable,
          GlucoseReading,
          $$GlucoseReadingsTableFilterComposer,
          $$GlucoseReadingsTableOrderingComposer,
          $$GlucoseReadingsTableAnnotationComposer,
          $$GlucoseReadingsTableCreateCompanionBuilder,
          $$GlucoseReadingsTableUpdateCompanionBuilder,
          (
            GlucoseReading,
            BaseReferences<_$AppDb, $GlucoseReadingsTable, GlucoseReading>,
          ),
          GlucoseReading,
          PrefetchHooks Function()
        > {
  $$GlucoseReadingsTableTableManager(_$AppDb db, $GlucoseReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GlucoseReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GlucoseReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GlucoseReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> measuredAtEpochMs = const Value.absent(),
                Value<double> mmolL = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> deviceId = const Value.absent(),
                Value<int?> syncedAtEpochMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GlucoseReadingsCompanion(
                id: id,
                measuredAtEpochMs: measuredAtEpochMs,
                mmolL: mmolL,
                source: source,
                deviceId: deviceId,
                syncedAtEpochMs: syncedAtEpochMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int measuredAtEpochMs,
                required double mmolL,
                required String source,
                Value<String?> deviceId = const Value.absent(),
                Value<int?> syncedAtEpochMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GlucoseReadingsCompanion.insert(
                id: id,
                measuredAtEpochMs: measuredAtEpochMs,
                mmolL: mmolL,
                source: source,
                deviceId: deviceId,
                syncedAtEpochMs: syncedAtEpochMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GlucoseReadingsTable, GlucoseReading>(table),
                  BaseReferences<
                    _$AppDb,
                    $GlucoseReadingsTable,
                    GlucoseReading
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GlucoseReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $GlucoseReadingsTable,
      GlucoseReading,
      $$GlucoseReadingsTableFilterComposer,
      $$GlucoseReadingsTableOrderingComposer,
      $$GlucoseReadingsTableAnnotationComposer,
      $$GlucoseReadingsTableCreateCompanionBuilder,
      $$GlucoseReadingsTableUpdateCompanionBuilder,
      (
        GlucoseReading,
        BaseReferences<_$AppDb, $GlucoseReadingsTable, GlucoseReading>,
      ),
      GlucoseReading,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$GlucoseReadingsTableTableManager get glucoseReadings =>
      $$GlucoseReadingsTableTableManager(_db, _db.glucoseReadings);
}
