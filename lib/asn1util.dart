part of asn1lib;

class ASN1Util {
  // convert a list to a hex string. Used for debugging ASN1 output
  static String listToString(List<int> list) {
    var b = StringBuffer('[');
    var doComma = false;
    list.forEach((v) {
      doComma ? b.write(', ') : doComma = true;
      b.write('0x${v.toRadixString(16)}');
    });
    b.write(']');
    return b.toString();
  }

  /// print an objects hex value. Object is a list or an integer
  static String obj2HexString(dynamic x) {
    if (x is List) {
      return listToString(x);
    } else {
      return x.toRadixString(16);
    }
  }

  // convert a list of bytes to a BigInt
  // bytes[0] has the most significant bits. The
  // bytes format is NOT two's complement format
  static BigInt bytes2BigInt(List<int> bytes) {
    var x = BigInt.zero;
    for (var i = 0; i < bytes.length; ++i) {
      x = x << 8;
      x += BigInt.from(bytes[i]);
    }
    return x;
  }
}
