library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:typed_data';
import 'dart:math';

main() {
  test('Test integer encoding', () {
    // key = integer to encode, val = expected encoding bytes
    var m = Map();
    m[0] = [0x0];
    m[127] = [0x7f];
    m[128] = [0x0, 0x80];
    m[129] = [0x0, 0x81];
    m[256] = [0x1, 0x0];
    m[-128] = [0x80];
    m[-129] = [0xff, 0x7f];

    m.forEach((val, expected) {
      var r = ASN1Integer.encodeInt(val);
      expect(r, equals(expected));
      // decode it back again. Should be the same as what we started with
      var x = ASN1Integer.decodeInt(r);
      expect(x, equals(val));
    });

    // for fun try some random numbers
    var random = Random();
    int sign = 1;
    for (int i = 0; i < 100000; ++i) {
      var x = random.nextInt(10000000) * sign;
      sign = sign * -1;
      var encoded = ASN1Integer.encodeInt(x);
      var decoded = ASN1Integer.decodeInt(encoded);
      // we should get back what we started with
      expect(x, decoded);

      // try via constructor
      var int1 = ASN1Integer.fromInt(x);
      var int2 = ASN1Integer.fromBytes(int1.encodedBytes);

      // equality is broken..
      expect(int1, equals(int2));
      expect(int2.intValue, equals(x));
    }
  });

  test('Length Encoding and Decoding', () {
    Uint8List x = ASN1Length.encodeLength(127);
    expect(x, equals([127]));

    x = ASN1Length.encodeLength(128);
    expect(x, equals([0x81, 128]));

    x = ASN1Length.encodeLength(1024);
    expect(x, equals([0x82, 0x04, 0x00]));
  });

  // This tests for behaviour when not enough bytes are provided to decode
  // the length. This could happen with some stream parsers that have not yet seen
  // all the bytes of a message.
  test('Length decoding when not enough bytes should throw RangeError', () {
    var b = Uint8List.fromList([0x0, 0x82, 0x04]); // missing 0x00

    try {
      // ignore: unused_local_variable
      var x = ASN1Length.decodeLength(b);
      fail("A RangeError is expected");
    } catch (e) {
      expect(e, e as RangeError);
    }
  });

  test('Octet String encoding', () {
    var s = "Hello";
    var os = ASN1OctetString(s);
    var os2 = ASN1OctetString.fromBytes(os.encodedBytes);
    expect(os2.stringValue, equals(s));
  });

  test('Octet get octets', () {
    List<int> octets = [1, 2, 3, 4, 5, 123, 254, 0, 33];
    var os1 = ASN1OctetString(String.fromCharCodes(octets));
    var os1d = ASN1OctetString.fromBytes(os1.encodedBytes);
    var os2 = ASN1OctetString(octets);
    var os2d = ASN1OctetString.fromBytes(os2.encodedBytes);
    expect(os1d.octets, equals(octets));
    expect(os2d.octets, equals(octets));
  });

  test('Sequence Test1', () {
    var s1 = ASN1OctetString("Hello");
    var s2 = ASN1OctetString("World");
    var s = ASN1Sequence();
    s.add(s1);
    s.add(s2);

    var seq2 = ASN1Sequence.fromBytes(s.encodedBytes);
    var t1 = seq2.elements[0] as ASN1OctetString;
    var t2 = seq2.elements[1] as ASN1OctetString;

    expect(t1.stringValue, equals("Hello"));
    expect(t2.stringValue, equals("World"));
  });

  test('Create sequence test2', () {
    // create a sequence with a non default tag
    // Example - 96 - LDAP BIND request
    var s = ASN1Sequence(tag: 96);
    expect(s.tag, equals(96));
  });

  test('Null Test', () {
    var t = ASN1Null();
    var expected = Uint8List.fromList([0x05, 0x00]);
    expect(t.encodedBytes, equals(expected));
  });

  // test for #26
  test('Null Sequence', () {
    var seq = ASN1Sequence(tag: 96);
    seq.add(ASN1Null());
    expect(seq.encodedBytes, isNotNull);
  });

  test("Boolean ", () {
    var f = ASN1Boolean.ASN1FalseBoolean;
    var t = ASN1Boolean.ASN1TrueBoolean;

    var fa = [BOOLEAN_TYPE, 0x01, 0x00];
    var ta = [BOOLEAN_TYPE, 0x01, 0xff];

    expect(f.encodedBytes.toList(), equals(fa));
    expect(t.encodedBytes.toList(), equals(ta));
  });

  test('Set test', () {
    var s = ASN1Set();
    s.add(ASN1Boolean.ASN1FalseBoolean);
    s.add(ASN1OctetString("hello world"));

    var bytes = s.encodedBytes;

    var s2 = ASN1Set.fromBytes(bytes);

    expect(s2.elements.length, equals(s.elements.length));

    // TODO: This fails. We need to review the notion of
    // equality for asn1 elements, sets, sequences etc.
    //expect(s.elements, everyElement(s2.elements));
  });

  test("Create ASN1Integer from int", () {
    var x = ASN1Integer.fromInt(47);
    expect(x.intValue, equals(47));
  });

  // show sample ussage
  test("Sample for README", () {
    var s = ASN1Sequence();
    s.add(ASN1OctetString('This is a test'));
    s.add(ASN1Boolean(true));

    // GET the BER Stream
    var bytes = s.encodedBytes;

    // decode
    // ignore: unused_local_variable
    var p = ASN1Parser(bytes);
    //var s2 = p.nextObject();
    // s2 is a sequence...
  });
}
