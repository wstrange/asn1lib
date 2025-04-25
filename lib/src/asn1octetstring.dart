part of '../asn1lib.dart';

///
/// An ASN1 Octet String. This is an array of character codes.
///
/// WARNING: The constructor `ASN1OctetString(String)` will encode the string
/// as UTF-8 octets. This is not different than Dart's UTF-16 encoding scheme.
///
/// If you need a different encoding, you should encode the string
/// as a Uint8List yourself and pass that to the constructor.
///
class ASN1OctetString extends ASN1Object {
  /// The decoded string value
  late final Uint8List octets;

  @override
  Uint8List contentBytes() => octets;

  ///
  /// Create an [ASN1OctetString] initialized with a [String] or a [List<int>].
  /// Optionally override the default ASN1 tag
  ///
  /// The String will be encoded as UTF-8 octets. This is not different than Dart's
  /// default encoding of strings as UTF-16.
  ///
  ASN1OctetString(dynamic octets, {super.tag = OCTET_STRING_TYPE}) {
    if (octets is String) {
      // We now default to utf8 encoding
      // this.octets = Uint8List.fromList(octets.codeUnits);
      this.octets = utf8.encode(octets);
    } else if (octets is Uint8List) {
      this.octets = octets;
    } else if (octets is List<int>) {
      this.octets = Uint8List.fromList(octets);
    } else {
      throw ArgumentError(
        'Parameters octets should be either of type String or List<int>.',
      );
    }
  }

  ///
  /// Create an [ASN1OctetString] from an encoded list of bytes.
  ///
  ASN1OctetString.fromBytes(super.bytes) : super.fromBytes() {
    octets = valueBytes();
  }

  /// Get the [String] value of this octet string.
  /// Note this uses Dart's default decoding of bytes to String (UTF-16).
  /// Be careful with this method as it may not be the correct encoding for
  /// your purposes.
  /// @deprecated use [utf8StringValue] or [utf16StringValue] instead
  String get stringValue => String.fromCharCodes(octets);

  String get utf16StringValue => String.fromCharCodes(octets);

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
  // Prints the string value of the octet string assuming utf-8 encoding.
  // This may not be what you want. If the object contents can't be decoded
  // as utf-8 string it is printed as an array of integer byte values.
  String toString() {
    try {
      return utf8StringValue;
    } catch (e) {
      return octets.toString();
    }
  }
}
