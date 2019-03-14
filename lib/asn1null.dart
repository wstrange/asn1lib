
part of asn1lib;

class ASN1Null extends ASN1Object {

  static final nullBytes = Uint8List.fromList([NULL_TYPE, 0x00]);

  @override
  Uint8List get _encodedBytes => nullBytes;
  
  ASN1Null():super(tag:NULL_TYPE);
  
  
  ASN1Null.fromBytes(Uint8List bytes) : super.fromBytes(bytes);

  @override
  Uint8List _encode() => _encodedBytes;

}
