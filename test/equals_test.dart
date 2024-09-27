import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  test('simple equals', () {
    expect(ASN1OctetString('Hello') == ASN1OctetString('Hello'), isTrue);
    expect(ASN1Integer.fromInt(43) == ASN1Integer.fromInt(43), isTrue);
    var s = ASN1Sequence();
    s.add(ASN1Integer.fromInt(43));
    s.add(ASN1OctetString('Hello'));

    var s2 = ASN1Sequence();
    s2.add(ASN1Integer.fromInt(43));
    s2.add(ASN1OctetString('Hello'));
    expect(s == s2, isTrue);
  });
}
