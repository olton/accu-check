class GlucoseReading {
  const GlucoseReading({
    required this.id,
    required this.measuredAt,
    required this.mmolL,
    required this.source,
    this.deviceId,
    this.syncedAt,
  });

  final String id;
  final DateTime measuredAt;
  final double mmolL;
  final GlucoseSource source;
  final String? deviceId;
  final DateTime? syncedAt;

  GlucoseReading copyWith({
    String? id,
    DateTime? measuredAt,
    double? mmolL,
    GlucoseSource? source,
    String? deviceId,
    DateTime? syncedAt,
  }) {
    return GlucoseReading(
      id: id ?? this.id,
      measuredAt: measuredAt ?? this.measuredAt,
      mmolL: mmolL ?? this.mmolL,
      source: source ?? this.source,
      deviceId: deviceId ?? this.deviceId,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}

enum GlucoseSource { meter, manual, import }
