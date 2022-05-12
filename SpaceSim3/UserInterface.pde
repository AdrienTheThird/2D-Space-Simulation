

PVector rightklickPos; //Position an der geklickt wurde

Boolean rightPress = false; //True wenn rechte Maustaste gedrückt
Boolean rightRelease = false; //True wenn rechte Maustaste losgelassen

int rightPressDuration = 5; //Länge der Dauer des Klicks


void userInterface() {

  info(); //some info (fps etc.)
  simPause(); //pause Simulation
  bodySelected(); //select object

  fill(#001219);


  //proprietary, probably gone soon
  if (rightPress) { //Dauer des Rechtsklicks zählen
    simActive = false;

    stroke(#001219);
    strokeWeight(3);
    line(rightklickPos.x, rightklickPos.y, mouseX, mouseY);
    //println("rightklickPos "+rightklickPos);

    noStroke();

    rightPressDuration++;
  }
  
  if (rightRelease) { //Dauer des Rechtsklicks zählen
    simActive = false;

    stroke(#FEFF2E);
    strokeWeight(3);
    line(rightklickPos.x, rightklickPos.y, mouseX, mouseY);
    //println("rightklickPos "+rightklickPos);

    noStroke();

    rightPressDuration++;
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



//wenn Linksklick, neuer Körper
void mousePressed() {
  if (mouseButton == RIGHT && simActive) { //wenn rechte Maustaste gedrückt
    if (!rightPress && !rightRelease) { //wenn noch nicht vorher gedrück
      rightPress = true; //Dauer des Rechtsklicks anfangen zu zählen
      rightklickPos = new PVector(mouseX, mouseY); //rightklickPos aktualisieren
    } else if (rightRelease) { //wenn schon vorher gedrückt
      addBody(10, rightklickPos.x, rightklickPos.y);
      rightPressDuration = 5; //Dauer des Rechtsklicks zurücksetzen
      
      //rightPress = false;
    }
  }
}

void mouseReleased() {
  if (mouseButton == RIGHT) {
    if(rightPress && !rightRelease) {
      
      rightPress = false; // Dauer des Rechtsklicks aufhören zu zählen
      rightRelease = true;
      //simActive = true;
      
    } else if(rightRelease) {
      rightRelease = false;
      simActive = true;
    }
    
    
    
    
  }
}


//Pausieren
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
