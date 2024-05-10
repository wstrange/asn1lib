import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  final sampleBytes = Uint8List.fromList([
    // 0x5f   0101 1111
    // APPLICATION. Bits 1-5 are ll 1's so this a high tag number form
    0x5f,
    // 00101001  - this is the extended tag
    0x29,
    // This is the length - so 1
    0x01,
    // Value of the first object
    0x00,

    // Second object starts here
    0x42, // 0101 0010  APPLICATION, tag = 02 (integer)
    0x08, //Length - 8
    0xfd,
    0x45,
    0x43,
    0x20,
    0x01,
    0xff,
    0xff,
    0x01,

    //Third object starts here
    0x5f, // 0101 1111  APPLICATION, extended tag
    0x4c, // 0100 1100   end of tag since high bit is 0.
    0x07, // Length is 7
    0xff,
    0x53,
    0x4d,
    0x52,
    0x44,
    0x54,
    0xd,
  ]);

  test(
      "Test ASN1Parser.nextObject method when objects with an extended tag's "
      'value are encoded in bytes. ', () {
    final parser = ASN1Parser(sampleBytes);

    final firstObj = parser.nextObject();
    expect(firstObj.extendedTag, equals(0x29));
    final expected1stObjValueBytes = Uint8List.fromList([
      0x00,
    ]);
    expect(firstObj.valueBytes(), orderedEquals(expected1stObjValueBytes));

    final secondObj = parser.nextObject();

    final expected2ndObjValueBytes = Uint8List.fromList([
      0xfd,
      0x45,
      0x43,
      0x20,
      0x01,
      0xff,
      0xff,
      0x01,
    ]);
    expect(secondObj.valueBytes(), orderedEquals(expected2ndObjValueBytes));

    final thirdObj = parser.nextObject();
    final expected3rdObjValueBytes = Uint8List.fromList([
      0xff,
      0x53,
      0x4d,
      0x52,
      0x44,
      0x54,
      0x0d,
    ]);

    expect(thirdObj.valueBytes(), orderedEquals(expected3rdObjValueBytes));
  });
}
