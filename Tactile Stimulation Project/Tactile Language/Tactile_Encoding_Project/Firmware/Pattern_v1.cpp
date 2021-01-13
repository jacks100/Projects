#include "Pattern_v1.h"
#include <stdlib.h>

/*----------------------------------------------------------*/
struct Pattern
{
  int queue_length = 0; // number of actions in the pattern
  double block_array[10]; // spcifies length of each action
  double action_array[10]; // describes each action
  
};

/*----------------------------------------------------------*/
Pattern_T Pattern_new() {
//  double block_array[100];
//  double action_array[100];
  //Pattern_T oPattern = (Pattern_T)malloc(sizeof(struct Pattern));
  Pattern_T oPattern = (Pattern_T)malloc(sizeof(struct Pattern) + 1);
  oPattern->queue_length = 0;
//  oPattern->block_array = block_array;
//  oPattern->action_array = action_array;
  return oPattern;
}

/*----------------------------------------------------------*/
void Pattern_block_insert(Pattern_T oPattern, int index, double block) {
 /* double *block_array = oPattern -> block_array;
  block_array[index] = block; */
  (oPattern->block_array)[index] = block;
}

/*--------------------------------------*/
/* Append an action to the action array */
void Pattern_action_insert(Pattern_T oPattern, int index, double action) {
//  double *action_array = oPattern -> action_array;
  (oPattern->action_array)[index] = action;
 // action_array[index] = action;
}


/*--------------------------------------*/
/* Return the block at the specified index in the block array */
double Pattern_get_block(Pattern_T oPattern, int index) {
  double *block_array = oPattern->block_array;
  return block_array[index];
}


/*--------------------------------------*/
/* Return the action at the specified index in the action array */
double Pattern_get_action(Pattern_T oPattern, int index) {
  double *action_array = oPattern->action_array;
  return action_array[index];
}

/*--------------------------------------*/
/* Modify the queue_length */
void Pattern_modify_queue_length(Pattern_T oPattern, int queue_length) {
  oPattern->queue_length = queue_length;
}

/*--------------------------------------*/
/* Get the queue_length */
int Pattern_get_queue_length(Pattern_T oPattern) {
  return oPattern->queue_length;
}
