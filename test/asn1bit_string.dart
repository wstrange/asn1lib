library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';
import 'dart:typed_data';

void main() {
  test("Decode 0 unused bits" () {
    final bytes = Uint8List.fromList([0x03, 0x02, 0x00, 0x20]);
    final bitString = ASN1BitString.fromBytes(bytes);

    expect(bitString.unusedBits, 0);

  });

  test("Decode 5 unused bits", () {
    final bytes = Uint8List.fromList([0x03, 0x02, 0x05, 0x80]);
    final bitString = ASN1BitString.fromBytes(bytes);

    expect(bitString.unusedBits, 5);
  });
}
