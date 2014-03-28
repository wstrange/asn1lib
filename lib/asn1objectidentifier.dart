part of asn1lib;


class ASN1ObjectIdentifier  extends ASN1Object  {
  
  List<int> oi;
  
  ASN1ObjectIdentifier(this.oi):super(tag:OBJECT_IDENTIFIER);
  
  ASN1ObjectIdentifier.fromBytes(Uint8List bytes) {
      _encodedBytes = bytes;
      _initFromBytes();
  }

  @override
  Uint8List _encode() {
      valueByteLength  = oi.length;
      super._encodeHeader();
      _setValueBytes(oi);
      return _encodedBytes;
    }
}