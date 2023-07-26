import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  test('ASN1Parser Encode/Decode Test', () {
    var bytes = Uint8List.fromList([
      0x30,
      0x82,
      0x01,
      0x2B,
      0x30,
      0x82,
      0x01,
      0x27,
      0xA0,
      0x03,
      0x02,
      0x01,
      0x02,
      0x30,
      0x0D,
      0x06,
      0x09,
      0x2A,
      0x86,
      0x48,
      0x86,
      0xF7,
      0x0D,
      0x01,
      0x01,
      0x01,
      0x05,
      0x00,
      0x03,
      0x82,
      0x01,
      0x0F,
      0x00,
      0x30,
      0x82,
      0x01,
      0x0A,
      0x02,
      0x82,
      0x01,
      0x01,
      0x00,
      0x90,
      0x1A,
      0xC7,
      0x35,
      0xD4,
      0x3F,
      0xD7,
      0x82,
      0x7A,
      0xF4,
      0xE5,
      0xE6,
      0x89,
      0x63,
      0x21,
      0x2B,
      0x7A,
      0x19,
      0x8B,
      0x0C,
      0xB5,
      0xFF,
      0xF5,
      0x7B,
      0x14,
      0x6E,
      0x05,
      0x53,
      0xA8,
      0x45,
      0x37,
      0x3D,
      0xAB,
      0x5F,
      0x75,
      0x35,
      0xC9,
      0xA0,
      0xAC,
      0xC7,
      0x65,
      0x0D,
      0x49,
      0xFF,
      0x2F,
      0x58,
      0xE5,
      0xC0,
      0xF4,
      0xBE,
      0xCD,
      0x06,
      0x84,
      0x7D,
      0xE9,
      0x97,
      0x49,
      0x30,
      0x37,
      0xC4,
      0x72,
      0xD6,
      0xCC,
      0xE9,
      0x63,
      0x68,
      0xA5,
      0xDC,
      0x67,
      0x38,
      0x1F,
      0xB7,
      0x4B,
      0x9F,
      0x1D,
      0xCD,
      0x90,
      0x77,
      0x84,
      0x76,
      0xDF,
      0x73,
      0x96,
      0x93,
      0x44,
      0x84,
      0xA5,
      0x47,
      0x79,
      0xB9,
      0x78,
      0xA5,
      0x1B,
      0x7B,
      0x3F,
      0x82,
      0x95,
      0xF1,
      0xCA,
      0x45,
      0x9F,
      0xC6,
      0x96,
      0x32,
      0x1F,
      0x6F,
      0x23,
      0x13,
      0xC2,
      0x33,
      0xBC,
      0x62,
      0xF8,
      0x17,
      0x50,
      0x7C,
      0x1A,
      0x4A,
      0x0C,
      0xC1,
      0xDC,
      0xD8,
      0x14,
      0xE6,
      0xD5,
      0xF6,
      0x63,
      0x03,
      0xA6,
      0x77,
      0x4F,
      0xCD,
      0x2B,
      0x70,
      0x3E,
      0x51,
      0x6B,
      0x6C,
      0x9D,
      0x1E,
      0x51,
      0x22,
      0x14,
      0xF1,
      0x19,
      0xB1,
      0xFD,
      0x4C,
      0x68,
      0x64,
      0x34,
      0x2C,
      0xDA,
      0x54,
      0x86,
      0xF9,
      0x8F,
      0xBE,
      0x3F,
      0x45,
      0xAB,
      0x6B,
      0x3F,
      0x82,
      0x95,
      0x11,
      0x0C,
      0xE0,
      0x92,
      0x8D,
      0x17,
      0xCD,
      0xF5,
      0x32,
      0x5E,
      0xF3,
      0x29,
      0xC5,
      0x6E,
      0xF1,
      0xB6,
      0x7C,
      0x6B,
      0x8F,
      0x76,
      0xB2,
      0x44,
      0xF9,
      0xED,
      0x5C,
      0xD6,
      0xD0,
      0x19,
      0xFB,
      0x93,
      0xA3,
      0x47,
      0x20,
      0x59,
      0x50,
      0x20,
      0x55,
      0x4B,
      0x06,
      0x6E,
      0xAB,
      0x29,
      0x08,
      0x63,
      0x5F,
      0x60,
      0xE4,
      0xBA,
      0x0F,
      0x81,
      0xB4,
      0x2B,
      0xDF,
      0x26,
      0xF8,
      0xF0,
      0xD4,
      0x5D,
      0xD8,
      0x27,
      0x2B,
      0xF2,
      0x02,
      0x10,
      0x71,
      0xE7,
      0x84,
      0xB3,
      0xB7,
      0x6A,
      0x5F,
      0x92,
      0x5A,
      0xF3,
      0xA0,
      0xCB,
      0x3A,
      0xD3,
      0x01,
      0x24,
      0x25,
      0x1E,
      0x66,
      0x7B,
      0x6F,
      0x22,
      0xFA,
      0xDE,
      0x8C,
      0xF0,
      0x5D,
      0x02,
      0x03,
      0x01,
      0x00,
      0x01
    ]);

    var parser = ASN1Parser(bytes);
    var sequence = parser.nextObject() as ASN1Sequence;
    expect(sequence.encodedBytes.length, sequence.totalEncodedByteLength);

    var subsequence = sequence.elements.elementAt(0) as ASN1Sequence;
    expect(subsequence.encodedBytes.length, subsequence.totalEncodedByteLength);

    var obj = subsequence.elements.elementAt(0);
    var subsubsequence = subsequence.elements.elementAt(1) as ASN1Sequence;
    var bitString = subsequence.elements.elementAt(2) as ASN1BitString;

    expect(obj.encodedBytes.length, obj.totalEncodedByteLength);
    expect(subsubsequence.encodedBytes.length,
        subsubsequence.totalEncodedByteLength);
    expect(bitString.encodedBytes.length, bitString.totalEncodedByteLength);

    var oid = subsubsequence.elements.elementAt(0) as ASN1ObjectIdentifier;
    var nullObj = subsubsequence.elements.elementAt(1);
    expect(oid.encodedBytes.length, oid.totalEncodedByteLength);
    expect(nullObj.encodedBytes.length, nullObj.totalEncodedByteLength);

    var subParser = ASN1Parser(bitString.contentBytes());
    var seq = subParser.nextObject() as ASN1Sequence;
    expect(seq.encodedBytes.length, seq.totalEncodedByteLength);
    var int1 = seq.elements.elementAt(0) as ASN1Integer;
    var int2 = seq.elements.elementAt(1) as ASN1Integer;

    expect(int1.encodedBytes.length, int1.totalEncodedByteLength);
    expect(int2.encodedBytes.length, int2.totalEncodedByteLength);
  });

  test('ASN1Parser Universal / Primitive Tag Test', () {
    var sequence = ASN1Sequence(tag: 0x30);
    sequence.add(ASN1Integer.fromInt(10));
    var parsed = ASN1Parser(sequence.encodedBytes);
    expect(parsed.nextObject(), isA<ASN1Sequence>());
  });

  test('ASN1Parser Application Tag Test', () {
    var sequence = ASN1Sequence(tag: 0x45);
    sequence.add(ASN1Integer.fromInt(10));
    var parsed = ASN1Parser(sequence.encodedBytes);
    expect(parsed.nextObject(), isA<ASN1Object>());
  });

  // todo: This test does not look legit. See comments below and
  // See https://github.com/wstrange/asn1lib/issues/61
  test('ASN1Parser Sequence Subtype Tag Test', () {
    // encodes as APPLICATION + SEQUENCE type, but does not set the constructed bit
    var sequence = ASN1Sequence(tag: 0x50);
    sequence.add(ASN1Integer.fromInt(10));
    var parsed = ASN1Parser(sequence.encodedBytes);
    // todo: this wont parse as a sequence
    // expect(parsed.nextObject(), isA<ASN1Sequence>());
    expect(parsed.nextObject(), isA<ASN1Object>());

    // Sets APPLICATION + constructed, but the type is 0
    var sequence2 = ASN1Sequence(tag: 0x60);
    sequence2.add(ASN1Integer.fromInt(10));
    var parsed2 = ASN1Parser(sequence2.encodedBytes);
    expect(parsed2.nextObject(), isA<ASN1Sequence>());

    // Sets APPLICATION + constructed + SEQUENCE
    var sequence3 = ASN1Sequence(tag: 0x70);
    sequence3.add(ASN1Integer.fromInt(10));
    var parsed3 = ASN1Parser(sequence3.encodedBytes);
    expect(parsed3.nextObject(), isA<ASN1Sequence>());
  }, skip: false);

  test('ASN1Parser Context-Specific Tag Test', () {
    var sequence = ASN1Sequence(tag: 0x80);
    sequence.add(ASN1Integer.fromInt(10));
    var parsed = ASN1Parser(sequence.encodedBytes);
    expect(parsed.nextObject(), isA<ASN1Object>());
  });

  test('ASN1Parser Private Tag Test', () {
    var sequence = ASN1Sequence(tag: 0xC0);
    sequence.add(ASN1Integer.fromInt(10));
    var parsed = ASN1Parser(sequence.encodedBytes);
    expect(parsed.nextObject(), isA<ASN1Object>());
  });
}
