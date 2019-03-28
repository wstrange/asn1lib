library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:typed_data';

main() {
  test("encode", () {
    {
      ASN1IA5String a = ASN1IA5String("");
      expect(a.stringValue, "");

      Uint8List encoded = a.encodedBytes;
      expect(encoded, [
        0x16,
        0x00,
      ]);
    }
    // from https://docs.microsoft.com/en-us/windows/desktop/seccertenroll/about-IA5string
    {
      ASN1IA5String a = ASN1IA5String("Hello");
      expect(a.stringValue, "Hello");

      Uint8List encoded = a.encodedBytes;
      expect(encoded, [0x16, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6F ]);
    }
  });
  test("decode", () {
    {
      Uint8List raw = Uint8List.fromList([
        0x16,
        0x00,
      ]);
      ASN1IA5String a = ASN1IA5String.fromBytes(raw);
      expect(a.stringValue, "");
    }
  });
  test("decode", () {
    {
      Uint8List raw = Uint8List.fromList([
        0x16,
        0x00,
      ]);
      ASN1IA5String a = ASN1IA5String.fromBytes(raw);
      expect(a.stringValue, "");
    }
    {
      Uint8List raw =
          Uint8List.fromList([0x16, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6F]);
      ASN1IA5String a = ASN1IA5String.fromBytes(raw);
      expect(a.stringValue, "Hello");
    }
  });
}
