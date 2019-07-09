PImage bossSplitImage;
float bossSpinSize = 200;

// Boss AI which splits into 2 smaller AIs when hit
class AIBossSplit extends AI {

 
  int speed = 5;
  int timer = 0;
  int speedFactor = 60;

  AIBossSplit(Room room, float speed, float size) {
    super(size, room, 20, seekerImage, 0, false, level.bossHealth, false, speed, 2, true, level.bossCollisionDamage);
    velocity.x = random(7, 10);
    velocity.y = random(7, 10);
  }


  //integrate
  void integrate() {
      if(checkForBlock()) {
        run(room.baddies);
      }
  }
  
}