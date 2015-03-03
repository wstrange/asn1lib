part of asn1lib;


class ASN1ObjectIdentifier  extends ASN1Object  {

  List<int> oi;
  
  ASN1ObjectIdentifier(this.oi,{tag:OBJECT_IDENTIFIER}):super(tag:tag);

  ASN1ObjectIdentifier.fromBytes(Uint8List bytes) : super.fromBytes(bytes);

  @override
  Uint8List _encode() {
      _valueByteLength  = oi.length;
      super._encodeHeader();
      _setValueBytes(oi);
      return _encodedBytes;
    }
}