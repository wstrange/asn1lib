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
      expect(a.oi, equals([0x2a]));
    }
    // US (ANSI)
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponents([
        1,
        2,
        840,
      ]);
      expect(a.oi, equals([0x2a, 0x86, 0x48]));
    }
    // RSA Data Security, Inc.
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549]);
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d]));
    }
    // RSA Data Security, Inc. PKCS
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549, 1]);
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01]));
    }
    // directory services (X.500)
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponents([
        2,
        5,
      ]);
      expect(a.oi, equals([0x55]));
    }
    // directory services-algorithms
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponents([
        2,
        5,
        8,
      ]);
      expect(a.oi, equals([0x55, 0x08]));
    }
  });
  test("fromComponentString", () {
    // ISO member bodies
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponentString("1.2");
      expect(a.oi, equals([0x2a]));
    }
    // US (ANSI)
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("1.2.840");
      expect(a.oi, equals([0x2a, 0x86, 0x48]));
    }
    // RSA Data Security, Inc.
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("1.2.840.113549");
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d]));
    }
    // RSA Data Security, Inc. PKCS
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("1.2.840.113549.1");
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01]));
    }
    // directory services (X.500)
    {
      ASN1ObjectIdentifier a = ASN1ObjectIdentifier.fromComponentString("2.5");
      expect(a.oi, equals([0x55]));
    }
    // directory services-algorithms
    {
      ASN1ObjectIdentifier a =
          ASN1ObjectIdentifier.fromComponentString("2.5.8");
      expect(a.oi, equals([0x55, 0x08]));
    }
  });

  test("fromName", () {
    // test that registration works
    ASN1ObjectIdentifier ou = ASN1ObjectIdentifier.fromComponentString("2.5.4.11");
    ASN1ObjectIdentifier.registerObjectIdentiferName("Ou", ou);

    // test lookup (noting case indepence)
    {
      ASN1ObjectIdentifier got = ASN1ObjectIdentifier.fromName("ou");
      expect(got.oi, equals(ou.oi));
      expect(got.tag, equals(ou.tag));
    }

    // test name doesn't exist
    {
      ASN1ObjectIdentifier got = ASN1ObjectIdentifier.fromName("doesNotExist");
      expect(got, equals(null));
    }
  });

  test("registerManyNames", () {
    ASN1ObjectIdentifier.registerManyNames({
      "title": "2.5.4.12",
      "givenName": "2.5.4.42",
    });

    ASN1ObjectIdentifier title = ASN1ObjectIdentifier.fromComponentString("2.5.4.12");
    ASN1ObjectIdentifier givenName = ASN1ObjectIdentifier.fromComponentString("2.5.4.42");

    {
      ASN1ObjectIdentifier got = ASN1ObjectIdentifier.fromName("TITLE");
      expect(got.oi, equals(title.oi));
      expect(got.tag, equals(title.tag));
    }

    {
      ASN1ObjectIdentifier got = ASN1ObjectIdentifier.fromName("GIVENNAME");
      expect(got.oi, equals(givenName.oi));
      expect(got.tag, equals(givenName.tag));
    }

  });
  test("registerFrequentNames", () {
    ASN1ObjectIdentifier.registerFrequentNames();

    ASN1ObjectIdentifier registeredAddress = ASN1ObjectIdentifier.fromComponentString("2.5.4.26");

    {
      ASN1ObjectIdentifier got = ASN1ObjectIdentifier.fromName("registeredAddress");
      expect(got.oi, equals(registeredAddress.oi));
      expect(got.tag, equals(registeredAddress.tag));
    }

  });
}
