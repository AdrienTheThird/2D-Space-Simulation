


//folgen der Kollision zwischen zwei Objekten berechnen
void collision(int obj1, int obj2) {

  //Schauen welche Art von Kollision stattfindet  
  if (body[obj1].radius > body[obj2].radius) {
    if (body[obj1].mass / body[obj2].mass < 6 && body[obj2].radius > 3) { //wenn Massedifferenz "klein"
      if (body[obj1].mass - body[obj2].mass < 10 && body[obj1].collidable > 2 && body[obj2].collidable > 2) {
      } else {
        type2Collision(obj1, obj2);
      }
    } else { //unelastische Kollision
      inelasticCollision(obj1, obj2);
    }
  } else {
    if (body[obj2].mass / body[obj1].mass < 6 && body[obj1].radius > 3) {
      if (body[obj2].mass - body[obj1].mass < 10 && body[obj1].collidable > 2 && body[obj2].collidable > 2) {
      } else {
        type2Collision(obj2, obj1);
      }
    } else {
      inelasticCollision(obj2, obj1);
    }
  }
}


//unelastische Kollision (Beide Körper verschmelzen zu einem)
void inelasticCollision(int obj1, int obj2) {
  PVector velZ; //Zwischenschritt der Geschwindigkeit
  float massF = body[obj1].mass + body[obj2].mass; //Gesammtmasse nach der Kollision

  velZ = PVector.add(PVector.mult(body[obj1].velocity, body[obj1].mass), PVector.mult(body[obj2].velocity, body[obj2].mass));
  body[obj1].velocity = PVector.div(velZ, massF); //neue Geschwindigkeit ausrechnen

  body[obj1].radius = sqrt(sq(body[obj1].radius)+sq(body[obj2].radius)); //Größe des Endobjekts berechnen
  body[obj1].mass = int(massF); //Masse addieren
  body[obj2].vis = false; //zweites (kleines) Objekt unsichtbar machen

  if (obj2 == selectedBody) { //wenn Körper ausgewählt, Körper abwählen
    body[obj2].sel = false;
    selectedBody = -1;
  }
  //println("velF: "+body[obj1].velocity);
}


//Kollision Typ 2 (m1 > m2)
void type2Collision(int obj1, int obj2) {
  PVector velDif = PVector.sub(body[obj1].velocity, body[obj2].velocity); //Differenz der Geschwindigkeit (Aufprallgeschwindigkeit von obj2 auf obj1)
  float velDifMag = velDif.mag(); //Betrag der Geschwindigkeitsdifferenz

  //neue Geschwindigkeiten
  PVector newVel1 = new PVector(0, 0); //Neue Geschwindigkeit obj1
  PVector newVel2 = new PVector(0, 0); //Neue Geschiwndigkeit obj2
  //Zwischenschritte
  float massSpacer1 = (2*body[obj2].mass)/(body[obj1].mass+body[obj2].mass); //Zwischenschritt Masse
  float massSpacer2 = (2*body[obj1].mass)/(body[obj1].mass+body[obj2].mass);
  PVector locSpacer1 = PVector.sub(body[obj1].location, body[obj2].location); //Zwischenschritt Position
  PVector locSpacer2 = PVector.sub(body[obj2].location, body[obj1].location);
  float dotSpacer1 = PVector.dot( PVector.sub(body[obj1].velocity, body[obj2].velocity), PVector.sub(body[obj1].location, body[obj2].location) ); //Zwischenschritt
  float dotSpacer2 = PVector.dot( PVector.sub(body[obj2].velocity, body[obj1].velocity), PVector.sub(body[obj2].location, body[obj1].location) );
  float magSpacer1 = sq( PVector.sub(body[obj1].location, body[obj2].location).mag() ); //Zwischenschritt Magnitude
  float magSpacer2 = sq( PVector.sub(body[obj2].location, body[obj1].location).mag() );
  //Vektorgleichungen für neue Geschwindigkeiten
  newVel1 = PVector.sub(body[obj1].velocity, PVector.mult(locSpacer1, (massSpacer1 * dotSpacer1/magSpacer1)) );
  newVel2 = PVector.sub(body[obj2].velocity, PVector.mult(locSpacer2, (massSpacer2 * dotSpacer2/magSpacer2)) );

  

  if (velDifMag < 1) { //Aufprallgeschwindigkeit klein, nur wenige kleine Fragmente if (velDifMag < 1)
    int fragNum = 2;
    float rotateVel = PI / fragNum;
    for (int i=0; i<fragNum; i++) {
      float randomizer = randomGaussian();
      float newMass = (body[obj2].mass/fragNum)*randomizer; //Masse des neuen Fragments
      float newRadius = (body[obj2].radius/fragNum)*randomizer; //Radius des neuen Fragments
      PVector newPos = body[obj2].location; //Position des neuen Fragments
      PVector newVel = PVector.div(newVel2, fragNum); //Geschwindigkeit des neuen Fragments

      newVel.rotate(i*rotateVel);
      //println("pos1 "+newPos);
      PVector randomizePos = new PVector(newVel.x, newVel.y);
      randomizePos.normalize();
      randomizePos.mult(newRadius);
      randomizePos.rotate(i*rotateVel);
      newPos.add(randomizePos);

      body[numObjects+addedObjects] = new CelBody(newPos.x, newPos.y, newVel.x, newVel.y, newRadius, newMass, numObjects+addedObjects);
      body[numObjects+addedObjects].collidable = noColTime; //Körper kann erst wieder nach 20 Frames kollidieren (um doppelkollisionen etc. zu verhindern)0
      addedObjects++;
    }
  } else if (velDifMag < 3) { //Aufprallgeschwindigkeit mäßig, einige Fragmente
    int fragNum = int(random(3, 5));
    float rotateVel = PI / fragNum;
    for (int i=0; i<fragNum; i++) {
      float randomizer = randomGaussian();
      float newMass = (body[obj2].mass/fragNum)*randomizer; //Masse des neuen Fragments
      float newRadius = (body[obj2].radius/fragNum)*randomizer; //Radius des neuen Fragments
      PVector newPos = body[obj2].location; //Position des neuen Fragments
      PVector newVel = PVector.div(newVel2, fragNum); //Geschwindigkeit des neuen Fragments

      newVel.rotate(i*rotateVel);
      //println("pos1 "+newPos);
      PVector randomizePos = new PVector(newVel.x, newVel.y);
      randomizePos.normalize();
      randomizePos.mult(newRadius);
      randomizePos.rotate(i*rotateVel);
      newPos.add(randomizePos);

      body[numObjects+addedObjects] = new CelBody(newPos.x, newPos.y, newVel.x, newVel.y, newRadius, newMass, numObjects+addedObjects);
      body[numObjects+addedObjects].collidable = noColTime; //Körper kann erst wieder nach 20 Frames kollidieren (um doppelkollisionen etc. zu verhindern)0
      addedObjects++;
    }
  } else { //Aufprallgeschwindigkeit groß, viele Fragmente
    int fragNum = int(random(6, 9));
    float rotateVel = PI / fragNum;
    for (int i=0; i<fragNum; i++) {
      float randomizer = randomGaussian();
      float newMass = (body[obj2].mass/fragNum)*randomizer; //Masse des neuen Fragments
      float newRadius = (body[obj2].radius/fragNum)*randomizer; //Radius des neuen Fragments
      PVector newPos = body[obj2].location; //Position des neuen Fragments
      PVector newVel = PVector.div(newVel2, fragNum); //Geschwindigkeit des neuen Fragments

      newVel.rotate(i*rotateVel);
      //println("pos1 "+newPos);
      PVector randomizePos = new PVector(newVel.x, newVel.y);
      randomizePos.normalize();
      randomizePos.mult(newRadius);
      randomizePos.rotate(i*rotateVel);
      newPos.add(randomizePos);

      body[numObjects+addedObjects] = new CelBody(newPos.x, newPos.y, newVel.x, newVel.y, newRadius, newMass, numObjects+addedObjects);
      body[numObjects+addedObjects].collidable = noColTime; //Körper kann erst wieder nach 20 Frames kollidieren (um doppelkollisionen etc. zu verhindern)0
      addedObjects++;
    }
  } 

  body[obj1].velocity = newVel1;

  body[obj2].vis = false; //zweites (kleines) Objekt unsichtbar machen
  
  if (obj2 == selectedBody) { //wenn Körper ausgewählt, Körper abwählen
    body[obj2].sel = false;
    selectedBody = -1;
  }
}
