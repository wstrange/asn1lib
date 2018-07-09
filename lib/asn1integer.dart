part of asn1lib;
/**
 * ASN1Integer encoding / decoding.
 *
 * Note that asn1 integers can be arbitrary precision, so a BigInt is used
 * to hold the int value. Convenience methods are provided to deal with
 * int or BigInt
 */

class ASN1Integer extends ASN1Object {
  BigInt _intValue;

  ASN1Integer(this._intValue, {tag: INTEGER_TYPE}) : super(tag: tag);

  ASN1Integer.fromInt(int x)  {
    _intValue = BigInt.from(x);
  }

  ASN1Integer.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    _intValue = decodeBigInt(this.valueBytes());
  }

  int get intValue => _intValue.toInt();

  BigInt get valueAsBigInteger => _intValue;

  @override
  Uint8List _encode() {
    var t = encodeBigInt(this._intValue);
    _valueByteLength = t.length;
    super._encodeHeader();
    _setValueBytes(t);
    return _encodedBytes;
  }

  static Uint8List encodeInt(int x) => encodeBigInt(new BigInt.from(x));

  static int decodeInt(Uint8List bytes) => decodeBigInt(bytes).toInt();

  String toString() => "ASNInteger($intValue)";

  static final _b256 = new BigInt.from(256);
  static final _minusOne = new BigInt.from(-1);
  static final _zeroList = new Uint8List.fromList([0]);

  /**
   * Given an ASN1 encoded integer return the
   * integer value of the byte stream.
   *
   */

  static BigInt decodeBigInt(Uint8List bytes) {
    var isNegative = (bytes[0] & 0x80) != 0;
    var result = BigInt.zero;
    for (int i = 0; i < bytes.length; ++i) {
      result = result << 8;
      var x = isNegative ? (bytes[i] ^ 0xff) : bytes[i];
      result += new BigInt.from(x);
    }
    if (isNegative) return (result + BigInt.one) * _minusOne;

    return result;
  }

  /**
   * Encode an integer to ASN.1 byte format.
   * ASN.1 integer is a two's complement format
   * with the *smallest" possible representation
   * in "Big" Endian format (MSB first on the wire.)
   *
   */

  static Uint8List encodeBigInt(BigInt number) {
    if (number.bitLength == 0) return _zeroList;

    int bytes = ((number.bitLength + 7) >> 3) + 1;
    var result = new Uint8List(bytes);
    var neg = false;
    if (number.isNegative) {
      neg = true;
      result[0] = 0xff;
    }

    for (int i = 1, j = bytes - 1; i < bytes; i++, --j) {
      result[j] = number.remainder(_b256).toInt();
      number = number >> 8;
    }
    if (!neg) {
      if (result[1] & 0x80 == 0) return result.sublist(1);
    } else {
      if (result[1] & 0x80 != 0) return result.sublist(1);
    }

    return result;
  }
}
