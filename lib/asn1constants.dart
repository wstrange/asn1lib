part of asn1lib;

// tag bytes for various ASN1 BER objects

const int BOOLEAN_TYPE = 0x01;
const int INTEGER_TYPE = 0x02;
const int BIT_STRING_TYPE = 0x03;
const int OCTET_STRING_TYPE = 0x04;
const int NULL_TYPE = 0x05;
const int ENUMERATED_TYPE = 0x0A;
const int UTF8_STRING_TYPE = 0x0C;
const int PRINTABLE_STRING_TYPE = 0x13;
const int IA5_STRING_TYPE = 0x16;
const int UTC_TIME_TYPE = 0x17;
const int SEQUENCE_TYPE = 0x30;
const int SET_TYPE = 0x31;
const int OBJECT_IDENTIFIER = 0x06;
const int GENERALIZED_TIME = 0x18;
const int TELETEXT_STRING = 0x14;

const int BOOLEAN_TRUE_VALUE = 0xff;
const int BOOLEAN_FALSE_VALUE = 0x00;
