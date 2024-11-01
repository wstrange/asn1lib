import 'package:asn1lib/asn1lib.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';

void main() {
  test('Adding new objects to a previously encoded sequence works', () {
    final s = ASN1Sequence();
    s.add(ASN1OctetString('Foo '));
    final b1 = s.encodedBytes;
    // add some more objects after encoding..
    s.add(ASN1OctetString(' bar'));
    final b2 = s.encodedBytes;

    expect(b1.lengthInBytes, lessThan(b2.lengthInBytes));

    // See if they are different objects. Not the same as list equality!
    expect(b1 != b2, true);

    // see if some bytes are different.

    // ignore: inference_failure_on_instance_creation
    Function eq = const ListEquality().equals;
    // ignore: avoid_dynamic_calls
    expect(eq(b1, b2), false);
  });
}
