
library asn1test;


import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';
import "package:bignum/bignum.dart";
import "package:crypto/crypto.dart";

import 'dart:typed_data';
import 'dart:math';
import 'dart:io';

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

  // This tests for behaviour when not enough bytes are provided to decode
  // the length. This could happen with some stream parsers that have not yet seen
  // all the bytes of a message.
  test('Length decoding when not enough bytes should throw RangeError',(){
    var b = new Uint8List.fromList([0x0,0x82, 0x04]); // missing 0x00

    try {
      var x = ASN1Length.decodeLength(b);
      fail("A RangeError is expected");
    }
    catch(e) {
      expect(e, new isInstanceOf<RangeError>());
    }

  });

  test('Octet String encoding', () {
    var s = "Hello";
    var os = new ASN1OctetString(s);
    var os2 = new ASN1OctetString.fromBytes(os.encodedBytes);
    expect( os2.stringValue, equals(s));
  });

  test('Octet get octets', () {
    List<int> octets = [1,2,3,4,5,123,254,0,33];
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


  test('Set test', (){
    var s = new ASN1Set();
    s.add( ASN1Boolean.ASN1FalseBoolean );
    s.add( new ASN1OctetString("hello world"));

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

  test("rsa private key", () {
    //openssl genrsa -out rsa_private_key.pem
    //PKCS#1 format
    File rsa_private_key_file = new File("./test/resource/rsa_private_key.pem");
    String pem = rsa_private_key_file.readAsStringSync();
    List lines  = pem.split("\n").map((line)=>line.trim()).skipWhile((String line)=>!line.startsWith("---")).toList();
    String key = lines.sublist(1, lines.length-2).join("");
    var key_bytes = new Uint8List.fromList(CryptoUtils.base64StringToBytes(key));

    var p = new ASN1Parser(key_bytes);
    expect(p.hasNext() , equals(true));
    var asn1object = p.nextObject();
    expect(asn1object is ASN1Sequence , equals(true));

    ASN1Sequence seq = asn1object;
    expect(seq.elements.length , equals(9));

    //?
    expect((seq.elements[0] as ASN1Integer).intValue , equals(0));
    //modulus
    expect((seq.elements[1] as ASN1Integer).intValue , equals(new BigInteger ([0x00,0xd8,0x3c,0x3c,0xac,0xb3,0xb7,0x67,0xa1,0x02,0x0f,0x94,0x7c,0xa2,0x01,0x20,0x10,0xba,0x49,0x4d,0x86,0xbd,0xa1,0xef,0xd4,0x37,0x35,0x7b,0x91,0xd5,0xc1,0xe6,0x1b,0x12,0x38,0x4c,0xd3,0xc0,0x1f,0x62,0x83,0x12,0xa5,0xef,0x15,0xcf,0x00,0x3f,0x62,0xc4,0xf6,0xb8,0x35,0xbb,0xb3,0xea,0x99,0x40,0x9f,0x87,0xe5,0x83,0xfa,0x69,0x91])));
    //publicExponent
    expect((seq.elements[2] as ASN1Integer).intValue , equals(65537));
    //privateExponent
    expect((seq.elements[3] as ASN1Integer).intValue , equals(new BigInteger ([0x00,0xa0,0xc2,0x2f,0xcd,0xa9,0x92,0xb9,0xcd,0x5e,0xed,0xdc,0x53,0xc8,0x51,0x93,0xd8,0x3b,0xd6,0x91,0x77,0x91,0xf6,0x19,0x8a,0x29,0x3d,0x6e,0xcf,0xde,0x1e,0x58,0x85,0xfb,0xc0,0xa7,0x66,0xaa,0xca,0x38,0x5d,0xd8,0xb3,0xb1,0x6a,0x58,0x20,0x1b,0xae,0xc3,0x90,0x0b,0x5c,0x16,0x36,0x32,0x1a,0x01,0x67,0xe9,0x56,0xd5,0xfb,0xe0,0x01])));
    //prime1
    expect((seq.elements[4] as ASN1Integer).intValue , equals(new BigInteger ([0x00,0xf3,0x10,0x3a,0x1b,0xb1,0x4f,0x88,0xf0,0x96,0x98,0x3e,0xcd,0x86,0xcb,0x51,0xf9,0xe0,0xe9,0x32,0x50,0x30,0x03,0x9b,0xe4,0xfb,0xb4,0x17,0x6d,0xe1,0xb7,0x3f,0x91])));
    //prime2
    expect((seq.elements[5] as ASN1Integer).intValue , equals(new BigInteger ([0x00,0xe3,0xbe,0x79,0x3b,0x59,0x3e,0x4e,0xd5,0xbc,0xe5,0xdb,0x1f,0xf5,0x63,0x46,0x8e,0xeb,0x5c,0xc7,0x15,0xb1,0x2b,0xad,0xf2,0x23,0xd1,0x97,0x0c,0xd8,0x8f,0x8a,0x01])));
    //exponent1
    expect((seq.elements[6] as ASN1Integer).intValue , equals(new BigInteger ([0x7e,0x4e,0x88,0x63,0xab,0x98,0x31,0x09,0x14,0xb8,0xb8,0xaa,0x04,0xc9,0xd3,0x27,0x8e,0x80,0x9f,0xec,0x9b,0x86,0xc4,0x94,0x11,0x58,0x5c,0x74,0x75,0x3e,0xcc,0x81])));
    //exponent2
    expect((seq.elements[7] as ASN1Integer).intValue , equals(new BigInteger ([0x68,0x7f,0x82,0x72,0xf7,0xec,0xfe,0x11,0x56,0x9e,0x85,0x5f,0xf1,0xa1,0x7e,0xc3,0x9f,0x3d,0x2f,0xe0,0x45,0x2e,0x0c,0x9f,0x79,0x4d,0xf7,0x28,0x1e,0xca,0x26,0x01])));
    //coefficient
    expect((seq.elements[8] as ASN1Integer).intValue , equals(new BigInteger ([0x00,0x92,0xe8,0x95,0xc1,0xa9,0xb7,0xb7,0x05,0xfb,0x69,0x4b,0xba,0x2d,0x52,0xcb,0x99,0x01,0xd4,0x62,0x8d,0xb7,0x94,0xeb,0x43,0x86,0x1b,0x08,0x6c,0x55,0x7d,0x29,0x13])));

  });

  test("rsa public key", () {
    //openssl genrsa -out rsa_private_key.pem
    //openssl rsa -in rsa_private_key.pem -pubout -out rsa_public_key.pem
    //PKCS#8 format
      File rsa_private_key_file = new File("./test/resource/rsa_public_key.pem");
      String pem = rsa_private_key_file.readAsStringSync();
      List lines  = pem.split("\n").map((line)=>line.trim()).skipWhile((String line)=>!line.startsWith("---")).toList();
      String key = lines.sublist(1, lines.length-2).join("");
      var key_bytes = new Uint8List.fromList(CryptoUtils.base64StringToBytes(key));

      var p = new ASN1Parser(key_bytes);
      expect(p.hasNext() , equals(true));
      var asn1object = p.nextObject();
      expect(asn1object is ASN1Sequence , equals(true));

      ASN1Sequence seq = asn1object;
      expect(seq.elements[1] is ASN1BitString , equals(true));
      ASN1BitString os = seq.elements[1]; //always ASN1BitString ?
      expect(os.valueBytes()[0] , equals(0));//always zero ?
      var bytes = os.valueBytes().sublist(1); //remove unused bits count
      p = new ASN1Parser(bytes);
      expect(p.hasNext() , equals(true));
      asn1object = p.nextObject();
      expect(asn1object is ASN1Sequence , equals(true));
      seq = asn1object;
      expect(seq.elements.length , equals(2));

      //modulus
      expect((seq.elements[0] as ASN1Integer).intValue , equals(new BigInteger ([0x00,0xd8,0x3c,0x3c,0xac,0xb3,0xb7,0x67,0xa1,0x02,0x0f,0x94,0x7c,0xa2,0x01,0x20,0x10,0xba,0x49,0x4d,0x86,0xbd,0xa1,0xef,0xd4,0x37,0x35,0x7b,0x91,0xd5,0xc1,0xe6,0x1b,0x12,0x38,0x4c,0xd3,0xc0,0x1f,0x62,0x83,0x12,0xa5,0xef,0x15,0xcf,0x00,0x3f,0x62,0xc4,0xf6,0xb8,0x35,0xbb,0xb3,0xea,0x99,0x40,0x9f,0x87,0xe5,0x83,0xfa,0x69,0x91])));
      //publicExponent
      expect((seq.elements[1] as ASN1Integer).intValue , equals(65537));
    });

  test("x509 public key certificate", () {

    String pem =
        "MIIDBTCCAfGgAwIBAgIQNQb+T2ncIrNA6cKvUA1GWTAJBgUrDgMCHQUAMBIxEDAOBgNVBAMT\n"
        "B0RldlJvb3QwHhcNMTAwMTIwMjIwMDAwWhcNMjAwMTIwMjIwMDAwWjAVMRMwEQYDVQQDEwpp\n"
        "ZHNydjN0ZXN0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqnTksBdxOiOlsmRN\n"
        "d+mMS2M3o1IDpK4uAr0T4/YqO3zYHAGAWTwsq4ms+NWynqY5HaB4EThNxuq2GWC5JKpO1Yir\n"
        "OrwS97B5x9LJyHXPsdJcSikEI9BxOkl6WLQ0UzPxHdYTLpR4/O+0ILAlXw8NU4+jB4AP8Sn9\n"
        "YGYJ5w0fLw5YmWioXeWvocz1wHrZdJPxS8XnqHXwMUozVzQj+x6daOv5FmrHU1r9/bbp0a1G\n"
        "Lv4BbTtSh4kMyz1hXylho0EvPg5p9YIKStbNAW9eNWvv5R8HN7PPei21AsUqxekK0oW9jnEd\n"
        "HewckToX7x5zULWKwwZIksll0XnVczVgy7fCFwIDAQABo1wwWjATBgNVHSUEDDAKBggrBgEF\n"
        "BQcDATBDBgNVHQEEPDA6gBDSFgDaV+Q2d2191r6A38tBoRQwEjEQMA4GA1UEAxMHRGV2Um9v\n"
        "dIIQLFk7exPNg41NRNaeNu0I9jAJBgUrDgMCHQUAA4IBAQBUnMSZxY5xosMEW6Mz4WEAjNoN\n"
        "v2QvqNmk23RMZGMgr516ROeWS5D3RlTNyU8FkstNCC4maDM3E0Bi4bbzW3AwrpbluqtcyMN3\n"
        "Pivqdxx+zKWKiORJqqLIvN8CT1fVPxxXb/e9GOdaR8eXSmB0PgNUhM4IjgNkwBbvWC9F/lzv\n"
        "wjlQgciR7d4GfXPYsE1vf8tmdQaY8/PtdAkExmbrb9MihdggSoGXlELrPA91Yce+fiRcKY3r\n"
        "QlNWVd4DOoJ/cPXsXwry8pWjNCo5JD8Q+RQ5yZEy7YPoifwemLhTdsBz3hlZr28oCGJ3kbnp\n"
        "W0xGvQb3VHSTVVbeei0CfXoW6iz1\n";

    var cert_bytes = new Uint8List.fromList(CryptoUtils.base64StringToBytes(pem));

    var p = new ASN1Parser(cert_bytes);
    expect(p.hasNext() , equals(true));
    var asn1object = p.nextObject();
    expect(asn1object is ASN1Sequence , equals(true));
    ASN1Sequence seq = asn1object;

    expect(seq.elements[0] is ASN1Sequence , equals(true));
    var element0 = seq.elements[0];

    var element0_3 = element0.elements[3];
    expect(element0_3 is ASN1Sequence, equals(true));
    var element0_3_0 = element0_3.elements[0];
    expect(element0_3_0 is ASN1Set, equals(true));
    var element0_3_0_0 = element0_3_0.elements.first;
    expect(element0_3_0_0 is ASN1Sequence, equals(true));
    var element0_3_0_0_1 = element0_3_0_0.elements[1];
    expect(element0_3_0_0_1 is ASN1PrintableString, equals(true));
    expect((element0_3_0_0_1 as ASN1PrintableString).stringValue, equals("DevRoot"));

    var element0_4 = element0.elements[4];
    expect(element0_4 is ASN1Sequence, equals(true));
    expect(element0_4.elements[0] is ASN1UtcTime, equals(true));
    expect((element0_4.elements[0] as ASN1UtcTime).dateTimeValue, equals(DateTime.parse("2010-01-20 22:00:00.000Z")));
    expect(element0_4.elements[1] is ASN1UtcTime, equals(true));
    expect((element0_4.elements[1] as ASN1UtcTime).dateTimeValue, equals(DateTime.parse("2020-01-20 22:00:00.000Z")));

    var element0_5 = element0.elements[5];
    expect(element0_5 is ASN1Sequence, equals(true));
    var element0_5_0 = element0_5.elements[0];
    expect(element0_5_0 is ASN1Set, equals(true));
    var element0_5_0_0 = element0_5_0.elements.first;
    expect(element0_5_0_0 is ASN1Sequence, equals(true));
    var element0_5_0_0_1 = element0_5_0_0.elements[1];
    expect(element0_5_0_0_1 is ASN1PrintableString, equals(true));
    expect((element0_5_0_0_1 as ASN1PrintableString).stringValue, equals("idsrv3test"));

    expect(element0.elements[6] is ASN1Sequence , equals(true));
    var element0_6 = element0.elements[6];

    expect(element0_6.elements[1] is ASN1BitString , equals(true));
    ASN1BitString os = element0_6.elements[1]; //always ASN1BitString ?

    expect(os.valueBytes()[0] , equals(0));//always zero ?
    var bytes = os.valueBytes().sublist(1); //remove unused bits count
    p = new ASN1Parser(bytes);
    expect(p.hasNext() , equals(true));
    asn1object = p.nextObject();
    expect(asn1object is ASN1Sequence , equals(true));
    seq = asn1object;
    expect(seq.elements.length , equals(2));

    //modulus
    BigInteger expectedModulos = new BigInteger(21518154084705346821274138762882407922380704212922210585843251781362809907270675925777565628062936818636913854980154942861118239830759902009001533075067878914941993916218504286518450568111160810759646573203377874470315017865982194621508952434846313326601022451790654534552713106625866324293583211173710664343249256163552449547128977997155833237720259198928785721740265119531438131641233778575574837591001136583435616772442565871706297666044427912910371785883437973412968680553651820978964644100864723176694453218133732558009376882289418835471454808121837066085343171141842204722779999397248471822012940201656724210199);
    expect((seq.elements[0] as ASN1Integer).intValue , equals(expectedModulos));
    //publicExponent
    expect((seq.elements[1] as ASN1Integer).intValue , equals(65537));
  });

}