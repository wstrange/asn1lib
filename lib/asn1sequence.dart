
part of asn1lib;

/// Represents a ASN1 BER encoded sequence
/// A sequence is a container for other ASN1 objects
/// Objects are serialized sequentially to the stream
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
    super._initFromBytes();
    //print("ASN1Sequence valbytes=${hex(valueBytes())}");
    _decodeSeq();
  }

  /// Create a new empty ASN1 Sequence. Optionally override the default tag
  ASN1Sequence({int tag:SEQUENCE_TYPE}):super(tag:tag);

  /// Add an [ASN1Object] to the sequence. Objects will be
  // serialized to BER in the order they were added
  add(ASN1Object o) {
    elements.add(o);
  }



  Uint8List _encode() {
   valueByteLength = _childLength();
   super._encodeHeader();
   var i = valueStartPosition;
   // encode each element
   elements.forEach( (obj) {
     var  b = obj.encodedBytes;
     encodedBytes.setRange(i, i+ b.length, b);
     i += b.length;
   });
   return _encodedBytes;
  }

  // Calculate encoded length of all children
  int _childLength() {
    int l = 0;
    elements.forEach( (obj) {
      l += obj._encode().length;
    });
    return l;
  }

  _decodeSeq() {
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
