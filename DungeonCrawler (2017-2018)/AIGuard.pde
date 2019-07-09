
PImage guardImage;
float guardSize = 20;

//AI which guards an exit and will move towards player if player gets too near
class AIGuard extends AI {

  PVector patrol1;
  PVector patrol2;
  boolean headingTo2 = true;
  PVector aim = new PVector();

  AIGuard(Room room, float speed) {
    super(guardSize, room, level.guardWeaponPower, guardImage, level.guardView, false, level.guardHealth, false, speed, -1, false,level.seekerWeaponPower);
    velocity = new PVector(random(1, 3), random(1, 3));
    linear = new PVector(0, 0) ;
    orientation = 0;
    getPatrol();
    position = patrol1.copy();
  }

  //get the two points to patrol between (aka the two sides of the exit)
  void getPatrol() {
    int random;
    PVector patrol = new PVector();
    int count=0;
    do {
      random = (int) random(1, 5);
      switch(random) {
      case 1: //left exit
        patrol.x = room.leftExit.x*stoneWidthRoom;
        patrol.y = room.leftExit.y*stoneHeightRoom;
        break;
      case 2: //right exit
        patrol.x = room.rightExit.x*stoneWidthRoom;
        patrol.y = room.rightExit.y*stoneHeightRoom;
        break;
      case 3: //top exit
        patrol.x = room.topExit.x*stoneWidthRoom;
        patrol.y = room.topExit.y*stoneHeightRoom;
        break;
      case 4: //bottom exit
        patrol.x = room.bottomExit.x*stoneWidthRoom;
        patrol.y = room.bottomExit.y*stoneHeightRoom;
        break;
      }
      count++;
      if(count ==20) break;
    } while (patrol.x == 0 && patrol.y == 0);
    
    switch(random) {
    case 1: //left exit
      patrol1 = new PVector(patrol.x, patrol.y - stoneHeightRoom);
      patrol2 = new PVector(patrol.x, patrol.y + stoneHeightRoom);
      //println("LEFT");
      break;
    case 2: //right exit
      patrol1 = new PVector(patrol.x, patrol.y - stoneHeightRoom);
      patrol2 = new PVector(patrol.x, patrol.y + stoneHeightRoom);
      //println("RIGHT");
      break;
    case 3: //top exit
      patrol1 = new PVector(patrol.x - stoneWidthRoom, patrol.y);
      patrol2 = new PVector(patrol.x + stoneWidthRoom, patrol.y);
      //println("TOP");
      break;
    case 4: //bottom exit
      patrol1 = new PVector(patrol.x - stoneWidthRoom, patrol.y);
      patrol2 = new PVector(patrol.x + stoneWidthRoom, patrol.y);
      //println("BOTTOM");
      break;
    }
  }

  // if player is near, walk towards player, else patrol
  void integrate() {
    if (checkIfPlayerInView() && timer==0) {
      if (checkForBlock()) walkTowardsPlayer(maxSpeed);
    } else {
      patrol();
    }
  }

  //walk between two points. Go through blocks if blocks are in the way (aka when AI is going back to patrol after chasing player)
  public void patrol() {

    if (headingTo2) {
      aim = new PVector(patrol2.x, patrol2.y);
    } else {
      aim = new PVector(patrol1.x, patrol1.y);
    }

    velocity.x = aim.x - position.x ;
    velocity.y = aim.y - position.y ;

    velocity.normalize() ;
    velocity.mult(MAX_SPEED1);
    position.add(velocity);


    if (reachedPosition(aim)) {
      headingTo2 = !headingTo2;
    }
  }

  //check if guard has reached target position
  boolean reachedPosition(PVector aim) {
    if (abs(aim.x-position.x)<2 && abs(aim.y-position.y)<2) {

      return true;
    } else return false;
  }
}