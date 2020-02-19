part of asn1lib;

///
/// Parses ASN1 BER Encoded bytes to create ASN1 Objects
///
class ASN1Parser {
  /// stream of bytes to parse. This might be a view into a longer stream
  final Uint8List _bytes;

  /// Create a new parser for the stream of [_bytes]
  ASN1Parser(this._bytes);

  /// current position in the byte array
  int _position = 0;

  bool hasNext() {
    //return _position < ASN1Length.decodeLength(_bytes).length;
    return _position < _bytes.length;
  }

  ///
  /// Return the next ASN1Object in the stream
  ///
  ASN1Object nextObject() {
    var tag = _bytes[_position]; // get curren tag in stream

    // print("parser tag = ${tag} bytes=${_bytes}");
    // ASN1 Primitives have high bits 8/7 set to 0

    var isPrimitive = (0xC0 & tag) == 0;
    var isApplication = (0x40 & tag) != 0;

    //int l = _bytes.length - _position;

    var l = 0;
    var length = ASN1Length.decodeLength(_bytes.sublist(_position));
    if (_position < length.length + length.valueStartPosition) {
      l = length.length + length.valueStartPosition;
    } else {
      l = _bytes.length - _position;
    }

    // create a view into the larger stream that includes the remaining un-parsed bytes
    var offset = _position + _bytes.offsetInBytes;
    var subBytes = Uint8List.view(_bytes.buffer, offset, l);
    //print("parser _bytes=${_bytes} position=${_position} len=$l  bytes=${hex(subBytes)}");

    ASN1Object obj;

    if (isPrimitive) {
      obj = _doPrimitive(tag, subBytes);
    } else if (isApplication) {
      // sequence subtype
      if ((tag & SEQUENCE_TYPE) != 0) {
        obj = ASN1Sequence.fromBytes(subBytes);
      } else {
        throw ASN1Exception('Parser for tag ${tag} not implemented yet');
      }
    } else {
      // create a vanilla object
      obj = ASN1Object.fromBytes(subBytes);
    }

    _position = _position + obj.totalEncodedByteLength;
    return obj;
  }

  ASN1Object _doPrimitive(int tag, Uint8List b) {
    //print("Primitive tag=${hex(tag)}");
    switch (tag) {
      case SEQUENCE_TYPE: // sequence
        return ASN1Sequence.fromBytes(b);

      case OCTET_STRING_TYPE:
        return ASN1OctetString.fromBytes(b);

      case UTF8_STRING_TYPE:
        return ASN1UTF8String.fromBytes(b);

      case IA5_STRING_TYPE:
        return ASN1IA5String.fromBytes(b);

      case INTEGER_TYPE:
      case ENUMERATED_TYPE:
        return ASN1Integer.fromBytes(b);

      case SET_TYPE:
        return ASN1Set.fromBytes(b);

      case BOOLEAN_TYPE:
        return ASN1Boolean.fromBytes(b);

      case OBJECT_IDENTIFIER:
        return ASN1ObjectIdentifier.fromBytes(b);

      case BIT_STRING_TYPE:
        return ASN1BitString.fromBytes(b);

      case NULL_TYPE:
        return ASN1Null.fromBytes(b);

      case PRINTABLE_STRING_TYPE:
        return ASN1PrintableString.fromBytes(b);

      case UTC_TIME_TYPE:
        return ASN1UtcTime.fromBytes(b);

      case GENERALIZED_TIME:
        return ASN1GeneralizedTime.fromBytes(b);

      case TELETEXT_STRING:
        return ASN1TeletextString.fromBytes(b);

      default:
        throw ASN1Exception('Parser for tag ${tag} not implemented yet');
    }
  }
}
