part of asn1lib;

///
/// Holds the encoded and decoded representation of an ASN1 object.
///
/// Object are allocated in two ways:
///
/// /// A value can be supplied representing the ASN1 Type for the object (Integer, String, etc.).
/// The encoded bytes can be read by calling [encodedBytes].
/// /// Conversely, the object can be initialized from an incoming BER byte array.
/// Using  [ASN1Object.fromBytes()]. This byte stream can then be decoded to its correspoding ASN1 type.
///
class ASN1Object {
  /// The BER tag representing this object
  final int _tag;
  int get tag => _tag;

  ///
  /// The ASN1 encoded bytes.
  ///
  /// If we are decoding a byte stream sent by another process (LDAP, for example), the
  /// decoder will parse the incoming bytes and set this array.
  /// Note that the encoded bytes could be part of another object (for example, sequence objects contain
  /// other sub objects). Care should be taken to not modify the bytes
  /// The length of _encodedBytes could be larger than the actual bytes for this specific object
  ///
  Uint8List? _encodedBytes;

  ///
  /// Get the encoded byte representation for this object. This can trigger
  /// calling the subclasss [_encode] method if the object has not yet been encoded
  ///
  Uint8List get encodedBytes {
    if (_encodedBytes == null) {
      _encode();
    }
    if (_encodedBytes == null) {
      throw ASN1Exception('ASN1 Encoding failed. This should never happen');
    }
    return _encodedBytes!;
  }

  /// Check if the encoding is ready.
  bool get isEncoded => _encodedBytes != null;

  /// Create an ASN1Object. Optionally set the tag
  ASN1Object({int tag = 0}) : _tag = tag;

  ///
  /// Create an object that encapsulates a set of value bytes that are already encoded.
  ///
  /// This is used in LDAP (for example) to encode a CHOICE type
  /// The supplied valBytes is the encoded value of the choice element
  ///
  ASN1Object.preEncoded(int tag, Uint8List valBytes) : _tag = tag {
    _valueByteLength = valBytes.length;
    _encodeHeader();
    _encodedBytes!.setRange(
        _valueStartPosition, _valueStartPosition + valBytes.length, valBytes);
  }

  ///
  /// Create an ASN1Object from the given [bytes].
  ///
  /// This will typically  happen when bytes are read from a socket
  ///
  /// Note that is it possible that the supplied encoded bytes
  /// could be longer than the actual object (i.e. in a
  /// byte stream we dont always know how long an object is
  /// until we complete parsing it).
  ///
  ASN1Object.fromBytes(bytes) : _tag = bytes[0] {
    _encodedBytes = bytes;
    _initFromBytes();
  }

  ///
  /// Perform initial decoding common to all ASN1 Objects
  /// Determines the length and where the value bytes start
  ////
  void _initFromBytes() {
    var l = ASN1Length.decodeLength(_encodedBytes!);
    _valueByteLength = l.length;
    _valueStartPosition = l.valueStartPosition;
  }

  ///
  /// The total length of this object in bytes - including its value
  /// bytes and the encoded tag and length bytes.
  ///
  /// We need this if we are parsing a stream of bytes to know when the
  /// next object starts in the stream.
  ///
  ////
  int get totalEncodedByteLength => _valueStartPosition + _valueByteLength!;

  ///
  /// Length of the encoded value bytes. This does not include the length of
  /// the tag or length fields. See [totalEncodedByteLength].
  ///
  int? _valueByteLength;

  ///
  /// The index where the value bytes start. This is the position after the tag + length bytes.
  ///
  /// Defaults to 2 - but encoding may change this value if more bytes are needed to encode the length field.
  ///
  int _valueStartPosition = 2;

  ///
  ///
  /// Encode the objects tag and length fields to BER. The encoded bytes are available in [encodedBytes].
  ///
  /// This will encode ///only/// the tag and the length bytes- which is all we can do right now
  /// Subclasses may call this method - but they MUST set [valueByteLength] before
  /// calling this. We need this know how big to make the encoded object array. Subclasses are
  /// responsible for encoding their value representations using [encodeBigInt]
  ///
  Uint8List? _encodeHeader() {
    if (_encodedBytes == null) {
      var lenEnc = ASN1Length.encodeLength(_valueByteLength!);
      _encodedBytes = Uint8List(1 + lenEnc.length + _valueByteLength!);
      _encodedBytes![0] = tag;
      _encodedBytes!.setRange(1, 1 + lenEnc.length, lenEnc, 0);
      _valueStartPosition = 1 + lenEnc.length;
    }
    return _encodedBytes;
  }

  ///
  /// Trigger encoding of the object. After calling this the encoded bytes will be available in [encodedBytes].
  ///
  /// Subclasses will need to override this.
  ///
  Uint8List? _encode() => _encodeHeader();

  ///
  /// Return just the value bytes.
  ///
  /// This returns a view into the byte buffer
  ///
  Uint8List valueBytes() {
    return Uint8List.view(_encodedBytes!.buffer,
        _valueStartPosition + _encodedBytes!.offsetInBytes, _valueByteLength);
  }

  ///
  /// Returns the real content of a tag. This might be equal to valueBytes for some tags.
  ///
  /// some other tags like BitString include padding in their valueBytes.
  /// This method always returns the unpadded contentBytes.
  ///
  Uint8List? contentBytes() => valueBytes();

  ///
  /// Subclasses can call this to set the value bytes
  ///
  void _setValueBytes(List<int> valBytes) {
    encodedBytes.setRange(
        _valueStartPosition, _valueStartPosition + valBytes.length, valBytes);
  }

  String toHexString() => ASN1Util.listToString(encodedBytes);

  @override
  String toString() =>
      'ASN1Object(tag=${tag.toRadixString(16)} valueByteLength=$_valueByteLength) startpos=$_valueStartPosition bytes=${toHexString()}';
}
