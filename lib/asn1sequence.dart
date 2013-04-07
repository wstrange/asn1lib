
part of asn1lib;

class ASN1Sequence extends ASN1Object {

  List<ASN1Object> elements = new List();


  /**
   * Create a sequence fromt the bytes
   * Note that bytes could be longer than the actual sequence - in which case
   * we would ignore any remaining bytes
   */
  ASN1Sequence.fromBytes(Uint8List b) {
    //this.tag = SEQUENCE_TYPE;
    this.tag = b[0];
    // todo; Check if b[0] is a valid sequence type???
    if( (tag & 0x30) == 0 )
      throw new ASN1Exception("The tag ${tag} does not look like a sequence type");

    _encodedBytes = b;
    // todo. Should we encode now, or be lazy?
    super._initFromBytes();
    print("ASN1Sequence valbytes=${hex(valueBytes())}");
    decodeSeq();
  }

  ASN1Sequence({int intTag: SEQUENCE_TYPE}) {
    _tag = intTag;
  }

  add(ASN1Object o) {
    elements.add(o);
  }


  encode() {
   valueByteLength = childLength();
   super.encode();
   var i = valueStartPosition;
   elements.forEach( (obj) {
     var  b = obj.encodedBytes;
     encodedBytes.setRange(i, b.length, b);
     i += b.length;
   });
  }

  int childLength() {
    int l = 0;
    elements.forEach( (obj) {
      obj.encode();
      l += obj.encodedBytes.length;
    });
    return l;
  }

  decodeSeq() {

    /*
      var l = ASN1Length.decodeLength(encodedBytes);
      this.valueStartPosition = l.valueStartPosition;
      this.valueByteLength = l.length;
      // now we know our value - but we need to scan for further embedded elements...
       */
      var parser = new ASN1Parser(valueBytes());


      while( parser.hasNext() ) {
        elements.add(parser.nextObject());
      }
  }

  String toString() {
   var b = new StringBuffer("Seq[");
   elements.forEach( (e) {
     b.write(e.toString());
     b.write(" ");
   });
   b.write("]");
   return b.toString();
  }

}
