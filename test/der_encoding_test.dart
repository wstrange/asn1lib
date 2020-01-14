library asn1test.der;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

void main() {
  group('der-encoding', () {
    test('bit-string', () {
      // 011011100101110111 (padded to 011011100101110111000000 to form 6e5dc0)
      // should become 03 04 06 6e 5d c0
      var bs = ASN1BitString([0x6e, 0x5d, 0xc0], unusedbits: 6);
      expect(bs.encodedBytes, equals([0x03, 0x04, 0x06, 0x6e, 0x5d, 0xc0]));
    });

    test('null', () {
      // null object
      // should become 05 00
      var n = ASN1Null();
      expect(n.encodedBytes, equals([0x05, 0x00]));
    });

    test('octet-string', () {
      // the octetstring 01 23 45 67 89 ab cd ef
      // should become 04 08 01 23 45 67 89 ab cd ef
      var os1 = ASN1OctetString(String.fromCharCodes(
          [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]));
      var os2 =
          ASN1OctetString([0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]);
      expect(os1.encodedBytes,
          equals([0x04, 0x08, 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]));
      expect(os2.encodedBytes,
          equals([0x04, 0x08, 0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef]));
    });

    // PrintableString 'Test User 1'
    // should become 13 0b 54 65 73 74 20 55 73 65 72 20 31

    // T61String 'cl'es publiques'
    // should become 14 0f 63 6c c2 65 73 20 70 75 62 6c 69 71 75 65 73

    test('printable-string', () {
      var testString = 'TheTestString';
      var ps = ASN1PrintableString(testString);
      expect(
          ps.encodedBytes,
          equals([
            PRINTABLE_STRING_TYPE,
            testString.length,
            0x54,
            0x68,
            0x65,
            0x54,
            0x65,
            0x73,
            0x74,
            0x53,
            0x74,
            0x72,
            0x69,
            0x6e,
            0x67
          ]));
    });

    test('utc-time', () {
      var testTime = DateTime.utc(2006, 03, 09, 17, 18);
      var ut = ASN1UtcTime(testTime);
      expect(
          ut.encodedBytes,
          equals([
            UTC_TIME_TYPE,
            0x0d,
            0x30,
            0x36,
            0x30,
            0x33,
            0x30,
            0x39,
            0x31,
            0x37,
            0x31,
            0x38,
            0x30,
            0x30,
            0x5a
          ]));
    });
  });
}
