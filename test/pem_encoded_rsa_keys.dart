
library asn1test;


import 'package:test/test.dart';
import 'package:asn1lib/asn1lib.dart';
import "package:bignum/bignum.dart";
import 'package:convert/convert.dart' as convert;

import 'dart:convert';

main() {

   List<int> publicKeyDER = decodePEM("""-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1W25XAj9GvCvSY7JzVAh
Z1L/kug3LMG8M2LRSDpI5mMZJ6ua3189uAMLCxKoIqOdC2/o74t5XcxAE5foIjwd
eEpSQtjKy8O457hFa4j7Q9P6Ki/tCfd3BGG5V9fAaKu7bHh9csIDCQWhpgBMyTlh
5z2EhvkeKg4W8fkc/5Kxq+O2zkwGlLobzI5Im3vjUSjDGPmQ11RBWbHOWKodXU/A
/vuDPIFU/d7kAlpdi/lzZXh9lFd3NwouFOQhxckYugtQpIXuEbv3wPHMDhosplKx
7m6j/iHL5XtppMODSIoxePjn+j7H5kBEuVEyuHd/7fW1lm8bn3PwnTOQBMhipro+
4wIDAQAB
-----END PUBLIC KEY-----""");

   List<int> privateKeyDER = decodePEM("""-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDVbblcCP0a8K9J
jsnNUCFnUv+S6DcswbwzYtFIOkjmYxknq5rfXz24AwsLEqgio50Lb+jvi3ldzEAT
l+giPB14SlJC2MrLw7jnuEVriPtD0/oqL+0J93cEYblX18Boq7tseH1ywgMJBaGm
AEzJOWHnPYSG+R4qDhbx+Rz/krGr47bOTAaUuhvMjkibe+NRKMMY+ZDXVEFZsc5Y
qh1dT8D++4M8gVT93uQCWl2L+XNleH2UV3c3Ci4U5CHFyRi6C1Ckhe4Ru/fA8cwO
GiymUrHubqP+Icvle2mkw4NIijF4+Of6PsfmQES5UTK4d3/t9bWWbxufc/CdM5AE
yGKmuj7jAgMBAAECggEBAKmF4MAYp6m5WRGNJ/87UXz3cOboKcMUEv+h0ueS3Aqa
1gUrifU4ehZp3GCsLf5thLTr69IxL3JwZMjrVMe0hhfguJw+BD57NKhhNkqm4CVM
/xx5Osc61z8UvBno1fyNw23x+nqnXa/R2Ea5YERIntoEg/qNbwcqb9E89GqPwy3q
WZ613d8fskhyLzfDMyY8tm+suxwpO75PjWOtxNAgMx0DC74OGD0bezDFMmO7ES/E
Bt5zYri5dxFbKyOLyN7KNZFz8AwlF4loSurz7NohP0w1O6Plo2inwX/AcJSSe0Fi
W66uT70KXACQ0GEJqS1SnEH4KQu9mK6/6wt8kYZXDnECgYEA/5X+wXWqLc1bUk0Q
1dR5zMzwCPeGgMvtyn/S1my7bLBz5fTFdcfZNHPU+9+XqcU1tGo8L4EwqRS6T9Cr
gXHn9frPLsM53zPbfPaDFPJgHU/Fw6L2vuA5QqPv/7nkH777bm4/RpxqkIVWjv4V
xHgq+xsYZ6UK8Kzf4tImwCa2qWsCgYEA1cY+e+gRWBHf9v17jrjEC/BNo7R8Qi5u
ZDEmgvF6tL2GgQ+aH79PnV6CxPSurdI4dIQCTSdlyITe/gNh+hQ+idT6lP4si83S
bQkvv9M8D7O9cFOHgqUUJli+Tm8si2K1p2BY11HrVmKWL/PA5aLKoJJSoYbbSgKW
wePkp8/SxmkCgYEAmcWe/rpSZzg0h3HCfURW+7cZe+ugywDm0nzRVx0YLq6DLIl1
/AT/U6WVMO03jHcQdrmr+FDb+/5yke7UIQ9tJft+h34B5Z6HocmW2BVzam9CZxA3
MGQrT0Le9Jbc/5SiJbDC9TLKkqUGjQWmBwzdnzKQHluYF3GLSiZyFg20vH0CgYBp
6DEEidAt5Y0jfCk+Z+MYVxDfzYbR8tbV5FPEA4ZbDJoaTnR4zfrPaAc5NE9l5gP6
FXxeZOpUER+4kEx17JmfB1itf87p5CofwrFZQ3k5/j4X7Anye34kEUsW6JUU6O49
4cmhwv/oaCcn0ob6PVBNhLBTPdBeNjIiFJkvWhJ+IQKBgQCO/tZuJ25KlBv6E+DY
BOGOgJI3ioqsTa/FJN7O76ptCCidfyaEQC7zimkfkhD5mYOCAFZ/HwMfPd+JFmqE
mv7tjEMIkqh4RhoQYJ5eE95H4RyIB25s/4GARO1N1aGD+dSz45EmXEx4mf1N/5++
dZGeuvqtAXpkUfBXJed4Ehdd9Q==
-----END PRIVATE KEY-----""");


  test('Test decode outer sequence', () {

    var asn1Parser = new ASN1Parser(publicKeyDER);
    var seq = asn1Parser.nextObject();

    expect(seq.valueBytes().length, 290);
  });

   test('Test decode algorithm', () {
     var asn1Parser = new ASN1Parser(publicKeyDER);
     var topLevelSeq = asn1Parser.nextObject();
     var algorithmSequence = topLevelSeq.elements[0];

     expect(algorithmSequence
         .valueBytes()
         .length, 13);
     expect(algorithmSequence.elements[0]
         .valueBytes()
         .length, 9);
     expect(algorithmSequence.elements[1]
         .valueBytes()
         .length, 0);
   });
   test('Test decode public key', () {

     var asn1Parser = new ASN1Parser(publicKeyDER);
     var topLevelSeq = asn1Parser.nextObject();
     var publicKeyBitString = topLevelSeq.elements[1];

     expect(publicKeyBitString.valueBytes().length, 271);

     asn1Parser = new ASN1Parser(publicKeyBitString.contentBytes());
     var pkSeq = asn1Parser.nextObject();

     var expected = new BigInteger();
     expected.fromInt(65537);
     expect(pkSeq.elements[1].valueAsBigInteger, expected);

     //dump from openssl
     var expectedHex = """00 d5 6d b9 5c 08 fd
1a f0 af 49 8e c9 cd 50-21 67 52 ff 92 e8 37 2c
c1 bc 33 62 d1 48 3a 48-e6 63 19 27 ab 9a df 5f
3d b8 03 0b 0b 12 a8 22-a3 9d 0b 6f e8 ef 8b 79
5d cc 40 13 97 e8 22 3c-1d 78 4a 52 42 d8 ca cb
c3 b8 e7 b8 45 6b 88 fb-43 d3 fa 2a 2f ed 09 f7
77 04 61 b9 57 d7 c0 68-ab bb 6c 78 7d 72 c2 03
09 05 a1 a6 00 4c c9 39-61 e7 3d 84 86 f9 1e 2a
0e 16 f1 f9 1c ff 92 b1-ab e3 b6 ce 4c 06 94 ba
1b cc 8e 48 9b 7b e3 51-28 c3 18 f9 90 d7 54 41
59 b1 ce 58 aa 1d 5d 4f-c0 fe fb 83 3c 81 54 fd
de e4 02 5a 5d 8b f9 73-65 78 7d 94 57 77 37 0a
2e 14 e4 21 c5 c9 18 ba-0b 50 a4 85 ee 11 bb f7
c0 f1 cc 0e 1a 2c a6 52-b1 ee 6e a3 fe 21 cb e5
7b 69 a4 c3 83 48 8a 31-78 f8 e7 fa 3e c7 e6 40
44 b9 51 32 b8 77 7f ed-f5 b5 96 6f 1b 9f 73 f0
 9d 33 90 04 c8 62 a6 ba-3e e3""";
     expectedHex = expectedHex.replaceAll(' ', '');
     expectedHex = expectedHex.replaceAll('-', '');
     expectedHex = expectedHex.replaceAll('\n', '');
     expectedHex = expectedHex.replaceAll('\r', '');
     expected = convert.hex.decode(expectedHex);

     expect(pkSeq.elements[0].valueAsBigInteger, new BigInteger.fromBytes(0, expected));
   });


   test('Test decode private key', () {
     var asn1Parser = new ASN1Parser(privateKeyDER);
     var topLevelSeq = asn1Parser.nextObject();

     var version = topLevelSeq.elements[0];
     expect(version.valueBytes().length, 1);

     var algorithm = topLevelSeq.elements[1];
     expect(algorithm.valueBytes().length, 13);

     var privateKey = topLevelSeq.elements[2];
     expect(privateKey.valueBytes().length, 1193);

     asn1Parser = new ASN1Parser(privateKey.contentBytes());
     var pkSeq = asn1Parser.nextObject();
     version = pkSeq.elements[0];
     var modulus = pkSeq.elements[1];
     var expectedModulus = decodeHex("""
00:d5:6d:b9:5c:08:fd:1a:f0:af:49:8e:c9:cd:50:
21:67:52:ff:92:e8:37:2c:c1:bc:33:62:d1:48:3a:
48:e6:63:19:27:ab:9a:df:5f:3d:b8:03:0b:0b:12:
a8:22:a3:9d:0b:6f:e8:ef:8b:79:5d:cc:40:13:97:
e8:22:3c:1d:78:4a:52:42:d8:ca:cb:c3:b8:e7:b8:
45:6b:88:fb:43:d3:fa:2a:2f:ed:09:f7:77:04:61:
b9:57:d7:c0:68:ab:bb:6c:78:7d:72:c2:03:09:05:
a1:a6:00:4c:c9:39:61:e7:3d:84:86:f9:1e:2a:0e:
16:f1:f9:1c:ff:92:b1:ab:e3:b6:ce:4c:06:94:ba:
1b:cc:8e:48:9b:7b:e3:51:28:c3:18:f9:90:d7:54:
41:59:b1:ce:58:aa:1d:5d:4f:c0:fe:fb:83:3c:81:
54:fd:de:e4:02:5a:5d:8b:f9:73:65:78:7d:94:57:
77:37:0a:2e:14:e4:21:c5:c9:18:ba:0b:50:a4:85:
ee:11:bb:f7:c0:f1:cc:0e:1a:2c:a6:52:b1:ee:6e:
a3:fe:21:cb:e5:7b:69:a4:c3:83:48:8a:31:78:f8:
e7:fa:3e:c7:e6:40:44:b9:51:32:b8:77:7f:ed:f5:
b5:96:6f:1b:9f:73:f0:9d:33:90:04:c8:62:a6:ba:
3e:e3""");
      expect(modulus.valueAsBigInteger, new BigInteger.fromBytes(0, expectedModulus));

     var publicExponent = pkSeq.elements[2];
     var expectedPublicExponent = decodeHex("""01:00:01""");
     expect(publicExponent.valueAsBigInteger, new BigInteger.fromBytes(0, expectedPublicExponent));

     var privateExponent = pkSeq.elements[3];
     var expectedPrivateExponent = decodeHex("""
00:a9:85:e0:c0:18:a7:a9:b9:59:11:8d:27:ff:3b:
51:7c:f7:70:e6:e8:29:c3:14:12:ff:a1:d2:e7:92:
dc:0a:9a:d6:05:2b:89:f5:38:7a:16:69:dc:60:ac:
2d:fe:6d:84:b4:eb:eb:d2:31:2f:72:70:64:c8:eb:
54:c7:b4:86:17:e0:b8:9c:3e:04:3e:7b:34:a8:61:
36:4a:a6:e0:25:4c:ff:1c:79:3a:c7:3a:d7:3f:14:
bc:19:e8:d5:fc:8d:c3:6d:f1:fa:7a:a7:5d:af:d1:
d8:46:b9:60:44:48:9e:da:04:83:fa:8d:6f:07:2a:
6f:d1:3c:f4:6a:8f:c3:2d:ea:59:9e:b5:dd:df:1f:
b2:48:72:2f:37:c3:33:26:3c:b6:6f:ac:bb:1c:29:
3b:be:4f:8d:63:ad:c4:d0:20:33:1d:03:0b:be:0e:
18:3d:1b:7b:30:c5:32:63:bb:11:2f:c4:06:de:73:
62:b8:b9:77:11:5b:2b:23:8b:c8:de:ca:35:91:73:
f0:0c:25:17:89:68:4a:ea:f3:ec:da:21:3f:4c:35:
3b:a3:e5:a3:68:a7:c1:7f:c0:70:94:92:7b:41:62:
5b:ae:ae:4f:bd:0a:5c:00:90:d0:61:09:a9:2d:52:
9c:41:f8:29:0b:bd:98:ae:bf:eb:0b:7c:91:86:57:
0e:71
""");
     expect(privateExponent.valueAsBigInteger, new BigInteger.fromBytes(0, expectedPrivateExponent));
     var p = pkSeq.elements[4];
     var expectedP = decodeHex("""
00:ff:95:fe:c1:75:aa:2d:cd:5b:52:4d:10:d5:d4:
79:cc:cc:f0:08:f7:86:80:cb:ed:ca:7f:d2:d6:6c:
bb:6c:b0:73:e5:f4:c5:75:c7:d9:34:73:d4:fb:df:
97:a9:c5:35:b4:6a:3c:2f:81:30:a9:14:ba:4f:d0:
ab:81:71:e7:f5:fa:cf:2e:c3:39:df:33:db:7c:f6:
83:14:f2:60:1d:4f:c5:c3:a2:f6:be:e0:39:42:a3:
ef:ff:b9:e4:1f:be:fb:6e:6e:3f:46:9c:6a:90:85:
56:8e:fe:15:c4:78:2a:fb:1b:18:67:a5:0a:f0:ac:
df:e2:d2:26:c0:26:b6:a9:6b
""");
     expect(p.valueAsBigInteger, new BigInteger.fromBytes(0, expectedP));
     var q = pkSeq.elements[5];
     var expectedQ = decodeHex("""
00:d5:c6:3e:7b:e8:11:58:11:df:f6:fd:7b:8e:b8:
c4:0b:f0:4d:a3:b4:7c:42:2e:6e:64:31:26:82:f1:
7a:b4:bd:86:81:0f:9a:1f:bf:4f:9d:5e:82:c4:f4:
ae:ad:d2:38:74:84:02:4d:27:65:c8:84:de:fe:03:
61:fa:14:3e:89:d4:fa:94:fe:2c:8b:cd:d2:6d:09:
2f:bf:d3:3c:0f:b3:bd:70:53:87:82:a5:14:26:58:
be:4e:6f:2c:8b:62:b5:a7:60:58:d7:51:eb:56:62:
96:2f:f3:c0:e5:a2:ca:a0:92:52:a1:86:db:4a:02:
96:c1:e3:e4:a7:cf:d2:c6:69
""");
     expect(q.valueAsBigInteger, new BigInteger.fromBytes(0, expectedQ));
     var exp1 = pkSeq.elements[6];
     var expectedExp1 = decodeHex("""
00:99:c5:9e:fe:ba:52:67:38:34:87:71:c2:7d:44:
56:fb:b7:19:7b:eb:a0:cb:00:e6:d2:7c:d1:57:1d:
18:2e:ae:83:2c:89:75:fc:04:ff:53:a5:95:30:ed:
37:8c:77:10:76:b9:ab:f8:50:db:fb:fe:72:91:ee:
d4:21:0f:6d:25:fb:7e:87:7e:01:e5:9e:87:a1:c9:
96:d8:15:73:6a:6f:42:67:10:37:30:64:2b:4f:42:
de:f4:96:dc:ff:94:a2:25:b0:c2:f5:32:ca:92:a5:
06:8d:05:a6:07:0c:dd:9f:32:90:1e:5b:98:17:71:
8b:4a:26:72:16:0d:b4:bc:7d
""");
     expect(exp1.valueAsBigInteger, new BigInteger.fromBytes(0, expectedExp1));
     var exp2 = pkSeq.elements[7];
     var expectedExp2 = decodeHex("""
69:e8:31:04:89:d0:2d:e5:8d:23:7c:29:3e:67:e3:
18:57:10:df:cd:86:d1:f2:d6:d5:e4:53:c4:03:86:
5b:0c:9a:1a:4e:74:78:cd:fa:cf:68:07:39:34:4f:
65:e6:03:fa:15:7c:5e:64:ea:54:11:1f:b8:90:4c:
75:ec:99:9f:07:58:ad:7f:ce:e9:e4:2a:1f:c2:b1:
59:43:79:39:fe:3e:17:ec:09:f2:7b:7e:24:11:4b:
16:e8:95:14:e8:ee:3d:e1:c9:a1:c2:ff:e8:68:27:
27:d2:86:fa:3d:50:4d:84:b0:53:3d:d0:5e:36:32:
22:14:99:2f:5a:12:7e:21
""");
     expect(exp2.valueAsBigInteger, new BigInteger.fromBytes(0, expectedExp2));
     var co = pkSeq.elements[8];
     var expectedCo = decodeHex("""
00:8e:fe:d6:6e:27:6e:4a:94:1b:fa:13:e0:d8:04:
e1:8e:80:92:37:8a:8a:ac:4d:af:c5:24:de:ce:ef:
aa:6d:08:28:9d:7f:26:84:40:2e:f3:8a:69:1f:92:
10:f9:99:83:82:00:56:7f:1f:03:1f:3d:df:89:16:
6a:84:9a:fe:ed:8c:43:08:92:a8:78:46:1a:10:60:
9e:5e:13:de:47:e1:1c:88:07:6e:6c:ff:81:80:44:
ed:4d:d5:a1:83:f9:d4:b3:e3:91:26:5c:4c:78:99:
fd:4d:ff:9f:be:75:91:9e:ba:fa:ad:01:7a:64:51:
f0:57:25:e7:78:12:17:5d:f5
""");
     expect(co.valueAsBigInteger, new BigInteger.fromBytes(0, expectedCo));
   });
}

List<int> decodePEM(pem){
  var startsWith = ["-----BEGIN PUBLIC KEY-----", "-----BEGIN PRIVATE KEY-----"];
  var endsWith = ["-----END PUBLIC KEY-----", "-----END PRIVATE KEY-----"];

  //HACK
  for(var s in startsWith){
    if(pem.startsWith(s))
      pem = pem.substring(s.length);
  }

  for(var s in endsWith){
    if(pem.endsWith(s))
      pem = pem.substring(0, pem.length - s.length);
  }

  //Dart base64 decoder does not support line breaks
  pem = pem.replaceAll('\n', '');
  pem = pem.replaceAll('\r', '');
  return BASE64.decode(pem);
}

List<int> decodeHex(String hex){
  hex = hex.replaceAll(':', '').replaceAll('\n','').replaceAll('\r','').replaceAll('\t','');
  return convert.hex.decode(hex);
}