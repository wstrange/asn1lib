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

  static ASN1ObjectIdentifier fromComponentString(String path,{tag:OBJECT_IDENTIFIER}) =>
      fromComponents(path.split(".").map((v) => int.parse(v)).toList(), tag:tag);  

  static ASN1ObjectIdentifier fromComponents(List<int> components,{tag:OBJECT_IDENTIFIER}) {
      assert(components.length >= 2);
      assert(components[0] < 3);
      assert(components[1] < 64);

      List<int> oi = List<int>();
      oi.add(components[0] * 40 + components[1]);

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

      return ASN1ObjectIdentifier(oi, tag:tag);
    }

  static Map<String,ASN1ObjectIdentifier> _names = Map<String,ASN1ObjectIdentifier>();
    
  static ASN1ObjectIdentifier fromName(String name,{tag:OBJECT_IDENTIFIER}) {
      name = name.toLowerCase();
      
      for(MapEntry<String,ASN1ObjectIdentifier> entry in _names.entries) {
        if (entry.key == name) {
          return ASN1ObjectIdentifier(entry.value.oi, tag:entry.value.tag);
        }
      }

      return null;
    }

  static registerObjectIdentiferName(String name, ASN1ObjectIdentifier oid) {
      _names[name.toLowerCase()] = oid;
    }

  static registerManyNames(Map<String,String> pairs) {
      pairs.forEach((key, value) {
        registerObjectIdentiferName(key, ASN1ObjectIdentifier.fromComponentString(value));
      });
    }

  static registerFrequentNames() {
    registerManyNames({
      // https://tools.ietf.org/html/rfc2256
      "cn": "2.5.4.3",
      "sn": "2.5.4.4",
      "c": "2.5.4.6",
      "l": "2.5.4.7",
      "st": "2.5.4.8",
      "s": "2.5.4.8", // alias
      "o": "2.5.4.10",
      "ou": "2.5.4.11",
      "title": "2.5.4.12",
      "registeredAddress": "2.5.4.26",
      "member": "2.5.4.31",
      "owner": "2.5.4.32",
      "roleOccupant": "2.5.4.33",
      "seeAlso": "2.5.4.34",
      "givenName": "2.5.4.42",
      "initials": "2.5.4.43",
      "generationQualifier": "2.5.4.44",
      "dmdName": "2.5.4.54",
      "alias": "2.5.6.1",
      "country": "2.5.6.2",
      "locality": "2.5.6.3",
      "organization": "2.5.6.4",
      "organizationalUnit": "2.5.6.5",
      "person": "2.5.6.6",
      "organizationalPerson": "2.5.6.7",
      "organizationalRole": "2.5.6.8",
      "groupOfNames": "2.5.6.9",
      "residentialPerson": "2.5.6.10",
      "applicationProcess": "2.5.6.11",
      "applicationEntity": "2.5.6.12",
      "dSA": "2.5.6.13",
      "device": "2.5.6.14",
      "strongAuthenticationUser": "2.5.6.15",
      "certificationAuthority": "2.5.6.16",
      "groupOfUniqueNames": "2.5.6.17",
      "userSecurityInformation": "2.5.6.18",
      "certificationAuthority-V2": "2.5.6.16.2",
      "cRLDistributionPoint": "2.5.6.19",
      "dmd": "2.5.6.20",

      // X.509
      "md5WithRSAEncryption": "1.2.840.113549.1.1.4",
      "rsaEncryption": "1.2.840.113549.1.1.1",
    });
  }
}