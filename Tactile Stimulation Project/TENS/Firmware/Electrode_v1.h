#ifndef Electrode_INCLUDED
#define Electrode_INCLUDED

/* Enumerations */
enum phase_direction{POSITIVE, NEGATIVE};
enum status_type{ON, OFF};

/* Electrode_T is a pointer to an Electrode */
typedef struct Electrode *Electrode_T;

/*--------------------------------------*/
/* Create Electrode ADT */
Electrode_T Electrode_new(void);

/*--------------------------------------*/
/* modify whether specific electrode is active/inactive */
void Electrode_modify_status(Electrode_T oElectrode, int electrode_status);

/*--------------------------------------*/
/* Modify the amplitude applied to a specific electrode */
void Electrode_modify_amplitude(Electrode_T oElectrode, int amplitude);

/*--------------------------------------*/
/* Modify the period of stimulation for a specific electrode, takes frequency as argument */
void Electrode_modify_period(Electrode_T oElectrode, int period);

/*--------------------------------------*/
/* Modify the start time */
void Electrode_modify_start(Electrode_T oElectrode, unsigned long current_time);

/*--------------------------------------*/
/* Modify the direction of the stimulation */
void Electrode_modify_phase(Electrode_T oElectrode, int phase);

/*--------------------------------------*/
/* Invert the direction of the stimulation */
void Electrode_invert_phase(Electrode_T oElectrode);


/*--------------------------------------*/
/* Return the status of a specific electrode */
int Electrode_get_status(Electrode_T oElectrode);

/*--------------------------------------*/
/* Return the amplitude of a specific electrode */
int Electrode_get_amplitude(Electrode_T oElectrode);

/*--------------------------------------*/
/* Return the period of a specific electrode */
unsigned long Electrode_get_period(Electrode_T oElectrode);

/*--------------------------------------*/
/* Return the start time of a specfic phase of the electrode */
unsigned long Electrode_get_start(Electrode_T oElectrode);

/*--------------------------------------*/
/* Return the phase of a specific electrode */
int Electrode_get_phase(Electrode_T oElectrode);



#endif
