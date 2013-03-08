
part of asn1lib;


String listToHexString(List<int> list) {

  StringBuffer b = new StringBuffer("[");
  bool doComma = false;
  list.forEach( (v) {
    if( v != null) {
      if( doComma ) {
        b.add(", ");
      } else {
        doComma = true;
      }
      //b.add("0x");
      b.add((v <= 0xf ? "0" : ""));
      b.add( v.toRadixString(16));
    }
  });
  b.add("]");
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
        b.add(", ");
      } else {
        doComma = true;
      }
      b.add("0x")..
        add( v.toRadixString(16));

    });
    b.add("]");
    return b.toString();
  }

  String hex(dynamic x) {
    if( x is List)
      return listToString(x);
    else
      return x.toRadixString(16);
  }

}
