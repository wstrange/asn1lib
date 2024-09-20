import 'package:asn1lib/asn1lib.dart';

import 'package:test/test.dart';

// Test caught the issue of equals method comparing the unencoded object

void main() async {
  test('set test', () {
    final s = ['a', 'b', 'c'];

    var a = ASN1Set();

    for (var e in s) {
      a.add(ASN1OctetString(e));
    }

    expect(a.elements.length, 3);
  });
}
