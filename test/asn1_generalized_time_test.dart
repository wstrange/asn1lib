import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

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

  test('encode single digit month-day-hour-minute-second', () {
    final dateTime = DateTime.utc(2025, 4, 1, 5, 2, 3);
    final time = ASN1GeneralizedTime(dateTime);
    final encodedTime = time.encodedBytes;

    final decodedTime = ASN1GeneralizedTime.fromBytes(encodedTime);
    expect(decodedTime.dateTimeValue, equals(dateTime));
  });
}
