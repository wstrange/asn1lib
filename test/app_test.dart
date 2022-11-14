import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';

import '../example/main.dart';

// Test for https://github.com/wstrange/asn1lib/issues/61
void main() {
  test('decode application tag', () {
    var bytes = Uint8List.fromList([113, 1, 0]);

    var parser = ASN1Parser(bytes);

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

  // https://github.com/wstrange/asn1lib/issues/57
  test('test key ext key usage decoding, issue 57', () {
    final pem =
        'MIICozCCAkqgAwIBAgIJAJQcWeYoxjoUMAoGCCqGSM49BAMCMIGMMQswCQYDVQQGEwJDWTEQMA4GA1UECAwHTmljb3NpYTEQMA4GA1UEBwwHTmljb3NpYTEbMBkGA1UECgwSTWluaXN0cnkgb2YgSGVhbHRoMSMwIQYDVQQLDBpOYXRpb25hbCBlSGVhbHRoIEF1dGhvcml0eTEXMBUGA1UEAwwOQ1NDQV9ER0NfQ1lfMDEwHhcNMjEwNjAyMTAzMjUxWhcNMjMwNTIzMTAzMjUxWjCBiDELMAkGA1UEBhMCQ1kxEDAOBgNVBAgMB05pY29zaWExEDAOBgNVBAcMB05pY29zaWExIzAhBgNVBAoMGk5hdGlvbmFsIGVIZWFsdGggQXV0aG9yaXR5MRYwFAYDVQQLDA1JVCBEZXBhcnRtZW50MRgwFgYDVQQDDA9EU0NfRVVEQ0NfQ1lfMDMwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAATjp3KNE+tnRdM1roEggJfIAPeQm8VFcbdBLfaItNCTJTlMBsY1eqdMzhXDkzxSRXpYC0HESHjEseG+EF8otEHDo4GWMIGTMC8GA1UdHwQoMCYwJKAioCCGHmh0dHA6Ly9jcmwubmVoYS5nb3YuY3kvZHNjLmNybDAzBgNVHSUELDAqBgwrBgEEAQCON49lAQEGDCsGAQQBAI43j2UBAgYMKwYBBAEAjjePZQEDMCsGA1UdEAQkMCKADzIwMjEwNjA2MDAwMDAwWoEPMjAyMzA2MDYwMDAwMDBaMAoGCCqGSM49BAMCA0cAMEQCICdei2wUg1ze7RsTr+nvuhf9NgrPqQefbGYDcnHaCQZYAiBuHa0onvEeo7ViG6kYXW1r45AwIDaiHBjMNeOzmFeBTg==';
    final parser = ASN1Parser(base64Decode(pem));
    final seq = parser.nextObject() as ASN1Sequence;
    //print(seq);
    final ekuObj = (seq.elements[0] as ASN1Sequence).elements[7];

    //print(ekuObj);
    final ekuParse = ASN1Parser(ekuObj.valueBytes());
    final ekuSeq =
        (ekuParse.nextObject() as ASN1Sequence).elements[1] as ASN1Sequence;
    final ekuOctet = ekuSeq.elements[1] as ASN1OctetString;
    final octetParse = ASN1Parser(ekuOctet.valueBytes());
    // print(ekuOctet.valueBytes());
    final octetSeq = octetParse.nextObject() as ASN1Sequence;
    //print('octetSeq is: $octetSeq');
    expect((octetSeq.elements[0] as ASN1ObjectIdentifier).identifier,
        '1.3.6.1.4.1.0.1847.2021.1.1');
    expect((octetSeq.elements[1] as ASN1ObjectIdentifier).identifier,
        '1.3.6.1.4.1.0.1847.2021.1.2');
    expect((octetSeq.elements[2] as ASN1ObjectIdentifier).identifier,
        '1.3.6.1.4.1.0.1847.2021.1.3');
  }, skip: false);

  test('parse failing sequence', () {
    // @format:off
    var _bytes = [
      // sequence header, length 42
      48, 42,
      // first ASN1ObjectIndentifier
      6, 12, 43, 6, 1, 4, 1, 0, 142, 55, 143, 101, 1, 1,
      // second - this is where the parsing bug made this length 28
      6, 12, 43, 6, 1, 4, 1, 0, 142, 55, 143, 101, 1, 2,
      // third
      6, 12, 43, 6, 1, 6, 1, 4, 1, 0, 142, 55, 143, 101
    ];
    // @format:on

    var p = ASN1Parser(Uint8List.fromList(_bytes));
    var seq = p.nextObject() as ASN1Sequence;

    expect((seq.elements[1] as ASN1ObjectIdentifier).identifier,
        '1.3.6.1.4.1.0.1847.2021.1.2');
  });
}
