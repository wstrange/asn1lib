library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:typed_data';
import 'dart:math';

main() {
  test('Test Encode integer', () {
    // key = integer to encode, val = expected encoding bytes
    var m = new Map();
    m[0] = [0x0];
    m[127] = [0x7f];
    m[128] = [0x0, 0x80];
    m[129] = [0x0, 0x81];
    m[256] = [0x1, 0x0];
    m[-128] = [0x80];
    m[-129] = [0xff, 0x7f];

    m.forEach((val, expected) {
      var r = ASN1Integer.encodeIntValue(val);
      expect(r, equals(expected));
      // decode it back again. Should be the same as what we started with
      var x = ASN1Integer.decodeInteger(r);
      expect(x, equals(val));
    });

    // for fun try some random numbers
    var random = new Random();
    int sign = 1;
    for (int i = 0; i < 10000; ++i) {
      var x = random.nextInt(10000000) * sign;
      sign = sign * -1;
      var encoded = ASN1Integer.encodeIntValue(x);
      var decoded = ASN1Integer.decodeInteger(encoded);
      // we should get back what we started with
      expect(x, decoded);
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
    var b = new Uint8List.fromList([0x0, 0x82, 0x04]); // missing 0x00

    try {
      // ignore: unused_local_variable
      var x = ASN1Length.decodeLength(b);
      fail("A RangeError is expected");
    } catch (e) {
      expect(e, new isInstanceOf<RangeError>());
    }
  });

  test('Octet String encoding', () {
    var s = "Hello";
    var os = new ASN1OctetString(s);
    var os2 = new ASN1OctetString.fromBytes(os.encodedBytes);
    expect(os2.stringValue, equals(s));
  });

  test('Octet get octets', () {
    List<int> octets = [1, 2, 3, 4, 5, 123, 254, 0, 33];
    var os1 = new ASN1OctetString(new String.fromCharCodes(octets));
    var os1d = new ASN1OctetString.fromBytes(os1.encodedBytes);
    var os2 = new ASN1OctetString(octets);
    var os2d = new ASN1OctetString.fromBytes(os2.encodedBytes);
    expect(os1d.octets, equals(octets));
    expect(os2d.octets, equals(octets));
  });

  test('Sequence Test1', () {
    var s1 = new ASN1OctetString("Hello");
    var s2 = new ASN1OctetString("World");
    var s = new ASN1Sequence();
    s.add(s1);
    s.add(s2);

    var seq2 = new ASN1Sequence.fromBytes(s.encodedBytes);
    var t1 = seq2.elements[0] as ASN1OctetString;
    var t2 = seq2.elements[1] as ASN1OctetString;

    expect(t1.stringValue, equals("Hello"));
    expect(t2.stringValue, equals("World"));
  });

  test('Create sequence test2', () {
    // create a sequence with a non default tag
    // Example - 96 - LDAP BIND request
    var s = new ASN1Sequence(tag: 96);
    expect(s.tag, equals(96));
  });

  test('Null Test', () {
    var t = new ASN1Null();
    var expected = new Uint8List.fromList([0x05, 0x00]);
    expect(t.encodedBytes, equals(expected));
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
    var s = new ASN1Set();
    s.add(ASN1Boolean.ASN1FalseBoolean);
    s.add(new ASN1OctetString("hello world"));

    var bytes = s.encodedBytes;

    var s2 = new ASN1Set.fromBytes(bytes);

    expect(s2.elements.length, equals(s.elements.length));

    // TODO: This fails. We need to review the notion of
    // equality for asn1 elements, sets, sequences etc.
    //expect(s.elements, everyElement(s2.elements));
  });

  // show sample ussage
  test("Sample for README", () {
    var s = new ASN1Sequence();
    s.add(new ASN1Integer(23));
    s.add(new ASN1OctetString('This is a test'));
    s.add(new ASN1Boolean(true));

    // GET the BER Stream
    var bytes = s.encodedBytes;

    // decode
    // ignore: unused_local_variable
    var p = new ASN1Parser(bytes);
    //var s2 = p.nextObject();
    // s2 is a sequence...
  });
}
