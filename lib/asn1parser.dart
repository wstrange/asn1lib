part of asn1lib;


/// Parses ASN1 BER Encoded bytes to create ASN1 Objects
class ASN1Parser {

  // stream of bytes to parse. This might be a view into a longer stream
  Uint8List _bytes;

  /// Create a new parser for the stream of [_bytes]
  ASN1Parser(this._bytes);

  // current position in the byte array
  int _position = 0;

  bool hasNext() { return  _position < _bytes.length; }

  /**
   * Return the next ASN1Object in the stream
   */
  ASN1Object nextObject() {
    int tag = _bytes[_position]; // get curren tag in stream

    //print("parser tag = ${hex(tag)} bytes=${hex(_bytes)}");
    // ASN1 Primitives have high bits 8/7 set to 0

    bool isPrimitive =  (0xC0 & tag) == 0;
    bool isApplication = (0x40 & tag) != 0;

    int l =  _bytes.length - _position;

    // create a view into the larger stream that includes the remaining un-parsed bytes
    var subBytes = new Uint8List.view(_bytes.buffer, _position + _bytes.offsetInBytes, l);
    //print("parser _bytes=${_bytes} position=${_position} len=$l  bytes=${hex(subBytes)}");

    ASN1Object obj = null;

    if( isPrimitive )
      obj =  _doPrimitive(tag,subBytes);
    else
    if( isApplication ) {
      // sequence subtype
      if( (tag & SEQUENCE_TYPE) != 0)
        obj = new ASN1Sequence.fromBytes(subBytes);
      else
        throw new ASN1Exception("Parser for tag ${tag} not implemented yet");
    }
    else {
      // create a vanilla object
       obj = new ASN1Object.fromBytes(subBytes);
    }

    _position = _position + obj.totalEncodedByteLength;
    return obj;

  }

  ASN1Object _doPrimitive(int tag,Uint8List b) {
    //print("Primitive tag=${hex(tag)}");
    switch(tag ) {
      case SEQUENCE_TYPE: // sequence
        return new ASN1Sequence.fromBytes(b);

      case OCTET_STRING_TYPE:
        return new ASN1OctetString.fromBytes(b);

      case INTEGER_TYPE:
      case ENUMERATED_TYPE:
        return new ASN1Integer.fromBytes(b);

      case SET_TYPE:
        return new ASN1Set.fromBytes(b);

      case BOOLEAN_TYPE:  // boolean
        return new ASN1Boolean.fromBytes(b);
        
      case OBJECT_IDENTIFIER:  // boolean
              return new ASN1ObjectIdentifier.fromBytes(b); 
              
      case BIT_STRING_TYPE:  // boolean
              return new ASN1BitString.fromBytes(b); 
               
      case NULL_TYPE:  // boolean
                    return new ASN1Null.fromBytes(b); 
         
      default:
        throw new ASN1Exception("Parser for tag ${tag} not implemented yet");
    }
  }
}
