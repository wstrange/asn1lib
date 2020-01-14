part of asn1lib;

///
/// An ASN1Set.
///
class ASN1Set extends ASN1Object {
  Set<ASN1Object> elements = <ASN1Object>{};

  ///
  /// Create a set fromt the bytes
  ///
  /// Note that bytes could be longer than the actual sequence - in which case we would ignore any remaining bytes
  ///
  ASN1Set.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    if ((tag & SET_TYPE) == 0) {
      throw ASN1Exception('The tag ${tag} does not look like a set type');
    }
    _decodeSet();
  }

  ASN1Set({int tag = SET_TYPE}) : super(tag: tag);

  ///
  /// Add an element to the set
  ///
  void add(ASN1Object o) {
    elements.add(o);
  }

  @override
  Uint8List _encode() {
    _valueByteLength = _childLength();
    //super._encode();

    super._encodeHeader();
    var i = _valueStartPosition;
    elements.forEach((obj) {
      var b = obj.encodedBytes;
      encodedBytes.setRange(i, i + b.length, b);
      i += b.length;
    });
    return _encodedBytes;
  }

  ///
  /// TODO: Merge with Sequence code
  ///
  int _childLength() {
    var l = 0;
    elements.forEach((obj) {
      obj._encode();
      l += obj.encodedBytes.length;
    });
    return l;
  }

  void _decodeSet() {
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
    var b = StringBuffer('Set[');
    elements.forEach((e) {
      b.write(e.toString());
      b.write(' ');
    });
    b.write(']');
    return b.toString();
  }
}
