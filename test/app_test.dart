import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import '../example/main.dart';

// Test for https://github.com/wstrange/asn1lib/issues/61
void main() {
  test('decode application tag', () {
    var bytes = Uint8List.fromList([113, 1, 0]);

    var parser = ASN1Parser(bytes, encodeApplicationTagsAsObject: true);

    while (parser.hasNext()) {
      var obj = parser.nextObject();
      expect(obj, isA<ASN1Object>());
    }
  });

  test('private tag', () {
    var bytes = Uint8List.fromList([254, 0]);

    var parser = ASN1Parser(bytes);

    while (parser.hasNext()) {
      var obj = parser.nextObject();
      expect(obj, isA<ASN1Object>());
    }
  });

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
      print('sequence obj len = ${obj.totalEncodedByteLength}');
      for (var elem in obj.elements) {
        //print('nested elem is $elem\n');
      }
    }
  });
}
