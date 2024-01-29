part of '../asn1lib.dart';


///
/// Encodes an object with an extended tag beyond the first byte
/// https://en.wikipedia.org/wiki/X.690#BER_encoding
///
///
/// TODO: We can probably merge this into ASN1Onbject with a bit of extra
/// checking..
class ASN1ExtendedTagObject extends ASN1Object {
  // for compatibility with the rest of the library, this is
  // the first byte of the object. Even though the rest of
  // the tag follows.
  int _extendedTag = 0;
  int get extendedTag => _extendedTag;

  ASN1ExtendedTagObject.fromBytes(Uint8List bytes): super(tag: bytes[0]) {
    // only if the rightmost 5 bits are 1s is this an extended tag
    assert( (tag & 0x1f) == 0x1f);
    var p = 1;

    int eb = bytes[p++];
    do {
      // get the lower 7 bits as the value
      _extendedTag |= (eb & 0x7f);
      if( (eb & 0x80) == 0 ) {
        break; // if the high bit is 0, we are done
      }
      // shift the extended tag left
      _extendedTag = _extendedTag << 7;
      eb = bytes[p++];
    }
    while( true );
    // p now points to offset where the length bytes start
    // calculate the length
    // var l = ASN1Length.decodeLength(bytes,offset: p);
    // print('l = ${l.length}');
    // l.valueStartPosition;

    _encodedBytes = bytes;
    _initFromBytes(offset: p);
    print(' _extended tag = $_extendedTag p=$p length = $_valueByteLength');

    // the extended tag
  }
}

