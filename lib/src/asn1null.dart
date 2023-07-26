part of '../asn1lib.dart';

///
/// An ASN1 Null Object
///
class ASN1Null extends ASN1Object {
  @override
  Uint8List get _encodedBytes => Uint8List.fromList([tag, 0x00]);

  ASN1Null({super.tag = NULL_TYPE});

  ASN1Null.fromBytes(super.bytes) : super.fromBytes();

  @override
  Uint8List _encode() => Uint8List.fromList([tag, 0x00]);
}
