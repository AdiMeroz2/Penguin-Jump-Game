#define L1 10                                                                                                                                                                                                           
#define L2 11

#define FORCE_SENSOR_PIN_1 A0
#define FORCE_SENSOR_PIN_2 A5
#define INTERMISSION 1000
#define JUMP_INTEMISSION 500

#define NO_TOUCH_THRESHOLD 30
#define DERIVATIVE_JUMP_MIN -20


#define LEFT 1
#define RIGHT 2
int LEDbrightness;

char val;  // Data received from the serial port
int currentMax1 = 0;
int currentMax2 = 0;
int jumpMax1 = 0;
int jumpMax2 = 0;

int patternCounter = 0;

// bool isFirstValue = true; // prevent first touch from triggering jump
bool isFirstValue1 = true;
bool isFirstValue2 = true;
bool jumping = false;
bool jumped1 = false;
bool jumped2 = false;
bool onground1 = true;
bool onground2 = true;
float previous1 = 0;
float previous2 = 0;


void setup() {
  pinMode(L1, OUTPUT);
  pinMode(L2, OUTPUT);
  Serial.begin(9600);
  establishContact();
}

bool isOnGround(int analogReading){
  return analogReading > NO_TOUCH_THRESHOLD;
}
/*
 * Is releasing left press if the next number is smaller than the previous SAVE_CYCLES
 */
bool isStep(int analogReading, int currentMax, int previous) {
  if (analogReading < currentMax / 3 && currentMax > NO_TOUCH_THRESHOLD && analogReading - previous >= DERIVATIVE_JUMP_MIN) {
    return true;
  }

  if (analogReading < NO_TOUCH_THRESHOLD) {
    return false;
  }

  return false;
}

/*
 * 
 */
// bool isJump(int analogReading1, int analogReading2) {
//   if (analogReading1 - previous1 < DERIVATIVE_JUMP_MIN && !isFirstValue) {
//     return true;
//   }

//   if (analogReading2 - previous2 < DERIVATIVE_JUMP_MIN && !isFirstValue) {
//     return true;
//   }

//   return false;
// }

// /*
//  * 
//  */
// bool isJump(int analogReading, int previous, bool isFirstValue) {
//   if (analogReading - previous < DERIVATIVE_JUMP_MIN && !isFirstValue) {
//     Serial.println((String)analogReading);
//     return true;
//   }
//   return false;
// }

bool isJump1(int analogReading) {
  if (analogReading - previous1 < DERIVATIVE_JUMP_MIN && !isFirstValue1) {
    //Serial.println((String)"JUMPED" + "Left" + analogReading);
    //jumped1 = true;
    onground1 = false;
    return true;
  }
  return false;
}

bool isJump2(int analogReading) {
  if (analogReading - previous2 < DERIVATIVE_JUMP_MIN && !isFirstValue2) {
    //Serial.println((String)"JUMPED" + " RIGHT" + analogReading);
    //jumped2 = true;
    onground2 = false;
    return true;
  }
  return false;
}
void loop() {
  digitalWrite(L1, LOW);
  digitalWrite(L2, LOW);

  int analogReading1 = analogRead(FORCE_SENSOR_PIN_1);
  int analogReading2 = analogRead(FORCE_SENSOR_PIN_2);

  if (analogReading1 > currentMax1) {
    currentMax1 = analogReading1;
  }

  if (analogReading2 > currentMax2) {
    currentMax2 = analogReading2;
  }
  jumped1 = isJump1(analogReading2);
  jumped2 = isJump2(analogReading1);
  if (jumped1 && jumped2) {
  // if (isJump(analogReading1, previous1, isFirstValue1) && isJump(analogReading2, previous2, isFirstValue2)) {
    // todo until not reaching ground is jumping
    //Serial.println((String) "Entered jump");
    digitalWrite(L1, HIGH);
    digitalWrite(L2, HIGH);
    currentMax1 = 0;
    currentMax2 = 0;    
    if(jumping == false){
      if (analogReading1 - analogReading2 <= 50 && analogReading2 - analogReading1 <= 50){
        Serial.println((String) "JUMPING");
      }
    }
    jumping = true;
    delay(JUMP_INTEMISSION);
  } 
  else if (isStep(analogReading1, currentMax1, previous1) && onground1) { //don't walk when one leg jumped first
    LEDbrightness = map(analogReading1, 0, 2046, 0, 255);
    Serial.println((String) "LEFT " + currentMax1);
    digitalWrite(L1, HIGH);
    // analogWrite(L1,LEDbrightness);
    // resetCyclicalArray1();
    currentMax1 = 0;
    delay(INTERMISSION);
  } else if (isStep(analogReading2, currentMax2, previous2) && onground2) {
    Serial.println((String) "RIGHT " + currentMax2);
    digitalWrite(L2, HIGH);
    // resetCyclicalArray2();
    currentMax2 = 0;
    delay(INTERMISSION);
  } else{
    jumping = false;
  }
  // Serial.println((String) onground1);
  onground1 = isOnGround(analogReading1);
  onground2 = isOnGround(analogReading2);
  // cyclicalArray1[counter % SAVE_CYCLES] = analogReading1;
  // cyclicalArray2[counter % SAVE_CYCLES] = analogReading2;

  // Serial.println((String) "1: " + analogReading1);
  // Serial.println((String) "2: " + analogReading2);
  // Serial.println(analogReading1);
  previous1 = analogReading1;
  previous2 = analogReading2;
  isFirstValue1 = false;
  isFirstValue2 = false;
  jumped1 = false;
  jumped2 = false;    
  delay(10);
}

// void loop() {
//   digitalWrite(L1, LOW);
//   digitalWrite(L2, LOW);

//   int analogReading1 = analogRead(FORCE_SENSOR_PIN_1);
//   int analogReading2 = analogRead(FORCE_SENSOR_PIN_2);

//   if (analogReading1 > currentMax1) {
//     currentMax1 = analogReading1;
//   }

//   if (analogReading2 > currentMax2) {
//     currentMax2 = analogReading2;
//   }

//   if (isJump(analogReading1, analogReading2)) {
//     Serial.println((String) "JUMP");
//     digitalWrite(L1, HIGH);
//     digitalWrite(L2, HIGH);
//     currentMax1 = 0;
//     currentMax2 = 0;    
//     delay(JUMP_INTEMISSION);
//   } else if (isStep(analogReading1, currentMax1)) {
//     LEDbrightness = map(analogReading1, 0, 2046, 0, 255);
//     Serial.println((String) "LEFT " + currentMax1);
//     //digitalWrite(L1, HIGH);
//     analogWrite(L1,LEDbrightness);
//     // resetCyclicalArray1();
//     currentMax1 = 0;
//     delay(INTERMISSION);
//   } else if (isStep(analogReading2, currentMax2)) {
//     Serial.println((String) "RIGHT " + currentMax2);
//     digitalWrite(L2, HIGH);
//     // resetCyclicalArray2();
//     currentMax2 = 0;
//     delay(INTERMISSION);
//   }

//   // cyclicalArray1[counter % SAVE_CYCLES] = analogReading1;
//   // cyclicalArray2[counter % SAVE_CYCLES] = analogReading2;

//   // Serial.println((String) "1: " + analogReading1);
//   // Serial.println((String) "2: " + analogReading2);
//   // Serial.println(analogReading1);
//   previous1 = analogReading1;
//   previous2 = analogReading2;
//   isFirstValue = false;    
//   delay(10);
// }

void establishContact() {
  while (Serial.available() < 0) {
    Serial.println("Waiting...");
    delay(300);
  }
}
