
library asn1test;


import 'package:unittest/unittest.dart';
import 'package:asn1lib/asn1lib.dart';
import "package:bignum/bignum.dart";

import 'dart:typed_data';
import 'dart:math';

main() {

  var ba = new Uint8List(8);
  
  test('Test Encode biginteger', () {
    var modulus = new BigInteger ([0x00,0xc8,0xbb,0x27,0xb3,0xdb,0x7f,0xff,0x61,0xa2,0xd6,0xbf,0x73,0x2b,0xc1,0x37,0xcc,0x14,0x15,0xf6,0x30,0xee,0x9e,0x31,0x56,0xfe,0x32,0xa7,0xa5,0x53,0x29,0xe1,0x59,0x3b,0x2c,0xd4,0x8c,0x75,0x24,0x59,0x0d,0xb7,0xe0,0x21,0xc1,0xd2,0x00,0xfd,0xce,0x30,0x2a,0xa7,0x8a,0x44,0x31,0x72,0x9e,0x9c,0x4b,0xc8,0xb9,0x1f,0xf1,0x39,0xa3,0x44,0x05,0xf6,0x6f,0xb9,0xc7,0xa6,0x3b,0x47,0x1a,0x54,0x18,0x10,0xbc,0x2c,0x31,0x7a,0xc2,0x90,0x55,0x06,0x19,0x17,0x3a,0x79,0xac,0x74,0x45,0xd5,0xed,0x35,0xb2,0x8a,0x52,0xb7,0x03,0x96,0x13,0x4f,0x7e,0xf5,0x00,0xe9,0xf8,0xc0,0xbb,0x4b,0x11,0x34,0xc8,0x3b,0x2c,0x73,0xb9,0xf5,0x74,0xb8,0x8b,0xcf,0xe5,0xcc,0xea,0x36,0x21]);
    var r = ASN1Integer.encodeIntValue(modulus);
    expect( r, equals(new Uint8List.fromList(modulus.toByteArray()) ));   
    var x = ASN1Integer.decodeInteger(r);
    expect( x, equals(modulus));
    });

  test('Test Encode integer', () {
    // key = integer to encode, val = expected encoding bytes
    var m = new Map();
    m[0] =  [0x0];
    m[127] = [0x7f];
    m[128] = [0x0, 0x80];
    m[129] = [0x0, 0x81];
    m[256] = [0x1, 0x0];
    m[-128] = [0x80];
    m[-129] = [0xff, 0x7f] ;

    m.forEach( (val,expected) {
      var r = ASN1Integer.encodeIntValue(val);
      expect( r, equals(expected));
      // decode it back again. Should be the same as what we started with
      var x = ASN1Integer.decodeInteger(r);
      expect( x, equals(val));
    });

    // for fun try some random numbers
    var random = new Random();
    int sign = 1;
    for(int i = 0; i < 10000; ++i) {
      var x = random.nextInt(10000000) * sign;
      sign = sign * -1;
      var encoded = ASN1Integer.encodeIntValue(x);
      var decoded = ASN1Integer.decodeInteger(encoded);
      // we should get back what we started with
      expect( x, decoded);
    }
  });


  test('Length Encoding and Decoding', () {
    Uint8List x = ASN1Length.encodeLength(127);
    expect(x, equals([127]));

    x = ASN1Length.encodeLength(128);
    expect(x, equals([0x81, 128]));

    x = ASN1Length.encodeLength(1024);
    expect( x, equals([0x82, 0x04,0x00]));
  });

  test('Octet String encoding', () {
    var s = "Hello";
    var os = new ASN1OctetString(s);
    var os2 = new ASN1OctetString.fromBytes(os.encodedBytes);
    expect( os2.stringValue, equals(s));
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

    expect( t1.stringValue, equals("Hello"));
    expect( t2.stringValue, equals("World"));

  });

  test('Create sequence test2',(){
    // create a sequence with a non default tag
    // Example - 96 - LDAP BIND request
    var s = new ASN1Sequence(tag:96);
    expect(s.tag, equals(96));
  });

  test('Null Test', () {
    var t = new ASN1Null();
    expect(t.encodedBytes, equals([0x05,0x00]));
  });

  test("Boolean ", () {
    var f = ASN1Boolean.ASN1FalseBoolean;
    var t = ASN1Boolean.ASN1TrueBoolean;

    var fa = [BOOLEAN_TYPE, 0x01, 0x00];
    var ta = [BOOLEAN_TYPE, 0x01, 0xff];

    expect(f.encodedBytes, equals(fa));
    expect(t.encodedBytes, equals(ta));
  });

  // show sample ussage
  test("Sample for README", () {

    var s = new ASN1Sequence();
    s.add( new ASN1Integer(23));
    s.add( new ASN1OctetString('This is a test'));
    s.add( new ASN1Boolean(true));

    // GET the BER Stream
    var bytes = s.encodedBytes;

    // decode
    var p = new ASN1Parser(bytes);
    var s2 = p.nextObject();
    // s2 is a sequence...

  });

}