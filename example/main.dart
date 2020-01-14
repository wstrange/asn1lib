import 'dart:convert';

import 'package:asn1lib/asn1lib.dart';

List<int> certificateDER = decodePEM('''-----BEGIN CERTIFICATE-----
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
7zEUAmJp9KggGMmQp1+63A8=
-----END CERTIFICATE-----''');

void main() {
  var asn1Parser = ASN1Parser(certificateDER);
  var seq = asn1Parser.nextObject() as ASN1Sequence;
  print(seq.valueBytes().length);
}

List<int> decodePEM(pem) {
  var startsWith = [
    '-----BEGIN PUBLIC KEY-----',
    '-----BEGIN PRIVATE KEY-----',
    '-----BEGIN CERTIFICATE-----',
  ];
  var endsWith = [
    '-----END PUBLIC KEY-----',
    '-----END PRIVATE KEY-----',
    '-----END CERTIFICATE-----'
  ];

  //HACK
  for (var s in startsWith) {
    if (pem.startsWith(s)) pem = pem.substring(s.length);
  }

  for (var s in endsWith) {
    if (pem.endsWith(s)) pem = pem.substring(0, pem.length - s.length);
  }

  //Dart base64 decoder does not support line breaks
  pem = pem.replaceAll('\n', '');
  pem = pem.replaceAll('\r', '');
  return base64.decode(pem);
}
