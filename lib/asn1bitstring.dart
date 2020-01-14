part of asn1lib;

///
/// An ASN1 Octet String. This is an array of character codes.
///
class ASN1BitString extends ASN1Object {
  /// The decoded string value
  List<int> stringValue;
  int unusedbits;

  @override
  Uint8List contentBytes() => Uint8List.fromList(stringValue);

  ///
  /// Create an [ASN1BitString] initialized with String value. Optionally override the tag.
  ///
  ASN1BitString(this.stringValue,
      {this.unusedbits = 0, int tag = BIT_STRING_TYPE})
      : super(tag: tag);

  ///
  /// Create an [ASN1OctetString] from an encoded list of bytes
  ///
  ASN1BitString.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    unusedbits = bytes[0];
    stringValue = valueBytes().sublist(1);
  }

  @override
  Uint8List _encode() {
    var valBytes = [unusedbits];
    valBytes.addAll(stringValue);
    _valueByteLength = valBytes.length;
    _encodeHeader();
    _setValueBytes(valBytes);
    return _encodedBytes;
  }

  static String decodeOctetString(Uint8List bytes) =>
      String.fromCharCodes(bytes);

  @override
  String toString() => 'BitString(${stringValue})';
}
