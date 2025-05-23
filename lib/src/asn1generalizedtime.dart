part of '../asn1lib.dart';

///
/// An ASN1 GeneralizedTime value.
///
/// UTCTime values take the form of either 'YYMMDDhhmmssZ' or 'YYMMDDhhmmss(+|-)hhmm'.
/// The first form indicates (by the literal letter 'Z') UTC time.
/// The second form indicates a time that differs from UTC by plus or minus
/// The hours and minutes represented by the final 'hhmm'.
///
class ASN1GeneralizedTime extends ASN1Object {
  // The decoded date value
  late final DateTime dateTimeValue;

  ///
  /// Create an [ASN1GeneralizedTime] initialized with DateTime value.
  ///
  /// Optionally override the tag
  ///
  ASN1GeneralizedTime(this.dateTimeValue, {super.tag = GENERALIZED_TIME});

  ///
  /// Create an [ASN1GeneralizedTime] from an encoded list of bytes
  ///
  ASN1GeneralizedTime.fromBytes(super.bytes) : super.fromBytes() {
    var octets = valueBytes();
    var stringValue = ascii.decode(octets);
    var year = stringValue.substring(0, 4);
    var month = stringValue.substring(4, 6);
    var day = stringValue.substring(6, 8);
    var hour = stringValue.substring(8, 10);
    var minute = stringValue.substring(10, 12);
    var second = stringValue.substring(12, 14);
    if (stringValue.length > 14) {
      var timeZone = stringValue.substring(14, stringValue.length);
      dateTimeValue =
          DateTime.parse('$year-$month-$day $hour:$minute:$second$timeZone');
    } else {
      dateTimeValue = DateTime.parse('$year-$month-$day $hour:$minute:$second');
    }
  }

  @override
  Uint8List _encode() {
    var utc = dateTimeValue.toUtc();
    var year = utc.year.toString().padLeft(4, '0');
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
    return _encodedBytes!;
  }

  @override
  String toString() => 'GeneralizedTime($dateTimeValue)';
}
