
part of asn1lib;

/**
 * Holds the encoded  and decoded representation of an ASN1 object
 * Object are allocated in two ways:
 * 
 *  A value can be supplied representing the ASN1 Type for the object (Integer, String, etc.). The object can then be encoded
 *  to its BER byte stream representation. 
 *  
 *  Conversely, the onbject can be initialized from an incoming BER byte array. This byte stream can then be decoded to its correspoding 
 *  ASN1 type.
 *  
 *  
 */
class ASN1Object {

  /** 
   *  The ASN1 encoded bytes. 
   *  If we are decoding a byte stream sent by another process (LDAP, for example), the
   *  decoder will parse the incoming bytes and set this array.
   *  Note that the encoded bytes could be part of another object (for example, sequence objects contain
   *  other sub objects). Care should be taken to not modify the bytes 
   *  The length of the encoded byte array could also be larger than the encoded bytes for this object
   *
   */
  Uint8List _encodedBytes;
  
  int _totalEncodedByteLength = 0;
  
  /**
   * The total length of this object in bytes.
   * We need this if we are parsing a stream of bytes to know when the
   * next object starts in the stream.
   */
  get totalEncodedByteLength => _totalEncodedByteLength;
  
  ASN1Object() {
  }
  
  ASN1Object.fromBytes(this._encodedBytes) {
    _initFromBytes();
  }
  
  /**
   * Perform initial decoding common to all ASN1 Objects
   * Determines the length and where the value bytes start
   */
  _initFromBytes() {
    _tag = _encodedBytes[0];
    ASN1Length l = ASN1Length.decodeLength(_encodedBytes);
    valueByteLength = l.length;
    valueStartPosition = l.valueStartPosition;  
    _totalEncodedByteLength = valueStartPosition + valueByteLength;
  }

  /** The BER tag representing this object */
  int _tag;

  int get tag => _tag;
  set tag(int v) => _tag = v;
  
  /**
   * Length of the encoded value in bytes. This does not include
   * the tag or the size of length field.
   */
  int valueByteLength;
  /** 
   * The index where the value bytes start. This is the position after the tag + length bytes
   */
  int valueStartPosition = 2;

  int totalEncodedLength () {
  }
  
  Uint8List get encodedBytes => _encodedBytes;
  
  
  /**
   * This will encode the tag and the length bytes - which is all we can do right now
   * Subclasses may call super on this method - but they MUST set valueByteLength before
   * calling this. We use that to know how big to make the encoded object array. Subclasses are
   * responsible for encoding their value representations.
   */
  encode() {
    Uint8List lenEnc= ASN1Length.encodeLength(valueByteLength);
    _encodedBytes = new Uint8List( 1 + lenEnc.length + valueByteLength);
    _encodedBytes[0] = tag;
    _encodedBytes.setRange(1,lenEnc.length , lenEnc, 0);
    valueStartPosition = 1 + lenEnc.length;
  }
  
  /**
   * Return just the value bytes.
   * This returns a view into the total bytes
   */
  Uint8List valueBytes() {
    return new Uint8List.view( encodedBytes.asByteArray(valueStartPosition, valueByteLength));
  }

  toHexString() => ASN1Util.listToString(encodedBytes);
  
  
  String toString() => "ASN1Object(tag=${tag.toRadixString(16)})";
}


