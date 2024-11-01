part of '../asn1lib.dart';

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
  final int tag;

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
  int? _extendedTag;

  bool get hasExtendedTag => _extendedTag != null;

  int? get extendedTag => _extendedTag;

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
  ASN1Object({this.tag = 0});

  ///
  /// Create an object that encapsulates a set of value bytes that are already encoded.
  ///
  /// This is used in LDAP (for example) to encode a CHOICE type
  /// The supplied valBytes is the encoded value of the choice element
  ///
  ASN1Object.preEncoded(this.tag, Uint8List valBytes) {
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
  ASN1Object.fromBytes(Uint8List bytes) : tag = bytes[0] {
    _encodedBytes = bytes;
    // _initFromBytes();

    var offset = 1; // offset where the length bytes start
    // This is an extended tag if all the lower 5 bits are 1s
    if ((tag & 0x1f) == 0x1f) {
      var (tag, o) = _calculateExtendedTag(bytes);
      _extendedTag = tag;
      offset = o;
    }

    var (l, v) = ASN1Object.decodeLength(_encodedBytes!, offset: offset);
    _valueByteLength = l;
    _valueStartPosition = v;
  }

  // calculate a tag that is bigger than can fit into the 5 bits of
  // the first byte.
  // returns (tag,counter where length bytes start)
  (int, int) _calculateExtendedTag(Uint8List bytes) {
    var extendedTag = 0;
    var p = 1;
    var eb = bytes[p++];
    do {
      // get the lower 7 bits as the value
      extendedTag |= eb & 0x7f;
      if ((eb & 0x80) == 0) {
        break; // if the high bit is 0, we are done
      }
      // shift the extended tag left
      extendedTag = extendedTag << 7;
      eb = bytes[p++];
    } while (true);
    return (extendedTag, p);
  }

  ///
  /// The total length of this object in bytes - including its value
  /// bytes and the encoded tag and length bytes.
  ///
  /// We need this if we are parsing a stream of bytes to know when the
  /// next object starts in the stream.
  ///
  ////
  int get totalEncodedByteLength => _valueStartPosition + _valueByteLength;

  ///
  /// Length of the encoded value bytes. This does not include the length of
  /// the tag or length fields. See [totalEncodedByteLength].
  ///
  late int _valueByteLength;

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
  /// This will encode __only__ the tag and the length bytes- which is all we can do right now
  /// Subclasses may call this method - but they MUST set [_valueByteLength] before
  /// calling this. We need this know how big to make the encoded object array.
  /// Subclasses are
  /// responsible for encoding their value representations.
  ///
  Uint8List _encodeHeader() {
    if (_encodedBytes == null) {
      var lenEnc = ASN1Object.encodeLength(_valueByteLength);
      _encodedBytes = Uint8List(1 + lenEnc.length + _valueByteLength);
      _encodedBytes![0] = tag;
      _encodedBytes!.setRange(1, 1 + lenEnc.length, lenEnc, 0);
      _valueStartPosition = 1 + lenEnc.length;
    }
    return _encodedBytes!;
  }

  ///
  /// Trigger encoding of the object. After calling this the encoded bytes will be available in [encodedBytes].
  ///
  /// Subclasses will need to override this.
  ///
  Uint8List _encode() => _encodeHeader();

  ///
  /// Return just the value bytes.
  ///
  /// This returns a view into the byte buffer
  ///
  Uint8List valueBytes() {
    return Uint8List.view(encodedBytes.buffer,
        _valueStartPosition + encodedBytes.offsetInBytes, _valueByteLength);
  }

  ///
  /// Returns the real content of a tag. This might be equal to valueBytes for some tags.
  ///
  /// some other tags like BitString include padding in their valueBytes.
  /// This method always returns the unpadded contentBytes.
  ///
  Uint8List contentBytes() => valueBytes();

  ///
  /// Subclasses can call this to set the value bytes
  ///
  void _setValueBytes(List<int> valBytes) {
    encodedBytes.setRange(
        _valueStartPosition, _valueStartPosition + valBytes.length, valBytes);
  }

  ///
  /// Decode the asn1 length field from the encoded bytes
  ///
  /// This method has no side effect on an object
  /// Returns a record with (length,valueStartPosition).
  /// where length is the length in bytes of the object, and
  /// value start position is the offset where the values start
  /// within the byte array (after the tag and the lenght bytes).
  ///
  /// Usually the first byte is the tag followed by the
  ///  length encoding.
  /// [offset] is where the length bytes start in the byte array. For
  ///  most objects, this will be right after the tag at position 1.
  ///
  static (int length, int valueStart) decodeLength(Uint8List encodedBytes,
      {int offset = 1}) {
    var valueStartPosition = offset + 1; //default
    var length = encodedBytes[offset] & 0x7F;
    if (length != encodedBytes[offset]) {
      var numLengthBytes = length;

      length = 0;
      for (var i = 0; i < numLengthBytes; i++) {
        length <<= 8;
        length |= encodedBytes[valueStartPosition++] & 0xFF;
      }
    }
    return (length, valueStartPosition);
  }

  ///
  /// Encode a BER length - into 1 to 5 bytes as appropriate
  /// Values less than <= 127 are encoded in a single byte
  /// If the value is larger than 127, the first byte
  /// contains 0x80 + the number of following bytes used to represent the length
  /// The length is encoded by the ///fewest/// number of bytes possible - treated
  /// as an unsigned binary value.
  ///
  /// This is a static method that has no side effect on an object. The
  /// returned bytes can be copied into an encoded representation of an object.
  ///
  static Uint8List encodeLength(int length) {
    Uint8List e;
    if (length <= 127) {
      e = Uint8List(1);
      e[0] = length;
    } else {
      var x = Uint32List(1);
      x[0] = length;
      var y = Uint8List.view(x.buffer);
      // skip null bytes
      var num = 3;
      while (y[num] == 0) {
        --num;
      }
      e = Uint8List(num + 2);
      e[0] = 0x80 + num + 1;
      for (var i = 1; i < e.length; ++i) {
        e[i] = y[num--];
      }
    }
    return e;
  }

  String toHexString() => ASN1Util.listToString(encodedBytes);

  @override
  String toString() =>
      'ASN1Object(tag=${tag.toRadixString(16)} valueByteLength=$_valueByteLength) startpos=$_valueStartPosition bytes=${toHexString()}';

  @override
  int get hashCode => encodedBytes.hashCode;

  @override
  bool operator ==(Object other) =>
      other is ASN1Object && _eq(encodedBytes, other.encodedBytes);

  // Byte by byte comparison.
  // The collection package can do this - but it introduces a dependency which
  // we want to avoid
  bool _eq(Uint8List a, Uint8List b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; ++i) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}
