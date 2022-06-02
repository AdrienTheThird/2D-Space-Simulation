
Table listT; //list of all Objects and their data


//object list variables
boolean showList = true;
boolean showHidden = false;
int listStart = 0;
int visObjects[] = new int[20000];
int numVisObjects = 0;
int selectedBodyVisIndex = 0; //index of the selected body in visObjects


void userInformation() {
  createTable();

  objectList();
}





void objectList() {
  if (showList) {
    int startPosY = 50;
    int startPosX = 1020;
    int rowDist = 16;

    if (listStart < 0) {
      listStart = 0;
    }

    visObjArray();


    fill(#023e8a);
    text("Index", startPosX, startPosY-16);
    text("PosX", startPosX+44, startPosY-16);
    text("PosY", startPosX+100, startPosY-16);



    noStroke();



    for (int i=0; i<16; i++) {
      if (showHidden) { //show all objects
        if (listStart+i < numObjects) {
          text(listStart+i, startPosX, i*rowDist+startPosY);
          text(listT.getInt(listStart+i, "locationX"), startPosX+44, i*rowDist+startPosY);
          text(listT.getInt(listStart+i, "locationY"), startPosX+100, i*rowDist+startPosY);
        }
      } else { //only show visible objects in the list
        if (listStart+i < numVisObjects) {
          if (listStart+i == selectedBodyVisIndex) {
            fill(#90e0ef);
            rect(startPosX, i*rowDist+startPosY-12, 200, rowDist);
          }
          fill(#023047);
          text(visObjects[listStart+i], startPosX, i*rowDist+startPosY);
          text(listT.getInt(visObjects[listStart+i], "locationX"), startPosX+44, i*rowDist+startPosY);
          text(listT.getInt(visObjects[listStart+i], "locationY"), startPosX+100, i*rowDist+startPosY);
        }
      }
    }

    stroke(#0077b6);
    line(startPosX, startPosY-13, startPosX+200, startPosY-13);
    line(startPosX+40, startPosY-27, startPosX+40, startPosY+300);
    line(startPosX+96, startPosY-27, startPosX+96, startPosY+300);

    if (!showHidden && numVisObjects < listStart+8) {
      listStart = numVisObjects - 16;
    }


    println(listStart);

    text(numObjects, startPosX, startPosY+330);
  }
}

//make Array of all visible objects
void visObjArray() {
  if (!showHidden) {
    numVisObjects = 0;
    for (int i=0; i<numObjects; i++) { //for all objects
      if (listT.getInt(i, "vis") == 1) { //only if object visible
        visObjects[numVisObjects] = i; //add object to array
        numVisObjects++;
        if (i == selectedBody) {
          selectedBodyVisIndex = numVisObjects - 1;
        }
      }
    }
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
