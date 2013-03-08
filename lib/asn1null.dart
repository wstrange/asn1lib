
part of asn1lib;

class ASN1Null extends ASN1Object {

  static final nullBytes = [NULL_TYPE, 0x00];

  List get encodedBytes => nullBytes;

}
