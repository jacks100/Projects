#include <SoftwareSerial.h>
#include "Electrode_v1.h"
#include "Pattern_v1.h"
#include "Tlc5940.h"

#define ELECTRODE_COUNT 2
#define INSTANCE_VARIABLE_COUNT 3


/* lp55231 driver */

static uint8_t current_electrode = 0;

/* Pattern ADT */
Pattern_T oPattern = Pattern_new();
/* Variables for time */
unsigned long current_time = millis();
unsigned long prev_time = millis();
unsigned long update_time_interval = 100;

/* H-bridge control */
int direction_array[4] = {4, 5, 6, 7}; // need to specfiy pins


/* Update status */
int update_status;

void setup() {
  // put your setup code here, to run once:
  // initialize LED driver
  Tlc.init(0);
  Tlc.update();
  delay(100);
  Serial.begin(9600);
 
  
  for (int i = 0; i < 2 * ELECTRODE_COUNT; i++) {
  pinMode(direction_array[i], OUTPUT);
  pinMode(direction_array[i], OUTPUT);
  }
  
  



}

void manage_electrodes(Pattern_T oPattern, unsigned long current_time) {
  for (int i = 0; i< 2*ELECTRODE_COUNT; i+=2) {
    Electrode_T oElectrode = Pattern_get_electrode(oPattern, i / 2);
    if ((current_time - Electrode_get_start(oElectrode)) > (Electrode_get_period(oElectrode) / 2) && Electrode_get_status(oElectrode)) { // condition to invert
     Serial.println("Invert");
     Serial.println(Electrode_get_phase(oElectrode));
     // Serial.println(i/4);
      Electrode_invert_phase(oElectrode);
      Electrode_modify_start(oElectrode, current_time);
      digitalWrite(direction_array[i], Electrode_get_phase(oElectrode));
      if (Electrode_get_phase(oElectrode) == 1) {
        digitalWrite(direction_array[i+1], LOW);
      }
      else {
        digitalWrite(direction_array[i + 1], HIGH);
      }
    //  digitalWrite(direction_array[i+1], ~Electrode_get_phase(oElectrode));
    }
  }
}



void loop() {
  // put your main code here, to run repeatedly:
  current_time = millis();
  if (current_time - prev_time > update_time_interval) {
    update_status = Pattern_update(oPattern);
    prev_time = current_time;
//    Serial.print("electrode 2: ");
//    Serial.println(Serial.println(Electrode_get_amplitude(Pattern_get_electrode(oPattern, 1))));
  }
  if (update_status) { // change control signals
    for (int current_electrode = 0; current_electrode < ELECTRODE_COUNT; current_electrode++) {
      Serial.print("electrode ");
      Serial.print(current_electrode);
      Serial.println(": ");
      Serial.print("status: ");
      Serial.println(Electrode_get_status(Pattern_get_electrode(oPattern, current_electrode)));
      Serial.print("amplitude: ");
      Serial.println(Electrode_get_amplitude(Pattern_get_electrode(oPattern, current_electrode)));
      Serial.print("period: ");
      Serial.println(Electrode_get_period(Pattern_get_electrode(oPattern, current_electrode)));
      
   //   Serial.flush();
      Tlc.set(current_electrode, Electrode_get_amplitude(Pattern_get_electrode(oPattern, current_electrode)));
      Tlc.update();
      delay(10);
    }
    update_status = 0;
  }
  manage_electrodes(oPattern, current_time);
    
  
}
