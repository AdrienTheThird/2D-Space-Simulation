

Boolean followActive = true; //follow active object
Boolean showGrid = true;

//is the cursor over background/UI/etc.
int cursorOver = 1; //1=background, 2=objectList

int errors = 0;

//everything drawn before the planets
void userInterface1() {
  time();
  grid();

  checkCursorPos();


  followObject(); //follow active object

  fill(#001219);
}

//everything drawn after the plantes
void userInterface2() {

  backgroundUI();

  simPause(); //pause Simulation

  bodySelected(); //select object info

  saveSequence();
  loadSequence();

  fill(#001219);
}

void backgroundUI() {
  fill(#FFFFFF);
  stroke(#000000);
  strokeWeight(2);
  curveTightness(0.4);

  if (showList) { //list Background
    beginShape();
    curveVertex(1300, -20);
    curveVertex(1300, -10);
    curveVertex(1000, -10);
    curveVertex(1000, 0);

    curveVertex(1020, 380);

    curveVertex(1300, 400);
    curveVertex(1310, 400);
    endShape();
  }
  if (selectedBody > -1) { //info Background
    beginShape();
    curveVertex(-10, 730);
    curveVertex(-15, 730);
    curveVertex(-10, 695);
    curveVertex(0, 695);
    curveVertex(400, 695);
    curveVertex(450, 720);
    curveVertex(430, 750);
    endShape();
  }

  //show/hide list symbol
  rect(1254, 4, 20, 20);
  line(1258, 9, 1270, 9);
  line(1258, 14, 1270, 14);
  line(1258, 19, 1270, 19);
}

void checkCursorPos() {
  cursorOver = 1; //standard = cursor over window, not over anything else
  if (mouseX < 0 || mouseX > 1280 || mouseY < 0 || mouseY > 720) {
    cursorOver = 0; //cursor not over window
  } else if (mouseX > 1254 && mouseY < 24) {
    cursorOver = 3; //cursor over list hide/show button
  } else if (showList && mouseX > 1000 && mouseY < 400) {
    cursorOver = 2; //cursor over list
  } else if (loadSequenceActive && mouseX>500 && mouseX<780 && mouseY>200 && mouseY<500) {
    cursorOver = 4; //cursor over savestate selection (loading)
  } else if (saveSequenceActive && mouseX>500 && mouseX<780 && mouseY>200 && mouseY<500) {
    cursorOver = 5; //cursor over savestate selection (saving)
  }
}



//follow active object
void followObject() {
  if (followActive && selectedBody > -1) {
    camPosX = -body[selectedBody].location.x;
    camPosY = -body[selectedBody].location.y;
  }
}


void bodySelected() {
  if (selectedBody > -1) { //If an object is selected
    fill(#001219);
    body[selectedBody].sel = true;
    text("Velocity: "+roundX(body[selectedBody].velocity.mag(), 2), 300, 712);
    text("Mass: "+roundX(body[selectedBody].mass, 2), 10, 712);
    text("Radius: "+roundX(body[selectedBody].radius, 2), 150, 712);
  }
}

//prüft ob die Simulation pausiert ist
void simPause() {
  if (!simActive) { //Simulation pausieren
    fill(#FA0303);
    textSize(20);
    text("SIMULATION PAUSED", 553, 25);
    textSize(14);
  }
}

//changes the speed of time (number of calculations per frame)
void time() {
  timeSpeed = 1;
  switch(globalTime) {
  case 9:
    timeStep = 10;
    break;
  case 10:
    timeSpeed = 1;
    break;
  case 11:
    timeSpeed = 2;
    break;
  case 12:
    timeSpeed = 4;
    break;
  case 13:
    timeSpeed = 8;
    break;
  case 14:
    timeSpeed = 16;
    break;
  case 15:
    timeSpeed = 32;
    break;
  case 16:
    timeSpeed = 64;
    break;
  case 17:
    timeSpeed = 128;
    break;
  }
  //println("timeSpeed: "+timeSpeed);
}


//draw Background grid
void grid() {
  if (showGrid) {
    stroke(#C6C4C4);
    strokeWeight(1);

    //different grid sizes
    if (camZoom < 4 && camZoom > 0.4) { //grid size 1
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
    } else if (camZoom > 0.1 && camZoom < 4) { //grid size 2
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
    } else if (camZoom > 0.02 && camZoom < 0.1) { //grid size 3
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
    } else if (camZoom > 0.005 && camZoom < 0.02) { //grid size 4
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


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  INPUT
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void mouseWheel(MouseEvent event) {
  if (cursorOver == 1) { //Zoom
    if (event.getCount() < 0 && camZoom < 30) {
      camZoom *= 1.2;
    } else if (event.getCount() > 0 && camZoom > 0.001) {
      camZoom *= 0.8;
    }
  }
  if (cursorOver == 2) { //scroll through list
    if (event.getCount() < 0) {
      scrollObjectList(true);
    } else {
      scrollObjectList(false);
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
    }
  }
  if (mouseButton == LEFT) {
    if (cursorOver == 3) { //hide/show list
      if (showList) {
        showList = false;
      } else {
        showList = true;
      }
    }
  }
  selectSave();
  selectList();
}

void keyReleased() {
  if (saveSequenceActive && saveSequenceStage == 1) {
    recTyping();
  } else {
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

    //debugging
    if (keyCode == 114) { //F3
      if (showDebugging) {
        showDebugging = false;
        if (!alwaysShowHidden) {
          showHidden = false;
        }
      } else {
        showDebugging = true;
        showHidden = true;
      }
    }

    //time speed
    if (key == 'z' && globalTime < 17) {
      globalTime++;
    }
    if (key == 't') {
      globalTime = 10;
    }
    if (key == 'r' && globalTime > 10) {
      globalTime--;
    }

    //save/load
    if (key == 'S') {
      saveSequenceActive = true;
    }
    if (key == 'L') {
      loadSequenceActive = true;
    }

    //println(keyCode, key);
  }
}

//select save to load / save to
void selectSave() {
  if (mouseButton == LEFT && cursorOver == 4 && selectingLoadState) { //select state to load
    int startPosY = 208;
    int rowDist = 28;

    for (int i=0; i<numSaves; i++) { //for all displayed saves
      if (mouseY>startPosY+rowDist*i && mouseY<startPosY+rowDist+rowDist*i) { //check yPos
        println("loadSave "+i);
        loadStateIndex = i;
        selectingLoadState = false;
      }
    }
  } else if (mouseButton == LEFT && cursorOver == 5 && saveSequenceStage > -1) { //select state to save to
    int startPosY = 208;
    int rowDist = 28;

    for (int i=0; i<numSaves+1; i++) { //for all displayed saves
      if (mouseY>startPosY+rowDist*i && mouseY<startPosY+rowDist+rowDist*i) { //check yPos
        println("saveState "+i);
        saveStateIndex = i;
        saveSequenceStage = 1;
        newSaveName = " ";
      }
    }
  } else if (mouseButton == LEFT) { //cancel loading/saving
    saveSequenceActive = false;

    loadSequenceActive = false;
    selectingLoadState = true;
    loadSequenceStart = true;
  }
}



//check if object in list gets selected (clicked)
void selectList() {
  if (mouseButton == LEFT && cursorOver == 2 && showList) { //if list shown and cursor over list
    if (mouseX > 1016 && mouseX < 1250) { //check x-coordinate
      int startPos = 20;
      int rowDist = 16;

      for (int i=0; i<20; i++) { //for all list rows
        if (mouseY > startPos+rowDist*i && mouseY < startPos+rowDist*i+rowDist) { //check y-coordinate
          println("SelectList "+i);
          for (int n=0; n<numObjects; n++) { //deselect all other objects
            body[n].sel = false;
          }
          if (showHidden) { //use listStart or visObject[listStart]
            if (listStart > 0) { //error catching
              selectedBody = listStart+i; //select object
              body[listStart+i].sel = true; //select object
              camPosX = -body[listStart+i].location.x; //go to object
              camPosY = -body[listStart+i].location.y;
            } else {
              selectedBody = i; //select object
              body[listStart+i].sel = true; //select object
              camPosX = -body[i].location.x; //go to object
              camPosY = -body[i].location.y;
            }
          } else {
            if (listStart > 0) { //error catching
              selectedBody = visObjects[listStart+i]; //select object
              body[visObjects[listStart+i]].sel = true; //select object
              camPosX = -body[visObjects[listStart+i]].location.x; //go to object
              camPosY = -body[visObjects[listStart+i]].location.y;
            } else {
              selectedBody = visObjects[i]; //select object
              body[visObjects[i]].sel = true; //select object
              camPosX = -body[visObjects[i]].location.x; //go to object
              camPosY = -body[visObjects[i]].location.y;
            }
          }
        }
      }
    }
  }
}
