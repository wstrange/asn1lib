part of asn1lib;

///
/// An ASN1 Boolean
///
class ASN1Boolean extends ASN1Object {
  bool _boolValue;

  static final ASN1Boolean ASN1TrueBoolean = ASN1Boolean(true);
  static final ASN1Boolean ASN1FalseBoolean = ASN1Boolean(false);

  bool get booleanValue => _boolValue;

  // ASN1Boolean(this._boolValue,{tag: BOOLEAN_TYPE}):super(tag:BOOLEAN_TYPE) {
  ASN1Boolean(this._boolValue, {tag = BOOLEAN_TYPE}) : super(tag: tag) {
    _valueByteLength = 1;
  }

  ASN1Boolean.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    var b = bytes[_valueStartPosition];
    _boolValue = (b == BOOLEAN_TRUE_VALUE);
  }

  @override
  Uint8List _encode() {
    super._encodeHeader();
    super._setValueBytes(
        [_boolValue == true ? BOOLEAN_TRUE_VALUE : BOOLEAN_FALSE_VALUE]);
    return _encodedBytes;
  }
}
