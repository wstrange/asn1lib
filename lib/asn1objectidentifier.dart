part of asn1lib;

///
/// An ASN1 Object Identifier
///
class ASN1ObjectIdentifier extends ASN1Object {
  static final Map<String, String> DN = {
    'cn': '2.5.4.3',
    'sn': '2.5.4.4',
    'c': '2.5.4.6',
    'l': '2.5.4.7',
    'st': '2.5.4.8',
    's': '2.5.4.8',
    'o': '2.5.4.10',
    'ou': '2.5.4.11',
    'title': '2.5.4.12',
    'registeredAddress': '2.5.4.26',
    'member': '2.5.4.31',
    'owner': '2.5.4.32',
    'roleOccupant': '2.5.4.33',
    'seeAlso': '2.5.4.34',
    'givenName': '2.5.4.42',
    'initials': '2.5.4.43',
    'generationQualifier': '2.5.4.44',
    'dmdName': '2.5.4.54',
    'alias': '2.5.6.1',
    'country': '2.5.6.2',
    'locality': '2.5.6.3',
    'organization': '2.5.6.4',
    'organizationalUnit': '2.5.6.5',
    'person': '2.5.6.6',
    'organizationalPerson': '2.5.6.7',
    'organizationalRole': '2.5.6.8',
    'groupOfNames': '2.5.6.9',
    'residentialPerson': '2.5.6.10',
    'applicationProcess': '2.5.6.11',
    'applicationEntity': '2.5.6.12',
    'dSA': '2.5.6.13',
    'device': '2.5.6.14',
    'strongAuthenticationUser': '2.5.6.15',
    'certificationAuthority': '2.5.6.16',
    'groupOfUniqueNames': '2.5.6.17',
    'userSecurityInformation': '2.5.6.18',
    'certificationAuthority-V2': '2.5.6.16.2',
    'cRLDistributionPoint': '2.5.6.19',
    'dmd': '2.5.6.20',
    'md5WithRSAEncryption': '1.2.840.113549.1.1.4',
    'rsaEncryption': '1.2.840.113549.1.1.1',
    'sha256WithRSAEncryption': '1.2.840.113549.1.1.11',
    'subjectAltName': '2.5.29.17',
    'businessCategory': '2.5.4.15',
    'jurisdictionOfIncorporationC': '1.3.6.1.4.1.311.60.2.1.3',
    'jurisdictionOfIncorporationSP': '1.3.6.1.4.1.311.60.2.1.2',
    'jurisdictionOfIncorporationL': '1.3.6.1.4.1.311.60.2.1.1',
    'sha1WithRSAEncryption': '1.2.840.113549.1.1.5',
    'ecPublicKey': '1.2.840.10045.2.1',
    'prime256v1': '1.2.840.10045.3.1.7',
    'ecdsaWithSHA256': '1.2.840.10045.4.3.2'
  };

  List<int> oi;

  String identifier;

  ASN1ObjectIdentifier(this.oi, {this.identifier, tag = OBJECT_IDENTIFIER})
      : super(tag: tag);

  ///
  /// Instantiate a [ASN1ObjectIdentifier] from the given [bytes].
  ///
  ASN1ObjectIdentifier.fromBytes(Uint8List bytes) : super.fromBytes(bytes) {
    // ignore the first 2 bytes because they are the tag and the length
    var subBytes = bytes.sublist(2, bytes.length);
    var value = 0;
    var first = true;
    BigInt bigValue;
    var list = <int>[];
    var objId = StringBuffer();
    for (var i = 0; i != subBytes.length; i++) {
      var b = subBytes[i] & 0xff;

      if (value < 0x80000000000000) {
        value = value * 128 + (b & 0x7f);
        if ((b & 0x80) == 0) {
          if (first) {
            switch (value ~/ 40) {
              case 0:
                list.add(0);
                objId.write('0');
                break;
              case 1:
                list.add(1);
                objId.write('1');
                value -= 40;
                break;
              default:
                list.add(2);
                objId.write('2');
                value -= 80;
            }
            first = false;
          }
          list.add(value);
          objId.write('.');
          objId.write(value);
          value = 0;
        }
      } else {
        bigValue ??= BigInt.from(value);
        bigValue = bigValue << (7);
        bigValue = bigValue | BigInt.from(b & 0x7f);
        if ((b & 0x80) == 0) {
          objId.write('.');
          objId.write(bigValue);
          bigValue = null;
          value = 0;
        }
      }
    }
    var objIdAsString = objId.toString();

    for (var k in DN.keys) {
      if (DN[k] == objIdAsString) {
        oi = list;
        identifier = objId.toString();
      }
    }
  }

  @override
  Uint8List _encode() {
    _valueByteLength = oi.length;
    super._encodeHeader();
    _setValueBytes(oi);
    return _encodedBytes;
  }

  static ASN1ObjectIdentifier fromComponentString(String path,
          {tag = OBJECT_IDENTIFIER}) =>
      fromComponents(path.split('.').map((v) => int.parse(v)).toList(),
          tag: tag);

  static ASN1ObjectIdentifier fromComponents(List<int> components,
      {tag = OBJECT_IDENTIFIER}) {
    assert(components.length >= 2);
    assert(components[0] < 3);
    assert(components[1] < 64);

    var oi = <int>[];
    oi.add(components[0] * 40 + components[1]);

    for (var ci = 2; ci < components.length; ci++) {
      var position = oi.length;
      var v = components[ci];
      assert(v > 0);

      var first = true;
      do {
        var remainder = v & 127;
        v = v >> 7;
        if (first) {
          first = false;
        } else {
          remainder |= 0x80;
        }

        oi.insert(position, remainder);
      } while (v > 0);
    }

    return ASN1ObjectIdentifier(oi, tag: tag);
  }

  static final _names = <String, ASN1ObjectIdentifier>{};

  static ASN1ObjectIdentifier fromName(String name, {tag = OBJECT_IDENTIFIER}) {
    name = name.toLowerCase();

    for (var entry in _names.entries) {
      if (entry.key == name) {
        return ASN1ObjectIdentifier(entry.value.oi, tag: entry.value.tag);
      }
    }

    return null;
  }

  static void registerObjectIdentiferName(
      String name, ASN1ObjectIdentifier oid) {
    _names[name.toLowerCase()] = oid;
  }

  static void registerManyNames(Map<String, String> pairs) {
    pairs.forEach((key, value) {
      registerObjectIdentiferName(
          key, ASN1ObjectIdentifier.fromComponentString(value));
    });
  }

  static void registerFrequentNames() {
    registerManyNames(DN);
  }
}
