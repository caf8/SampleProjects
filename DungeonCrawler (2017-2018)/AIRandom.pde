PImage randomImage;
float randomSize = 20;

//AI which bounces off walls towards the player and shoots bullets
class AIRandom extends AI {

  Bullet[] AIRandomBullets = new Bullet[50];
  int speed = 2;
  int timer = 0;
  int speedFactor = 80;

  
  AIRandom(Room room, float speed) {
    super(randomSize, room, level.randomWeaponPower, randomImage, 0, true, level.randomHealth, false, speed, 1, false, 1);
    velocity.x = random(3, 5);
    velocity.y = random(3, 5);
  }


  //modified from last practical
  void integrate() {
    updateWeapon();
    velocity.normalize();
    velocity.mult(speed);

    if(level.checkBlocks(velocity, position, size)) position.add(velocity);

    if (!level.checkBlocks(velocity, position, size) || outOfBounds(velocity, position, size)) {
      velocity.x = - velocity.x;
      velocity.y = - velocity.y;
      PVector linear = new PVector();
      //position.add(velocity);
      linear.x = player.position.x - position.x ;
      linear.y = player.position.y - position.y ;
      
      linear.normalize() ;
      velocity.add(linear) ;
    
    }
  }

  //shoot if timer allows
  void updateWeapon() {
    if (timer >= level.randomShootTime) {
      timer = 0;
      newBullet(player.position.x, player.position.y, this, AIRandomBullets, 5);
    }
    timer ++;
    for (int i =0; i < AIRandomBullets.length; i ++) {
      if (AIRandomBullets[i]!=null) {
        AIRandomBullets[i].updateBullet();
        if (!AIRandomBullets[i].checkBlocksForBullet()) AIRandomBullets[i] = null;
      }
    }
  }
}