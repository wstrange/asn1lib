part of '../asn1lib.dart';

///
/// An ASN1 Numeric String
///
/// A NumericString is a restricted character string type in the ASN.1 notation.
/// It is used to describe data that does only consist of digits and space character.
///
class ASN1NumericString extends ASN1Object {
  // The decoded string value
  late final String stringValue;

  ///
  /// Create an [ASN1NumericString] initialized with String value.
  ///
  /// Optionally override the tag
  ///
  ASN1NumericString(this.stringValue, {super.tag = NUMERIC_STRING_TYPE}) {
    if (!RegExp(r'^[\d\s]*$').hasMatch(stringValue)) {
      throw ASN1Exception(
          'ASN1 NumericString should only include digits or spaces');
    }
  }

  ///
  /// Create an [ASN1NumericString] from an encoded list of bytes.
  ///
  ASN1NumericString.fromBytes(super.bytes) : super.fromBytes() {
    var octets = valueBytes();
    stringValue = ascii.decode(octets);
  }

  @override
  Uint8List _encode() {
    var octets = ascii.encode(stringValue);
    _valueByteLength = octets.length;
    _encodeHeader();
    _setValueBytes(octets);
    return _encodedBytes!;
  }

  @override
  String toString() => 'NumericString($stringValue)';
}
