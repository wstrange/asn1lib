import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

void main() {
  test('encode', () {
    var bytes = Uint8List.fromList(
        [24, 15, 50, 48, 49, 48, 49, 48, 51, 48, 49, 48, 49, 48, 51, 48, 90]);
    var time = ASN1GeneralizedTime.fromBytes(bytes);
    expect(time.dateTimeValue.toIso8601String(), '2010-10-30T10:10:30.000Z');
    var encoded = time.encodedBytes;
    expect(encoded.length, bytes.length);
    expect(encoded, bytes);
  });
}
