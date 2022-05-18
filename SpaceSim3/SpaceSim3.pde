
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

int globalTime = 10;
float time = 0; //aktueller Zeitstand
float timeStep = 60; //Geschwindigkeit der Simulation (60 ist Normalgeschwindigkeit bei 60fps)
int timeSpeed = 1; //Anzahl der Berechnungen pro Frame

int noColTime = 20; //Anzahl der Frames bevor ein Körper erneut kollidieren kann

float camPosX = 0; //Position des aktuellen Bildausschnitts
float camPosY = 0;
float camZoom = 1;

int selectedBody = -1;

Boolean simActive = true; //Simmulation start/stop

int numObjects = 300; //aktuelle Anzahl der Objekte in der Simulation (eigentlich -1)
int numObjectsReal; //reelle Zahl der Objekte die angezeigt und berechnet wird (ohne die unsichtbaren Objekte)
int addedObjects = 0; //anzahl der Objekte die durch aktuelle Kollision dazukommen



CelBody[] body = new CelBody[20000]; //Array für alle Körper
//CelBody body2;
//CelBody body3;

void setup() {
  background(240);
  size(1280, 720);
  //smooth(4);

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
  newObjects();
  
  
  pushMatrix();
  
  moveCam();



  if (simActive) {

    for (int i=0; i<timeSpeed; i++) {
      gravity();


      for (int n=0; n<numObjects; n++) {
        body[n].calcLocation();
        body[n].select();
        body[n].selected();
      }
    }
  }

  for (int i=0; i<numObjects; i++) {
    body[i].display();
  }
  
  popMatrix();
  
  userInterface2();
}


//Zusatzinformationen (fps, Anzahl aktiver Objekte, Masse des ausgewählten Körpers etc.)
void Pinfo() {
  fill(#001219);
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



//Bewegung der Kamera
//rechnet alle Koordinaten in neues Kordinatensystem um (0/0 in der Mitte, verchieb-, zoombar)
void moveCam() {
  translate(width/2, height/2);
  scale(camZoom);
  translate(camPosX, camPosY);

  if (mousePressed && (mouseButton == CENTER)) {
    followActive = false;
    camPosX += (mouseX-pmouseX)*1/camZoom;
    camPosY += (mouseY-pmouseY)*1/camZoom;
  }
}


//Zoomen der Kamera
void mouseWheel(MouseEvent event) {
  if (event.getCount() < 0) {
    camZoom *= 1.2;
  } else {
    camZoom *= 0.8;
  }
}
