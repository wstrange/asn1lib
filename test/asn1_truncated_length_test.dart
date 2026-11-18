import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

// A length field cut short by the end of the input used to read past the end
// of the bytes while parsing, raising an uncaught RangeError (a Dart Error,
// not an Exception). The declared-length check added for GHSA-j4h8-q5f2-r54m
// runs only after the length has been read, so it did not cover this. Parsing
// such input must now throw a catchable ASN1Exception instead.
//
// ASN1Object.decodeLength itself still throws a RangeError for a short
// buffer, for stream readers that use it to detect an incomplete message
// (see 'Length decoding when not enough bytes should throw RangeError').
void main() {
  void expectAsn1Exception(List<int> der) {
    expect(
      () {
        final obj = ASN1Parser(Uint8List.fromList(der)).nextObject();
        if (obj is ASN1Sequence) {
          for (final e in obj.elements) {
            e.valueBytes();
          }
        }
      },
      throwsA(isA<ASN1Exception>()),
    );
  }

  test('a tag with no length byte throws ASN1Exception', () {
    expectAsn1Exception([0x30]); // SEQUENCE
    expectAsn1Exception([0x02]); // INTEGER
    expectAsn1Exception([0x41]); // APPLICATION
    expectAsn1Exception([0x80]); // context-specific
    expectAsn1Exception([0x1f, 0x01]); // extended tag
  });

  test('a long-form length missing its length bytes throws ASN1Exception', () {
    expectAsn1Exception([0x04, 0x82]);
    expectAsn1Exception([0x04, 0x82, 0x01]);
    expectAsn1Exception([0x04, 0xff]);
  });

  test('a truncated length inside a SEQUENCE throws ASN1Exception', () {
    expectAsn1Exception([0x30, 0x01, 0x02]);
    expectAsn1Exception([0x30, 0x02, 0x04, 0x81]);
  });

  test('ASN1Object.fromBytes rejects a missing or truncated length', () {
    expect(
      () => ASN1Object.fromBytes(Uint8List.fromList([0x04])),
      throwsA(isA<ASN1Exception>()),
    );
    expect(
      () => ASN1Object.fromBytes(Uint8List.fromList([0x04, 0x82, 0x01])),
      throwsA(isA<ASN1Exception>()),
    );
  });

  test('nextObject on an exhausted stream throws ASN1Exception', () {
    expectAsn1Exception([]);
    final parser = ASN1Parser(Uint8List.fromList([0x05, 0x00]));
    parser.nextObject();
    expect(parser.hasNext(), isFalse);
    expect(parser.nextObject, throwsA(isA<ASN1Exception>()));
  });

  test('well-formed short and long-form lengths still parse', () {
    final short = ASN1Parser(Uint8List.fromList([0x04, 0x01, 0x41]))
        .nextObject() as ASN1OctetString;
    expect(short.valueBytes(), equals(Uint8List.fromList([0x41])));

    final long = ASN1Parser(Uint8List.fromList([0x04, 0x81, 0x01, 0x41]))
        .nextObject() as ASN1OctetString;
    expect(long.valueBytes(), equals(Uint8List.fromList([0x41])));

    final value = List<int>.filled(300, 0x41);
    final twoByte =
        ASN1Parser(Uint8List.fromList([0x04, 0x82, 0x01, 0x2c, ...value]))
            .nextObject() as ASN1OctetString;
    expect(twoByte.valueBytes().length, equals(300));
  });
}
