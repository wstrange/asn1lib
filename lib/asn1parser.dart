part of asn1lib;


class ASN1Parser {
  
  Uint8List _bytes;
  
  ASN1Parser(this._bytes);
  
  // current position in the byte array 
  int _position = 0;
  //int _currentTagPosition = 0; 
  
  bool hasNext() { return  _position < _bytes.length; }  
  
  ASN1Object nextObject() {
    int tag = _bytes[_position];
  
    
    print("parser tag = ${hex(tag)} bytes=${hex(_bytes)}");
    // ASN1 Primitives have high bits 8/7 set to 0
    
    bool isPrimitive =  (0xC0 & tag) == 0; 
    bool isApplication = (0x40 & tag) != 0;
    
    
    int l =  _bytes.length - _position;
    
    var subBytes = new Uint8List.view(_bytes.asByteArray(), _position,l );
    
    ASN1Object obj = null;
    if( isPrimitive ) 
      obj =  _doPrimitive(tag,subBytes);
    else
    if( isApplication ) {
      print("Application tag !!");
      // sequence subtype
      if( (tag & SEQUENCE_TYPE) != 0) 
        obj = new ASN1Sequence.fromBytes(subBytes);
      else
        throw "Not done yet!!!";
    }
    else {
       print("Other type...");
      // create a vanilla object
       obj = new ASN1Object.fromBytes(subBytes);
    }
    
    _position = _position + obj.totalEncodedByteLength;
    return obj;
  
  }
  
  ASN1Object _doPrimitive(int tag,Uint8List b) {
    print("Primitive tag=${hex(tag)}");
    switch(tag ) {
    
      case SEQUENCE_TYPE: // sequence 
        return new ASN1Sequence.fromBytes(b);
        
      case OCTET_STRING_TYPE: 
        return new ASN1OctetString.fromBytes(b);
      
      case INTEGER_TYPE: 
      case ENUMERATED_TYPE:
        return new ASN1Integer.fromBytes(b);
        
        
      case BOOLEAN_TYPE:  // boolean  
      default: 
        throw "not done";
    }    
  }
}
