PImage playerImage;
int playerMaxSpeed = 5;
int maxHealthPlayer = 100;
int playerSize = 20;
int characterWeaponPower = 20;
PowerUp[] powerUps = new PowerUp[50];

//player class
class Player extends Character {

  PVector pursueTarget;
  int lives = 3;
  int score = 0;


  Player() {
    super(maxHealthPlayer, playerMaxSpeed, playerSize, level.startingRoom, characterWeaponPower, false, 0);
  }

  //update the player health and stats
  void updatePlayerStats() {
    if (level.currentStunnedTimer > 0) {
      level.currentStunnedTimer--;
    } else {
      isStunned = false;
    }

    Room currentRoom = level.currentRoom;

    for (int i=0; i<currentRoom.baddies.length; i++) {
      if (currentRoom.baddies[i] != null) {
        if (checkCollision(currentRoom.baddies[i].position, (int) currentRoom.baddies[i].size, (int) currentRoom.baddies[i].size)) {
          takeDamage(currentRoom.baddies[i].collisionDamage);
          level.totalDamageTaken += (currentRoom.baddies[i].collisionDamage);
          if (checkIfDead()) {
            lives--;
            health = 100;
            if (lives == 0) {
              dead = true;
            }
          }
        }
        if (checkForBullet(currentRoom.baddies[i])) {
          if (!isStunned && currentRoom.finalRoom) {
            isStunned = true;
            level.currentStunnedTimer = level.stunnedTimer;
            player.velocity = new PVector(0, 0);
            isUp = isDown = isLeft = isRight = false;
          }
          takeDamage(currentRoom.baddies[i].weaponDamage);
          level.totalDamageTaken += (currentRoom.baddies[i].weaponDamage);
          if (checkIfDead()) {
            lives--;
            health = 100;
            if (lives == 0) {
              dead = true;
            }
          }
        }
      }
    }
    if (!currentRoom.finalRoom) {
      updatePowerUps();
    }
  }

  //check if bullet has hit player
  boolean checkForBullet(AI baddie) {
    if (baddie.AIType == 0) return checkForBulletBossStun(baddie);
    else if (baddie.AIType == 1) return checkBulletRandom(baddie);
    else if (baddie.AIType == 3) return checkBulletCombo(baddie);
    else return false;
  }

  //check for bullet from AIRandom
  boolean checkBulletRandom(AI baddie) {
    if (baddie.shootsBullets) {
      AIRandom ai = (AIRandom) baddie;
      for (int i=0; i<ai.AIRandomBullets.length; i++) {
        if (ai.AIRandomBullets[i] == null) continue;
        if (checkCollision(ai.AIRandomBullets[i].position, ai.AIRandomBullets[i].size, ai.AIRandomBullets[i].size)) {
          ai.AIRandomBullets[i] = null;
          return true;
        }
      }
    }
    return false;
  }

  //check for bullet from AIBossCombo
  boolean checkBulletCombo(AI baddie) {
    if (baddie.shootsBullets) {
      AIBossCombo ai = (AIBossCombo) baddie;
      for (int i=0; i<ai.AIBossComboBullets.length; i++) {
        if (ai.AIBossComboBullets[i] == null) continue;
        if (checkCollision(ai.AIBossComboBullets[i].position, ai.AIBossComboBullets[i].size, ai.AIBossComboBullets[i].size)) {
          ai.AIBossComboBullets[i] = null;
          return true;
        }
      }
    }
    return false;
  }

  //check for bullet from AIBoosStun
  boolean checkForBulletBossStun(AI baddie) {
    if (baddie.shootsBullets) {
      AIBossStun ai = (AIBossStun) baddie;
      for (int i=0; i<ai.AIBossStunBullets.length; i++) {
        if (ai.AIBossStunBullets[i] == null) continue;
        if (checkCollision(ai.AIBossStunBullets[i].position, ai.AIBossStunBullets[i].size, ai.AIBossStunBullets[i].size)) {
          ai.AIBossStunBullets[i] = null;
          return true;
        }
      }
    }
    return false;
  }

  //display lives and health of player
  void displayPlayerStats() {
    displayHealth(true);
    displayLives();
    fill(0, 0, 255);
    textSize(20);
    text("Score: " + score, 900, 20);
  }

  //display the lives 
  void displayLives() {
    for (int i=0; i<lives; i++) {
      image(heart, position.x + 20 + (10*i), position.y + 5, 8, 8);
    }
  }

  //Check if move is legal and move character
  void update(boolean isLeft, boolean isRight, boolean isUp, boolean isDown) {
    velocity.x = 0;
    velocity.y = 0;
    if (!isStunned) {
      PVector vel = new PVector();


      if (isLeft && position.x>=10 && 
        level.checkLeft(new PVector(-playerMaxSpeed, 0), new PVector(position.x, position.y), size) && 
        level.checkLeft(new PVector(-playerMaxSpeed, 0), new PVector(position.x+size, position.y), size) &&
        level.checkLeft(new PVector(-playerMaxSpeed, 0), new PVector(position.x, position.y+size), size) &&
        level.checkLeft(new PVector(-playerMaxSpeed, 0), new PVector(position.x+size, position.y+size), size)) {
        vel.x=(-playerMaxSpeed);
      }
      if (isRight && 
        level.checkRight(new PVector(playerMaxSpeed, 0), new PVector(position.x, position.y), size) && 
        level.checkRight(new PVector(playerMaxSpeed, 0), new PVector(position.x+size, position.y), size)&&
        level.checkRight(new PVector(playerMaxSpeed, 0), new PVector(position.x, position.y+size), size) &&
        level.checkRight(new PVector(playerMaxSpeed, 0), new PVector(position.x+size, position.y+size), size)) {
        vel.x=(playerMaxSpeed);
      }
      if (isDown && 
        level.checkBottom(new PVector(0, playerMaxSpeed), new PVector(position.x, position.y), size) && 
        level.checkBottom(new PVector(0, playerMaxSpeed), new PVector(position.x+size, position.y), size) &&
        level.checkBottom(new PVector(0, playerMaxSpeed), new PVector(position.x, position.y+size), size) &&
        level.checkBottom(new PVector(0, playerMaxSpeed), new PVector(position.x+size, position.y+size), size)) {
        vel.y=(playerMaxSpeed);
      }
      if (isUp && position.y >= 10 && 
        level.checkTop(new PVector(0, -playerMaxSpeed), new PVector(position.x, position.y), size) &&
        level.checkTop(new PVector(0, -playerMaxSpeed), new PVector(position.x+size, position.y), size) &&
        level.checkTop(new PVector(0, -playerMaxSpeed), new PVector(position.x, position.y+size), size) &&
        level.checkTop(new PVector(0, -playerMaxSpeed), new PVector(position.x+size, position.y+size), size)) {
        vel.y=(-playerMaxSpeed);
      }

     
        if (position.x + vel.x < 0 || position.x + vel.x + size > width || position.y + vel.y < 0 || position.y + vel.y + size > height) {
          
        } else{
          velocity = vel;
        }

      if (isLeft && isUp || isRight && isUp || isLeft && isDown || isRight && isDown) {
        velocity.x = velocity.x /1.4;
        velocity.y = velocity.y /1.4;
      }

      position.x+=velocity.x; 
      position.y+=velocity.y;
    }
  }

  //check if player has gone through exit
  void checkExits() {   
    boolean[][] currentDungeon = level.currentDungeon;
    Room[][] dungeon = level.dungeon;

    Room newRoom;
    if (player.position.x <= 0 + stoneWidthRoom) { //left
      if (level.currentRoomX>0 && !currentDungeon[level.currentRoomX-1][level.currentRoomY]
        && !dungeon[level.currentRoomX][level.currentRoomY].leftBlocked) {
        level.currentRoomX -= 1;
        newRoom = dungeon[level.currentRoomX][level.currentRoomY];
        player.setPosition((int) (newRoom.rightExit.x-1)*stoneWidthRoom, (int) newRoom.rightExit.y*stoneHeightRoom);
      }
    } else if (player.position.x >= width - stoneWidthRoom) { //right
      if (level.currentRoomX<numBlocksWidth-1 && !currentDungeon[level.currentRoomX+1][level.currentRoomY]
        && !dungeon[level.currentRoomX][level.currentRoomY].rightBlocked) {
        level.currentRoomX += 1;
        newRoom = dungeon[level.currentRoomX][level.currentRoomY];
        player.setPosition((int) (newRoom.leftExit.x+1)*stoneWidthRoom, (int) newRoom.leftExit.y*stoneHeightRoom);
      }
    } else if (player.position.y <= 0 + stoneHeightRoom) { //top
      if (level.currentRoomY>0 && !currentDungeon[level.currentRoomX][level.currentRoomY-1]
        && !dungeon[level.currentRoomX][level.currentRoomY].topBlocked) {
        level.currentRoomY -= 1;
        newRoom = dungeon[level.currentRoomX][level.currentRoomY];
        player.setPosition((int) newRoom.bottomExit.x*stoneWidthRoom, (int) (newRoom.bottomExit.y-1)*stoneHeightRoom);
      }
    } else if (player.position.y >= height - stoneHeightRoom) { //bottom
      if (level.currentRoomY<numBlocksHeight-1 && !currentDungeon[level.currentRoomX][level.currentRoomY+1]
        && !dungeon[level.currentRoomX][level.currentRoomY].bottomBlocked) {
        level.currentRoomY += 1;
        newRoom = dungeon[level.currentRoomX][level.currentRoomY];
        player.setPosition((int) newRoom.topExit.x*stoneWidthRoom, (int) (newRoom.topExit.y+1)*stoneHeightRoom);
      }
    }
  }

  //add powerup to player
  void addToPowerUps(PowerUp newPowerUp) {
    for (int i=0; i<powerUps.length; i++) {
      if (powerUps[i] == null) {
        powerUps[i] = newPowerUp;
        break;
      }
    }
  }

  //update the power ups
  void updatePowerUps() {
    for (int i=0; i<powerUps.length; i++) {
      if (powerUps[i] != null) {
        if (powerUps[i].timer >= powerUps[i].maxTimer) {
          powerUps[i].reverseThing();
          powerUps[i] = null;
          continue;
        }
        powerUps[i].timer++;
      }
    }
  }
}