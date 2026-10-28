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

  test('well-formed DER still parses', () {
    final der = Uint8List.fromList([0x30, 0x04, 0x04, 0x02, 0x48, 0x69]);
    final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
    final octet = seq.elements.first as ASN1OctetString;
    expect(octet.valueBytes(), equals(Uint8List.fromList([0x48, 0x69])));
  });
}
