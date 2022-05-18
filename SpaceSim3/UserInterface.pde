

Boolean followActive = true; //follow active object
Boolean showGrid = true;

void userInterface() {

  grid();

  info(); //some info (fps etc.)
  simPause(); //pause Simulation
  bodySelected(); //select object
  followObject(); //follow active object

  fill(#001219);
}

//follow active object
void followObject() {
  if (followActive && selectedBody > -1) {
    camPosX = -body[selectedBody].location.x;
    camPosY = -body[selectedBody].location.y;
  }
}


//additional information (fps, number active objects, selected objects mass etc.)
void info() {
  fill(#001219);
  text(frameRate, 20, 20);
  text("Körper: "+numObjectsReal, 1190, 20);
}


void bodySelected() {
  if (selectedBody > -1) { //If an object is selected
    text("Geschwindigkeit: "+body[selectedBody].velocity, 280, 700);
    text("Masse: "+body[selectedBody].mass, 20, 700);
    text("Radius: "+body[selectedBody].radius, 150, 700);
  }
}

//prüft ob die Simulation pausiert ist
void simPause() {
  if (!simActive) { //Simulation pausieren
    fill(#FA0303);
    textSize(30);
    text("Simulation Gestoppt", 520, 600);
    textSize(14);
  }
}

//make Background grid
void grid() {
  if (showGrid) {
    stroke(#C6C4C4);
    strokeWeight(1);

    if (camZoom < 4 && camZoom > 0.4) {
      float startXGrid = camZoom * floor(camPosX / (50)) * (50);
      float startYGrid = camZoom * floor(camPosY / (50)) * (50);
      int loopStartX = round(16/camZoom);
      int loopStartY = round(12/camZoom);
      for (int i=-loopStartX; i<loopStartX; i+= 1) {

        line(realX(i*50)-startXGrid, realY(-550/camZoom)-startYGrid, realX(i*50)-startXGrid, realY(600/camZoom)-startYGrid);
      }
      for (int i=-loopStartY; i<loopStartY; i+= 1) {

        line(realX(-800/camZoom)-startXGrid, realY(i*50)-startYGrid, realX(850/camZoom)-startXGrid, realY(i*50)-startYGrid);
      }
    } else if (camZoom > 0.1 && camZoom < 4) {
      float startXGrid = camZoom * floor(camPosX / (200)) * (200);
      float startYGrid = camZoom * floor(camPosY / (200)) * (200);
      int loopStartX = round(16/camZoom);
      int loopStartY = round(12/camZoom);
      for (int i=-loopStartX; i<loopStartX; i+= 1) {

        line(realX(i*200)-startXGrid, realY(-550/camZoom)-startYGrid, realX(i*200)-startXGrid, realY(600/camZoom)-startYGrid);
      }
      for (int i=-loopStartY; i<loopStartY; i+= 1) {

        line(realX(-800/camZoom)-startXGrid, realY(i*200)-startYGrid, realX(850/camZoom)-startXGrid, realY(i*200)-startYGrid);
      }
    } else if (camZoom > 0.02 && camZoom < 0.1) {
      float startXGrid = camZoom * floor(camPosX / (800)) * (800);
      float startYGrid = camZoom * floor(camPosY / (800)) * (800);
      int loopStartX = round(16/camZoom);
      int loopStartY = round(12/camZoom);
      for (int i=-loopStartX; i<loopStartX; i+= 1) {

        line(realX(i*800)-startXGrid, realY(-550/camZoom)-startYGrid, realX(i*800)-startXGrid, realY(600/camZoom)-startYGrid);
      }
      for (int i=-loopStartY; i<loopStartY; i+= 1) {

        line(realX(-800/camZoom)-startXGrid, realY(i*800)-startYGrid, realX(850/camZoom)-startXGrid, realY(i*800)-startYGrid);
      }
    } else if (camZoom > 0.005 && camZoom < 0.02) {
      float startXGrid = camZoom * floor(camPosX / (3200)) * (3200);
      float startYGrid = camZoom * floor(camPosY / (3200)) * (3200);
      int loopStartX = round(16/camZoom);
      int loopStartY = round(12/camZoom);
      for (int i=-loopStartX; i<loopStartX; i+= 1) {

        line(realX(i*3200)-startXGrid, realY(-550/camZoom)-startYGrid, realX(i*3200)-startXGrid, realY(600/camZoom)-startYGrid);
      }
      for (int i=-loopStartY; i<loopStartY; i+= 1) {

        line(realX(-800/camZoom)-startXGrid, realY(i*3200)-startYGrid, realX(850/camZoom)-startXGrid, realY(i*3200)-startYGrid);
      }
    }
  }
}




//wenn Linksklick, neuer Körper
void mousePressed() {
  if (mouseButton == RIGHT && simActive) { //wenn rechte Maustaste gedrückt
    if (!rightPress && !rightRelease) { //wenn noch nicht vorher gedrück
      //wenn Objekt angeklickt
      if (selectedBody > -1 && ((mouseX>realX(body[selectedBody].location.x-body[selectedBody].radius)) && (mouseX<realX(body[selectedBody].location.x+body[selectedBody].radius)) ) && ( (mouseY>realY(body[selectedBody].location.y-body[selectedBody].radius)) && (mouseY<realY(body[selectedBody].location.y+body[selectedBody].radius)))) {
        newOrbit = true;
      } else {
        newOrbit = false;
      }
      rightPress = true; //neues Objekt anfangen
      rightklickPos = new PVector(mouseX, mouseY); //rightklickPos aktualisieren
    } else if (rightRelease) { //wenn schon vorher gedrückt
      addBody();
      rightPressDuration = 5; //Dauer des Rechtsklicks zurücksetzen
      println("lol");
      //rightPress = false;
    }
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    if (rightPress && !rightRelease) {

      rightPress = false; // Dauer des Rechtsklicks aufhören zu zählen
      rightRelease = true;
      //simActive = true;
    } else if (rightRelease) {
      rightRelease = false;
      simActive = true;
      addBody();
      println("lul");
    }
  }
}


//Pausieren
void keyReleased() {
  if (key == ' ') { //pause simulation
    if (simActive) {
      simActive = false;
    } else {
      simActive = true;
    }
    println("SPACE");
  }
  if (key == '0') { //activate follow
    if (followActive) {
      followActive = false;
    } else {
      followActive = true;
    }
  }
  if (key == '/') { //show grid
    if (showGrid) {
      showGrid = false;
    } else {
      showGrid = true;
    }
  }
}
