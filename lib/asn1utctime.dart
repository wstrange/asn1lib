part of asn1lib;

/// An ASN1 UtcTime value.
/// UTCTime values take the form of either "YYMMDDhhmm[ss]Z" or "YYMMDDhhmm[ss](+|-)hhmm".
/// The first form indicates (by the literal letter "Z") UTC time.
/// The second form indicates a time that differs from UTC by plus or minus
/// the hours and minutes represented by the final "hhmm".
class ASN1UtcTime extends ASN1Object {

  // The decoded date value
  DateTime dateTimeValue;
  List<int> unusedbytes;

  /// Create an [ASN1UtcTime] initialized with DateTime value.
  /// optionally override the tag
  ASN1UtcTime(this.dateTimeValue, {int tag: PRINTABLE_STRING_TYPE}):super(tag:tag);

  /// Create an [ASN1UtcTime] from an encoded list of bytes
  ASN1UtcTime.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    // The first byte is the tag (23) and the second is CR (13)
    unusedbytes = bytes.sublist(0, 2);

    // TODO: Check if the main parse loop should really send us the full buffer
    // When there is a sequence of two UtcTime values we get both
    // in the incoming buffer when called to parsed only the first one
    // so check that we termintate parsing when we hit another tag/CR sequence (23, 13)
    var end = bytes.sublist(2).indexOf(13) + 2 - 1;
    if (end <= 0)
      end = bytes.length;

    // The DateTime.parse() function wants:
    // * Either T or space as separator between date and time.
    // * Full year with 4 digits (the UtcTime in ASN.1 has only two digits for year).
    // so we need to add that in order for DateTime to parse the Utc value
    var stringValue = new String.fromCharCodes(bytes.sublist(2, end));
    var y2 = int.parse(stringValue.substring(0, 2));
    if (y2 > 75)
      stringValue = "19" + stringValue;
    else
      stringValue = "20" + stringValue;
    stringValue = stringValue.substring(0, 8) + "T" + stringValue.substring(8);

    dateTimeValue = DateTime.parse(stringValue);
  }

  @override
  Uint8List _encode() {
    // TODO: Untested code
    var valBytes = new List.from(unusedbytes);
    var utc = dateTimeValue.toUtc();
    var year = utc.year.toString().substring(2).padLeft(2, "0");
    var month = utc.month.toString().padLeft(2, "0");
    var day = utc.day.toString().padLeft(2, "0");
    var hour = utc.hour.toString().padLeft(2, "0");
    var minute = utc.minute.toString().padLeft(2, "0");
    var second = utc.second.toString().padLeft(2, "0");
    // Encode string to YYMMDDhhmm[ss]Z
    var utcString = "$year$month$day$hour$minute${second}Z";
    valBytes.addAll(utcString.codeUnits);
    _valueByteLength = valBytes.length;
    _encodeHeader();
    _setValueBytes(valBytes);
    return _encodedBytes;
  }

  @override
  String toString() => "UtcTime(${dateTimeValue})";

}
