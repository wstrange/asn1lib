part of '../asn1lib.dart';

///
/// An ASN1 Teletext String.
///
class ASN1TeletextString extends ASN1Object {
  // The decoded string value
  late final String stringValue;

  ///
  /// Create an [ASN1TeletextString] initialized with String value.
  ///
  /// Optionally override the tag
  ///
  ASN1TeletextString(this.stringValue, {super.tag = UTF8_STRING_TYPE});

  ///
  /// Create an [ASN1TeletextString] from an encoded list of bytes
  ///
  ASN1TeletextString.fromBytes(super.bytes) : super.fromBytes() {
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
  String toString() => 'ASN1TeletextString($stringValue)';
}
