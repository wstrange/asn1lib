import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

// test for issue https://github.com/wstrange/asn1lib/issues/62
void main() {
  // test snmp message should be a sequence
  // @format:off
  var bytes = [
    // sequence
    48, 74,
    //
    2, 1, 1, 4, 5, 115, 101, 118, 101, 110,
    // 162 - is the tag that was triggering the bug.
    162, 62, 2, 4, 3, 235, 147, 43, 2,
    1, 0, 2, 1,
    0, 48, 48, 48, 46, 6, 8, 43, 6, 1, 2, 1, 1, 1, 0, 4, 34, 69, 100, 103,
    101, 79, 83, 32, 118, 52, 46, 52, 46, 53, 54, 46, 53, 52, 52, 57, 48, 54,
    50, 46, 50, 49, 49, 48, 50, 48, 46, 48, 56, 51, 49
  ];
  // @format:on

  test('issue 62 sequence does not parse', () {
    var p = ASN1Parser(Uint8List.fromList(bytes));

    var seq = p.nextObject() as ASN1Sequence;
    expect(seq.elements[0], isA<ASN1Integer>());
    expect(seq.elements[1], isA<ASN1OctetString>());
    // tag 162, 0xa2, binary 10100010 - is context specific
    // This will parse as a ASN1Object
    var s = seq.elements[2];
    expect(s, isA<ASN1Object>());
    // Allow this to be recast as a sequence type.
    var t = ASN1Sequence.fromBytes(s.encodedBytes);
    expect(t, isA<ASN1Sequence>());
  });

  // Test bytes taken from https://letsencrypt.org/docs/a-warm-welcome-to-asn1-and-der/#encoding-instructions
  test('decode Points sample', () {
    var p = ASN1Parser(Uint8List.fromList([0x30, 0x3, 0x80, 0x01, 0x09]));
    var seq = p.nextObject() as ASN1Sequence;
    expect(seq.elements.length, equals(1));
    var e = seq.elements[0];
    expect(e, isA<ASN1Object>());
    expect(isContextSpecific(e.tag), isTrue);
  });
}
