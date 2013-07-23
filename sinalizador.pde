
void setup (){ 
 
  size (800,800);
}

void draw () {
  
  background (0);

  stroke(255,255,255);
  ellipse(400,400,mouseX,mouseX);
  noFill();
  strokeWeight(mouseY);
  ellipse(400,400, mouseY,mouseY);


arc(50, 55, 50, 50, 0, HALF_PI);
noFill();
arc(50, 55, 60, 60, HALF_PI, PI);
arc(50, 55, 70, 70, PI, PI+QUARTER_PI);
arc(50, 55, 80, 80, PI+QUARTER_PI, TWO_PI);

 
}
