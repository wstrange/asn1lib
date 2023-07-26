import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  test('encode', () {
    {
      var a = ASN1NumericString('');
      expect(a.stringValue, '');

      var encoded = a.encodedBytes;
      expect(encoded, [
        0x12,
        0x00,
      ]);
    }
  });
  test('encode', () {
    {
      var a = ASN1NumericString('1047702026701');
      expect(a.stringValue, '1047702026701');

      var encoded = a.encodedBytes;
      expect(encoded, [
        0x12,
        0x0D,
        0x31,
        0x30,
        0x34,
        0x37,
        0x37,
        0x30,
        0x32,
        0x30,
        0x32,
        0x36,
        0x37,
        0x30,
        0x31
      ]);
    }
  });
  test('encode', () {
    expect(() => ASN1NumericString('a'), throwsException);
  });
  test('decode', () {
    {
      var raw = Uint8List.fromList([
        0x12,
        0x0D,
        0x31,
        0x30,
        0x34,
        0x37,
        0x37,
        0x30,
        0x32,
        0x30,
        0x32,
        0x36,
        0x37,
        0x30,
        0x31
      ]);
      var a = ASN1IA5String.fromBytes(raw);
      expect(a.stringValue, '1047702026701');
    }
  });
  test('decode', () {
    {
      var raw = Uint8List.fromList([
        0x12,
        0x0C,
        0x30,
        0x30,
        0x37,
        0x37,
        0x31,
        0x30,
        0x34,
        0x37,
        0x34,
        0x33,
        0x37,
        0x35
      ]);
      var a = ASN1IA5String.fromBytes(raw);
      expect(a.stringValue, '007710474375');
    }
  });
}
