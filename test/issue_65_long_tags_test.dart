import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';


// This is a certificate from #65
// It has a tag that is more than one byte.
// @format:off
final certificate = Uint8List.fromList(
  [
    0x7F, 0x21, 0x81, 0xC9, 0x7F, 0x4E, 0x81, 0x82, 0x5F, 0x29, 0x01, 0x00, 0x42, 0x08, 0xFD, 0x45,
    0x43, 0x20, 0x01, 0xFF, 0xFF, 0x01, 0x5F, 0x4C, 0x07, 0xFF, 0x53, 0x4D, 0x52, 0x44, 0x54, 0x0D,
    0x7F, 0x49, 0x4E, 0x06, 0x09, 0x2B, 0x24, 0x03, 0x03, 0x02, 0x08, 0x01, 0x01, 0x07, 0x86, 0x41,
    0x04, 0x08, 0xC0, 0x4E, 0x39, 0x26, 0xC8, 0xDE, 0x85, 0x54, 0x42, 0x40, 0xCD, 0xE4, 0x0D, 0xAB,
    0x70, 0xD2, 0xB4, 0x7E, 0x0F, 0x83, 0x76, 0x25, 0x22, 0xD7, 0xB0, 0xB8, 0x54, 0x3B, 0x9B, 0x29,
    0xDC, 0x80, 0xE5, 0xC6, 0x7B, 0x82, 0xA6, 0x2D, 0x55, 0xE3, 0x48, 0x3A, 0xB4, 0xB0, 0x0A, 0x24,
    0xC2, 0xA2, 0x56, 0x6C, 0x37, 0x86, 0x79, 0x7A, 0x1A, 0x05, 0x28, 0x22, 0xAB, 0x4B, 0xF1, 0xF2,
    0x92, 0x5F, 0x20, 0x08, 0xFD, 0x45, 0x43, 0x20, 0x01, 0xFF, 0xFF, 0x01, 0x5F, 0x25, 0x04, 0x5B,
    0x21, 0xB0, 0x00, 0x5F, 0x24, 0x04, 0x9B, 0x8F, 0xAE, 0x80, 0x5F, 0x37, 0x40, 0x65, 0xC6, 0x2A,
    0xC1, 0x3D, 0xED, 0x14, 0x7F, 0xA8, 0xD1, 0xD1, 0x1A, 0x8F, 0x5B, 0xF2, 0xCF, 0x9E, 0x95, 0xDB,
    0x1B, 0x43, 0xD2, 0x53, 0xB4, 0x8B, 0x61, 0x5B, 0x2F, 0xE7, 0x0B, 0x3F, 0xD8, 0x2A, 0xA8, 0xD3,
    0x3D, 0x27, 0xF0, 0xF4, 0xD7, 0x36, 0x7C, 0x04, 0x90, 0x3B, 0xBB, 0xE6, 0x37, 0x5B, 0x64, 0x3A,
    0x19, 0xC5, 0xB8, 0x3D, 0x19, 0xFC, 0x74, 0x85, 0xDB, 0x47, 0x6C, 0x70, 0x67,
  ],
);
// @format:on


// test for issue https://github.com/wstrange/asn1lib/issues/62
void main() {

  test('issue 65 tag value does not fit in the first byte', () {
    var p = ASN1Parser(certificate,relaxedParsing: true);

    try {
      var obj = p.nextObject();
      expect(obj, isNotNull);
    }
    catch(e) {
      fail('Multi byte tag should not cause an exception');
    }
  });

}
