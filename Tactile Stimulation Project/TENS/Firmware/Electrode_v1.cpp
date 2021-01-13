#include "Electrode_v1.h"
#include <stdlib.h>
#include "Electrode_v1.h"

/*----------------------------------------------------------*/
/* Enumerations */
//enum phase_direction{POSITIVE, NEGATIVE};
//enum status_type{ON, OFF};

/*----------------------------------------------------------*/
/* Define structure */
struct Electrode
{
  int electrode_status; // whether electrode is on or off
  int amplitude; // intensity of electrode stimulation
  unsigned long period; // period of waveform
  unsigned long start_time; // time at which current phase of stimulation began
  int phase; // direction of stimulation
  
};

/*----------------------------------------------------------*/
Electrode_T Electrode_new() {
  Electrode_T oElectrode = (Electrode_T)malloc(sizeof(struct Electrode) + 1);
  oElectrode -> electrode_status = OFF; // default
  oElectrode -> amplitude = 0; // default
  oElectrode -> period = 0; // default
  oElectrode -> start_time = 0; // default
  oElectrode -> phase = 1; // default

  return oElectrode;
}

/*----------------------------------------------------------*/
void Electrode_modify_status(Electrode_T oElectrode, int electrode_status) {
  oElectrode -> electrode_status = electrode_status;
}

/*----------------------------------------------------------*/
void Electrode_modify_amplitude(Electrode_T oElectrode, int amplitude) {
  oElectrode -> amplitude = 50 * (100 - amplitude);
}

/*----------------------------------------------------------*/
void Electrode_modify_period(Electrode_T oElectrode, int period) {
  oElectrode -> period = (unsigned long)(50 * period);
}

/*----------------------------------------------------------*/
void Electrode_modify_start(Electrode_T oElectrode, unsigned long current_time) {
  oElectrode -> start_time = current_time;
}

/*----------------------------------------------------------*/
void Electrode_modify_phase(Electrode_T oElectrode, int phase) {
 oElectrode -> phase = phase;
}

/*----------------------------------------------------------*/
void Electrode_invert_phase(Electrode_T oElectrode) {
  if (oElectrode -> phase == 1)
    oElectrode -> phase = 0;
  else
    oElectrode -> phase = 1;
}

/*----------------------------------------------------------*/
int Electrode_get_status(Electrode_T oElectrode) {
  return oElectrode -> electrode_status;
}

/*----------------------------------------------------------*/
int Electrode_get_amplitude(Electrode_T oElectrode) {
  return oElectrode -> amplitude;
}

/*----------------------------------------------------------*/
unsigned long Electrode_get_period(Electrode_T oElectrode) {
  return oElectrode -> period;
}

/*----------------------------------------------------------*/
unsigned long Electrode_get_start(Electrode_T oElectrode) {
  return oElectrode -> start_time;
}

/*--------------------------------------*/
int Electrode_get_phase(Electrode_T oElectrode) {
  return oElectrode -> phase;
}
