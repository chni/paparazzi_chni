#include "boards/tiny_2.1.h"

#undef DefaultVoltageOfAdc
#define DefaultVoltageOfAdc(adc) (0.0257204301*adc)
