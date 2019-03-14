part of asn1lib;


class ASN1ObjectIdentifier  extends ASN1Object  {

  List<int> oi;
  
  ASN1ObjectIdentifier(this.oi,{tag:OBJECT_IDENTIFIER}):super(tag:tag);

  ASN1ObjectIdentifier.fromBytes(Uint8List bytes) : super.fromBytes(bytes);

  @override
  Uint8List _encode() {
      _valueByteLength  = oi.length;
      super._encodeHeader();
      _setValueBytes(oi);
      return _encodedBytes;
    }

  static ASN1ObjectIdentifier fromComponentString(String path) =>
      fromComponents(path.split(".").map((v) => int.parse(v)).toList());  

  static ASN1ObjectIdentifier fromComponents(List<int> components) {
      assert(components.length >= 2);
      assert(components[0] < 3);
      assert(components[1] < 64);

      List<int> oi = List<int>();
      oi.add((components[0] << 4) | components[1]);

      for (var ci = 2; ci < components.length; ci++) {
        int position = oi.length;
        int v = components[ci];
        assert(v > 0);
        
        bool first = true;
        do {
            int remainder = v & 127;
            v = v >> 7;

            if (first) {
                first = false;
            } else {
                remainder |= 0x80;
            }

            oi.insert(position, remainder);
        } while (v > 0);
      }

      return ASN1ObjectIdentifier(oi);
    }
}