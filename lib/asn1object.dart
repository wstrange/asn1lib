
part of asn1lib;

/**
 * Holds the encoded  and decoded representation of an ASN1 object
 * Object are allocated in two ways:
 *
 *  A value can be supplied representing the ASN1 Type for the object (Integer, String, etc.). The object can then be encoded
 *  to its BER byte stream representation by calling [encode]
 *
 *  Conversely, the object can be initialized from an incoming BER byte array. This byte stream can then be decoded to its correspoding
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
   *  The length of _encodedBytes could be larger than the actual bytes for this specific object
   *
   */
  Uint8List _encodedBytes;
  Uint8List get encodedBytes => _encodedBytes;
  /**
   * The setter is needed rarely - usually when dealing with CHOICE encoding
   * where the encoded object is supplied.
   *
   * todo: refactor this. Should probably create a CHOICE object
   */
  set encodedBytes(Uint8List b) => _encodedBytes = b;


  /**
   * The total length of this object in bytes.
   * We need this if we are parsing a stream of bytes to know when the
   * next object starts in the stream.
   *
   */
  int get totalEncodedByteLength => valueStartPosition + valueByteLength;

  ASN1Object() {
  }

  /**
   * Create an object that encapsulates a set of value bytes
   * This is used in LDAP (for example) to encode a CHOICE type
   * The supplied valBytes is the encoded value of the choice element
   *
   * todo: refactor this - its ugly
   *
   */
  ASN1Object.fromTag(this._tag,Uint8List valBytes) {
    valueByteLength = valBytes.length;
    encode();
    _encodedBytes.setRange(valueStartPosition, valBytes.length, valBytes);
  }

  /**
   * Create an ASN1Object from supplied bytes.
   * This will typically  happen when bytes are read from a socket
   *
   * Note that is it possible that the supplied encoded bytes
   * could be longer than the actual object (i.e. in a
   * byte stream we dont always know how long an object is
   * until we complete parsing it).
   */

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
   * The index where the value bytes start. This is the position after the tag + length bytes.
   * defaults to 2 - but encoding may change this value.
   */
  int valueStartPosition = 2;

  /**
   * This will encode the tag and the length bytes - which is all we can do right now
   * Subclasses may call super on this method - but they MUST set valueByteLength before
   * calling this. We use that to know how big to make the encoded object array. Subclasses are
   * responsible for encoding their value representations.
   */
  Uint8List encode() {
    if( _encodedBytes == null ) {
      Uint8List lenEnc= ASN1Length.encodeLength(valueByteLength);
      _encodedBytes = new Uint8List( 1 + lenEnc.length + valueByteLength);
      _encodedBytes[0] = tag;
      _encodedBytes.setRange(1,lenEnc.length , lenEnc, 0);
      valueStartPosition = 1 + lenEnc.length;
    }
    return _encodedBytes;
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


