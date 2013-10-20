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

