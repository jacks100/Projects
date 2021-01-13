#ifndef Pattern_INCLUDED
#define Pattern_INCLUDED
/* Pattern_T is a pointer to a Pattern */
typedef struct Pattern *Pattern_T;

/*--------------------------------------*/
/* Create pattern ADT */
Pattern_T Pattern_new(void);
/*--------------------------------------*/
/* append a block to the block array */
void Pattern_block_insert(Pattern_T oPattern, int index, double block);

/*--------------------------------------*/
/* Append an action to the action array */
void Pattern_action_insert(Pattern_T oPattern, int index, double action);


/*--------------------------------------*/
/* Return the block at the specified index in the block array */
double Pattern_get_block(Pattern_T oPattern, int index);


/*--------------------------------------*/
/* Return the action at the specified index in the action array */
double Pattern_get_action(Pattern_T oPattern, int index);

/*--------------------------------------*/
/* Modify the queue_length */
void Pattern_modify_queue_length(Pattern_T oPattern, int queue_length);

/*--------------------------------------*/
/* Get the queue_length */
int Pattern_get_queue_length(Pattern_T oPattern);

#endif
