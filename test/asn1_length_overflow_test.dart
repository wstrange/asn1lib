import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

// Regression test for the ASN.1/DER long-form length integer-overflow
// out-of-bounds read (GHSA-j4h8-q5f2-r54m).
//
// A long-form length near 2^63 used to overflow the signed-64-bit bounds check
// inside Uint8List.view (start + length wraps negative), producing an
// out-of-bounds view and an uncatchable SIGSEGV when the value bytes were read.
// Parsing/reading such input must now throw a catchable ASN1Exception instead.
void main() {
  // 8-octet long-form length = 0x7FFFFFFFFFFFFFF5 (~2^63), far larger than any
  // real buffer, chosen so that `start + length` overflows to a negative value.
  final hugeLen = <int>[0x88, 0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF5];

  test('over-long OCTET STRING length inside a SEQUENCE throws (no crash)', () {
    // SEQUENCE { OCTET STRING <huge length> <1 content byte> }  -> 13 bytes
    final inner = <int>[0x04, ...hugeLen, 0x41];
    final der = Uint8List.fromList(<int>[0x30, inner.length, ...inner]);
    expect(() {
      final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
      seq.elements.first.valueBytes();
    }, throwsA(isA<ASN1Exception>()));
  });

  test('over-long top-level OBJECT IDENTIFIER length throws', () {
    // The basic_utils X509Utils.pkcs7fromPem vector: a SEQUENCE wrapping an OID
    // whose declared length is ~2^63.
    final oid = <int>[0x06, ...hugeLen];
    final der = Uint8List.fromList(<int>[0x30, oid.length, ...oid]);
    expect(() {
      final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
      seq.elements.first.valueBytes();
    }, throwsA(isA<ASN1Exception>()));
  });

  test('ASN1Object.fromBytes rejects an over-long length', () {
    // A bare primitive whose declared value length exceeds its own bytes.
    final der = Uint8List.fromList(<int>[0x04, ...hugeLen, 0x41]);
    expect(() => ASN1Object.fromBytes(der), throwsA(isA<ASN1Exception>()));
  });

  test('a 58-char malicious PEM body is rejected, not crashed', () {
    final der = <int>[0x30, 0x0a, 0x06, ...hugeLen]; // SEQUENCE { OID <huge len> }
    final bytes = base64.decode(base64.encode(Uint8List.fromList(der)));
    expect(() {
      final seq = ASN1Parser(Uint8List.fromList(bytes)).nextObject() as ASN1Sequence;
      seq.elements.first.valueBytes();
    }, throwsA(isA<ASN1Exception>()));
  });

  test('well-formed DER still parses correctly', () {
    // SEQUENCE { OCTET STRING "Hi" } — must be unaffected by the length guard.
    final der = Uint8List.fromList(<int>[0x30, 0x04, 0x04, 0x02, 0x48, 0x69]);
    final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
    final octet = seq.elements.first as ASN1OctetString;
    expect(octet.valueBytes(), equals(Uint8List.fromList([0x48, 0x69])));
  });
}
