int val = A1;
int i = 0;
int index = 0;
const int BUFF_SIZE = 500; // number of values in buffer
int buff[BUFF_SIZE]; // declare array
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

}

void loop() {
  // put your main code here, to run repeatedly:
  if (index == 100) {
    for (i = 0; i < 100; i++) {
      Serial.println(buff[i]);
    }
    index = 0; // reset index
  }
  //Serial.println(analogRead(val));
  buff[index] = analogRead(val); // populate buffer
  index++;
  

}
