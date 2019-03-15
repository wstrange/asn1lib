library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

main() {
  test("tagless", () {
    {
      ASN1Null a = ASN1Null();
      expect(a.encodedBytes, [
        0x05,
        0x00,
      ]);
    }
  });
  test("with tag", () {
    {
      ASN1Null a = ASN1Null(tag: 0x06);
      expect(a.encodedBytes, [
        0x06,
        0x00,
      ]);
    }
  });
}
