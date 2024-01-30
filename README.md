# ASN.1 Parser for Dart

Encodes & decodes ASN1 using BER encoding.

## Samples

### Encoding

```dart
import 'package:asn1lib/asn1lib.dart';

var s = ASN1Sequence();
s.add(ASN1Integer(23));
s.add(ASN1OctetString('This is a test'));
s.add(ASN1Boolean(true));

// GET the BER Stream
var bytes = s
.
encodedBytes;
```

### Decoding

```dart
import 'package:asn1lib/asn1lib.dart';

// e.g. bytes from the Encoding Example
var p = ASN1Parser(bytes);
var s2 = p.nextObject();
// s2 is a sequence...


// relaxed parsing, returning a generic ASN1Object from (yet) unsupported structures, instead of throwing
var p2 = ASN1Parser(bytes, relaxedParsing: true);
var s3 = p2.nextObject();
// s3 is a sequence...
```

## ASN1 Object classes

The library has been most thoroughly tested against ASN1 _primitive_ class types, such as strings,
integers,
sequences and sets.

There is minimal support for ASN1 Application, Context-specific and Private classes. If the parser
encounters
these tags, it will wrap them in an a corresponding object ( ASN1Application, ASN1ContextSpecific,
ASN1Private). You
can force decode these to another type, by doing something like this:

```dart 
    var s = parser.nextObject();
    // We expect this is a context-specific class
    expect(s, isA<ASN1ContextSpecific>());
    // which is also an ASN1Object...
    expect(s, isA<ASN1Object>());
    // We expect this is a sequence, so "recast" to a sequence type
    var sequence = ASN1Sequence.fromBytes(s.encodedBytes);
    expect(sequence, isA<ASN1Sequence>()); 
```

## Issues

ASN1 parsing is complex, so bugs are expected. If you find a bug, please provide a test case
that demonstrates the issue, along with the
expected output. Bonus points if it is formatted as a dart test.

## References

* https://letsencrypt.org/docs/a-warm-welcome-to-asn1-and-der/
* https://luca.ntop.org/Teaching/Appunti/asn1.html
* https://ldap.com/ldapv3-wire-protocol-reference-asn1-ber/