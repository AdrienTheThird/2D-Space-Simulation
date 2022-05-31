
int numThreads = 2;
int startCalc;
int stopCalc;
int startCalcG;

void gravity() {

  //need to do that later...
  /*startCalc = numObjects / numThreads;
   println("startCalc: "+startCalc);
   
   for (int i=0; i<numThreads; i++) {
   stopCalc = (startCalc * i) + startCalc;
   startCalcG = startCalc * i;
   println("startCalcG: "+startCalcG);
   println("stopCalc: "+stopCalc);
   if (i < numThreads-1) {
   thread("calcGravityE");
   } else {
   startCalc = numObjects;
   thread("calcGravityE");
   }
   } */
  //calcGravityE(startCalc*0, numObjects);
  calcGravityE();
}


//calc Gravity, startCalc = Object to start with, stopCalc = object to stop with
//if 1000 Objects and 2 thread, thread one will calculate from object 1-500 etc.
public void calcGravityE() {
  /*int startCalcE = startCalcG;
   int stopCalcE = stopCalc;
   println(startCalcE);
   println(stopCalcE);*/
  numObjectsReal = 0;
  for (int i=0; i<numObjects; i++) {
    if (body[i].vis) {
      numObjectsReal += 1;
    }
    for (int n=i+1; n<numObjects; n++) {
      if (body[i].vis && body[n].vis) { //wenn beide Körper vorhanden
        if (body[i].collidable > 2 && body[n].collidable > 2) { //new fragments dont affect each other
        } else {
          PVector forceTmp = new PVector(0, 0); //temporäre Kraft

          forceTmp = PVector.sub(body[i].location, body[n].location); //Richtung der Kraft
          float tmpMag = forceTmp.mag(); //Distanz zwischen den beiden Objekten
          
          //add+calc force
          if (tmpMag > 2 && tmpMag > body[i].radius+body[n].radius) { //only if bodies are not overlapping
            forceTmp.setMag(6.6743*pow(10, -2) * (body[i].mass*body[n].mass) / sq(tmpMag) ); //Länge der Kraft
            body[i].forceE.add(forceTmp.mult(-1)); //Kraft zur Gesammtkraft von Objekt1 hinzufügen
            body[n].forceE.add(forceTmp.mult(-1)); //Kraft zur Gesanntkraft Objekt2 hinzufügen
          } else if (tmpMag > 2) { //if bodies are overlapping
            forceTmp.setMag(6.6743*pow(10, -2) * (body[i].mass*body[n].mass) / sq(body[i].radius+body[n].radius) ); //Länge der Kraft
            body[i].forceE.add(forceTmp.mult(-1)); //Kraft zur Gesammtkraft von Objekt1 hinzufügen
            body[n].forceE.add(forceTmp.mult(-1)); //Kraft zur Gesanntkraft Objekt2 hinzufügen
          }

          //check for collisions
          if (tmpMag < (body[i].radius + body[n].radius) ) {
            collision(i, n);
          }
        }
      }
    }
  }

  numObjects += addedObjects; //Objekte die durch Kollisionen dazugekommen sind zur gesammtzahl hinzufügen
  addedObjects = 0;
}
