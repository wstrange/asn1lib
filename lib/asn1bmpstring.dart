part of asn1lib;

///
/// An ASN1 BMP String.
///
/// A BMPString is a restricted character string type in the ASN.1 notation. We are treating it as 2 byte UTF8 data
///
class ASN1BMPString extends ASN1Object {
  /// The decoded string value
  late String stringValue;

  ///
  /// Create an [ASN1BMPString] initialized with String value.
  /// Optionally override the tag
  ///
  ASN1BMPString(this.stringValue, {int tag = BMP_STRING_TYPE})
      : super(tag: tag);

  ///
  /// Create an [ASN1BMPString] from an encoded list of bytes
  ///
  ASN1BMPString.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    var octets = valueBytes();
    var mergedOctets = <int>[];

    for (var i = 0; i < octets.length;) {
      var hi = octets[i++];
      var lo = octets[i++];
      mergedOctets.add((hi << 8) | lo);
    }

    stringValue = utf8.decode(mergedOctets);
  }

  @override
  Uint8List? _encode() {
    var octets = utf8.encode(stringValue);
    var doubleOctets = <int>[];

    for (var i = 0; i < octets.length; i++) {
      doubleOctets.add(octets[i] >> 8);
      doubleOctets.add(octets[i] & 0xff);
    }

    _valueByteLength = doubleOctets.length;
    _encodeHeader();
    _setValueBytes(doubleOctets);
    return _encodedBytes;
  }

  @override
  String toString() => 'ASN1BMPString($stringValue)';
}
