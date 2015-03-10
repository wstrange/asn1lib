An ASN.1 Parser for Dart.

Encodes & decodes ASN1 using BER encoding.

There is *just* enough implementation here to
get an LDAP client library working.


Sample

```dart
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
```


# Changes 

Added PrintableString and UTC Time elements

Changes to support RSA Private key : PEM file

Add import "package:bignum/bignum.dart"; in asn1lib.dart

Add ASN1ObjectIdentifier class 

Add OBJECT_IDENTIFIER in asn1constants.dart

Modify ASN1Parser._doPrimitive to take OBJECT_IDENTIFIER and NULL_TYPE into account

Modify ASN1Null add contructor ASN1Null.fromBytes

Modify ASN1Integer to support BigInteger

Modify asn1element_test.dart to test BigInteger case, and rsa private key test

Add test/resource folder to store rsa key for testing

Changes to support RSA public key : PEM file

Add ASN1BitString class : not sure how to handle bitstring when unused bits is not zero

Add BIT_STRING_TYPE in asn1constants.dart

Modify ASN1Parser._doPrimitive to take BIT_STRING_TYPE into account

Modify asn1element_test.dart to test rsa public key 






