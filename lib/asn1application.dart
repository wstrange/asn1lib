part of asn1lib;

// Represent an ASN1 APPLICATION type. An Application is a
// custom ASN1 object that delegates the interpretation to the
// consumer.
class ASN1Application extends ASN1Object {
  ASN1Application({int tag = APPLICATION_CLASS}) : super(tag: tag);

  ASN1Application.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
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
  ASN1Private({int tag = PRIVATE_CLASS}) : super(tag: tag);

  ASN1Private.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
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
  ASN1ContextSpecific({int tag = PRIVATE_CLASS}) : super(tag: tag);

  ASN1ContextSpecific.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    // check that this really is an Private type
    if (!isContextSpecific(tag)) {
      throw ASN1Exception('tag $tag is not an ASN1 Context specific class');
    }
  }
}
