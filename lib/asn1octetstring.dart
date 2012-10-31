
part of asn1lib;

class ASN1OctetString extends ASN1Object {

  String stringValue;

  ASN1OctetString(this.stringValue) {
    tag = OCTET_STRING_TYPE;
  }

  ASN1OctetString.fromBytes(Uint8List bytes) {
    _encodedBytes = bytes;
    _initFromBytes();
   
    stringValue = decodeOctetString( valueBytes() );
  }
  

  encode() {
    var valBytes = stringValue.charCodes;
    valueByteLength  = valBytes.length;
    super.encode();
    this.encodedBytes.setRange(valueStartPosition, valBytes.length, valBytes);
  }

 

  static String decodeOctetString(Uint8List bytes) => new String.fromCharCodes(bytes);

  String toString() => "OctetString(${stringValue})";

}
