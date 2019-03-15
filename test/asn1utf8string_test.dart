library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:typed_data';

main() {
  test("encode", () {
    {
      ASN1UTF8String a = ASN1UTF8String("");
      expect(a.utf8StringValue, "");

      Uint8List encoded = a.encodedBytes;
      expect(encoded, [
        0x0c,
        0x00,
      ]);
    }
    // from https://docs.microsoft.com/en-us/windows/desktop/seccertenroll/about-utf8string
    {
      ASN1UTF8String a = ASN1UTF8String("Helló");
      expect(a.utf8StringValue, "Helló");

      Uint8List encoded = a.encodedBytes;
      expect(encoded, [0x0c, 0x06, 0x48, 0x65, 0x6c, 0x6c, 0xc3, 0xb3]);
    }
  });
  test("decode", () {
    {
      Uint8List raw = Uint8List.fromList([
        0x0c,
        0x00,
      ]);
      ASN1UTF8String a = ASN1UTF8String.fromBytes(raw);
      expect(a.utf8StringValue, "");
    }
  });
  test("decode", () {
    {
      Uint8List raw = Uint8List.fromList([
        0x0c,
        0x00,
      ]);
      ASN1UTF8String a = ASN1UTF8String.fromBytes(raw);
      expect(a.utf8StringValue, "");
    }
    {
      Uint8List raw =
          Uint8List.fromList([0x0c, 0x06, 0x48, 0x65, 0x6c, 0x6c, 0xc3, 0xb3]);
      ASN1UTF8String a = ASN1UTF8String.fromBytes(raw);
      expect(a.utf8StringValue, "Helló");
    }
  });
}
