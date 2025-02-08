import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  test('encode', () {
    {
      var a = ASN1UTF8String('');
      expect(a.utf8StringValue, '');

      var encoded = a.encodedBytes;
      expect(encoded, [
        0x0c,
        0x00,
      ]);
    }
    // from https://docs.microsoft.com/en-us/windows/desktop/seccertenroll/about-utf8string
    {
      var a = ASN1UTF8String('Helló');
      expect(a.utf8StringValue, 'Helló');

      var encoded = a.encodedBytes;
      expect(encoded, [0x0c, 0x06, 0x48, 0x65, 0x6c, 0x6c, 0xc3, 0xb3]);
    }
  });
  test('decode', () {
    {
      var raw = Uint8List.fromList([
        0x0c,
        0x00,
      ]);
      var a = ASN1UTF8String.fromBytes(raw);
      expect(a.utf8StringValue, '');
    }
  });
  test('decode', () {
    {
      var raw = Uint8List.fromList([
        0x0c,
        0x00,
      ]);
      var a = ASN1UTF8String.fromBytes(raw);
      expect(a.utf8StringValue, '');
    }
    {
      var raw =
          Uint8List.fromList([0x0c, 0x06, 0x48, 0x65, 0x6c, 0x6c, 0xc3, 0xb3]);
      var a = ASN1UTF8String.fromBytes(raw);
      expect(a.utf8StringValue, 'Helló');
    }
  });

  // Tests a vanilla ASN1 Octet String. LDAP servers
  // use this in many places.
  test('ASN1OctestString encoding as utf-8', () {
    var s = 'Helló, World! 😀';
    var bytes = utf8.encode(s);
    var a = ASN1OctetString(bytes);
    var s2 = a.utf8StringValue;
    expect(s2, equals(s));
  });
}
