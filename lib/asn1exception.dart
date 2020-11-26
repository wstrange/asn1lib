part of asn1lib;

///
/// An ASN1 Exception
///
class ASN1Exception implements Exception {
  String message;

  ASN1Exception(this.message);
}
