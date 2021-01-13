#include <SoftwareSerial.h>
#include "Pattern_v1.h"
// transmission 

#define BUFFER_SIZE 100//This will prevent buffer overruns.
int inData[BUFFER_SIZE];
const long baudRate = 9600;
int inChar = -1; // initialze first character as nothing
int first = 99; // start symbol
int last = 100; // stop symbol
//double block_size_reference[9] = {0.4, 0.8, 1.2, 1.6, 2.0, 2.4, 2.8, 3.2, 3.6};
double block_size_reference[30];
double action_reference[40];
double block_increment = 0.5;
double val = 0.5;
int j = 0;
//while (val < 10.0) {
//  block_size_reference[i] = val;
//  val += block_increment;
//  i++;
//}
//val = 0.0;
//i = 0;
//double action_reference[30];
//double action_increment = 0.1;
//while (val < 6.0) {
//  action_reference[i] = val;
//  val += action_increment;
//  i++;
//}
//double action_reference[80] = {0, 0.05, 0.1,  0.15, 0.2,  0.25, 0.3,  0.35, 0.4,  0.45, 0.5,  0.55, 0.6,  0.65,
// 0.7,  0.75, 0.8,  0.85, 0.9,  0.95, 1,   1.05, 1.1,  1.15, 1.2,  1.25, 1.3,  1.35,
// 1.4,  1.45, 1.5,  1.55, 1.6,  1.65, 1.7,  1.75, 1.8,  1.85, 1.9,  1.95, 2.0,   2.05,
// 2.1,  2.15, 2.2,  2.25, 2.3,  2.35, 2.4,  2.45, 2.5,  2.55, 2.6,  2.65, 2.7,  2.75,
// 2.8,  2.85, 2.9,  2.95, 3.0,   3.05, 3.1,  3.15, 3.2,  3.25, 3.3,  3.35, 3.4,  3.45,
// 3.5,  3.55, 3.6,  3.65, 3.7,  3.75, 3.8,  3.85, 3.9,  3.95};
//


String s;
// Pattern
double block_pattern[50];
double action_pattern[50];
 int queue_length = 1;
Pattern_T oPattern = Pattern_new();

// H-Bridge control
enum direction{FORWARD, REVERSE};
enum direction state = FORWARD;
int top1 = 10;
int top2 = 9;
int bottom1 = 6;
int bottom2 = 5;
int i = 0;
int set = 0; // used in determining if you should kep reading buffer data
unsigned long current_time = millis();
unsigned long prev_time = millis();
unsigned long call_time = millis();
int dummy = 1;
int *ran = &dummy;

int power = 12;




// testing
int run_number = 0;
void setup() {
  // put your setup code here, to run once:
  pinMode(top1, OUTPUT);
  pinMode(top2, OUTPUT);
  pinMode(bottom1, OUTPUT);
  pinMode(bottom2, OUTPUT);

  pinMode(power, OUTPUT);
  
  Serial.begin(9600);//Initialize communications to the serial monitor in the Arduino IDE





  while (val < 10.0) {
    block_size_reference[j] = val;
    val += block_increment;
    j++;
  }
  val = 0.7;
  j = 0;
  double action_increment = 0.1;
  while (val < 1.6) {
    action_reference[j] = val;
    val += action_increment;
    j++;
  }

}



void Update() {
  byte byte_count= Serial.available();//This gets the number of bytes that were sent by the python script
  Serial.println(byte_count);
 if(byte_count) {//If there are any bytes then deal with them 
   *ran = 1;
   delay(10);
   Serial.println("ABCD");
   Serial.print("Current time: ");
   Serial.println(current_time);
   queue_length = Serial.read();
   Serial.print("Queue length: ");
   Serial.println(queue_length);
  // struct
  Pattern_modify_queue_length(oPattern, queue_length);
   
   i = 0;
    while (1) {
      inData[i] = Serial.read();
      if (inData[i] == last)
        break;
      //Serial.println(inData[i]);
      i++;
    }
    Serial.print("i: ");
    Serial.println(i);
    for (i = 0; i <queue_length; i++) {
        block_pattern[i] = block_size_reference[inData[i]];
        // struct
        Pattern_block_insert(oPattern, i, block_size_reference[inData[i]]);
        //
        Serial.print("block pattern: ");
        Serial.println(Pattern_get_block(oPattern,i));
       // action_pattern[i] = action_reference[inData[i + queue_length]];
        // struct
        Pattern_action_insert(oPattern, i, action_reference[inData[i + queue_length]]);
        //
        Serial.print("action pattern: ");
        Serial.println(Pattern_get_action(oPattern,i));
        //Serial.println(inData[i]);
      }
      
  /*  for (i = queue_length; i< (2*queue_length); i++) {
       action_pattern[i - queue_length] = action_reference[inData[i]];
       Serial.print("action pattern: ");
       Serial.println(action_reference[inData[i]]);
      } */
   
 }
}










void act(int period, int block){
  // oscillate at specific frequency

    digitalWrite(power, HIGH);
   current_time = millis();
   call_time = current_time;
   prev_time = current_time;
  while ((current_time - call_time) < (block * 1000)) {
    current_time = millis();
    if (current_time - prev_time > (period * 500) && state == FORWARD) {
       digitalWrite(top2, LOW);
       digitalWrite(bottom1, LOW);
       digitalWrite(top1, HIGH);
       digitalWrite(bottom2, HIGH);
       state = REVERSE;
       prev_time = current_time;
    }
    else if(current_time - prev_time > (period * 500) && state == REVERSE) {
      digitalWrite(top1, LOW);
      digitalWrite(bottom2, LOW);
      digitalWrite(top2, HIGH);
      digitalWrite(bottom1, HIGH);
      state = FORWARD;
      prev_time = current_time;
    }
  }
}
void loop() {
  // put your main code here, to run repeatedly:
// read Serial data
// number_of_blocks = size(block_pattern);
Update();
//delay(4);
if (*ran) {
  Serial.print("Run number: ");
  Serial.println(run_number);
  for (i = 0; i < queue_length; i++) {
         Serial.print("Actual queue length: ");
        Serial.println(queue_length);
        Serial.print("Struct queue length: ");
        Serial.println(Pattern_get_queue_length(oPattern));





    
//    Serial.print("Iteration: ");
//    Serial.println(i);
//    Serial.print("Actual block: ");
//    Serial.println(block_pattern[i]);
//    Serial.print("Struct block: ");
//    Serial.println(Pattern_get_block(oPattern, i));
//    
    /* Serial.print("Actual action: ");
    Serial.println(action_pattern[i]);
    Serial.print("Struct action: ");
    Serial.println(Pattern_get_action(oPattern, i)); */
    // act(action_pattern[i], block_pattern[i]);
    // struct
    act(Pattern_get_action(oPattern, i), Pattern_get_block(oPattern, i));
    //
    }
   *ran = 0;
   run_number++;
}
digitalWrite(power, LOW);
}
