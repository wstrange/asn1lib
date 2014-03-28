
part of asn1lib;

/**
 * An ASN1Set.
 *
 * todo: This code can be shared with ASN1Sequence
 */
class ASN1Set extends ASN1Object {

  Set<ASN1Object> elements = new Set<ASN1Object>();

  /**
   * Create a set fromt the bytes
   * Note that bytes could be longer than the actual sequence - in which case
   * we would ignore any remaining bytes
   */
  ASN1Set.fromBytes(Uint8List b) {
    //this.tag = SEQUENCE_TYPE;
    this.tag = b[0];
    // todo; Check if b[0] is a valid sequence type???
    if( (tag & 0x30) == 0 )
      throw new ASN1Exception("The tag ${tag} does not look like a set type");

    _encodedBytes = b;
    super._initFromBytes();
    _decodeSet();
  }

  ASN1Set({int tag: SET_TYPE}):super(tag:tag) ;

  /// Add an element to the set
  add(ASN1Object o) {
    elements.add(o);
  }

  @override
  Uint8List _encode() {
   super._encode();
   valueByteLength = childLength();
   super._encodeHeader();
   var i = valueStartPosition;
   elements.forEach( (obj) {
     var  b = obj.encodedBytes;
     encodedBytes.setRange(i, i + b.length, b);
     i += b.length;
   });
   return _encodedBytes;
  }

  // todo: Merge with Sequence code
  int childLength() {
    int l = 0;
    elements.forEach( (obj) {
      obj._encode();
      l += obj.encodedBytes.length;
    });
    return l;
  }

  _decodeSet() {
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

  @override
  String toString() {
   var b = new StringBuffer("Set[");
   elements.forEach( (e) {
     b.write(e.toString());
     b.write(" ");
   });
   b.write("]");
   return b.toString();
  }

}
