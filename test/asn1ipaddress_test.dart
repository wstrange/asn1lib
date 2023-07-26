import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  test('IpAddress default constructor', () {
    {
      var a = ASN1IpAddress([192, 168, 0, 1]);
      expect(a.octets.elementAt(0), equals(192));
      expect(a.octets.elementAt(1), equals(168));
      expect(a.octets.elementAt(2), equals(0));
      expect(a.octets.elementAt(3), equals(1));
      expect(a.stringValue, equals('192.168.0.1'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0xC0, 0xA8, 0x00, 0x01]));
    }

    {
      var a = ASN1IpAddress([10, 23, 128, 255]);
      expect(a.octets.elementAt(0), equals(10));
      expect(a.octets.elementAt(1), equals(23));
      expect(a.octets.elementAt(2), equals(128));
      expect(a.octets.elementAt(3), equals(255));
      expect(a.stringValue, equals('10.23.128.255'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0x0A, 0x17, 0x80, 0xFF]));
    }
  });

  test('IpAddress fromBytes', () {
    {
      var a = ASN1IpAddress.fromBytes(
          Uint8List.fromList([0x40, 0x04, 0xC0, 0xA8, 0x00, 0x01]));
      expect(a.octets.elementAt(0), equals(192));
      expect(a.octets.elementAt(1), equals(168));
      expect(a.octets.elementAt(2), equals(0));
      expect(a.octets.elementAt(3), equals(1));
      expect(a.stringValue, equals('192.168.0.1'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0xC0, 0xA8, 0x00, 0x01]));
    }

    {
      var a = ASN1IpAddress.fromBytes(
          Uint8List.fromList([0x40, 0x04, 0x0A, 0x17, 0x80, 0xFF]));
      expect(a.octets.elementAt(0), equals(10));
      expect(a.octets.elementAt(1), equals(23));
      expect(a.octets.elementAt(2), equals(128));
      expect(a.octets.elementAt(3), equals(255));
      expect(a.stringValue, equals('10.23.128.255'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0x0A, 0x17, 0x80, 0xFF]));
    }
  });

  test('IpAddress fromComponents', () {
    {
      var a = ASN1IpAddress.fromComponents([192, 168, 0, 1]);
      expect(a.octets.elementAt(0), equals(192));
      expect(a.octets.elementAt(1), equals(168));
      expect(a.octets.elementAt(2), equals(0));
      expect(a.octets.elementAt(3), equals(1));
      expect(a.stringValue, equals('192.168.0.1'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0xC0, 0xA8, 0x00, 0x01]));
    }

    {
      var a = ASN1IpAddress.fromComponents([10, 23, 128, 255]);
      expect(a.octets.elementAt(0), equals(10));
      expect(a.octets.elementAt(1), equals(23));
      expect(a.octets.elementAt(2), equals(128));
      expect(a.octets.elementAt(3), equals(255));
      expect(a.stringValue, equals('10.23.128.255'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0x0A, 0x17, 0x80, 0xFF]));
    }
  });

  test('IpAddress fromComponentString', () {
    {
      var a = ASN1IpAddress.fromComponentString('192.168.0.1');
      expect(a.octets.elementAt(0), equals(192));
      expect(a.octets.elementAt(1), equals(168));
      expect(a.octets.elementAt(2), equals(0));
      expect(a.octets.elementAt(3), equals(1));
      expect(a.stringValue, equals('192.168.0.1'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0xC0, 0xA8, 0x00, 0x01]));
    }

    {
      var a = ASN1IpAddress.fromComponentString('10.23.128.255');
      expect(a.octets.elementAt(0), equals(10));
      expect(a.octets.elementAt(1), equals(23));
      expect(a.octets.elementAt(2), equals(128));
      expect(a.octets.elementAt(3), equals(255));
      expect(a.stringValue, equals('10.23.128.255'));
      expect(a.encodedBytes, equals([0x40, 0x04, 0x0A, 0x17, 0x80, 0xFF]));
    }
  });

  test('IpAddress invalid input', () {
    {
      expect(() => ASN1IpAddress([1, 2, 3]), throwsArgumentError);
      expect(() => ASN1IpAddress([1, 2, 3, 4, 5]), throwsArgumentError);
      expect(
          () => ASN1IpAddress.fromBytes(
              Uint8List.fromList([0x40, 0x03, 0x01, 0x02, 0x03])),
          throwsArgumentError);
      expect(
          () => ASN1IpAddress.fromBytes(
              Uint8List.fromList([0x40, 0x05, 0x01, 0x02, 0x03, 0x04, 0x05])),
          throwsArgumentError);
    }
    {
      expect(() => ASN1IpAddress([1, 2, 3, 256]), throwsArgumentError);
    }
  });
}
