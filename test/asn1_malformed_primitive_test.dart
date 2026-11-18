import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  void expectAsn1Exception(List<int> der) {
    expect(
      () => ASN1Parser(Uint8List.fromList(der)).nextObject().contentBytes(),
      throwsA(isA<ASN1Exception>()),
    );
  }

  test('empty BIT STRING throws ASN1Exception', () {
    expectAsn1Exception([0x03, 0x00]);
  });

  test('short GeneralizedTime throws ASN1Exception', () {
    expectAsn1Exception([0x18, 0x02, 0x32, 0x33]);
  });

  test('short UTCTime throws ASN1Exception', () {
    expectAsn1Exception([0x17, 0x01, 0x31]);
  });

  test('runaway extended tag throws ASN1Exception', () {
    expectAsn1Exception([0x1f, 0x80, 0x80, 0x80]);
  });

  test('truncated extended tag throws ASN1Exception', () {
    expectAsn1Exception([0x1f]);
  });

  test('empty BOOLEAN throws ASN1Exception', () {
    expectAsn1Exception([0x01, 0x00]);
  });

  test('empty INTEGER throws ASN1Exception', () {
    expectAsn1Exception([0x02, 0x00]);
  });

  test('empty ENUMERATED throws ASN1Exception', () {
    expectAsn1Exception([0x0a, 0x00]);
  });

  test('decodeBigInt of no bytes throws ASN1Exception', () {
    expect(
      () => ASN1Integer.decodeBigInt(Uint8List(0)),
      throwsA(isA<ASN1Exception>()),
    );
  });

  test('odd-length BMPString throws ASN1Exception', () {
    expectAsn1Exception([0x1e, 0x01, 0x41]);
    expectAsn1Exception([0x1e, 0x03, 0x00, 0x41, 0x00]);
  });

  test('well-formed BOOLEAN, INTEGER and BMPString still parse', () {
    final b = ASN1Parser(Uint8List.fromList([0x01, 0x01, 0xff])).nextObject();
    expect((b as ASN1Boolean).booleanValue, isTrue);
    final i = ASN1Parser(Uint8List.fromList([0x02, 0x01, 0x05])).nextObject();
    expect((i as ASN1Integer).intValue, equals(5));
    final s =
        ASN1Parser(Uint8List.fromList([0x1e, 0x02, 0x00, 0x41])).nextObject();
    expect((s as ASN1BMPString).stringValue, equals('A'));
  });

  test('well-formed DER still parses', () {
    final der = Uint8List.fromList([0x30, 0x04, 0x04, 0x02, 0x48, 0x69]);
    final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
    final octet = seq.elements.first as ASN1OctetString;
    expect(octet.valueBytes(), equals(Uint8List.fromList([0x48, 0x69])));
  });
}
