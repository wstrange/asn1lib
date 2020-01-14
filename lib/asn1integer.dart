part of asn1lib;

///
/// ASN1Integer encoding / decoding.
///
/// Note that asn1 integers can be arbitrary precision, so a BigInt is used
/// to hold the int value. Convenience methods are provided to deal with
/// int or BigInt
///
class ASN1Integer extends ASN1Object {
  BigInt _intValue;

  ASN1Integer(this._intValue, {tag = INTEGER_TYPE}) : super(tag: tag);

  ASN1Integer.fromInt(int x, {tag = INTEGER_TYPE}) : super(tag: tag) {
    _intValue = BigInt.from(x);
    _encode();
  }

  ASN1Integer.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    _intValue = decodeBigInt(valueBytes());
  }

  int get intValue => _intValue.toInt();

  BigInt get valueAsBigInteger => _intValue;

  @override
  Uint8List _encode() {
    var t = encodeBigInt(_intValue);
    _valueByteLength = t.length;
    super._encodeHeader();
    _setValueBytes(t);
    return _encodedBytes;
  }

  static Uint8List encodeInt(int x) => encodeBigInt(BigInt.from(x));

  static int decodeInt(Uint8List bytes) => decodeBigInt(bytes).toInt();

  @override
  String toString() => 'ASNInteger($intValue)';

  static final _b256 = BigInt.from(256);
  static final _minusOne = BigInt.from(-1);

  ///
  /// Given an ASN1 encoded integer return the integer value of the byte stream.
  ///
  static BigInt decodeBigInt(Uint8List bytes) {
    var isNegative = (bytes[0] & 0x80) != 0;
    var result = BigInt.zero;
    for (var i = 0; i < bytes.length; ++i) {
      result = result << 8;
      var x = isNegative ? (bytes[i] ^ 0xff) : bytes[i];
      result += BigInt.from(x);
    }
    if (isNegative) return (result + BigInt.one) * _minusOne;

    return result;
  }

  ///
  /// Encode an integer to ASN.1 byte format.
  /// ASN.1 integer is a two's complement format
  /// with the ///smallest' possible representation
  /// in 'Big' Endian format (MSB first on the wire.)
  ///
  /// The most significant bit is the sign bit (1 for negative,
  /// 0 postive).
  /// This may require padding the representation with an extra byte
  /// to get the correct sign bit
  ///
  static final _negOne = BigInt.from(-1);
  static final _negOneArray = Uint8List.fromList([0xff]);
  static final _zeroList = Uint8List.fromList([0]);

  static Uint8List encodeBigInt(BigInt number) {
    var orig = number;

    if (number.bitLength == 0) {
      if (number == _negOne) {
        return _negOneArray;
      } else {
        return _zeroList;
      }
    }
    // we may need one extra byte for padding
    var bytes = (number.bitLength / 8).ceil() + 1;
    var result = Uint8List(bytes);

    number = number.abs();
    for (var i = 0, j = bytes - 1; i < (bytes); i++, --j) {
      var x = number.remainder(_b256).toInt();
      result[j] = x;
      number = number >> 8;
    }

    if (orig.isNegative) {
      _twosComplement(result);
      if ((result[1] & 0x80) == 0x80) {
        // high order bit is a one - we don't need pad
        return result.sublist(1);
      }
    } else {
      if ((result[1] & 0x80) != 0x80) {
        // hi order bit is a 0, we dont need pad
        return result.sublist(1);
      }
    }
    return result;
  }

  ///
  /// calculate the twos complement by flipping each bit and adding 1
  ///
  static void _twosComplement(Uint8List result) {
    var carry = 1;
    for (var j = result.length - 1; j >= 0; --j) {
      // flip the bits
      result[j] ^= 0xFF;

      if (result[j] == 255 && carry == 1) {
        // overflow
        result[j] = 0;
        carry = 1;
      } else {
        result[j] += carry;
        carry = 0;
      }
    }
    result[0] = result[0] | 0x80;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ASN1Integer &&
          runtimeType == other.runtimeType &&
          _intValue == other._intValue;

  @override
  int get hashCode => _intValue.hashCode;
}
