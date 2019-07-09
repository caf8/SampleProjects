int initialBulletSize = 20;

//Boss AI which both shoot stun bullets and splits 
class AIBossCombo extends AI {


  int speed = 2;
  int timer = 0;

  Bullet[] AIBossComboBullets = new Bullet[50];


  AIBossCombo(Room room, float speed, float size) {
    super(size, room, level.aIComboBulletDamage, clusterImage, 0, true, level.bossHealth, false, speed, 3, true, level.bossCollisionDamage);
    velocity.x = random(4, 5);
    velocity.y = random(4, 5);
    bulletSize = 20;
  }

  //integrate
  void integrate() {
    updateWeapon();
      if(checkForBlock()) {
        run(room.baddies);
      }
  }

  //shoot weapon if timer allows
  void updateWeapon() {
    if (timer >= level.randomShootTime) {
      timer = 0;
      newBullet(player.position.x, player.position.y, this, AIBossComboBullets, bulletSize);
    }
    timer ++;
    for (int i =0; i < AIBossComboBullets.length; i ++) {
      if (AIBossComboBullets[i]!=null) {
        AIBossComboBullets[i].updateBullet();
        if (!AIBossComboBullets[i].checkBlocksForBullet()) AIBossComboBullets[i] = null;
      }
    }
  }
}