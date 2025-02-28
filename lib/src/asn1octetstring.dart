part of '../asn1lib.dart';

///
/// An ASN1 Octet String. This is an array of character codes.
///
class ASN1OctetString extends ASN1Object {
  /// The decoded string value
  late final Uint8List octets;

  @override
  Uint8List contentBytes() => octets;

  ///
  /// Create an [ASN1OctetString] initialized with a [String] or a [List<int>].
  /// Optionally override the tag
  ///
  ASN1OctetString(dynamic octets, {super.tag = OCTET_STRING_TYPE}) {
    if (octets is String) {
      this.octets = Uint8List.fromList(octets.codeUnits);
    } else if (octets is Uint8List) {
      this.octets = octets;
    } else if (octets is List<int>) {
      this.octets = Uint8List.fromList(octets);
    } else {
      throw ArgumentError(
          'Parameters octets should be either of type String or List<int>.');
    }
  }

  ///
  /// Create an [ASN1OctetString] from an encoded list of bytes.
  ///
  ASN1OctetString.fromBytes(super.bytes) : super.fromBytes() {
    octets = valueBytes();
  }

  /// Get the [String] value of this octet string.
  /// Note this uses Dart's default encoding of bytes to String (UTF-16).
  /// Be careful with this method as it may not be the correct encoding for
  /// your purposes.
  String get stringValue => String.fromCharCodes(octets);

  /// get the [String] value assuming utf-8 encoding of the octet bytes.
  /// UTF-8 is a common encoding for ldap servers
  String get utf8StringValue => utf8.decode(octets);

  @override
  Uint8List _encode() {
    _valueByteLength = octets.length;
    _encodeHeader();
    _setValueBytes(octets);
    //this.encodedBytes.setRange(valueStartPosition,
    //  valueStartPosition + valBytes.length, valBytes);
    return _encodedBytes!;
  }

  @override
  String toString() => 'OctetString($stringValue)';
}
