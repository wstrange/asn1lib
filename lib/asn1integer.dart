
part of asn1lib;

class ASN1Integer extends ASN1Object {

  var intValue;

  ASN1Integer(this.intValue):super(tag:INTEGER_TYPE);

  ASN1Integer.fromBytes(Uint8List bytes) {
    _encodedBytes = bytes;
    _initFromBytes();
    intValue = decodeInteger(this.valueBytes());
  }

  BigInteger get valueAsBigInteger {
    if(intValue is BigInteger) return intValue;
    if(isEncoded) return new BigInteger(valueBytes());
    return new BigInteger(intValue);
  }

  BigInteger get valueAsPositiveBigInteger {
    if(!isEncoded) _encode();
    return new BigInteger.fromBytes(1, valueBytes());
  }

  @override
  Uint8List _encode() {
    var t = encodeIntValue(this.intValue);
    valueByteLength  = t.length;
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
    if (intValue is BigInteger ){
      result = new Uint8List.fromList(intValue.toByteArray());
    } else {
      var t = new Int64List(1);
         t[0] = intValue;
         // x is a byte view into the long representation
         //var x = new Uint8List.view(t.asByteArray(0,1));
         var x = new Uint8List.view(t.buffer);

         // now we have an array of 8 bytes in little endian order
         // we need to return the smallest representation
         int i = 7; // start at the last byte and work back

         var padValue = 0;
         if( intValue.isNegative ) {
           padValue = 0xFF;
         }

         // discard bytes we don't need for representation
         // This will be 0 for positives, 0xFF for negatives
         while( x[i] == padValue && i > 0) --i;

         // Now we need to test the high bit of the remaining digits
         // we may need to add an extra byte back in for legal 2-comp representation

         if( intValue.isNegative ) {
           if( (x[i] & 0x80) == 0 ) {
             ++i;
           }
         }
         else {
           if( (x[i] & 0x80) != 0 ) {
             ++i;
           }
         }

         result = new Uint8List(i+1);
         for( int j =0; j < (i+1); ++j) {
           result[j] = x[i-j];
         }
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
    
    if (bytes.length - offset > 8) return new BigInteger(bytes.sublist(offset));
    var pad = (bytes[offset] & 0x80) == 0 ? 0 : 0xFF;
    var t = new Int64List(1);
    // create an 8 byte "view" into the above 64 bit integer

    var x = new Uint8List.view(t.buffer);


    int j = 0;
    int i = bytes.length -1;
    // reverse copy the bytes into the view
    while( i >= offset) {
      x[j++] = bytes[i--];
    }
    // any remaining bytes in the view get set to the pad value
    while( j <= 7) {
      x[j++] = pad;
    }

    // the 64 bit integer is now in t[0]
    return t[0];
  }
}

