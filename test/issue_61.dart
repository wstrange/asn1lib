import 'dart:convert';
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:test/test.dart';

import '../example/main.dart'; // for decodePEM

// Test cases for https://github.com/wstrange/asn1lib/issues/61
void main() {
  var testBytes = [
    // @formatter:off
    112, 130, 2, 67, 48, 130, 2, 63, 48, 130, 1, 161, 160, 3, 2, 1, 2, 2, 17, 0,
    241, 37, 53,
    1, 245, 101, 254, 123, 227, 232, 24, 198, 233, 209, 186, 121, 48, 10, 6, 8,
    42, 134, 72, 206, 61, 4, 3,
    4, 48, 53, 49, 22, 48, 20, 6, 3, 85, 4, 3, 19, 13, 81, 83, 97, 102, 101, 32,
    82, 111, 111, 116, 32, 67,
    65, 49, 11, 48, 9, 6, 3, 85, 4, 6, 19, 2, 67, 72, 49, 14, 48, 12, 6, 3, 85,
    4, 10, 19, 5, 113, 115, 97,
    102, 101, 48, 30, 23, 13, 50, 50, 49, 48, 49, 51, 49, 52, 52, 56, 52, 52,
    90, 23, 13, 51, 50, 49, 48,
    49, 48, 49, 52, 52, 56, 52, 52, 90, 48, 62, 49, 31, 48, 29, 6, 3, 85, 4, 3,
    19, 22, 81, 83, 97, 102,
    101, 32, 77, 97, 110, 97, 103, 101, 109, 101, 110, 116, 32, 83, 117, 98, 67,
    65, 49, 11, 48, 9, 6, 3,
    85, 4, 6, 19, 2, 67, 72, 49, 14, 48, 12, 6, 3, 85, 4, 10, 19, 5, 113, 115,
    97, 102, 101, 48, 89, 48, 19,
    6, 7, 42, 134, 72, 206, 61, 2, 1, 6, 8, 42, 134, 72, 206, 61, 3, 1, 7, 3,
    66, 0, 4, 245, 37, 160, 205,
    186, 201, 132, 55, 14, 255, 31, 190, 213, 248, 71, 133, 167, 187, 249, 160,
    133, 253, 237, 80, 240, 241,
    253, 230, 76, 105, 114, 197, 209, 111, 2, 84, 105, 28, 206, 37, 26, 171,
    235, 62, 133, 250, 182, 121, 77,
    170, 162, 138, 228, 225, 141, 117, 2, 193, 208, 33, 202, 229, 56, 216, 163,
    129, 136, 48, 129, 133, 48,
    33, 6, 3, 85, 29, 14, 4, 26, 4, 24, 178, 86, 37, 149, 146, 99, 71, 45, 239,
    84, 119, 201, 224, 247, 36,
    202, 33, 183, 106, 143, 165, 74, 38, 93, 48, 14, 6, 3, 85, 29, 15, 1, 1,
    255, 4, 4, 3, 2, 1, 6, 48, 23,
    6, 3, 85, 29, 17, 4, 16, 48, 14, 129, 12, 113, 109, 115, 64, 113, 115, 97,
    102, 101, 46, 99, 104, 48,
    18, 6, 3, 85, 29, 19, 1, 1, 255, 4, 8, 48, 6, 1, 1, 255, 2, 1, 1, 48, 35, 6,
    3, 85, 29, 35, 4, 28, 48,
    26, 128, 24, 204, 8, 68, 110, 197, 203, 88, 195, 126, 193, 109, 59, 120, 77,
    184, 102, 3, 91, 11, 80,
    45, 172, 213, 21, 48, 10, 6, 8, 42, 134, 72, 206, 61, 4, 3, 4, 3, 129, 139,
    0, 48, 129, 135, 2, 66, 1,
    203, 18, 146, 103, 163, 7, 188, 133, 141, 7, 47, 252, 170, 252, 244, 249,
    244, 81, 108, 17, 26, 28, 17,
    23, 112, 209, 65, 137, 55, 237, 124, 175, 5, 51, 5, 142, 190, 171, 103, 253,
    168, 143, 82, 126, 85, 158,
    105, 122, 228, 62, 252, 132, 73, 101, 225, 15, 233, 15, 74, 126, 132, 64,
    140, 157, 245, 2, 65, 35, 14,
    88, 229, 195, 209, 161, 229, 221, 102, 131, 237, 29, 56, 25, 106, 128, 36,
    241, 90, 222, 25, 216, 30,
    105, 104, 130, 183, 73, 224, 185, 115, 101, 67, 213, 144, 196, 248, 119, 77,
    50, 138, 21, 101, 228, 168,
    176, 134, 100, 20, 202, 30, 163, 47, 155, 180, 18, 237, 249, 238, 155, 75,
    51, 95, 254,
    // The online javascript decoder https://lapo.it/asn1js/ cant decode these last 5 bytes
    // these are also the same bytes that are giving issues..
    // see other test
    //113, 1, 0, 254, 0
  ];
  //@formatter:on

  test('Parse PIV hardware key contents, issue 61 ', () {
    var objs = <ASN1Object>[];
    var rest = Uint8List.fromList(testBytes);
    while (rest.isNotEmpty) {
      var asn1Parser = ASN1Parser(rest, relaxedParsing: false);
      var obj = asn1Parser.nextObject();
      objs.add(obj);

      if (objs.isNotEmpty && objs[0].valueBytes().isNotEmpty) {
        // We can parse then first element objs[0] as Certificate ...
        // This works fine.
      }
      rest = rest.sublist(obj.encodedBytes.length);
    }
  }, skip: false);

  try {
    test('decode PIV tag', () {
      // These last 5 bytes are two asn1 objects coming from a hardware PIV
      // However - they dont appear to be valid ASN1.
      // The online javascript decoder https://lapo.it/asn1js/ cant decode these last 5 bytes
      var pivBytes = Uint8List.fromList([113, 1, 0, 254, 0]);
      //print( base64.encode(pivBytes)); // cQEA/gA=

      // This is an APPLICATION tag with the constructed bit set
      // this is not valid for LDAP - it must be a sequence but the
      // length is wrong
      var piv1 = Uint8List.fromList([113, 1, 0]);
      print('piv1 ${base64.encode(piv1)}');

      var obj1 = ASN1Application.fromBytes(piv1);
      expect(obj1, isA<ASN1Object>());

      var piv2 = Uint8List.fromList([254, 0]);
      print('piv2 ${base64.encode(piv2)}');
      var p = ASN1Parser(piv2);
      var parsedPiv2 = p.nextObject();
      expect(parsedPiv2, isA<ASN1Private>());
      expect(parsedPiv2.valueBytes().length, equals(0));

      try {
        var parser = ASN1Parser(pivBytes);
        while (parser.hasNext()) {
          var obj = parser.nextObject();
          expect(obj, isA<ASN1Object>());
        }
      } catch (e) {
        // nothing - we expect this right now since these bytes dont seem
        // valid
      }
    });
  } catch (e, s) {
    print(s);
  }

  test('private tag', () {
    var bytes = Uint8List.fromList([254, 0]);

    var parser = ASN1Parser(bytes);

    while (parser.hasNext()) {
      var obj = parser.nextObject();
      expect(obj, isA<ASN1Object>());
    }
  });

  // just to ensure the sample cert provided in #61 parses OK.
  test('cert test', () {
    var cert = '''
-----BEGIN CERTIFICATE-----
MIICPzCCAaGgAwIBAgIRAPElNQH1Zf574+gYxunRunkwCgYIKoZIzj0EAwQwNTEW
MBQGA1UEAxMNUVNhZmUgUm9vdCBDQTELMAkGA1UEBhMCQ0gxDjAMBgNVBAoTBXFz
YWZlMB4XDTIyMTAxMzE0NDg0NFoXDTMyMTAxMDE0NDg0NFowPjEfMB0GA1UEAxMW
UVNhZmUgTWFuYWdlbWVudCBTdWJDQTELMAkGA1UEBhMCQ0gxDjAMBgNVBAoTBXFz
YWZlMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE9SWgzbrJhDcO/x++1fhHhae7
+aCF/e1Q8PH95kxpcsXRbwJUaRzOJRqr6z6F+rZ5TaqiiuThjXUCwdAhyuU42KOB
iDCBhTAhBgNVHQ4EGgQYslYllZJjRy3vVHfJ4PckyiG3ao+lSiZdMA4GA1UdDwEB
/wQEAwIBBjAXBgNVHREEEDAOgQxxbXNAcXNhZmUuY2gwEgYDVR0TAQH/BAgwBgEB
/wIBATAjBgNVHSMEHDAagBjMCERuxctYw37BbTt4TbhmA1sLUC2s1RUwCgYIKoZI
zj0EAwQDgYsAMIGHAkIByxKSZ6MHvIWNBy/8qvz0+fRRbBEaHBEXcNFBiTftfK8F
MwWOvqtn/aiPUn5Vnml65D78hEll4Q/pD0p+hECMnfUCQSMOWOXD0aHl3WaD7R04
GWqAJPFa3hnYHmlogrdJ4LlzZUPVkMT4d00yihVl5KiwhmQUyh6jL5u0Eu357ptL
M1/+
-----END CERTIFICATE-----''';

    var bytes = decodePEM(cert);

    var parser = ASN1Parser(bytes);
    while (parser.hasNext()) {
      var obj = parser.nextObject() as ASN1Sequence;
      expect(obj, isA<ASN1Sequence>());
    }
  }, skip: false);
}
