#define L1 10
#define L2 11

#define FORCE_SENSOR_PIN_1 A0
#define FORCE_SENSOR_PIN_2 A5
#define INTERMISSION 1000
#define JUMP_INTEMISSION 2000

#define NO_TOUCH_THRESHOLD 30
#define DERIVATIVE_JUMP_MIN -40

#define LEFT 1
#define RIGHT 2

char val;  // Data received from the serial port
int currentMax1 = 0;
int currentMax2 = 0;

int patternCounter = 0;

bool isFirstValue = true; // prevent first touch from triggering jump
float previous1 = 0;
float previous2 = 0;


void setup() {
  pinMode(L1, OUTPUT);
  pinMode(L2, OUTPUT);
  Serial.begin(9600);
  establishContact();
}


/*
 * Is releasing left press if the next number is smaller than the previous SAVE_CYCLES
 */
bool isPress(int analogReading, int currentMax) {
  if (analogReading < currentMax / 3 && currentMax > NO_TOUCH_THRESHOLD) {
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
bool isJump(int analogReading1, int analogReading2) {
  if (analogReading1 - previous1 < DERIVATIVE_JUMP_MIN && !isFirstValue) {
    return true;
  }

  if (analogReading2 - previous2 < DERIVATIVE_JUMP_MIN && !isFirstValue) {
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

  if (isJump(analogReading1, analogReading2)) {
    Serial.println((String) "JUMP");
    digitalWrite(L1, HIGH);
    digitalWrite(L2, HIGH);
    currentMax1 = 0;
    currentMax2 = 0;    
    delay(JUMP_INTEMISSION);
  } else if (isPress(analogReading1, currentMax1)) {
    Serial.println((String) "LEFT " + currentMax1);
    digitalWrite(L1, HIGH);
    // resetCyclicalArray1();
    currentMax1 = 0;
    delay(INTERMISSION);
  } else if (isPress(analogReading2, currentMax2)) {
    Serial.println((String) "RIGHT " + currentMax2);
    digitalWrite(L2, HIGH);
    // resetCyclicalArray2();
    currentMax2 = 0;
    delay(INTERMISSION);
  }

  // cyclicalArray1[counter % SAVE_CYCLES] = analogReading1;
  // cyclicalArray2[counter % SAVE_CYCLES] = analogReading2;

  Serial.println((String) "1: " + analogReading1);
  // Serial.println((String) "2: " + analogReading2);
  // Serial.println(analogReading1);
  previous1 = analogReading1;
  previous2 = analogReading2;
  isFirstValue = false;    
  delay(10);
}

void establishContact() {
  while (Serial.available() < 0) {
    Serial.println("Waiting...");
    delay(300);
  }
}
