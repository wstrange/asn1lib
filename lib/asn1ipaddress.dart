part of asn1lib;

///
/// An ASN1 IP Address. This is length-4 array of character codes.
///
class ASN1IpAddress extends ASN1OctetString {
  ///
  /// Create an [ASN1IpAddress] initialized with a [String] or a [List<int>].
  /// Optionally override the tag
  ///
  ASN1IpAddress(dynamic octets, {int tag = IP_ADDRESS})
      : super(octets, tag: tag) {
    _assertValidLength(this.octets);
  }

  ///
  /// Create an [ASN1IpAddress] from an encoded list of bytes.
  ///
  ASN1IpAddress.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    octets = valueBytes();
    _assertValidLength(octets);
  }

  ///
  /// Create an [ASN1IpAddress] from an IP Address String such as '192.168.1.1'
  ///
  static ASN1IpAddress fromComponentString(String path, {tag = IP_ADDRESS}) =>
      fromComponents(path.split('.').map((v) => int.parse(v)).toList(),
          tag: tag);

  ///
  /// Create an [ASN1IpAddress] from a list of int IP Address octets
  /// e.g. [192, 168, 1, 1]
  ///
  static ASN1IpAddress fromComponents(List<int> components,
          {tag = IP_ADDRESS}) =>
      ASN1IpAddress(components, tag: tag);

  void _assertValidLength(Uint8List octets) {
    if (octets.length != 4) {
      throw ArgumentError('IPv4 Address should contain exactly 4 octets.');
    }
  }

  @override
  String toString() => 'IpAddress(${stringValue})';
}
