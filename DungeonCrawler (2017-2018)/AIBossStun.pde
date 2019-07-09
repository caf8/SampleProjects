PImage bossStunImage;
float bossStunSize = 200;

//AI Boss which shoots bullets that stun the player (so the playyer cannot move). Player can still shoot when stunned
class AIBossStun extends AI {

  Bullet[] AIBossStunBullets = new Bullet[50];
  int speed = 5;
  int timer = 0;
  
  int speedFactor = 60;

  AIBossStun(Room room, float speed) {
    super(bossStunSize, room, level.aIStunBulletDamage, randomImage, 0, true, level.bossHealth, false, speed, 0, true, level.bossCollisionDamage);
    velocity.x = random(7, 10);
    velocity.y = random(7, 10);
  }


  //Taken from last practical
  void integrate() {
    updateWeapon();
    velocity.normalize();
    velocity.mult(speed);

    position.add(velocity);

    if (!level.checkBlocks(velocity, position, size) || outOfBounds(velocity, position, size)) {
      velocity.x =  -velocity.x;
      velocity.y =  -velocity.y;
      position.add(velocity);
      if (velocity.x < 0) {
        velocity.x = -player.position.x/speedFactor;
      } else {
        velocity.x = player.position.x/speedFactor;
      }
      if (velocity.y < 0) {
        velocity.y = -player.position.y/speedFactor;
      } else {
        velocity.y = player.position.y/speedFactor;
      }
    }

  }

  //shot the weapon if timer allows
  void updateWeapon() {
    if (timer >= level.randomShootTime) {
      timer = 0;
      newBullet(player.position.x, player.position.y, this, AIBossStunBullets, 20);
    }
    timer ++;
    for (int i =0; i < AIBossStunBullets.length; i ++) {
      if (AIBossStunBullets[i]!=null) {
        AIBossStunBullets[i].updateBullet();
        if (!AIBossStunBullets[i].checkBlocksForBullet()) AIBossStunBullets[i] = null;
      }
    }
  }
}