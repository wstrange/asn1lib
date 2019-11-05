# ASN.1 Parser for Dart

Encodes & decodes ASN1 using BER encoding.

There is *just* enough implementation here to
get an LDAP client library working.
Contributions welcome.

## Samples

### Encoding

```dart
import 'package:asn1lib/asn1lib.dart';

var s = ASN1Sequence();
s.add(ASN1Integer(23));
s.add(ASN1OctetString('This is a test'));
s.add(ASN1Boolean(true));

// GET the BER Stream
var bytes = s.encodedBytes;
```

### Decoding

```dart
import 'package:asn1lib/asn1lib.dart';

// e.g. bytes from the Encoding Example
var p = ASN1Parser(bytes);
var s2 = p.nextObject();
// s2 is a sequence...
```
