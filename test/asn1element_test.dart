library asn1test;

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:typed_data';
import 'dart:math';

void main() {
  test('Test integer encoding', () {
    // key = integer to encode, val = expected encoding bytes
    var m = {};
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
    var sign = 1;
    for (var i = 0; i < 100000; ++i) {
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
    var x = ASN1Length.encodeLength(127);
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
      fail('A RangeError is expected');
    } catch (e) {
      expect(e, e as RangeError);
    }
  });

  test('Length decoding', () {
    var b = Uint8List.fromList([0x30, 0x82, 0x01, 0x26]); // missing 0x00

    try {
      // ignore: unused_local_variable
      var x = ASN1Length.decodeLength(b);
      expect(294, x.length);
    } catch (e) {
      fail('No error expected');
    }
  });

  test('Octet String encoding', () {
    var s = 'Hello';
    var os = ASN1OctetString(s);
    var os2 = ASN1OctetString.fromBytes(os.encodedBytes);
    expect(os2.stringValue, equals(s));
  });

  test('Octet get octets', () {
    var octets = <int>[1, 2, 3, 4, 5, 123, 254, 0, 33];
    var os1 = ASN1OctetString(String.fromCharCodes(octets));
    var os1d = ASN1OctetString.fromBytes(os1.encodedBytes);
    var os2 = ASN1OctetString(octets);
    var os2d = ASN1OctetString.fromBytes(os2.encodedBytes);
    expect(os1d.octets, equals(octets));
    expect(os2d.octets, equals(octets));
  });

  test('Sequence Test1', () {
    var s1 = ASN1OctetString('Hello');
    var s2 = ASN1OctetString('World');
    var s = ASN1Sequence();
    s.add(s1);
    s.add(s2);

    var seq2 = ASN1Sequence.fromBytes(s.encodedBytes);
    var t1 = seq2.elements[0] as ASN1OctetString;
    var t2 = seq2.elements[1] as ASN1OctetString;

    expect(t1.stringValue, equals('Hello'));
    expect(t2.stringValue, equals('World'));
  });

  test('Sequence Test2', () {
    var hex =
        '30 82 01 26 30 82 01 22 30 0D 06 09 2A 86 48 86 F7 0D 01 01 01 05 00 03 82 01 0F 00 30 82 01 0A 02 82 01 01 00 90 1A C7 35 D4 3F D7 82 7A F4 E5 E6 89 63 21 2B 7A 19 8B 0C B5 FF F5 7B 14 6E 05 53 A8 45 37 3D AB 5F 75 35 C9 A0 AC C7 65 0D 49 FF 2F 58 E5 C0 F4 BE CD 06 84 7D E9 97 49 30 37 C4 72 D6 CC E9 63 68 A5 DC 67 38 1F B7 4B 9F 1D CD 90 77 84 76 DF 73 96 93 44 84 A5 47 79 B9 78 A5 1B 7B 3F 82 95 F1 CA 45 9F C6 96 32 1F 6F 23 13 C2 33 BC 62 F8 17 50 7C 1A 4A 0C C1 DC D8 14 E6 D5 F6 63 03 A6 77 4F CD 2B 70 3E 51 6B 6C 9D 1E 51 22 14 F1 19 B1 FD 4C 68 64 34 2C DA 54 86 F9 8F BE 3F 45 AB 6B 3F 82 95 11 0C E0 92 8D 17 CD F5 32 5E F3 29 C5 6E F1 B6 7C 6B 8F 76 B2 44 F9 ED 5C D6 D0 19 FB 93 A3 47 20 59 50 20 55 4B 06 6E AB 29 08 63 5F 60 E4 BA 0F 81 B4 2B DF 26 F8 F0 D4 5D D8 27 2B F2 02 10 71 E7 84 B3 B7 6A 5F 92 5A F3 A0 CB 3A D3 01 24 25 1E 66 7B 6F 22 FA DE 8C F0 5D 02 03 01 00 01';
    var splitted = hex.split(' ');
    var ints = <int>[];
    splitted.forEach((String s) {
      ints.add(int.parse(s, radix: 16));
    });
    var s = ASN1Sequence.fromBytes(Uint8List.fromList(ints));
    s.encodedBytes.length;
    var length = s.elements.elementAt(0).encodedBytes.length;
    expect(length, 294);
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

  test('Boolean ', () {
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
    s.add(ASN1OctetString('hello world'));

    var bytes = s.encodedBytes;

    var s2 = ASN1Set.fromBytes(bytes);

    expect(s2.elements.length, equals(s.elements.length));

    // TODO: This fails. We need to review the notion of
    // equality for asn1 elements, sets, sequences etc.
    // expect(s.elements, everyElement(s2.elements));
  });

  test('Create ASN1Integer from int', () {
    var x = ASN1Integer.fromInt(47);
    expect(x.intValue, equals(47));
  });

  // show sample ussage
  test('Sample for README', () {
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
