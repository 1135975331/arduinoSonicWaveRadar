#include <Servo.h>  //서보 라이브러리를 불러온다
#define TRIG 4    //트리거는 4번  (원래 2번이었으나, 실수로 아두이노 부품에 문제를 일으켜 변경)
#define ECHO 3    //에코는 3번
Servo servo;
 
int servoDirection = 1, rad = 0; // rad는 각도를 의미합니다.
 
void setup() {
  Serial.begin(9600);
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  servo.attach(9); //서보모터 핀은 9번
}
 
void loop() {
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);  //2uS 동안 멈춤
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);  //10uS 동안 동작
  digitalWrite(TRIG, LOW);
 
  //5800이면 1m 입니다. 최대 기다리는 시간은 1,000,000 입니다.
  // 5800을 58로 나누게 되면 cm 단위가 됩니다.
  long distance = pulseIn(ECHO, HIGH, 5800) / 58; //5800uS 동안 기다렸으므로 1미터 측정이 된다.
  //Serial.print("r");
  Serial.print(String(rad));  //Processing에 값을 넘기기 위함
  Serial.print(",");
  //Serial.print("d");
  Serial.println(String(distance));  //Processing에 값을 넘기기 위함
  
 
  rad += servoDirection;
  if (rad > 180) {
    rad = 179;
    servoDirection = -1;
  }
  else if (rad < 0) {
    rad = 1;
    servoDirection = 1;
  }
  servo.write(rad);
  delay(100); //서보모터가 움직이는 걸리는 시간을 줍니다.
}
