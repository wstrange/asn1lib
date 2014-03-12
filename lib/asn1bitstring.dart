
part of asn1lib;

/// An ASN1 Octet String. This is an array of character codes.
class ASN1BitString extends ASN1Object {

  // The decoded string value
  List<int> stringValue;
  int unusedbits;

  /// Create an [ASN1BitString] initialized with String value.
  /// optionally override the tag
  ASN1BitString(this.stringValue, {int tag: BIT_STRING_TYPE}):super(tag:tag) {
    unusedbits = 0;
  }

  /// Create an [ASN1OctetString] from an encoded list of bytes
  ASN1BitString.fromBytes(Uint8List bytes) {
    _encodedBytes = bytes;
    _initFromBytes();
    unusedbits = bytes[0];
    stringValue = valueBytes().sublist(1);
  }


  Uint8List encode() {
    var valBytes = [unusedbits];
    valBytes.addAll(stringValue);
    valueByteLength  = valBytes.length;
    _encodeHeader();
    _setValueBytes(valBytes);
    //this.encodedBytes.setRange(valueStartPosition,
      //  valueStartPosition + valBytes.length, valBytes);
    return _encodedBytes;
  }



  static String decodeOctetString(Uint8List bytes) => new String.fromCharCodes(bytes);

  String toString() => "BitString(${stringValue})";

}
