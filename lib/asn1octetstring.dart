
part of asn1lib;

/// An ASN1 Octet String. This is an array of character codes.
class ASN1OctetString extends ASN1Object {

  // The decoded string value
  String stringValue;

  /// Create an [ASN1OctetString] initialized with String value.
  /// optionally override the tag
  ASN1OctetString(this.stringValue, {int tag: OCTET_STRING_TYPE}):super(tag:tag) {
    encodeHeader();
  }

  /// Create an [ASN1OctetString] from an encoded list of bytes
  ASN1OctetString.fromBytes(Uint8List bytes) {
    _encodedBytes = bytes;
    _initFromBytes();
    stringValue = decodeOctetString( valueBytes() );
  }


  encodeHeader() {
    var valBytes = stringValue.codeUnits;
    valueByteLength  = valBytes.length;
    super.encodeHeader();
    this.encodedBytes.setRange(valueStartPosition,
        valueStartPosition + valBytes.length, valBytes);
  }



  static String decodeOctetString(Uint8List bytes) => new String.fromCharCodes(bytes);

  String toString() => "OctetString(${stringValue})";

}
