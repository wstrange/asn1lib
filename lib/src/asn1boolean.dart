part of '../asn1lib.dart';

///
/// An ASN1 Boolean
///
class ASN1Boolean extends ASN1Object {
  late final bool booleanValue;

  static final ASN1Boolean ASN1TrueBoolean = ASN1Boolean(true);
  static final ASN1Boolean ASN1FalseBoolean = ASN1Boolean(false);

  // ASN1Boolean(this._boolValue,{tag: BOOLEAN_TYPE}):super(tag:BOOLEAN_TYPE) {
  ASN1Boolean(this.booleanValue, {super.tag = BOOLEAN_TYPE}) {
    _valueByteLength = 1;
  }

  ASN1Boolean.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    var b = bytes[_valueStartPosition];
    booleanValue = (b == BOOLEAN_TRUE_VALUE);
  }

  @override
  Uint8List _encode() {
    super._encodeHeader();
    super._setValueBytes(
        [booleanValue ? BOOLEAN_TRUE_VALUE : BOOLEAN_FALSE_VALUE]);
    return _encodedBytes!;
  }
}
