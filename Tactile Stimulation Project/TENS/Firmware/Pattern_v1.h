#ifndef Pattern_INCLUDED
#define Pattern_INCLUDED
/* Pattern_T is a pointer to a Pattern object */
typedef struct Pattern* Pattern_T;

/*--------------------------------------*/
/* Create Pattern ADT */
Pattern_T Pattern_new(void);

/*--------------------------------------*/
/* Update Pattern */
int Pattern_update(Pattern_T oPattern);


/*--------------------------------------*/
/* Get an electrode from electrode_array */
Electrode_T Pattern_get_electrode(Pattern_T oPattern, int index);


#endif
