

//saves current state to csv
void saveState() {
  simActive = false;
  
  //save table
  saveTable(listT, "saves/save1.csv");
  println("state saved!");
}



void loadState() {
  simActive = false;

  //create Table
  Table loadT;
  loadT = loadTable("saves/save1.csv", "header");


  for (int i=0; i<numObjects; i++) {
    body[i].vis = false;
  }

  for (int i=0; i<loadT.getRowCount(); i++) {
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
  //last row for camPos etc.
  TableRow info = listT.addRow();
  info.setFloat("locationX", camPosX);
  info.setFloat("locationY", camPosY);
  info.setFloat("radius", camZoom);
  info.setInt("mass", selectedBody);
  
}
