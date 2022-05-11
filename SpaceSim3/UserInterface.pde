


void userInterface() {
  
  info(); //some info (fps etc.)
  simPause(); //pause Simulation
  bodySelected(); //select object
  
  fill(#001219);
  
  
  //proprietary, probably gone soon
  if (rightPress) { //Dauer des Rechtsklicks zählen
    simActive = false;
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
