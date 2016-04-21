import processing.serial.*;
Serial myPort;

int numValues = 3; // nummeros des inputs de valores dos sensors
// *alterar isso se somar ou subtrair novos sensores *

float[] values = new float[numValues];
int[] min = new int[numValues];
int[] max = new int[numValues];
color[] valColor = new color[numValues];

float partH; // altura parcial da tela

int xPos = 0; // posição horizontal do gráfico
boolean clearScreen = true; // sinaliza na tela para o gráfico


void setup() {
  size(800, 600);
  partH = height / numValues;

  // portas livres:
  printArray(Serial.list());
  // port [0] 
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  // não cria nada até receber novo caracter
  myPort.bufferUntil('\n');

  textSize(10);

  background(255);
  noStroke();

  // inicializa:
  // *editar isso* setar quantos valores se quer e quais cores 
  values[0] = 0;
  min[0] = 0;
  max[0] = 1023; // exemplo de range, analogRead
  valColor[0] = color(255, 0, 0); // vermelho

  values[1] = 0; 
  min[1] = 0;
  max[1] = 700;  // range parcial, e.g. IR distancia sensor
  valColor[1] = color(0, 255, 0); // verde

  values[2] = 0;
  min[2] = 0;
  max[2] = 700;    // 
  valColor[2] = color(0, 0, 255); // azul
  /*
 // exemplo de quarto valor:
   values[3] = 0;
   min[3] = 0;
   max[3] = 400; // range customizado
   valColor[3] = color(255, 0, 255); // roxo
   */
}


void draw() {
  // in the Arduino website example, everything is done in serialEvent
  //aqui, os dados rolam no serialEvent, e o desenho rola em draw()
  // 

  if (clearScreen) {
    // autor: two options for erasing screen, i like the translucent option to see "history"
    // erase screen with black:
    //background(0); 

    // usei um efeito trânslucido de background:
    fill(255,200);
    noStroke();
    rect(0,0,width,height);

    clearScreen = false; // reset 
  } 

  for (int i=0; i<numValues; i++) {

    // mapeia um range de altura parcial:
    float mappedVal = map(values[i], min[i], max[i], 0, partH);

    // desenha as linhas:
    stroke(valColor[i]);
    line(xPos, partH*(i+1), xPos, partH*(i+1) - mappedVal);

    // desenha a próxima linha:
  //  stroke(0);
    //line(0, partH*(i+1), width, partH*(i+1));

    // apresenta valores na tela:
   // fill(0);
   // noStroke();
   // rect(0, partH*i+1, 70, 12);
    fill(80);
    textSize(20);
    text("Temperatura da sala", 220, 35); 
    fill(0, 0, 0);
    textSize(20);
    text("Luz", 220, 230); 
    fill(0, 0, 0);
    textSize(20);
    text("Sua distância", 220, 435); 
    fill(0, 0, 0);
    //print(i + ": " + values[i] + "\t"); // <- uncomment this to debug values in array
    //println("\t"+mappedVal); // <- uncomment this to debug mapped values
  }
  //println(); // <- uncomment this to read debugged values easier
}


void serialEvent(Serial myPort) { 
  try {
    // ASCII string:
    String inString = myPort.readStringUntil('\n');
    //println("raw: \t" + inString); // <- uncomment this to debug serial input from Arduino

    if (inString != null) {
      
      inString = trim(inString);

      
      values = float(splitTokens(inString, ", \t")); // delimiter can be comma space or tab

      
      
      if (values.length >= numValues) {
        
        if (xPos >= width) {
          xPos = 0;
          clearScreen = true;
        } else {
          xPos++; 
        }
      }
    }
  }
  catch(RuntimeException e) {
    
    e.printStackTrace();
  }
}
