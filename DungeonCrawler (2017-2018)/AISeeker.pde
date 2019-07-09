
PImage seekerImage;
float seekerSize = 20;

//AI which will walk towadrs player if the player is within range
class AISeeker extends AI {

  // Accel is calculated at each integration

  AISeeker(Room room, float speed) {
    super(seekerSize, room, level.seekerWeaponPower, seekerImage, level.seekerView, false, level.seekerHealth, false, speed, -1, false,level.seekerWeaponPower);
    velocity = new PVector(random(1, 3), random(1, 3));
    linear = new PVector(0, 0) ;
    orientation = 0;
  }


  // if player is in view, walk towards it, else walk randomly
  void integrate() {
    if (checkIfPlayerInView()) {
      if(checkForBlock()) walkTowardsPlayer(maxSpeed);
    } else {
      walkRandomly();
    }
  }
 

  
}