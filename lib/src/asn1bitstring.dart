part of '../asn1lib.dart';

///
/// An ASN1 Octet String. This is an array of character codes.
///
class ASN1BitString extends ASN1Object {
  /// The decoded string value
  late final List<int> stringValue;
  late final int unusedbits;

  @override
  Uint8List contentBytes() => Uint8List.fromList(stringValue);

  ///
  /// Create an [ASN1BitString] initialized with String value. Optionally override the tag.
  ///
  ASN1BitString(this.stringValue,
      {this.unusedbits = 0, super.tag = BIT_STRING_TYPE});

  ///
  /// Create an [ASN1OctetString] from an encoded list of bytes
  ///
  ASN1BitString.fromBytes(super.bytes) : super.fromBytes() {
    unusedbits = valueBytes()[0];
    stringValue = valueBytes().sublist(1);
  }

  @override
  Uint8List _encode() {
    var valBytes = [unusedbits];
    valBytes.addAll(stringValue);
    _valueByteLength = valBytes.length;
    _encodeHeader();
    _setValueBytes(valBytes);
    return _encodedBytes!;
  }

  static String decodeOctetString(Uint8List bytes) =>
      String.fromCharCodes(bytes);

  @override
  String toString() => 'BitString($stringValue)';
}
