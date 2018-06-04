part of asn1lib;
/**
 * ASN1Integer encoding / decoding.
 *
 * Note that asn1 integers can be arbitrary precision.
 * TODO: convert use of BigInteger to dart sdk BigInt class.
 */

class ASN1Integer extends ASN1Object {
  var intValue;

  ASN1Integer(this.intValue, {tag: INTEGER_TYPE}) : super(tag: tag);

  ASN1Integer.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    intValue = decodeInteger(this.valueBytes());
  }

  BigInteger get valueAsBigInteger {
    if (intValue is BigInteger) return intValue;
    if (isEncoded) return new BigInteger(valueBytes());
    return new BigInteger(intValue);
  }

  BigInteger get valueAsPositiveBigInteger {
    if (!isEncoded) _encode();
    return new BigInteger.fromBytes(1, valueBytes());
  }

  @override
  Uint8List _encode() {
    var t = encodeIntValue(this.intValue);
    _valueByteLength = t.length;
    super._encodeHeader();
    _setValueBytes(t);
    return _encodedBytes;
  }

  /**
   * Encode an integer to ASN.1 byte format.
   * ASN.1 integer is a two's complement format
   * with the *smallest" possible representation
   * in "Big" Endian format (MSB first on the wire.)
   *
   * This method uses some dart vm tricks to
   * encode integer values by playing around with the
   * machine representation using ByteArray methods.
   *
   * This is limited to encoding longs (64 bit values)
   * The basic technique is to stuff a 64 bit int
   * into a ByteArray, and retrieve the byte values
   * from that array.
   *
   * The dart VM is little endian - so we need to
   * flip the order around.
   */
  static Uint8List encodeIntValue(var intValue) {
    var result;
    if (intValue is BigInteger) {
      result = new Uint8List.fromList(intValue.toByteArray());
    } else {
      var bn = new BigInteger(intValue);
      result = new Uint8List.fromList(bn.toByteArray());
    }
    return result;
  }

  /**
   * Given an ASN1 encoded integer return the
   * integer value of the byte stream.
   * Uses the same tricks as [encodeIntValue]
   *
   * The optional offset argument is where the encoded integer starts in the
   * byte array. TODO: Do we need the offset feature??
   *
   * Note that the byte array length is expected to be exact (no extra padding
   * on the end of the array).
   */

  static dynamic decodeInteger(Uint8List bytes, {int offset: 0}) {
    if (bytes.length - offset > 8) {
      return new BigInteger(bytes.sublist(offset));
    } else {
      return new BigInteger(bytes.sublist(offset)).intValue();
    }
  }

  String toString() => "ASNInteger($intValue)";
}
