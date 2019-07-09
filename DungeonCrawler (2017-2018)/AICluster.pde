
PImage clusterImage;
float clusterSize = 10;

//Multiple Cluster ais will converge on a player if the player shoots any AI or gets to close to a cluster. Implements flocking algorithm 
class AICluster extends AI {


  AICluster(Room room, float speed) {
    super(clusterSize, room, level.clusterWeaponPower, clusterImage, level.clusterView, false, level.clusterHealth, true, speed, -1, false,level.seekerWeaponPower);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }


  // update position, velocity and rotation
  void integrate() {
    if (room.activateClusters) {
      if (checkForBlock()){
        if(onlyOneCluster()) walkTowardsPlayer(maxSpeed); //write about this in the report - in walkTowardsPlayer it gets faster and more urgent
        else{
          run(room.baddies);
        }
      }
    } else {
      if (checkIfPlayerInView()) {
        room.activateClusters = true;
      }
      walkRandomly();
    }
  }

  //if there is only one cluster left, simply walk towardsplayer (no flocking needed)
  boolean onlyOneCluster(){
    int count = 0;
    int count2 = 0;
    for(int i=0; i<room.baddies.length; i++){
      if(room.baddies[i] != null)count2++; //to delete after debugging
      if(room.baddies[i] != null && room.baddies[i].isCluster) count++;
    }
    if(count == 1) return true;
    else return false;
  }


  
  
    boolean twoCharactersEqual(Character c) {
    if ((abs(position.x - c.position.x) < 20) && (abs(position.y - c.position.y) < 20)) {
      return true;
    } else {
      return false;
    }
  }
  
}