#include <Arduino.h>
#include "Electrode_v1.h"
#include "Pattern_v1.h"
#include <stdlib.h>
#include <SoftwareSerial.h>
#include "Pattern_v1.h"
#define ELECTRODE_COUNT 2
#define INSTANCE_VARIABLE_COUNT 3
/*----------------------------------------------------------*/
/* Define structure */
struct Pattern
{
  Electrode_T electrode_array[ELECTRODE_COUNT]; // Array of electrode objects
  
};

/*----------------------------------------------------------*/
Pattern_T Pattern_new() {
  Pattern_T oPattern = (Pattern_T)malloc(sizeof(struct Pattern) + 1);
  
  return oPattern;
}


/*----------------------------------------------------------*/
int Pattern_update(Pattern_T oPattern) {
  int test = 0;
  int i = 0;
  byte byte_count= Serial.available();//This gets the number of bytes that were sent by the python script
 if(byte_count) {//If there are any bytes then deal with them 
   delay(10);
  // struct
  Serial.println("Updating");
  //Electrode_T* electrode_array = oPattern -> electrode_array;
   for (i = 0; i < ELECTRODE_COUNT; i++) {
        test = Serial.read();
        Serial.print("status: ");
        Serial.println(test);
        Electrode_modify_status((oPattern->electrode_array)[i], test); // previously inData[i[
       // i++;
        test = Serial.read();
        Serial.print("amplitude: ");
        Serial.println(test);
        Electrode_modify_amplitude((oPattern->electrode_array)[i], test);
        Serial.print("stored amplitude: ");
        Serial.println(Electrode_get_amplitude((oPattern->electrode_array)[i]));
       // i++;
        test = Serial.read();
        Serial.print("period: ");
        Serial.println(test);
        Electrode_modify_period((oPattern->electrode_array)[i], test);
      //  i++;
      }
   while (i < byte_count) { // get rid of extra bytes
    Serial.read(); 
    i++;  
   }
   return 1;   
 }
 return 0;
}

/*----------------------------------------------------------*/
Electrode_T Pattern_get_electrode(Pattern_T oPattern, int index) {
  Electrode_T* electrode_array = oPattern -> electrode_array;
  //return (oPattern -> electrode_array)[index];
  return electrode_array[index];
}




