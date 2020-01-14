library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

void main() {
  test('tagless', () {
    {
      var a = ASN1Null();
      expect(a.encodedBytes, [
        0x05,
        0x00,
      ]);
    }
  });
  test('with tag', () {
    {
      var a = ASN1Null(tag: 0x06);
      expect(a.encodedBytes, [
        0x06,
        0x00,
      ]);
    }
  });
}
