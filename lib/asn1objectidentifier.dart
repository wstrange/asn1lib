part of asn1lib;


class ASN1ObjectIdentifier  extends ASN1Object  {
  
  ASN1ObjectIdentifier.fromBytes(Uint8List bytes) {
      _encodedBytes = bytes;
      _initFromBytes();
//      intValue = decodeInteger(this.valueBytes());
  }
}