
Table listT; //list of all Objects and their data

boolean showDebugging = false;

//object list variables
boolean showList = false;
boolean showHidden = false;
int listStart = 0;
int visObjects[] = new int[20000];
int selectedBodyVisIndex = 0; //index of the selected body in visObjects


void userInformation() {
  createTable();

  objectList();

  debuggingInformation();
}



void objectList() {
  if (showList) {
    int startPosY = 34;
    int startPosX = 1016;
    int rowDist = 16;

    if (listStart < 0) {
      listStart = 0;
    }

    visObjArray(); //creates Array of all visible objects

    //header
    fill(#023e8a);
    text("Index", startPosX, startPosY-16);
    text("PosX", startPosX+44, startPosY-16);
    text("PosY", startPosX+100, startPosY-16);
    text("Vel", startPosX+156, startPosY-16);
    text("Mass", startPosX+184, startPosY-16);
    text("Total: "+numVisObjects, 1190, 380);
    noStroke();

    //entries
    for (int i=0; i<20; i++) {
      if (showHidden) { //show all objects

        if (listStart+i < numObjects) {
          int velocity = round(body[listStart+i].velocity.mag());
          if (listStart+i == selectedBody) { //highlight selected
            fill(#90e0ef);
            rect(startPosX, i*rowDist+startPosY-12, 230, rowDist);
          }
          if (body[listStart+i].vis == false) { //highlight invisible objects
            fill(#FF6A74);
            rect(startPosX, i*rowDist+startPosY-12, 230, rowDist);
          }
          fill(#023047);
          text(listStart+i, startPosX, i*rowDist+startPosY);
          text(listT.getInt(listStart+i, "locationX"), startPosX+44, i*rowDist+startPosY);
          text(listT.getInt(listStart+i, "locationY"), startPosX+100, i*rowDist+startPosY);
          text(velocity, startPosX+156, i*rowDist+startPosY);
          text(round(body[listStart+i].mass), startPosX+184, i*rowDist+startPosY);
        }
      } else { //only show visible objects in the list
        if (listStart+i < numVisObjects) {
          int velocity = round(body[visObjects[listStart+i]].velocity.mag());
          if (listStart+i == selectedBodyVisIndex) { //highlight selected
            fill(#90e0ef);
            rect(startPosX, i*rowDist+startPosY-12, 230, rowDist);
          }
          fill(#023047);
          text(visObjects[listStart+i], startPosX, i*rowDist+startPosY);
          text(listT.getInt(visObjects[listStart+i], "locationX"), startPosX+44, i*rowDist+startPosY);
          text(listT.getInt(visObjects[listStart+i], "locationY"), startPosX+100, i*rowDist+startPosY);
          text(velocity, startPosX+156, i*rowDist+startPosY);
          text(round(body[visObjects[listStart+i]].mass), startPosX+184, i*rowDist+startPosY);
        }
      }
    }

    //table lines
    stroke(#0077b6);
    line(startPosX, startPosY-13, startPosX+230, startPosY-13);
    line(startPosX+40, startPosY-27, startPosX+40, startPosY+300);
    line(startPosX+96, startPosY-27, startPosX+96, startPosY+300);
    line(startPosX+152, startPosY-27, startPosX+152, startPosY+300);
    line(startPosX+180, startPosY-27, startPosX+180, startPosY+300);

    if (!showHidden && numVisObjects < listStart+8) { //scroll back to last entry
      listStart = numVisObjects - 16;
    }

    text(numObjects, startPosX, startPosY+330);
  }
}


//make Array of all visible objects
void visObjArray() {

  numVisObjects = 0;

  for (int i=0; i<numObjects; i++) { //for all objects
    try { //catches ArrayOutOfBounds errors that occur because of multithreading
      if (listT.getInt(i, "vis") == 1) { //only if object visible
        visObjects[numVisObjects] = i; //add object to array
        numVisObjects++;
        if (i == selectedBody) {
          selectedBodyVisIndex = numVisObjects - 1;
        }
      }
    }
    catch (ArrayIndexOutOfBoundsException e) {
      errors++;
    }
  }

  if (selectedBody == -1) {
    selectedBodyVisIndex = -1;
  }
}



void scrollObjectList(boolean up) {
  if (up) { //scroll up
    if (listStart > 0) {
      listStart -= 8;
    }
  } else { //scroll down
    if (showHidden) {
      if (listStart < numObjects-16) {
        listStart += 8;
      }
    } else {
      if (listStart < numVisObjects-14) {
        listStart += 8;
      }
    }
  }
}


void debuggingInformation() {
  if (showDebugging) {
    int startPosX = 10;
    int startPosY = 400;

    stroke(#505050);
    fill(#676767, 100);
    rectMode(CORNER);
    rect(startPosX, startPosY, 220, 200, 10);


    fill(#313639);
    text("framerate: " + roundX(frameRate, 1), startPosX+8, startPosY+16);
    text("finished threads: " + threadsFinishedDebug, startPosX+8, startPosY+30);
    text("errors: " + errors, startPosX+8, startPosY+44);
    text("visible objects: " + numVisObjects, startPosX+8, startPosY+58); //only updates when object list shown
    text("object-array entries: " + numObjects, startPosX+8, startPosY+72);
    text("empty slots: " + numEmpty, startPosX+8, startPosY+86);
    text("zoom: " + roundX(camZoom, 4), startPosX+8, startPosY+100);
    text("camPos: " + roundX(camPosX, 1) + " " + roundX(camPosY, 1), startPosX+8, startPosY+114);
  }
}
