part of asn1lib;

///
/// An ASN1 UtcTime value.
///
/// UTCTime values take the form of either 'YYMMDDhhmm[ss]Z' or 'YYMMDDhhmm[ss](+|-)hhmm'.
/// The first form indicates (by the literal letter 'Z') UTC time.
/// The second form indicates a time that differs from UTC by plus or minus
/// The hours and minutes represented by the final 'hhmm'.
///
class ASN1UtcTime extends ASN1Object {
  // The decoded date value
  DateTime dateTimeValue;

  ///
  /// Create an [ASN1UtcTime] initialized with DateTime value.
  ///
  /// Optionally override the tag
  ///
  ASN1UtcTime(this.dateTimeValue, {int tag = UTC_TIME_TYPE}) : super(tag: tag);

  ///
  /// Create an [ASN1UtcTime] from an encoded list of bytes
  ///
  ASN1UtcTime.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    // The DateTime.parse() function wants:
    // * Either T or space as separator between date and time.
    // * Full year with 4 digits (the UtcTime in ASN.1 has only two digits for year).
    // so we need to add that in order for DateTime to parse the Utc value
    var octets = valueBytes();
    var stringValue = ascii.decode(octets);
    var y2 = int.parse(stringValue.substring(0, 2));
    if (y2 > 75) {
      stringValue = '19' + stringValue;
    } else {
      stringValue = '20' + stringValue;
    }
    stringValue = stringValue.substring(0, 8) + 'T' + stringValue.substring(8);

    dateTimeValue = DateTime.parse(stringValue);
  }

  @override
  Uint8List _encode() {
    var utc = dateTimeValue.toUtc();
    var year = utc.year.toString().substring(2).padLeft(2, '0');
    var month = utc.month.toString().padLeft(2, '0');
    var day = utc.day.toString().padLeft(2, '0');
    var hour = utc.hour.toString().padLeft(2, '0');
    var minute = utc.minute.toString().padLeft(2, '0');
    var second = utc.second.toString().padLeft(2, '0');
    // Encode string to YYMMDDhhmm[ss]Z
    var utcString = '$year$month$day$hour$minute${second}Z';
    var valBytes = <int>[];
    valBytes.addAll(ascii.encode(utcString));
    _valueByteLength = valBytes.length;
    _encodeHeader();
    _setValueBytes(valBytes);
    return _encodedBytes;
  }

  @override
  String toString() => 'UtcTime(${dateTimeValue})';
}
