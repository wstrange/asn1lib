library asn1test;

import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

void main() {
  test('ASN1Parser Test1', () {
    var hex =
        '30 82 01 2B 30 82 01 27 A0 03 02 01 02 30 0D 06 09 2A 86 48 86 F7 0D 01 01 01 05 00 03 82 01 0F 00 30 82 01 0A 02 82 01 01 00 90 1A C7 35 D4 3F D7 82 7A F4 E5 E6 89 63 21 2B 7A 19 8B 0C B5 FF F5 7B 14 6E 05 53 A8 45 37 3D AB 5F 75 35 C9 A0 AC C7 65 0D 49 FF 2F 58 E5 C0 F4 BE CD 06 84 7D E9 97 49 30 37 C4 72 D6 CC E9 63 68 A5 DC 67 38 1F B7 4B 9F 1D CD 90 77 84 76 DF 73 96 93 44 84 A5 47 79 B9 78 A5 1B 7B 3F 82 95 F1 CA 45 9F C6 96 32 1F 6F 23 13 C2 33 BC 62 F8 17 50 7C 1A 4A 0C C1 DC D8 14 E6 D5 F6 63 03 A6 77 4F CD 2B 70 3E 51 6B 6C 9D 1E 51 22 14 F1 19 B1 FD 4C 68 64 34 2C DA 54 86 F9 8F BE 3F 45 AB 6B 3F 82 95 11 0C E0 92 8D 17 CD F5 32 5E F3 29 C5 6E F1 B6 7C 6B 8F 76 B2 44 F9 ED 5C D6 D0 19 FB 93 A3 47 20 59 50 20 55 4B 06 6E AB 29 08 63 5F 60 E4 BA 0F 81 B4 2B DF 26 F8 F0 D4 5D D8 27 2B F2 02 10 71 E7 84 B3 B7 6A 5F 92 5A F3 A0 CB 3A D3 01 24 25 1E 66 7B 6F 22 FA DE 8C F0 5D 02 03 01 00 01';
    var splitted = hex.split(' ');
    var ints = <int>[];
    splitted.forEach((String s) {
      ints.add(int.parse(s, radix: 16));
    });
    var parser = ASN1Parser(Uint8List.fromList(ints));
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
}
