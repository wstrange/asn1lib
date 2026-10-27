import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

// Regression test for quadratic (O(N^2)) parsing of a SEQUENCE/SET (or stream)
// with many elements (GHSA-qpgw-g46g-ff4r).
//
// ASN1Parser.nextObject used to copy the entire remaining byte tail
// (`_bytes.sublist(_position)`) on every element, just to read the length header,
// so parsing a container with K children performed K tail-copies -> O(K^2). A
// 625 KB SEQUENCE of ~320000 NULLs took ~37 s of CPU. nextObject now reads the
// length in place, so parsing is linear in the input size.

List<int> _derLen(int l) {
  if (l < 128) return [l];
  final out = <int>[];
  var t = l;
  while (t > 0) {
    out.insert(0, t & 0xFF);
    t >>= 8;
  }
  return [0x80 | out.length, ...out];
}

// SEQUENCE { NULL * k } ; each NULL encodes as 05 00.
Uint8List _seqOfNulls(int k) {
  final v = Uint8List(2 * k);
  for (var i = 0; i < k; i++) {
    v[2 * i] = 0x05;
    v[2 * i + 1] = 0x00;
  }
  return Uint8List.fromList(<int>[0x30, ..._derLen(v.length), ...v]);
}

void main() {
  test('a SEQUENCE with many elements parses in linear time', () {
    const k = 200000;
    final der = _seqOfNulls(k);
    final sw = Stopwatch()..start();
    final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
    sw.stop();
    expect(seq.elements.length, equals(k));
    // The O(N^2) version took tens of seconds for this input; the in-place
    // length decode parses it in well under a second. A generous 5 s budget
    // fails loudly if the quadratic tail-copy is ever reintroduced.
    expect(sw.elapsed, lessThan(const Duration(seconds: 5)),
        reason: 'parsing $k elements took ${sw.elapsedMilliseconds}ms '
            '(quadratic regression?)');
  });

  test('a flat top-level stream of many objects parses in linear time', () {
    const k = 200000;
    final stream = Uint8List(2 * k);
    for (var i = 0; i < k; i++) {
      stream[2 * i] = 0x05;
      stream[2 * i + 1] = 0x00;
    }
    final sw = Stopwatch()..start();
    final parser = ASN1Parser(stream);
    var n = 0;
    while (parser.hasNext()) {
      parser.nextObject();
      n++;
    }
    sw.stop();
    expect(n, equals(k));
    expect(sw.elapsed, lessThan(const Duration(seconds: 5)),
        reason: 'parsing $k stream objects took ${sw.elapsedMilliseconds}ms');
  });

  test('a small SEQUENCE still parses correctly', () {
    // SEQUENCE { INTEGER 1, NULL, OCTET STRING "Hi" }
    final der = Uint8List.fromList(<int>[
      0x30, 0x09, //
      0x02, 0x01, 0x01, //
      0x05, 0x00, //
      0x04, 0x02, 0x48, 0x69, //
    ]);
    final seq = ASN1Parser(der).nextObject() as ASN1Sequence;
    expect(seq.elements.length, equals(3));
    expect((seq.elements[0] as ASN1Integer).intValue, equals(1));
    expect((seq.elements[2] as ASN1OctetString).valueBytes(),
        equals(Uint8List.fromList([0x48, 0x69])));
  });
}
