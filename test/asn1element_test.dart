
library asn1test;


import 'package:unittest/unittest.dart';
import 'package:asn1lib/asn1lib.dart';

import 'dart:scalarlist';
import 'dart:math';

main() {

  var ba = new Uint8List(8);

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
    os.encode();
    
    var os2 = new ASN1OctetString.fromBytes(os.encodedBytes);
    
    
   
    expect( s, equals(os2.stringValue));

  });
  
  
  test('Sequence Test1', () {
    var s1 = new ASN1OctetString("Hello");
    var s2 = new ASN1OctetString("World");
    var s = new ASN1Sequence();
    s.add(s1);
    s.add(s2);
    s.encode();
    print("Encoded Seq ${s.encodedBytes}");
    
    var seq2 = new ASN1Sequence.fromBytes(s.encodedBytes);
    var t1 = seq2.elements[0] as ASN1OctetString;
    var t2 = seq2.elements[1] as ASN1OctetString;
    //print( "${seq2}");
    
    expect( t1.stringValue, equals("Hello"));
    expect( t2.stringValue, equals("World"));
  
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
    
    // todo: find an easy way to convert List<int> to Uint8List
    // OR should all these methods take a List<int> instead??
    //var f2 = ASN1Boolean.fromBytes(fa);
    //expect(f2.booleanValue, equals(false));

  });

}