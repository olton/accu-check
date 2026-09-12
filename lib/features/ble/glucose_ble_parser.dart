import '../glucose/glucose_reading.dart';

class ParsedBleMeasurement {
  const ParsedBleMeasurement({
    required this.sequenceNumber,
    required this.reading,
  });

  final int sequenceNumber;
  final GlucoseReading reading;
}

class GlucoseBleParser {
  const GlucoseBleParser();

  ParsedBleMeasurement? parseMeasurement({
    required List<int> value,
    required String deviceId,
  }) {
    if (value.length < 10) {
      return null;
    }

    final flags = value[0];
    final hasTimeOffset = (flags & 0x01) != 0;
    final hasConcentration = (flags & 0x02) != 0;
    final concentrationInMolPerL = (flags & 0x04) != 0;

    final sequenceNumber = _readUint16(value, 1);

    final year = _readUint16(value, 3);
    final month = value[5];
    final day = value[6];
    final hour = value[7];
    final minute = value[8];
    final second = value[9];

    DateTime measuredAt = DateTime(
      year,
      month.clamp(1, 12),
      day.clamp(1, 31),
      hour.clamp(0, 23),
      minute.clamp(0, 59),
      second.clamp(0, 59),
    );

    var index = 10;
    if (hasTimeOffset && value.length >= index + 2) {
      final offsetMinutes = _readInt16(value, index);
      measuredAt = measuredAt.add(Duration(minutes: offsetMinutes));
      index += 2;
    }

    double? mmolL;
    if (hasConcentration && value.length >= index + 2) {
      final rawConcentration = _decodeSfloat16(value[index], value[index + 1]);
      if (rawConcentration != null) {
        mmolL = concentrationInMolPerL
            ? rawConcentration * 1000
            : _kgPerLToMmolPerL(rawConcentration);
      }
    }

    if (mmolL == null || mmolL.isNaN || mmolL.isInfinite) {
      return null;
    }

    final reading = GlucoseReading(
      id: '${deviceId}_$sequenceNumber',
      measuredAt: measuredAt,
      mmolL: mmolL,
      source: GlucoseSource.meter,
      deviceId: deviceId,
      syncedAt: DateTime.now(),
    );

    return ParsedBleMeasurement(
      sequenceNumber: sequenceNumber,
      reading: reading,
    );
  }

  static int _readUint16(List<int> bytes, int index) {
    return bytes[index] | (bytes[index + 1] << 8);
  }

  static int _readInt16(List<int> bytes, int index) {
    final value = _readUint16(bytes, index);
    return value >= 0x8000 ? value - 0x10000 : value;
  }

  static double _kgPerLToMmolPerL(double valueInKgPerL) {
    const molarMassGlucoseMgPerMmol = 180.1559;
    final mgPerL = valueInKgPerL * 1000000;
    return mgPerL / molarMassGlucoseMgPerMmol;
  }

  static double? _decodeSfloat16(int low, int high) {
    final raw = low | (high << 8);

    final exponentNibble = (raw >> 12) & 0x0F;
    final mantissaNibble = raw & 0x0FFF;

    final exponent = exponentNibble >= 0x8
        ? exponentNibble - 0x10
        : exponentNibble;
    final mantissa = mantissaNibble >= 0x800
        ? mantissaNibble - 0x1000
        : mantissaNibble;

    if (mantissa == 0x07FF || mantissa == -2048) {
      return null;
    }

    return mantissa * _pow10(exponent);
  }

  static double _pow10(int exponent) {
    if (exponent == 0) {
      return 1;
    }

    final positive = exponent > 0;
    var result = 1.0;
    final turns = exponent.abs();

    for (var i = 0; i < turns; i++) {
      result = positive ? result * 10 : result / 10;
    }

    return result;
  }
}
