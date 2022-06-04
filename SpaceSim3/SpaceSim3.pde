
//Test MultiThread

/*
This is on GITHUB now:
 https://github.com/AdrienTheThird/2D-Space-Simulation
 
 Programm zur 2D-Simulation von Objekten im Weltall (Anziehungskräfte und so)
 
 G = 6,6743*10^-2 statt *10^-11 (Milliardenfache Geschwindigkeit)
 
 Controlls:
 - middle-mouse-button to move around
 - mouse-wheel to zoom
 - leftklick to select object
 - rightklick-drag to spawn new objects
 - SPACE to pause
 - '0' to follow selected object
 - '/' to show/hide background grid
 - time: 'r' to slow down, 't' to reset, 'z' to speed up
 
 */

//changeable options
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int numThreads = 4; // only use 1, 2, 4 or 6 !!
Boolean alwaysShowHidden = true; //always show all objects in list
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


int globalTime = 10; //switch variable for time
float timeStep = 60; //Geschwindigkeit der Simulation (60 ist Normalgeschwindigkeit bei 60fps)
int timeSpeed = 1; //Anzahl der Berechnungen pro Frame

int noColTime = 80; //Anzahl der Frames bevor ein Körper erneut kollidieren kann

float camPosX = 0; //Position des aktuellen Bildausschnitts
float camPosY = 0;
float camZoom = 1;

int selectedBody = -1;

Boolean simActive = true; //Simmulation start/stop

int numObjects = 300; //aktuelle Anzahl der Objekte in der Simulation (eigentlich -1)
int numVisObjects = 0; //reelle Zahl der Objekte die angezeigt und berechnet wird (ohne die unsichtbaren Objekte)
int addedObjects = 0; //anzahl der Objekte die durch aktuelle Kollision dazukommen


CelBody[] body = new CelBody[20000]; //Array für alle Körper


void setup() {

  if (numThreads < 1 || numThreads > 6) {
    exit();
  }
  
  if (alwaysShowHidden) {
    showHidden = true;
  }
  

  size(1280, 720);

  for (int i=0; i<numObjects-1; i++) {
    int randomSize = int(abs(random(6, 20)));
    int randomMass = int( randomSize*random(1, 3));
    body[i] = new CelBody(100+i*10, 100+int(random(20, 2250)), random(-3, 3), random(-3, 3), randomSize, randomMass, i);
  }
  body[numObjects-1] = new CelBody(100+6*80, 400, 0, 0, 60, 50000, numObjects-1);
}


void draw() {
  background(240);
  textSize(14);

  userInterface1();
  newObjects(); //check if new object is added by right-clicking

  pushMatrix(); //creates new coordinate system for the objects

  moveCam();
  
  try { //catches NullPointerExceptions that occur because of overloaded multithreading
    if (simActive) {
      for (int i=0; i<timeSpeed; i++) { //simulation speed
        gravity(); //calc gravity
        for (int n=0; n<numObjects; n++) { //calc objects
          body[n].calcLocation();
          body[n].select();
          body[n].selected();
        }
      }
    }
    for (int i=0; i<numObjects; i++) { //show objects
      body[i].display();
    }
  } catch (NullPointerException e) {
    errors++;
  }
  
  popMatrix(); //goes back to the "normal" coordinate system for UI elements

  userInterface2();
  userInformation();
}



//Gibt bei Eingabe von Fenster Koordinaten die äquivalenten im Koordinatensystem zurück
int newX(float x) {
  x -= width/2;
  x /= camZoom;
  x -= camPosX;
  return(int(x));
}
int newY(float y) {
  y -= height/2;
  y /= camZoom;
  y -= camPosY;
  return(int(y));
}

//Genau das Gegenteil von newX/Y und moveCam (für Texte, Menüs etc.)
//Gibt bei Eingabe von Koordinatensystem-Koordinaten die "echten" Koordinaten im Fenster zurück (0/0 oben links)
int realX(float x) {
  x += camPosX;
  x *= camZoom;
  x += width/2;
  return(int(x));
}
int realY(float y) {
  y += camPosY;
  y *= camZoom;
  y += height/2;
  return(int(y));
}

//rounds a float to x decimals
float roundX(float input, int x) {
  input *= pow(10, x);
  float output = int(input);
  output /= pow(10, x);
  return(output);
}

//Bewegung der Kamera
//rechnet alle Koordinaten in neues Kordinatensystem um (0/0 in der Mitte, verchieb-, zoombar)
void moveCam() {
  translate(width/2, height/2);
  scale(camZoom);
  translate(camPosX, camPosY);

  if (cursorOver == 1) { //only if mouse over simulation
    if (mousePressed && (mouseButton == CENTER)) {
      followActive = false;
      camPosX += (mouseX-pmouseX)*1/camZoom;
      camPosY += (mouseY-pmouseY)*1/camZoom;
    }
  }
}
