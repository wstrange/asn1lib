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
  });
  test("encode", () {
    // from https://docs.microsoft.com/en-us/windows/desktop/seccertenroll/about-IA5string
    {
      ASN1IA5String a = ASN1IA5String("Hello");
      expect(a.stringValue, "Hello");

      Uint8List encoded = a.encodedBytes;
      expect(encoded, [0x16, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6F]);
    }
  });
  test("encode", () {
    {
      ASN1IA5String a = ASN1IA5String("test1@rsa.com");
      expect(a.stringValue, "test1@rsa.com");

      Uint8List encoded = a.encodedBytes;
      expect(encoded, [
        0x16,
        0x0d,
        0x74,
        0x65,
        0x73,
        0x74,
        0x31,
        0x40,
        0x72,
        0x73,
        0x61,
        0x2e,
        0x63,
        0x6f,
        0x6d,
      ]);
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

  test("decode", () {
    {
      Uint8List raw = Uint8List.fromList([
        0x16,
        0x0d,
        0x74,
        0x65,
        0x73,
        0x74,
        0x31,
        0x40,
        0x72,
        0x73,
        0x61,
        0x2e,
        0x63,
        0x6f,
        0x6d,
        0x00,
      ]);
      ASN1IA5String a = ASN1IA5String.fromBytes(raw);
      expect(a.stringValue, "test1@rsa.com");
    }
    {
      Uint8List raw =
          Uint8List.fromList([0x16, 0x05, 0x48, 0x65, 0x6c, 0x6c, 0x6F]);
      ASN1IA5String a = ASN1IA5String.fromBytes(raw);
      expect(a.stringValue, "Hello");
    }
  });
}
