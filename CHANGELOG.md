# Changelog

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

* allow creation from dotted number lists
* allow creation from dotted number strings
* allow names to be registered, for shorthands
* allow bulk name registration
* commonly used names (obviously, what this is could be expanded)

## 0.5.4

Fixed #26

## 0.5.1 

Add AS1Integer.fromInt factory method
 
## 0.5.0 

* Convert use of BigInteger to dart SDK BigInt

## 0.4.3 

* Updates for dart 2


## 0.4.2

* Added `contentBytes()` getter
* Removed Int64List dependency and use bignum's BigInteger instead
 
