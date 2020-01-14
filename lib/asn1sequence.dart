part of asn1lib;

///
/// Represents a ASN1 BER encoded sequence.
///
/// A sequence is a container for other ASN1 objects
/// Objects are serialized sequentially to the stream
///
class ASN1Sequence extends ASN1Object {
  List<ASN1Object> elements = <ASN1Object>[];

  ///
  /// Create a sequence fromt the byte array [bytes].
  ///
  /// Note that bytes array b could be longer than the actual encoded sequence - in which case
  /// we ignore any remaining bytes.
  ///
  ASN1Sequence.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    if ((tag & SEQUENCE_TYPE) == 0) {
      throw ASN1Exception('The tag ${tag} does not look like a sequence type');
    }
    //print('ASN1Sequence valbytes=${hex(valueBytes())}');
    _decodeSeq();
  }

  ///
  /// Create a new empty ASN1 Sequence. Optionally override the default tag
  ///
  ASN1Sequence({int tag = SEQUENCE_TYPE}) : super(tag: tag);

  ///
  /// Add an [ASN1Object] to the sequence. Objects will be serialized to BER in the order they were added
  ///
  void add(ASN1Object o) {
    elements.add(o);
  }

  @override
  Uint8List _encode() {
    _valueByteLength = _childLength();
    super._encodeHeader();
    var i = _valueStartPosition;
    // encode each element
    elements.forEach((obj) {
      var b = obj.encodedBytes;
      encodedBytes.setRange(i, i + b.length, b);
      i += b.length;
    });
    return _encodedBytes;
  }

  ///
  /// Calculate encoded length of all children
  ///
  int _childLength() {
    var l = 0;
    elements.forEach((obj) {
      l += obj._encode().length;
    });
    return l;
  }

  void _decodeSeq() {
    /*
      var l = ASN1Length.decodeLength(encodedBytes);
      this.valueStartPosition = l.valueStartPosition;
      this.valueByteLength = l.length;
      // now we know our value - but we need to scan for further embedded elements...
       */
    var parser = ASN1Parser(valueBytes());

    while (parser.hasNext()) {
      elements.add(parser.nextObject());
    }
  }

  @override
  String toString() {
    var b = StringBuffer('Seq[');
    elements.forEach((e) {
      b.write(e.toString());
      b.write(' ');
    });
    b.write(']');
    return b.toString();
  }
}
