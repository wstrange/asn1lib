import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

// Test for https://github.com/wstrange/asn1lib/issues/61
main() {
  test('decode application tag', () {
    var bytes = Uint8List.fromList([113, 1, 0]);

    var parser = ASN1Parser(bytes, encodeApplicationTagsAsObject: true);

    while (parser.hasNext()) {
      var obj = parser.nextObject();
      expect(obj, isA<ASN1Object>());
    }
  });

  test('private tag', () {
    var bytes = Uint8List.fromList([254,0]);

    var parser = ASN1Parser(bytes);

    while (parser.hasNext()) {
      var obj = parser.nextObject();
      expect(obj, isA<ASN1Object>());
    }
  });
}
