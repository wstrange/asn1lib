
part of asn1lib;


// todo: fix this. These need to be in a class or not....
const int BOOLEAN_TYPE = 0x01; 
const int INTEGER_TYPE = 0x02;
const int OCTET_STRING_TYPE = 0x04;
const int NULL_TYPE = 0x05;
const int ENUMERATED_TYPE = 0x0A;
const int SEQUENCE_TYPE = 0x30;
const int SET_TYPE = 0x31;

const int BOOLEAN_TRUE_VALUE = 0xff;
const int BOOLEAN_FALSE_VALUE = 0x00;

/**
 * ASN1 Constants.
 * First byte of the encoded object detemines the type
 */

class ASN1Constants {
  
  const int BOOLEAN_TYPE = 0x01; 
  const int INTEGER_TYPE = 0x02;
  const int OCTET_STRING_TYPE = 0x04;
  const int NULL_TYPE = 0x05;
  const int ENUMERATED_TYPE = 0x0A;
  const int SEQUENCE_TYPE = 0x30;
  const int SET_TYPE = 0x31;

}