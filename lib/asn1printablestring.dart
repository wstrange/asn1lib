part of asn1lib;

///
/// An ASN1 Printable String.
///
/// A PrintableString is a restricted character string type in the ASN.1 notation.
/// It is used to describe data that does only consist of a specific printable subset of the ascii character set.
///
class ASN1PrintableString extends ASN1Object {
  // The decoded string value
  String stringValue;

  ///
  /// Create an [ASN1PrintableString] initialized with String value.
  ///
  /// Optionally override the tag
  ///
  ASN1PrintableString(this.stringValue, {int tag = PRINTABLE_STRING_TYPE})
      : super(tag: tag);

  ///
  /// Create an [ASN1PrintableString] from an encoded list of bytes.
  ///
  ASN1PrintableString.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    var octets = valueBytes();
    stringValue = ascii.decode(octets);
  }

  @override
  Uint8List _encode() {
    var octets = ascii.encode(stringValue);
    _valueByteLength = octets.length;
    _encodeHeader();
    _setValueBytes(octets);
    return _encodedBytes;
  }

  @override
  String toString() => 'PrintableString(${stringValue})';
}
