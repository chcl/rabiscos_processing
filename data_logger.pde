import processing.serial.*;

PrintWriter output;
Serial arduino;

int sensor1 = 0;

void setup() 
{
  size(200, 200);
  
  int D = day();    // Values from 1 - 31
  int M = month();  // Values from 1 - 12
  int Y = year();   // 2003, 2004, 2005, etc.
  
  int s = second();  // Values from 0 - 59
  int m = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23
  
  output = createWriter("planta-" + Y + z(M) + z(D) + '-' + z(h) + z(m) + z(s) + ".csv");
  arduino = new Serial(this, Serial.list()[0], 9600);
  arduino.bufferUntil('\n');
  
  frameRate(12);
}

String z (int n) {
  if(n < 10){
    return "0"+n;
  }
  return ""+n;
}

void serialEvent(Serial arduino) {

  String inString = arduino.readStringUntil('\n');
  println(inString);
  //////////////////////

  if (inString != null) {
      
      String[] values = split(inString, ' ');
      
      if (values.length >= 2) {
        
        sensor1 = int(trim(values[0]));
        
        int mi = (millis() % 1000)/10;
    
        int s = second();  // Values from 0 - 59
        int m = minute();  // Values from 0 - 59
        int h = hour();    // Values from 0 - 23
    
        String data = z(h) + ":" + z(m) + ":" + z(s);
        String timer = z(millis() / 360000) + ":" + z(millis() / 60000) + ":" + z(millis() / 1000) + ":" + z((millis() % 1000)/10) ;
    
        output.println(data + ";" + timer + ";" + millis() + ";" + sensor1);
        
    }
  }
}

void draw() 
{
  background(0);
  
  for( int i = 0; i < 6; i++) {
    fill(50 + i * 20);
    float x = i * (width / 6);
    float y = height - map(sensor1, 0, 1023, 0, height);
    rect(x, y, width/6, height);
  }
}

void keyPressed() {
  if(keyCode == 81){ // key: q
   output.flush(); // Write the remaining data
   output.close(); // Finish the file
   exit();
  }
}
