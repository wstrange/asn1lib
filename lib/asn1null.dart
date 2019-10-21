part of asn1lib;

///
/// An ASN1 Null Object
///
class ASN1Null extends ASN1Object {
  @override
  Uint8List get _encodedBytes => Uint8List.fromList([tag, 0x00]);

  ASN1Null({tag = NULL_TYPE}) : super(tag: tag);

  ASN1Null.fromBytes(Uint8List bytes) : super.fromBytes(bytes);

  @override
  Uint8List _encode() => Uint8List.fromList([tag, 0x00]);
}
