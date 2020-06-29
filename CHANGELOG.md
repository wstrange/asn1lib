# Changelog

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
