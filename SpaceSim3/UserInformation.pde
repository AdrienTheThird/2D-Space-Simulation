
Table listT; //list of all Objects and their data


//object list variables
boolean showList = true;
int listStart = 50; 



void userInformation() {
  createTable();
  
  objectList();
  
}





void objectList() {
  if (showList) {
    int startPosY = 50;
    int startPosX = 1000;
    int rowDist = 20;
    
    for (int i=0; i<8; i++) {
      text(listStart+i, startPosX, i*rowDist+startPosY);
      text(listT.getFloat(listStart+i, "locationX"), startPosX+50, i*rowDist+startPosY);
    }
    
    
  }
}
