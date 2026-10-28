import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  List<int> encodeLength(int length) {
    if (length < 128) return [length];
    final out = <int>[];
    var remaining = length;
    while (remaining > 0) {
      out.insert(0, remaining & 0xFF);
      remaining >>= 8;
    }
    return [0x80 | out.length, ...out];
  }

  Uint8List nested(int tag, int depth) {
    var current = <int>[0x05, 0x00];
    for (var i = 0; i < depth; i++) {
      current = [tag, ...encodeLength(current.length), ...current];
    }
    return Uint8List.fromList(current);
  }

  test('deeply nested SEQUENCE throws ASN1Exception instead of overflowing the stack',
      () {
    expect(() => ASN1Parser(nested(0x30, 3000)).nextObject(),
        throwsA(isA<ASN1Exception>()));
  });

  test('deeply nested SET throws ASN1Exception instead of overflowing the stack',
      () {
    expect(() => ASN1Parser(nested(0x31, 3000)).nextObject(),
        throwsA(isA<ASN1Exception>()));
  });

  test('nesting just past the limit is rejected with ASN1Exception', () {
    expect(() => ASN1Parser(nested(0x30, 129)).nextObject(),
        throwsA(isA<ASN1Exception>()));
  });

  test('nesting within the limit parses without error', () {
    final obj = ASN1Parser(nested(0x30, 128)).nextObject();
    expect(obj, isA<ASN1Sequence>());
  });

  test('shallow well-formed DER still parses correctly', () {
    final der = Uint8List.fromList(<int>[0x30, 0x04, 0x04, 0x02, 0x48, 0x69]);
    final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
    final octet = seq.elements.first as ASN1OctetString;
    expect(octet.valueBytes(), equals(Uint8List.fromList([0x48, 0x69])));
  });
}
