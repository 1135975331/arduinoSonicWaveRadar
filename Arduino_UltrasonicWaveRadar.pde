import processing.serial.*;

Serial port;

final int RADIUS = 200;
final int MAX_DIST = 100;
String vals;
int[] valArr;


/*초기설정, 실행하고 맨 처음 한번만 실행된다.*/
void setup() {
  size(500, 500);
  background(0, 0, 0, 100);
  fill(0, 0, 0, 0);
  strokeWeight(1);
  stroke(0, 255,0, 255);
  smooth();
  port = new Serial(this, Serial.list()[0], 9600);
}


/*해당 함수 내의 명령을 반복해서 실행한다.*/
void draw() {  
  if (port.available() > 0) {  // 포트가 있으면 0을 제외한 무작위의 값 반환,
    vals = trim(port.readStringUntil('\n'));  // 아두이노 시리얼 모니터의 출력값을 읽어들임
    //vals = 각도(육십분법), 거리

    if(vals != null) {  //NullPointerException 발생 방지
      valArr = int(split(vals, ","));  //vals를 쪼개서 배열로 만듦
    }
  }
  //printArray(valArr); //디버깅 전용
  
  if(valArr != null && valArr.length == 2) {
    //print(valArr[0], "  ", valArr[1], "\n");  //디버깅 전용
    drawRader();
    drawScanline(toRadian(valArr[0]));
    drawPosition(toRadian(valArr[0]), valArr[1]);
    drawText(valArr[0], valArr[1]);
  }
}


float toRadian(int angle) {  //육십분법 각도를 호도법(라디안) 각도로 변환
  return angle*(PI/180);
}

void drawRader() {
  stroke(0, 255, 0, 255);
  fill(0, 0, 0, 0);
  arc(width/2, height/1.5, RADIUS*2, RADIUS*2, PI, TWO_PI, PIE);  //반원 (중심각 1PI 부채꼴)
}

void drawScanline(float radianAngle) {  //막대기 그리기
  line(width/2, height/1.5, width/2 - cos(radianAngle)*RADIUS,  height/1.5 - sin(radianAngle)*RADIUS);
  //println(cos(toRadian(valArr[0])), sin(toRadian(valArr[0])));  //디버깅 전용
}

void drawPosition(float radianAngle, int distance) {
  float distance_f = float(distance);  //실수형으로 변환
  final float MAX_DIST_F = float(MAX_DIST);  //실수형으로 변환 (소수점이 필요하기 때문)

  
  fill(0, 20);  //페이드 아웃 효과
  rect(0, 0, width, height);  //페이드 아웃 효과
  
  fill(((MAX_DIST_F - distance_f)/MAX_DIST_F)*255, (distance_f/MAX_DIST_F)*255, 0, 255);
  noStroke();  //테두리 제거
  ellipse(width/2 - cos(radianAngle)*2*distance, height/1.5 - sin(radianAngle)*2*distance, 20, 20);
}

void drawText(int angle, int distance) {
  textSize(25);
  fill(255, 255, 255, 255);
  text("angle: " + angle, width/2-160, height/1.25);

  float distance_f = float(distance);  //실수형으로 변환
  final float MAX_DIST_F = float(MAX_DIST);  //실수형으로 변환 (소수점이 필요하기 때문)

  fill(((MAX_DIST_F - distance_f)/MAX_DIST_F)*255, (distance_f/MAX_DIST_F)*255, 0, 255); 
  text("distance: " + distance, width/2+20, height/1.25);
  //println(distance_f, MAX_DIST_F - distance_f, "\n", (distance_f/MAX_DIST_F)*255, ((MAX_DIST_F - distance_f)/MAX_DIST_F)*255);  //디버깅 전용
}
