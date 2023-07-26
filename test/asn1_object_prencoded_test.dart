import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

void main() {
  test('support optional tagging', () {
    var object = ASN1Object.preEncoded(
        160, ASN1ObjectIdentifier.fromComponentString('1.1.1.1').encodedBytes);
    expect(object.contentBytes(), [6, 3, 41, 1, 1]);
  });
}
