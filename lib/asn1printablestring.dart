part of asn1lib;

/// An ASN1 Printable String. This is an array of character codes.
/// A PrintableString is a restricted character string type in the ASN.1 notation.
/// It is used to describe data that does only consist of a specific printable subset of the ASCII character set.
class ASN1PrintableString extends ASN1Object {

  // The decoded string value
  String stringValue;

  /// Create an [ASN1PrintableString] initialized with String value.
  /// optionally override the tag
  ASN1PrintableString(this.stringValue, {int tag: PRINTABLE_STRING_TYPE}):super(tag:tag);

  /// Create an [ASN1PrintableString] from an encoded list of bytes
  ASN1PrintableString.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    if (bytes[0] != PRINTABLE_STRING_TYPE)
      throw new ASN1Exception("First byte should be $PRINTABLE_STRING_TYPE");
    if (bytes[1] != bytes.length - 2)
      throw new ASN1Exception("Second byte should be ${bytes.length - 2}");
    stringValue = new String.fromCharCodes(bytes.sublist(2));
  }

  @override
  Uint8List _encode() {
    var valBytes = new List<int>();
    valBytes.addAll(ASCII.encode(stringValue));
    _valueByteLength = valBytes.length;
    _encodeHeader();
    _setValueBytes(valBytes);
    return _encodedBytes;
  }

  @override
  String toString() => "PrintableString(${stringValue})";

}
