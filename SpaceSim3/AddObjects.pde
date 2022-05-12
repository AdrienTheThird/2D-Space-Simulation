



void addBody(float newRadius, float posX, float posY) {
  float newMass = newRadius*2;
  
  body[numObjects] = new CelBody(posX, posY, 0, 2, newRadius, newMass, numObjects);
  numObjects++;
  println("addBody");
}
