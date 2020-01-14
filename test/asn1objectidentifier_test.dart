library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:typed_data';

// many tests from - http://luca.ntop.org/Teaching/Appunti/asn1.html
// print(a.oi.map((x) => '0x' + x.toRadixString(16).padLeft(2, '0')));

void main() {
  test('fromComponents', () {
    // ISO member bodies
    {
      var a = ASN1ObjectIdentifier.fromComponents([
        1,
        2,
      ]);
      expect(a.oi, equals([0x2a]));
    }
    // US (ANSI)
    {
      var a = ASN1ObjectIdentifier.fromComponents([
        1,
        2,
        840,
      ]);
      expect(a.oi, equals([0x2a, 0x86, 0x48]));
    }
    // RSA Data Security, Inc.
    {
      var a = ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549]);
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d]));
    }
    // RSA Data Security, Inc. PKCS
    {
      var a = ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549, 1]);
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01]));
    }
    // directory services (X.500)
    {
      var a = ASN1ObjectIdentifier.fromComponents([
        2,
        5,
      ]);
      expect(a.oi, equals([0x55]));
    }
    // directory services-algorithms
    {
      var a = ASN1ObjectIdentifier.fromComponents([
        2,
        5,
        8,
      ]);
      expect(a.oi, equals([0x55, 0x08]));
    }
  });
  test('fromComponentString', () {
    // ISO member bodies
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2');
      expect(a.oi, equals([0x2a]));
    }
    // US (ANSI)
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2.840');
      expect(a.oi, equals([0x2a, 0x86, 0x48]));
    }
    // RSA Data Security, Inc.
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2.840.113549');
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d]));
    }
    // RSA Data Security, Inc. PKCS
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2.840.113549.1');
      expect(a.oi, equals([0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01]));
    }
    // directory services (X.500)
    {
      var a = ASN1ObjectIdentifier.fromComponentString('2.5');
      expect(a.oi, equals([0x55]));
    }
    // directory services-algorithms
    {
      var a = ASN1ObjectIdentifier.fromComponentString('2.5.8');
      expect(a.oi, equals([0x55, 0x08]));
    }
  });

  test('fromName', () {
    // test that registration works
    var ou = ASN1ObjectIdentifier.fromComponentString('2.5.4.11');
    ASN1ObjectIdentifier.registerObjectIdentiferName('Ou', ou);

    // test lookup (noting case indepence)
    {
      var got = ASN1ObjectIdentifier.fromName('ou');
      expect(got.oi, equals(ou.oi));
      expect(got.tag, equals(ou.tag));
    }

    // test name doesn't exist
    {
      var got = ASN1ObjectIdentifier.fromName('doesNotExist');
      expect(got, equals(null));
    }
  });

  test('registerManyNames', () {
    ASN1ObjectIdentifier.registerManyNames({
      'title': '2.5.4.12',
      'givenName': '2.5.4.42',
    });

    var title = ASN1ObjectIdentifier.fromComponentString('2.5.4.12');
    var givenName = ASN1ObjectIdentifier.fromComponentString('2.5.4.42');

    {
      var got = ASN1ObjectIdentifier.fromName('TITLE');
      expect(got.oi, equals(title.oi));
      expect(got.tag, equals(title.tag));
    }

    {
      var got = ASN1ObjectIdentifier.fromName('GIVENNAME');
      expect(got.oi, equals(givenName.oi));
      expect(got.tag, equals(givenName.tag));
    }
  });
  test('registerFrequentNames', () {
    ASN1ObjectIdentifier.registerFrequentNames();

    var registeredAddress =
        ASN1ObjectIdentifier.fromComponentString('2.5.4.26');

    {
      var got = ASN1ObjectIdentifier.fromName('registeredAddress');
      expect(got.oi, equals(registeredAddress.oi));
      expect(got.tag, equals(registeredAddress.tag));
    }
  });

  test('fromBytes', () {
    var bytes = Uint8List.fromList([0x06, 0x03, 0x55, 0x04, 0x03]);
    var objId = ASN1ObjectIdentifier.fromBytes(bytes);
    expect(objId.identifier, '2.5.4.3');
    expect(objId.oi.length, 4);
    expect(objId.oi.elementAt(0), 2);
    expect(objId.oi.elementAt(1), 5);
    expect(objId.oi.elementAt(2), 4);
    expect(objId.oi.elementAt(3), 3);
  });
}
