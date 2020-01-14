import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

// list of test value pairs. The first value is the integer to encode, the
// second is expected length of the content bytes (excludes type and length).
final List<int> intTestValues = [
  0x00000000,
  1,
  0x00000001,
  1,
  0x0000000F,
  1,
  0x00000010,
  1,
  0x0000007F,
  1,
  0x00000080,
  2,
  0x000000FF,
  2,
  0x00000100,
  2,
  0x00000FFF,
  2,
  0x00001000,
  2,
  0x0000FFFF,
  3,
  0x00010000,
  3,
  0x000FFFFF,
  3,
  0x00100000,
  3,
  0x00FFFFFF,
  4,
  0x01000000,
  4,
  0x0FFFFFFF,
  4,
  0x10000000,
  4,
  0x7FFFFFFF,
  4,
  -0x00000001,
  1,
  -0x0000000F,
  1,
  -0x00000010,
  1,
  -0x0000007F,
  1,
  -0x00000080,
  1,
  -0x000000FF,
  2,
  -0x00000100,
  2,
  -0x00000FFF,
  2,
  -0x00001000,
  2,
  -0x0000FFFF,
  3,
  -0x00010000,
  3,
  -0x000FFFFF,
  3,
  -0x00100000,
  3,
  -0x00FFFFFF,
  4,
  -0x01000000,
  4,
  -0x0FFFFFFF,
  4,
  -0x10000000,
  4,
  -0x7FFFFFFF,
  4,
  0x80000000,
  //4];
  5
]; // ds says 4 bytes, but it looks like 5?

final List<int> longTestValues = [
  0x0000000000000000,
  1,
  0x0000000000000001,
  1,
  0x000000000000007F,
  1,
  0x0000000000000080,
  2,
  0x00000000000000FF,
  2,
  0x0000000000000100,
  2,
  0x000000000000FFFF,
  3,
  0x0000000000010000,
  3,
  0x0000000000FFFFFF,
  4,
  0x0000000001000000,
  4,
  0x00000000FFFFFFFF,
  5,
  0x0000000100000000,
  5,
  0x000000FFFFFFFFFF,
  6,
  0x0000010000000000,
  6,
  0x0000FFFFFFFFFFFF,
  7,
  0x0001000000000000,
  7,
  0x00FFFFFFFFFFFFFF,
  8,
  0x0100000000000000,
  8,
  0x7FFFFFFFFFFFFFFF,
  8,
  -0x0000000000000001,
  1,
  -0x000000000000007F,
  1,
  -0x0000000000000080,
  1,
  -0x00000000000000FF,
  2,
  -0x0000000000000100,
  2,
  -0x000000000000FFFF,
  3,
  -0x0000000000010000,
  3,
  -0x0000000000FFFFFF,
  4,
  -0x0000000001000000,
  4,
  -0x00000000FFFFFFFF,
  5,
  -0x0000000100000000,
  5,
  -0x000000FFFFFFFFFF,
  6,
  -0x0000010000000000,
  6,
  -0x0000FFFFFFFFFFFF,
  7,
  -0x0001000000000000,
  7,
  -0x00FFFFFFFFFFFFFF,
  8,
  -0x0100000000000000,
  8,
  -0x7FFFFFFFFFFFFFFF,
  8,
  0x8000000000000000,
  8
];

/*
String _printBytes(List<int> b) {
  var s = '';
  b.forEach((e) {
    s += '0x${e.toRadixString(16)}, ';
  });
  return s;
}
*/

// iterate over the list - which is a pair of (value,expected number of encoded bytes)
void testList(List<int> l) {
  var i = l.iterator;

  while (i.moveNext()) {
    var x = i.current; // get the value
    i.moveNext();
    var expectedLength = i.current; // expected bytes
    testPair(x, expectedLength);
  }
}

void testPair(int x, int expectedLength) {
  var int1 = ASN1Integer.fromInt(x);
  //print(
  //    'Value 0x${x.toRadixString(16)},$expectedLength. Encoded Bytes =  ${_printBytes(int1.encodedBytes.sublist(2))}');

  var contentLength = int1.contentBytes().length;
  expect(contentLength, expectedLength,
      reason: 'expected number of content bytes is wrong');
  var int2 = ASN1Integer.fromBytes(int1.encodedBytes);
  expect(int1, equals(int2), reason: 'decoded value didnt match original');
  expect(int2.intValue, equals(x));
}

void main() {
  test('Int encode/decode test', () {
    testList(intTestValues);
    testList(longTestValues);
  });

  test('fromInt vs BigInt.from', () {
    var si = ASN1Integer.fromInt(1);
    var sb = ASN1Integer(BigInt.from(1));

    expect(si.encodedBytes, equals(sb.encodedBytes));
  });
}
