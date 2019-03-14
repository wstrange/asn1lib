library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

// many tests from - http://luca.ntop.org/Teaching/Appunti/asn1.html
// print(a.oi.map((x) => "0x" + x.toRadixString(16).padLeft(2, "0")));

main() {
  test("fromComponents", () {
    // ISO member bodies
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponents([
        1,
        2,
      ]);
      expect(a.oi, equals([0x12]));
    }
    // US (ANSI)
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponents([
        1,
        2,
        840,
      ]);
      expect(a.oi, equals([0x12, 0x86, 0x48]));
    }
    // RSA Data Security, Inc.
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549]);
      expect(a.oi, equals([0x12, 0x86, 0x48, 0x86, 0xf7, 0x0d]));
    }
    // RSA Data Security, Inc. PKCS
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549, 1]);
      expect(a.oi, equals([0x12, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01]));
    }
    // directory services (X.500)
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponents([
        2,
        5,
      ]);
      expect(a.oi, equals([0x25]));
    }
    // directory services-algorithms
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponents([
        2,
        5,
        8,
      ]);
      expect(a.oi, equals([0x25, 0x08]));
    }
  });
  test("fromComponentString", () {
    // ISO member bodies
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponentString("1.2");
      expect(a.oi, equals([0x12]));
    }
    // US (ANSI)
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("1.2.840");
      expect(a.oi, equals([0x12, 0x86, 0x48]));
    }
    // RSA Data Security, Inc.
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("1.2.840.113549");
      expect(a.oi, equals([0x12, 0x86, 0x48, 0x86, 0xf7, 0x0d]));
    }
    // RSA Data Security, Inc. PKCS
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("1.2.840.113549.1");
      expect(a.oi, equals([0x12, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01]));
    }
    // directory services (X.500)
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponentString("2.5");
      expect(a.oi, equals([0x25]));
    }
    // directory services-algorithms
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("2.5.8");
      expect(a.oi, equals([0x25, 0x08]));
    }
  });
}
