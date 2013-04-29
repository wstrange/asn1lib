
part of asn1lib;

class ASN1Sequence extends ASN1Object {

  List<ASN1Object> elements = new List();


  /**
   * Create a sequence fromt the byte array [b]
   * Note that bytes array b could be longer than the actual encoded sequence - in which case
   * we ignore any remaining bytes
   */
  ASN1Sequence.fromBytes(Uint8List b) {
    this.tag = b[0];
    // todo; Check if b[0] is a valid sequence type???
    if( (tag & 0x30) == 0 )
      throw new ASN1Exception("The tag ${tag} does not look like a sequence type");

    _encodedBytes = b;
    // todo. Should we encode now, or be lazy?
    super._initFromBytes();
    //print("ASN1Sequence valbytes=${hex(valueBytes())}");
    decodeSeq();
  }

  /// Create a new empty ASN1 Sequence. Optionally override the tag
  ASN1Sequence({int tag:SEQUENCE_TYPE}):super(tag:tag){
  }

  add(ASN1Object o) {
    elements.add(o);
  }


  encodeHeader() {
   valueByteLength = childLength();
   super.encodeHeader();
   var i = valueStartPosition;
   elements.forEach( (obj) {
     var  b = obj.encodedBytes;
     encodedBytes.setRange(i, i+ b.length, b);
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
