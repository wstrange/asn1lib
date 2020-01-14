part of asn1lib;

///
/// An ASN1 Octet String. This is an array of character codes.
///
class ASN1OctetString extends ASN1Object {
  /// The decoded string value
  Uint8List octets;

  @override
  Uint8List contentBytes() => octets;

  ///
  /// Create an [ASN1OctetString] initialized with a [String] or a [List<int>].
  /// Optionally override the tag
  ///
  ASN1OctetString(dynamic octets, {int tag = OCTET_STRING_TYPE})
      : super(tag: tag) {
    if (octets is String) {
      this.octets = Uint8List.fromList(octets.codeUnits);
    } else if (octets is Uint8List) {
      this.octets = octets;
    } else if (octets is List<int>) {
      this.octets = Uint8List.fromList(octets);
    } else {
      throw ArgumentError(
          'Parameters octets should be either of type String or List<int>.');
    }
  }

  ///
  /// Create an [ASN1OctetString] from an encoded list of bytes.
  ///
  ASN1OctetString.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    octets = valueBytes();
  }

  ///
  /// Get the [String] value of this octet string.
  ///
  String get stringValue => String.fromCharCodes(octets);

  @override
  Uint8List _encode() {
    _valueByteLength = octets.length;
    _encodeHeader();
    _setValueBytes(octets);
    //this.encodedBytes.setRange(valueStartPosition,
    //  valueStartPosition + valBytes.length, valBytes);
    return _encodedBytes;
  }

  @override
  String toString() => 'OctetString(${stringValue})';
}
