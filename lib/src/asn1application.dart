part of '../asn1lib.dart';

// Represent an ASN1 APPLICATION type. An Application is a
// custom ASN1 object that delegates the interpretation to the
// consumer.
class ASN1Application extends ASN1Object {
  ASN1Application({super.tag = APPLICATION_CLASS});

  ///  TODO: Need to override the tag..

  ASN1Application.fromBytes(super.bytes) : super.fromBytes() {
    // check that this really is an application type
    if (!isApplication(tag)) {
      throw ASN1Exception('tag $tag is not an ASN1 Application class');
    }
  }
}

// Represent an ASN1 PRIVATE type. This is a
// custom ASN1 object that delegates the interpretation to the
// consumer.
class ASN1Private extends ASN1Object {
  ASN1Private({super.tag = PRIVATE_CLASS});

  ASN1Private.fromBytes(super.bytes) : super.fromBytes() {
    // check that this really is an Private type
    if (!isPrivate(tag)) {
      throw ASN1Exception('tag $tag is not an ASN1 Private class');
    }
  }
}

// Represent an ASN1 PRIVATE type. This is a
// custom ASN1 object that delegates the interpretation to the
// consumer.
class ASN1ContextSpecific extends ASN1Object {
  ASN1ContextSpecific({super.tag = PRIVATE_CLASS});

  ASN1ContextSpecific.fromBytes(super.bytes) : super.fromBytes() {
    // check that this really is an Private type
    if (!isContextSpecific(tag)) {
      throw ASN1Exception('tag $tag is not an ASN1 Context specific class');
    }
  }
}
