part of '../asn1lib.dart';

///
/// An ASN1 IP Address. This is length-4 array of character codes.
///
class ASN1IpAddress extends ASN1OctetString {
  ///
  /// Create an [ASN1IpAddress] initialized with a [String] or a [List<int>].
  /// Optionally override the tag
  ///
  ASN1IpAddress(List<int> octets, {int tag = IP_ADDRESS})
      : super(octets, tag: tag) {
    _assertValidLength(this.octets);
    for (var o in octets) {
      if (0 > o || o > 255) {
        throw ArgumentError('Octet out of range!.');
      }
    }
  }

  ///
  /// Create an [ASN1IpAddress] from an encoded list of bytes.
  ///
  ASN1IpAddress.fromBytes(super.bytes) : super.fromBytes() {
    _assertValidLength(octets);
  }

  ///
  /// Create an [ASN1IpAddress] from an IP Address String such as '192.168.1.1'
  ///
  static ASN1IpAddress fromComponentString(String path,
          {int tag = IP_ADDRESS}) =>
      fromComponents(path.split('.').map(int.parse).toList(), tag: tag);

  ///
  /// Create an [ASN1IpAddress] from a list of int IP Address octets
  /// e.g. [192, 168, 1, 1]
  ///
  static ASN1IpAddress fromComponents(List<int> components,
          {int tag = IP_ADDRESS}) =>
      ASN1IpAddress(components, tag: tag);

  /// Ensure there are no more or less than 4 octets for an IPv4 address
  void _assertValidLength(Uint8List octets) {
    if (octets.length != 4) {
      throw ArgumentError('IPv4 Address should contain exactly 4 octets.');
    }
  }

  @override
  String get stringValue => octets.join('.');

  @override
  String toString() => 'IpAddress($stringValue)';
}
