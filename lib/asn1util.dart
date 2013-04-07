
part of asn1lib;


String listToHexString(List<int> list) {

  StringBuffer b = new StringBuffer("[");
  bool doComma = false;
  list.forEach( (v) {
    if( v != null) {
      if( doComma ) {
        b.write(", ");
      } else {
        doComma = true;
      }
      //b.add("0x");
      b.write((v <= 0xf ? "0" : ""));
      b.write( v.toRadixString(16));
    }
  });
  b.write("]");
  return b.toString();
}

String hex(dynamic x) {
  if( x is List)
    return listToHexString(x);
  else
    return x.toRadixString(16);
}

class ASN1Util {

  static String listToString(List<int> list) {

    StringBuffer b = new StringBuffer("[");
    bool doComma = false;
    list.forEach( (v) {
      if( doComma ) {
        b.write(", ");
      } else {
        doComma = true;
      }
      b.write("0x")..
        write( v.toRadixString(16));

    });
    b.write("]");
    return b.toString();
  }

  String hex(dynamic x) {
    if( x is List)
      return listToString(x);
    else
      return x.toRadixString(16);
  }

}
