import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  test('simple equals', () {
    expect(ASN1OctetString('Hello') == ASN1OctetString('Hello'), isTrue);
    expect(ASN1Integer.fromInt(43) == ASN1Integer.fromInt(43), isTrue);
  });
}
