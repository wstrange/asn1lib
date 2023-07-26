import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

// many tests from - http://luca.ntop.org/Teaching/Appunti/asn1.html
// print(a.oi.map((x) => '0x' + x.toRadixString(16).padLeft(2, '0')));

void main() {
  test('fromComponents', () {
    // ISO member bodies
    {
      var a = ASN1ObjectIdentifier.fromComponents([1, 2]);
      expect(a.encodedBytes, equals([0x06, 0x01, 0x2a]));
      expect(a.identifier, '1.2');
      expect(a.oi.length, 2);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
    }
    // US (ANSI)
    {
      var a = ASN1ObjectIdentifier.fromComponents([1, 2, 840]);
      expect(a.encodedBytes, equals([0x06, 0x03, 0x2a, 0x86, 0x48]));
      expect(a.identifier, '1.2.840');
      expect(a.oi.length, 3);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
      expect(a.oi.elementAt(2), 840);
    }
    // RSA Data Security, Inc.
    {
      var a = ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549]);
      expect(a.encodedBytes,
          equals([0x06, 0x06, 0x2a, 0x86, 0x48, 0x86, 0xF7, 0x0D]));
      expect(a.identifier, '1.2.840.113549');
      expect(a.oi.length, 4);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
      expect(a.oi.elementAt(2), 840);
      expect(a.oi.elementAt(3), 113549);
    }
    // RSA Data Security, Inc. PKCS
    {
      var a = ASN1ObjectIdentifier.fromComponents([1, 2, 840, 113549, 1]);
      expect(a.encodedBytes,
          equals([0x06, 0x07, 0x2a, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01]));
      expect(a.identifier, '1.2.840.113549.1');
      expect(a.oi.length, 5);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
      expect(a.oi.elementAt(2), 840);
      expect(a.oi.elementAt(3), 113549);
      expect(a.oi.elementAt(4), 1);
    }
    // directory services (X.500)
    {
      var a = ASN1ObjectIdentifier.fromComponents([2, 5]);
      expect(a.encodedBytes, equals([0x06, 0x01, 0x55]));
      expect(a.identifier, '2.5');
      expect(a.oi.length, 2);
      expect(a.oi.elementAt(0), 2);
      expect(a.oi.elementAt(1), 5);
    }
    // directory services-algorithms
    {
      var a = ASN1ObjectIdentifier.fromComponents([2, 5, 8]);
      expect(a.encodedBytes, equals([0x06, 0x02, 0x55, 0x08]));
      expect(a.identifier, '2.5.8');
      expect(a.oi.length, 3);
      expect(a.oi.elementAt(0), 2);
      expect(a.oi.elementAt(1), 5);
      expect(a.oi.elementAt(2), 8);
    }

    /// Test fromComponents() with an oid that does not exist in the DN map
    /// OID used for test is SNMP protocol "sysDesc"
    {
      var objId = ASN1ObjectIdentifier.fromComponents([1, 3, 6, 1, 2, 1, 1, 1]);
      expect(objId.identifier, '1.3.6.1.2.1.1.1');
      expect(objId.oi.length, 8);
      expect(objId.oi.elementAt(0), 1);
      expect(objId.oi.elementAt(1), 3);
      expect(objId.oi.elementAt(2), 6);
      expect(objId.oi.elementAt(3), 1);
      expect(objId.oi.elementAt(4), 2);
      expect(objId.oi.elementAt(5), 1);
      expect(objId.oi.elementAt(6), 1);
      expect(objId.oi.elementAt(7), 1);
    }
  });
  test('fromComponentString', () {
    // ISO member bodies
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2');
      expect(a.encodedBytes, equals([0x06, 0x01, 0x2a]));
      expect(a.identifier, '1.2');
      expect(a.oi.length, 2);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
    }
    // US (ANSI)
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2.840');
      expect(a.encodedBytes, equals([0x06, 0x03, 0x2a, 0x86, 0x48]));
      expect(a.identifier, '1.2.840');
      expect(a.oi.length, 3);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
      expect(a.oi.elementAt(2), 840);
    }
    // RSA Data Security, Inc.
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2.840.113549');
      expect(a.encodedBytes,
          equals([0x06, 0x06, 0x2a, 0x86, 0x48, 0x86, 0xF7, 0x0D]));
      expect(a.identifier, '1.2.840.113549');
      expect(a.oi.length, 4);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
      expect(a.oi.elementAt(2), 840);
      expect(a.oi.elementAt(3), 113549);
    }
    // RSA Data Security, Inc. PKCS
    {
      var a = ASN1ObjectIdentifier.fromComponentString('1.2.840.113549.1');
      expect(a.encodedBytes,
          equals([0x06, 0x07, 0x2a, 0x86, 0x48, 0x86, 0xF7, 0x0D, 0x01]));
      expect(a.identifier, '1.2.840.113549.1');
      expect(a.oi.length, 5);
      expect(a.oi.elementAt(0), 1);
      expect(a.oi.elementAt(1), 2);
      expect(a.oi.elementAt(2), 840);
      expect(a.oi.elementAt(3), 113549);
      expect(a.oi.elementAt(4), 1);
    }
    // directory services (X.500)
    {
      var a = ASN1ObjectIdentifier.fromComponentString('2.5');
      expect(a.encodedBytes, equals([0x06, 0x01, 0x55]));
      expect(a.identifier, '2.5');
      expect(a.oi.length, 2);
      expect(a.oi.elementAt(0), 2);
      expect(a.oi.elementAt(1), 5);
    }
    // directory services-algorithms
    {
      var a = ASN1ObjectIdentifier.fromComponentString('2.5.8');
      expect(a.encodedBytes, equals([0x06, 0x02, 0x55, 0x08]));
      expect(a.identifier, '2.5.8');
      expect(a.oi.length, 3);
      expect(a.oi.elementAt(0), 2);
      expect(a.oi.elementAt(1), 5);
      expect(a.oi.elementAt(2), 8);
    }

    /// Test fromComponentString() with an oid that does not exist in the DN map
    /// OID used for test is SNMP protocol "sysDesc"
    {
      var objId = ASN1ObjectIdentifier.fromComponentString('1.3.6.1.2.1.1.1');
      expect(objId.identifier, '1.3.6.1.2.1.1.1');
      expect(objId.oi.length, 8);
      expect(objId.oi.elementAt(0), 1);
      expect(objId.oi.elementAt(1), 3);
      expect(objId.oi.elementAt(2), 6);
      expect(objId.oi.elementAt(3), 1);
      expect(objId.oi.elementAt(4), 2);
      expect(objId.oi.elementAt(5), 1);
      expect(objId.oi.elementAt(6), 1);
      expect(objId.oi.elementAt(7), 1);
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

    expect(
        () => ASN1ObjectIdentifier.fromName('doesNotExist'), throwsException);
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
    {
      var bytes = Uint8List.fromList([0x06, 0x03, 0x55, 0x04, 0x03]);
      var objId = ASN1ObjectIdentifier.fromBytes(bytes);
      expect(objId.encodedBytes, equals(bytes));
      expect(objId.identifier, '2.5.4.3');
      expect(objId.oi.length, 4);
      expect(objId.oi.elementAt(0), 2);
      expect(objId.oi.elementAt(1), 5);
      expect(objId.oi.elementAt(2), 4);
      expect(objId.oi.elementAt(3), 3);
    }

    /// Test fromBytes() with an oid that does not exist in the DN map
    /// OID used for test is SNMP protocol "sysDesc"
    {
      var bytes = Uint8List.fromList(
          [0x06, 0x07, 0x2B, 0x06, 0x01, 0x02, 0x01, 0x01, 0x01]);
      var objId = ASN1ObjectIdentifier.fromBytes(bytes);
      expect(objId.encodedBytes, equals(bytes));
      expect(objId.identifier, '1.3.6.1.2.1.1.1');
      expect(objId.oi.length, 8);
      expect(objId.oi.elementAt(0), 1);
      expect(objId.oi.elementAt(1), 3);
      expect(objId.oi.elementAt(2), 6);
      expect(objId.oi.elementAt(3), 1);
      expect(objId.oi.elementAt(4), 2);
      expect(objId.oi.elementAt(5), 1);
      expect(objId.oi.elementAt(6), 1);
      expect(objId.oi.elementAt(7), 1);
    }
  });

  test('toString', () {
    var bytes = Uint8List.fromList(
        [0x06, 0x07, 0x2B, 0x06, 0x01, 0x02, 0x01, 0x01, 0x01]);
    var objId = ASN1ObjectIdentifier.fromBytes(bytes);
    expect(objId.toString(), 'ObjectIdentifier(1.3.6.1.2.1.1.1)');
  });
}
