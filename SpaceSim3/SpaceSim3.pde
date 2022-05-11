
/*
Programm zur 2D-Simulation von Objekten im Weltall (Anziehungskräfte und so)
 
 Massen in TeraGramm -> G = 6,6743*10^-2 statt *10^-11 (G prop. zu 1/m)
 
 Malte Putzar, 27.03.2022
 */


float time = 0; //aktueller Zeitstand
float timeStep = 60; //Geschwindigkeit der Simulation (60 ist Normalgeschwindigkeit bei 60fps)
int timeSpeed = 1; //Anzahl der Berechnungen pro Frame

int noColTime = 40; //Anzahl der Frames bevor ein Körper erneut kollidieren kann

int camPosX = 0; //Position des aktuellen Bildausschnitts
int camPosY = 0;
float camZoom = 1;

int selectedBody = -1;

Boolean simActive = true; //Simmulation start/stop

int numObjects = 100; //aktuelle Anzahl der Objekte in der Simulation (eigentlich -1)
int numObjectsReal; //reelle Zahl der Objekte die angezeigt und berechnet wird (ohne die unsichtbaren Objekte)
int addedObjects = 0; //anzahl der Objekte die durch aktuelle Kollision dazukommen

Boolean rightPress = false; //True wenn rechte Maustaste gedrückt
int rightPressDuration = 5; //Länge der Dauer des Klicks

CelBody[] body = new CelBody[10000]; //Array für alle Körper
//CelBody body2;
//CelBody body3;

void setup() {
  background(240);
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

  info();

  moveCam();


  if (simActive) {

    calcGravityE();


    for (int i=0; i<numObjects; i++) {
      body[i].calcLocation();
      body[i].select();
      body[i].selected();
    }
  } 

  for (int i=0; i<numObjects; i++) {
    body[i].display();
  }
}



//Zusatzinformationen (fps, Anzahl aktiver Objekte, Masse des ausgewählten Körpers etc.)
void info() {
  fill(#001219);
  text(frameRate, 20, 20);
  text("Körper: "+numObjectsReal, 1190, 20);

  //println(selectedBody);
  
  if (!simActive) {
    fill(#FA0303);
    textSize(30);
    text("Simulation Gestoppt", 520, 600);
    textSize(14);
  }

  if (selectedBody > -1) {
    text("Geschwindigkeit: "+body[selectedBody].velocity, 280, 700);
    text("Masse: "+body[selectedBody].mass, 20, 700);
    text("Radius: "+body[selectedBody].radius, 150, 700);
  }

  if (rightPress) { //Dauer des Rechtsklicks zählen
    simActive = false;
    rightPressDuration++;
  }
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

//wenn Linksklick, neuer Körper
void mousePressed() {
  if (mouseButton == RIGHT && simActive) {
    rightPress = true; //Dauer des Rechtsklicks anfangen zu zählen
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    rightPress = false; // Dauer des Rechtsklicks aufhören zu zählen
    simActive = true;
    addBody();
    rightPressDuration = 5; //Dauer des Rechtsklicks zurücksetzen
  }
}


void keyReleased() {
  if (key == ' ') { //Simulation Pausieren
    if (simActive) {
      simActive = false;
    } else {
      simActive = true;
    }
    println("SPACE");
  }
}
