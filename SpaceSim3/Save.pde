
Boolean loadSequenceActive = false; //start load sequence
Boolean saveSequenceActive = false; //start save sequence
int saveSequenceStage = -1;
Boolean selectingLoadState = true;
Boolean loadSequenceStart = true;

int loadStateIndex = 0;
int saveStateIndex = 0;
String curSaveName = "LUL"; //name of the current savestate
int numSaves;

String newSaveName = "";

String[] saveNames = new String[10];

char lol = '?';


//list of all SaveStates with Information
void listSaveStates() {
  numSaves = 0;

  //load all names from saves
  for (int i=0; i<10; i++) {
    try { //only if save exists
      Table loadT;
      loadT = loadTable("saves/save"+i+".csv", "header");
      saveNames[i] = loadT.getString(loadT.getRowCount()-1, "vis");
      numSaves++;
    }
    catch (NullPointerException e) {
    }
  }
}


void saveSequence() {
  if (saveSequenceActive) {
    simActive = false;
    if (saveSequenceStage == -1) { //do once, make list of all saves
      listSaveStates();
      saveSequenceStage = 0;
    } else if (saveSequenceStage == 0) { //repeat, show saves
      selectSaveState();
    } else if (saveSequenceStage == 1) { //repeat, name new save
      selectSaveState();
      nameSaveState();
    } else if (saveSequenceStage == 2) {
      createTable();
      saveTable(listT, "saves/save"+saveStateIndex+".csv");
      println("state saved!");
      saveSequenceActive = false;
      saveSequenceStage = -1;
    }
  }
}

//select which save should be loaded
void selectSaveState() {
  int startX = 450;
  int startY = 200;

  stroke(#000000);
  fill(#FFFFFF);
  rect(startX, startY, 380, 300); //show background

  textSize(22);
  fill(#000000);
  for (int i=0; i<numSaves; i++) { //show saves
    text("Save" + (i+1) + ":", startX+14, 30+startY+i*28);
    text(saveNames[i], startX+90, 30+startY+i*28);
  }
  if (numSaves<10) {
    for (int i=numSaves; i<10; i++) {
      fill(#FA0303);
      text("Save" + (i+1) + ":", startX+14, 30+startY+i*28);
      text("save does not exist", startX+90, 30+startY+i*28);
    }
  }
  textSize(14);
}


void nameSaveState() {
  int startX = 538;
  int startY = 210;
  
  fill(#FFFFFF);
  rect(startX, startY+saveStateIndex*28, 286, 24);

  textSize(22);
  if (newSaveName.length() < 2) { //show placeholder
    fill(#B2B2B2);
    text(" new name", startX, 20+startY+saveStateIndex*28);
  } else { //show new name
    fill(#000000);
    text(newSaveName, startX, 20+startY+saveStateIndex*28);
  }
  textSize(14);
}

void recTyping() {
  if (keyCode > 46 && keyCode < 90 && newSaveName.length() < 20) {
    newSaveName = (newSaveName + key);
  } else if (keyCode == 10) {
    curSaveName = newSaveName;
    saveSequenceStage = 2;
  }
}




void loadSequence() {
  if  (loadSequenceActive) {
    if (loadSequenceStart) { //do once before selection
      listSaveStates();
      loadSequenceStart = false;
    }
    simActive = false;
    if (selectingLoadState) { //repeat
      selectSaveState(); //select which savestate should be loaded
    } else { //do once after save selection
      loadState(); //load selected state
      loadSequenceActive = false;
      selectingLoadState = true;
      loadSequenceStart = true;
    }
  }
}


void loadState() {
  simActive = false;

  //create Table
  Table loadT;
  loadT = loadTable("saves/save"+loadStateIndex+".csv", "header");


  for (int i=0; i<numObjects; i++) { //make all objects invisible to avoid leftover objects from current save state
    body[i].vis = false;
  }

  for (int i=0; i<loadT.getRowCount(); i++) { //load all objects
    body[i] = new CelBody(loadT.getFloat(i, 0), loadT.getFloat(i, 1), loadT.getFloat(i, 2), loadT.getFloat(i, 3), loadT.getFloat(i, 4), loadT.getFloat(i, 5), i);
    if (loadT.getInt(i, "vis") == 0) {
      body[i].vis = false;
    }
  }

  numObjects = loadT.getRowCount() - 1;
  selectedBody = loadT.getInt(loadT.getRowCount()-1, "mass");
}



void createTable() {
  //create table
  listT = new Table();
  listT.addColumn("locationX");
  listT.addColumn("locationY");
  listT.addColumn("velocityX");
  listT.addColumn("velocityY");
  listT.addColumn("radius");
  listT.addColumn("mass");
  listT.addColumn("vis");

  //fill table
  try { //catches NullPointerExceptions that occur becaues of multithreading
    for (int i=0; i<numObjects; i++) {
      TableRow objects = listT.addRow();
      objects.setFloat("locationX", body[i].location.x);
      objects.setFloat("locationY", body[i].location.y);
      objects.setFloat("velocityX", body[i].velocity.x);
      objects.setFloat("velocityY", body[i].velocity.y);
      objects.setFloat("radius", body[i].radius);
      objects.setFloat("mass", body[i].mass);
      if (body[i].vis) {
        objects.setInt("vis", 1);
      } else {
        objects.setInt("vis", 0);
      }
    }
  }
  catch (NullPointerException e) {
    errors++;
  }
  //last row for camPos etc.
  TableRow info = listT.addRow();
  info.setFloat("locationX", camPosX);
  info.setFloat("locationY", camPosY);
  info.setFloat("radius", camZoom);
  info.setInt("mass", selectedBody);
  info.setString("vis", curSaveName);
}
