part of '../asn1lib.dart';

///
/// An enum is encoded as an Integer.
///
class ASN1Enumerated extends ASN1Integer {
  ASN1Enumerated(int i, {super.tag = ENUMERATED_TYPE}) : super(BigInt.from(i));
}
