part of asn1lib;

///
/// An ASN1 UTF8 String.
///
class ASN1UTF8String extends ASN1Object {
  // The decoded string value
  String utf8StringValue;

  ///
  /// Create an [ASN1UTF8String] initialized with String value.
  ///
  /// Optionally override the tag
  ///
  ASN1UTF8String(this.utf8StringValue, {int tag = UTF8_STRING_TYPE})
      : super(tag: tag);

  ///
  /// Create an [ASN1UTF8String] from an encoded list of bytes
  ///
  ASN1UTF8String.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    var octets = valueBytes();
    utf8StringValue = utf8.decode(octets);
  }

  @override
  Uint8List _encode() {
    var octets = utf8.encode(utf8StringValue);
    _valueByteLength = octets.length;
    _encodeHeader();
    _setValueBytes(octets);
    return _encodedBytes;
  }

  @override
  String toString() => 'UTF8String(${utf8StringValue})';
}
