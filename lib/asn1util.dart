
part of asn1lib;


class ASN1Util {

  // convert a list to a hex string. Used for debugging ASN1 output
  static String listToString(List<int> list) {
    StringBuffer b = new StringBuffer("[");
    bool doComma = false;
    list.forEach( (v) {
      doComma ? b.write(", ") : doComma = true;
      b.write("0x${v.toRadixString(16)}");
    });
    b.write("]");
    return b.toString();
  }

  /// print an objects hex value. Object is a list or an integer
  static String obj2HexString(dynamic x) {
    if( x is List)
      return listToString(x);
    else
      return x.toRadixString(16);
  }

  static BigInt bytes2BigInt(Uint8List bytes, int start, int end) {
    if (end - start <= 4) {
      int result = 0;
      for (int i = end - 1; i >= start; i--) {
        result = result * 256 + bytes[i];
      }
      return new BigInt.from(result);
    }
    int mid = start + ((end - start) >> 1);
    var result = bytes2BigInt(bytes,start, mid) + bytes2BigInt(bytes, mid, end) * (BigInt.one << (mid - start));
    return result;
  }

  static BigInt readBigIntBytes(Uint8List bytes) {
    return bytes2BigInt(bytes, 0, bytes.length);
  }

  static Uint8List writeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = new BigInt.from(256);
    var result = new Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
  }

}
