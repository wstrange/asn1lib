# Changelog

### 1.5.3

- Fixes #68

### 1.5.2

- Support the ability to parse objects with extended tags (more than one byte). #65
- Simplify by converting ASN1Length to Dart records

### 1.5.0

- Make a number of fields `final` that should not be changed.
- Add types to a few members.
- Remove nullability from a field fields.
- Require Dart 3.0

### 1.4.1

- Fix null assertion when accessing valueBytes before encodedBytes.

### 1.4.0

* Reverted parsing of APPLICATION tags to the older behaviour. If the constructed bit is
  set, the tag is parsed as an ASN1Sequence. The recent updates broke LDAP ASN1 parsing.

### 1.3.0

* Adds classes to handle non primitive classes: ASN1Application,ASN1ContextSpecific, ASN1Private.
* This is a potential change in behavior for consumers that expect some of these classes
  to be parsed as primitive or sequence types. See [README.md]
* The `encodeApplicationTagsAsObject` option on ASN1Parser has been dropped as it
  is now the default. Consumers should reparse bytes they know to be a sequence, etc.

### 1.2.2

- Fix #62. Allow context specific tags to be cast to an asn1 sequence.

### 1.2.1

- Fix #57

### 1.2.0

- Fix #61. Adds a flag to the parser `encodeApplicationTagsAsObject` that will
  force APPLICATION objects to be encoded as ASN1Objects, skipping any attempt to create sequences.

### 1.1.1

- fix: Use the correct value for `unusedBits` in `ASN1BitString.fromBytes `

### 1.1.0

- Add optional flag whether to relax parsing, off by default, for backwards-compatibility

### 1.0.3

- Add ASN1BMPString support

### 1.0.2

- Better toString() for ASN1ObjectIdentifier

### 1.0.1

- Add ASN1NumericString support

### 1.0.0

- Bumped to 1.0.0 as this is now null safe
- Code cleanup

## 0.9.0

- Requires Dart 2.12
- Enable null-safety

## 0.8.1

- Allow OID octets to be 0
- Fix ASN1Integer.toString() typo

## 0.8.0

- Add ASN1IpAddress object based on ASN1OctetString
- Add tests for ASN1IpAddress

## 0.7.1

- Allow parsing of unrecognizes application tags into generic ASN1Objects
- Fix parser test filename typo
- Add new tag tests

## 0.7.0

- Improve object identifier tests
- Fix ASN1ObjectIdentifier static methods fromBytes() and fromComponents()

## 0.6.5

- Add new object identifiers

## 0.6.4

- Fix ASN1Object.preEncoded bytes range
- Add unit tests

## 0.6.3

- Add ASN1TeletextString Parser
- Add unit tests

## 0.6.2

- Small fix for the ASN1GeneralizedTime parser

## 0.6.1

- Add sha1WithRSAEncryption object identifier
- Add ASN1GeneralizedTime Parser
- Add unit tests

## 0.6.0

- Fix all linter warnings

## 0.5.15

- Add businessCategory object identifier

## 0.5.14

- Add DN for subjectAltName

## 0.5.13

- Merged #37. Improved length computing in the ASN1Parser.
- Added new unit tests.

## 0.5.12

- Merged #36. Improved length computing in the ASN1Parser.

## 0.5.11

- Merged #34. Added example

## 0.5.10

- Merged #32. Update length in asn1 parser.

## 0.5.9

- Merged #31. Improve fromBytes. Logic from Java Bouncy Castle.

## 0.5.8

Merged #30

- Add IA5String
- Add associated tests
- Make sure parser handles IA5 and UT8 String
- Add large test case with PEM Certificate that includes IA5 and UTF8 Strings
- Cleanup README

## 0.5.7

Merged #29

- Expand AS1NNull to accept tag
- Associated test cases
- Added David Janes as author

## 0.5.6

Merged #28

Add ASN1UTF8String

## 0.5.5

Merged #27

Updates to ASN1ObjectIdentifier to:

- allow creation from dotted number lists
- allow creation from dotted number strings
- allow names to be registered, for shorthands
- allow bulk name registration
- commonly used names (obviously, what this is could be expanded)

## 0.5.4

Fixed #26

## 0.5.1

Add AS1Integer.fromInt factory method

## 0.5.0

- Convert use of BigInteger to dart SDK BigInt

## 0.4.3

- Updates for dart 2

## 0.4.2

- Added `contentBytes()` getter
- Removed Int64List dependency and use bignum's BigInteger instead
