
//Multithreading can -when overloaded- cause Problems and lead to inaccurate simulation
//If you don't want to use Multithreading, set numThreads to 1

int startCalc;

int threadsFinished;
int threadsFinishedDebug;
boolean allThreadsFinished = true;

boolean[] filled = new boolean[20000]; //stores which slots are currently used
int[] freeSlots = new int[20000]; //stores the indices of all currently free slots
int numEmpty = 0; //number of free slots


void gravity() {
  startCalc = numObjects / numThreads;

  //println(threadsFinished);
  threadsFinishedDebug = threadsFinished;

  threadsFinished = 0;
  allThreadsFinished = false;

  switch(numThreads) { //determines how many threads should be opened
  case 1:
    calcGravityE(0, numObjects);
    break;
  case 2:
    thread("thread1");
    thread("threadLast");
    break;
  case 4:
    thread("thread1");
    thread("thread2");
    thread("thread3");
    thread("threadLast");
    break;
  case 6:
    thread("thread1");
    thread("thread2");
    thread("thread3");
    thread("thread4");
    thread("thread5");
    thread("threadLast");
    break;
  case 3:
    exit();
    break;
  case 5:
    exit();
    break;
  }
}

//all threads
void thread1() {
  calcGravityE(0, startCalc-1);
}
void thread2() {
  calcGravityE(startCalc, 2*startCalc-1);
}
void thread3() {
  calcGravityE(2*startCalc, 3*startCalc-1);
}
void thread4() {
  calcGravityE(3*startCalc, 4*startCalc-1);
}
void thread5() {
  calcGravityE(4*startCalc, 5*startCalc-1);
}
void threadLast() {
  calcGravityE((numThreads-1)*startCalc, numObjects);
}


void calcGravityE(int startCalc, int stopCalc) {
  filledSlots();
  try { //catches NullPointerExceptions that occur because of multithreading
    for (int i=startCalc; i<stopCalc; i++) {
      for (int n=i+1; n<numObjects; n++) {

        if (body[i].vis && body[n].vis) { //wenn beide Körper vorhanden
          if (body[i].collidable > 2 && body[n].collidable > 2) { //new fragments dont affect each other
          } else {
            PVector forceGravity = new PVector(0, 0); //temporary force

            forceGravity = PVector.sub(body[i].location, body[n].location); //Richtung der Kraft
            float dist = forceGravity.mag(); //Distanz zwischen den beiden Objekten

            //add & calculate force
            if (dist > 2 && dist > body[i].radius+body[n].radius) { //only if bodies are not overlapping
              forceGravity.setMag(6.6743*pow(10, -2) * (body[i].mass*body[n].mass) / sq(dist) ); //Länge der Kraft
              body[i].forceE.add(forceGravity.mult(-1)); //Kraft zur Gesammtkraft von Objekt1 hinzufügen
              body[n].forceE.add(forceGravity.mult(-1)); //Kraft zur Gesanntkraft Objekt2 hinzufügen
            } else if (dist > 2) { //if bodies are overlapping
            }

            if (dist < (body[i].radius + body[n].radius) ) { //check for collisions
              collision(i, n);
            }
          }
        }
      }
      if (body[i].vis && body[i].mass < 0.01) { //Deletes objects with mass = 0
        body[i].vis = false;
      }
    }
  }
  catch (NullPointerException e) {
    errors++;
  }
  numObjects += addedObjects; //Objekte die durch Kollisionen dazugekommen sind zur gesammtzahl hinzufügen
  addedObjects = 0;

  threadsFinished++;
}
//stores which slots of the body array are currently used
void filledSlots() {
  numEmpty = 0;
  for (int i=0; i<numObjects; i++) {
    try { //catches NullPointerExceptions that occur because of multithreading
      if (body[i].vis) {
        filled[i] = true;
      } else {
        freeSlots[numEmpty] = i;
        filled[i] = false;
        numEmpty++;
      }
    }
    catch (NullPointerException e) {
      errors++;
    }
  }
}
