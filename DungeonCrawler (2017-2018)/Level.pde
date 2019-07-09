 //<>//
//Class which hold the level and all values particular to that level
class Level {

  int currentRoomX;
  int currentRoomY;
  int finalRoomX;
  int finalRoomY;
  Bullet[] bullets = new Bullet[50];
  boolean [][] currentDungeon;
  Room[][] dungeon;
  Dungeon dungeonReal;
  Room currentRoom;
  Room startingRoom;
  boolean foundKey = false;
  boolean keyInBaddie = false;
  float difficulty;
  int stunnedTimer;
  int currentStunnedTimer;
  int numberAIsTotal = 0;
  boolean showFinalRoom = false;
  int totalEnemiesKilled = 0;

  int bossType; //0 - stun, 1 = split, 2 = combo
  int bossHealth;


  int clusterHealth;
  int seekerHealth;
  int randomHealth;
  int guardHealth;

  float clusterWeaponPower;
  float seekerWeaponPower;
  float randomWeaponPower;
  int randomShootTime;
  float guardWeaponPower;

  int aIStunBulletDamage;
  int aIComboBulletDamage;
  float bossCollisionDamage;

  float chanceOfClusters;
  int numberClusters;
  float chanceOfSeeker;
  float chanceOfRandom;
  float chanceOfGuard;
  float chance2AI;
  float chance3AI;

  int guardView;
  int seekerView;
  int clusterView;

  float chanceOfLife;
  float chanceOfAmmo;
  int ammoTimer;

  float maxAISpeed;

  float ratio;
  int planningAIState=0;
  int totalDamageDealt = 0;
  int totalDamageTaken = 0;



  Level(int levelNo) {
    difficulty = ((float) levelNo)/((float) numberLevels);
    println(levelNo);
    println(difficulty);
    
  }


  //set up the map
  void intialiseMap() {
    setValuesFromDifficulty();
    
    setDifficultiesWithRatio(ratio);
    Dungeon d = new Dungeon();
    currentDungeon = d.map;
    dungeon = new Room[currentDungeon.length][currentDungeon[0].length];
    for (int i = 0; i < currentDungeon.length; i++) {
      for (int j = 0; j < currentDungeon[0].length; j++) {
        if (currentDungeon[i][j] == false) {
          dungeon[i][j] = new Room(i, j); //create the rooms
        }
      }
    }
    
    
    setStartingRoom();
    setFinalRoom();
    
    for (int i = 0; i < currentDungeon.length; i++) {
      for (int j = 0; j < currentDungeon[0].length; j++) {
        if (currentDungeon[i][j] == false) {
          if (dungeon[i][j].finalRoom) dungeon[i][j].initialise(true);
          else dungeon[i][j].initialise(false); //initialise the rooms
        }
      }
    }
    for (int i = 0; i < currentDungeon.length; i++) {
      for (int j = 0; j < currentDungeon[0].length; j++) {
        if (currentDungeon[i][j] == false) {
          dungeon[i][j].intialisePart2(); //initialise the rooms
        }
      }
    }
    //place the key
    placeKey();
  }

  //set which room is the starting one (it is a random room)
  void setStartingRoom() {
    int i, j;
    int count = 0;
    do {
      count++;
      i = (int) random(1, currentDungeon.length-1);
      j = (int) random(1, currentDungeon[0].length-1);
    } while (currentDungeon[i][j] && count < 10);
    if (count >= 10) intialiseMap();
    startingRoom = dungeon[i][j];
    currentRoom = dungeon[i][j];
    currentRoomX = i;
    currentRoomY = j;
  }

  //set which room is the final one (it is the room the furthest away from the start)
  void setFinalRoom() {
    int highest = 0;
    for (int i=0; i<currentDungeon.length; i++) {
      for (int j=0; j<currentDungeon[0].length; j++) {
        if (!currentDungeon[i][j]) {
          int distance = getDistance(i, j);
          if (distance > highest) {
            highest = distance;
            finalRoomX = i;
            finalRoomY = j;
          }
        }
      }
    }
    dungeon[finalRoomX][finalRoomY].finalRoom = true;
  }

  //get distance between two rooms
  int getDistance(int otherI, int otherJ) {
    int differenceI = abs(otherI - currentRoomX);
    int differenceJ = abs(otherJ - currentRoomY);
    return differenceI + differenceJ;
  }

  //place the key
  void placeKey() {
    if (keyInBaddie) placeKeyInBaddie();
    else placeKeyInRoom();
  }

  //place the key in a room
  void placeKeyInRoom() {
    int i, j;
    do {
      i = (int) random(1, width/stoneWidthDungeon-1);
      j = (int) random(1, height/stoneHeightDungeon-1);
    } while (currentDungeon[i][j] ||
      (i==currentRoomX && j==currentRoomY) || 
      (i==finalRoomX && j==finalRoomY));
    dungeon[i][j].containsKey = true;
    dungeon[i][j].keyPos = dungeon[i][j].createStartingPosition();
    println("i: " + i + ", j: " + j);
  }

  //place the key in an AI which is dropped when the AI dies
  void placeKeyInBaddie() {
    int i, j;
    do {
      i = (int) random(1, width/stoneWidthDungeon-1);
      j = (int) random(1, height/stoneHeightDungeon-1);
    } while (currentDungeon[i][j] ||
      (i==currentRoomX && j==currentRoomY) || 
      (i==finalRoomX && j==finalRoomY || dungeon[i][j].baddies == null || dungeon[i][j].baddies.length == 0));
    
    int r;
    do {
      r = (int) random(0, dungeon[i][j].baddies.length);
    } while (dungeon[i][j].baddies[r] == null);
    
    dungeon[i][j].baddies[r].hasKey = true;
    dungeon[i][j].containsKey = false;
    println("i: " + i + ", j: " + j);
  }

  //draw the room
  void drawRoom() {
    boolean [][] room = currentRoom.map;
    for (int i =0; i < room.length; i++) {
      for (int j = 0; j < room[i].length; j++) {
        if (room[i][j] == true) {
          rect(i*stoneHeightRoom, j*currentRoom.stoneHeight, stoneHeightRoom, stoneHeightRoom);
        }
      }
    }
    if (currentRoom.containsKey) {
      fill(255, 165, 0);
      rect(currentRoom.keyPos.x, currentRoom.keyPos.y, stoneWidthRoom, stoneHeightRoom);
    }
    if (currentRoom.finalRoom && currentRoom.bossDefeated) {
      image(ladder, currentRoom.ladderPos.x, currentRoom.ladderPos.y, stoneWidthRoom, stoneHeightRoom);
    }
  }


  //draw the map
  void drawMap() {
    for (int i =0; i < currentDungeon.length; i++) {
      for (int j = 0; j < currentDungeon[i].length; j++) {
        if (currentDungeon[i][j]) {
          fill(255);
          rect(i*80, j*80, 80, 80);
        } else if (i == currentRoomX && j == currentRoomY) {
          fill(255, 0, 0);
          rect(i*80, j*80, 80, 80);
        } else if (dungeon[i][j].roomVisited) {
          fill(100);
          rect(i*80, j*80, 80, 80);
        }
        if (i == finalRoomX && j == finalRoomY && showFinalRoom) {
          fill(0, 255, 0);
          rect(i*80, j*80, 80, 80);
        }
      }
    }
    fill(0);
    text("LEVEL:  " + currentLevelNumber, 10, 30);
  }

  //update bullets
  void updateBullets() {
    for (int i =0; i < bullets.length; i ++) {
      if (bullets[i]!=null) {
        bullets[i].updateBullet();
        if (!bullets[i].checkBlocksForBullet()) bullets[i] = null;
      }
    }
  }



   //get the block i value for this position
  int getCurrentBlockI(PVector pos) {
    return (int) pos.x/stoneWidthRoom;
  }
  
   //get the block j value for this position
  int getCurrentBlockJ(PVector pos) {
    return (int) pos.y/stoneHeightRoom;
  }

   //check if this position plus this velocity hits a block
  boolean checkBlocks(PVector vel, PVector position, float size) {
    if (!checkBlocksI(vel, new PVector(position.x, position.y), size) || 
      !checkBlocksI(vel, new PVector(position.x+size, position.y), size) ||
      !checkBlocksI(vel, new PVector(position.x, position.y+size), size) ||
      !checkBlocksI(vel, new PVector(position.x+size, position.y+size), size)) {

      return false;
    }
    if (!checkBlocksJ(vel, new PVector(position.x, position.y), size) || 
      !checkBlocksJ(vel, new PVector(position.x+size, position.y), size) ||
      !checkBlocksJ(vel, new PVector(position.x, position.y+size), size) ||
      !checkBlocksJ(vel, new PVector(position.x+size, position.y+size), size)) {

      return false;
    }
    return true;
  }

  //check if this position plus this velocity hits a block either left or right
  public boolean checkBlocksI(PVector vel, PVector position, float size) {
    int oldI = getCurrentBlockI(position);
    PVector newPos = position.copy();

    newPos = newPos.add(vel);
    int newI = getCurrentBlockI(newPos);
    if (newI > oldI) {
      if (!checkRight(vel, position, size)) {
        return false;
      }
    } else if (newI < oldI) {
      if (!checkLeft(vel, position, size)) {
        return false;
      }
    }
    return true;
  }
  
  //check if this position plus this velocity hits a block either top or bottom
  public boolean checkBlocksJ(PVector vel, PVector position, float size) {
    int oldJ = getCurrentBlockJ(position);
    PVector newPos = position.copy();
    newPos = newPos.add(vel);
    int newJ = getCurrentBlockJ(newPos);

    if (newJ > oldJ) {
      if (!checkBottom(vel, position, size)) {
        return false;
      }
    } else if (newJ < oldJ) {
      if (!checkTop(vel, position, size)) {
        return false;
      }
    }
    return true;
  }

  //check block to the left
  boolean checkLeft(PVector vel, PVector position, float size) {
    int currentI = getCurrentBlockI(position);
    int currentJ = getCurrentBlockJ(position);
    int left = currentI-1;
    if (left<0) return true;
    PVector newPos = position.copy();
    newPos = newPos.add(vel);

    if (currentRoom.map[left][currentJ] 
      && newPos.x <= (currentI)*stoneWidthRoom
      ) {
      return false;
    }
    return true;
  }

  //check block to the right
  boolean checkRight(PVector vel, PVector position, float size) {
    int currentI = getCurrentBlockI(position);
    int currentJ = getCurrentBlockJ(position);
    int right = currentI+1;
    if (right>=currentRoom.map.length) return true;
    PVector newPos = position.copy();
    newPos = newPos.add(vel);
    if (currentRoom.map[right][currentJ]) {
      if ( newPos.x  >= (currentI+1)*stoneWidthRoom) {
        return false;
      }
    }
    return true;
  }

  //check block to the top
  boolean checkTop(PVector vel, PVector position, float size) {
    int currentI = getCurrentBlockI(position);
    int currentJ = getCurrentBlockJ(position);
    int top = currentJ-1;
    if (top<0) return true;

    PVector newPos = position.copy();
    newPos = newPos.add(vel);

    if (currentRoom.map[currentI][top] 
      && newPos.y <= (currentJ)*stoneHeightRoom
      ) {
      return false;
    }
    return true;
  }

  //check block to the bottom
  boolean checkBottom(PVector vel, PVector position, float size) {

    int currentI = getCurrentBlockI(position);
    int currentJ = getCurrentBlockJ(position);
    int bottom = currentJ+1;
    if (bottom>=currentRoom.map[0].length) return true;

    PVector newPos = position.copy();
    newPos = newPos.add(vel);

    if (currentRoom.map[currentI][bottom] 
      && newPos.y >= (bottom)*stoneHeightRoom) {
      return false;
    }
    return true;
  }

  //unblock exits (after key is found)
  void unblockExits() {
    for (int i=0; i<currentDungeon.length; i++) {
      for (int j=0; j<currentDungeon[0].length; j++) {
        if (!currentDungeon[i][j]) {
          Room room = dungeon[i][j];
          room.leftBlocked = false;
          room.rightBlocked = false;
          room.topBlocked = false;
          room.bottomBlocked = false;
        }
      }
    }
  }




  //set all the values
  void setValuesFromDifficulty() {
    

    if (difficulty <= 0.2) { // very easy
      clusterHealth = 20;
      seekerHealth = 40;
      randomHealth = 40;
      guardHealth = 40;

      clusterWeaponPower = 0.15;
      seekerWeaponPower = 0.15;
      randomWeaponPower = 10;
      randomShootTime = 100;
      guardWeaponPower = 0.25;

      chanceOfClusters = 0.5;
      numberClusters = 5;
      chanceOfSeeker = 0.5;
      chanceOfRandom = 0.5;
      chanceOfGuard = 0.5;
      chance2AI = 0;
      chance3AI = 0;

      guardView = 50;
      seekerView = 100;
      clusterView = 100;

      chanceOfLife = 0.2;
      chanceOfAmmo = 0.4;
      ammoTimer = 1000;

      maxAISpeed = 1;
      keyInBaddie = false;
      bossType = 0;
      bossHealth = 500;
      stunnedTimer = 50;

      aIStunBulletDamage = 10;
      aIComboBulletDamage = 10;
      bossCollisionDamage = 0.2;
    } else if (difficulty > 0.2 && difficulty <= 0.4) { // easy
      clusterHealth = 20;
      seekerHealth = 60;
      randomHealth = 60;
      guardHealth = 60;

      clusterWeaponPower = 0.1;
      seekerWeaponPower = 0.2;
      randomWeaponPower = 10;
      randomShootTime = 80;
      guardWeaponPower = 0.2;

      chanceOfClusters = 0.6;
      numberClusters = 4;
      chanceOfSeeker = 0.6;
      chanceOfRandom = 0.6;
      chanceOfGuard = 0.6;
      chance2AI = 0.05;
      chance3AI = 0.02;

      guardView = 80;
      seekerView = 200;
      clusterView = 100;

      chanceOfLife = 0.2;
      chanceOfAmmo = 0.4;
      ammoTimer = 800;

      maxAISpeed = 1.2;
      keyInBaddie = false;
      bossType = 1;
      bossHealth = 100;
      stunnedTimer = 50;

      aIStunBulletDamage = 20;
      aIComboBulletDamage = 20;
      bossCollisionDamage = 0.3;
    } else if (difficulty > 0.4 && difficulty <= 0.6) { // medium
      clusterHealth = 20;
      seekerHealth = 80;
      randomHealth = 80;
      guardHealth = 80;

      clusterWeaponPower = 0.2;
      seekerWeaponPower = 0.3;
      randomWeaponPower = 10;
      randomShootTime = 50;
      guardWeaponPower = 0.5;

      chanceOfClusters = 0.8;
      numberClusters = 6;
      chanceOfSeeker = 0.8;
      chanceOfRandom = 0.8;
      chanceOfGuard = 0.8;
      chance2AI = 0.1;
      chance3AI = 0.05;

      guardView = 100;
      seekerView = 300;
      clusterView = 150;

      chanceOfLife = 0.3;
      chanceOfAmmo = 0.4;
      ammoTimer = 600;

      maxAISpeed = 1.5;
      keyInBaddie = true;
      bossType = 0;
      bossHealth = 500;
      stunnedTimer = 50;

      aIStunBulletDamage = 30;
      aIComboBulletDamage = 30;
      bossCollisionDamage = 0.5;
    } else if (difficulty > 0.6 && difficulty <= 0.8) { // hard
      clusterHealth = 40;
      seekerHealth = 80;
      randomHealth = 80;
      guardHealth = 80;

      clusterWeaponPower = 0.2;
      seekerWeaponPower = 0.4;
      randomWeaponPower = 20;
      randomShootTime = 40;
      guardWeaponPower = 0.6;

      chanceOfClusters = 0.7;
      numberClusters = 7;
      chanceOfSeeker = 0.7;
      chanceOfRandom = 0.7;
      chanceOfGuard = 0.7;
      chance2AI = 0.15;
      chance3AI = 0.8;

      guardView = 150;
      seekerView = 400;
      clusterView = 200;

      chanceOfLife = 0.4;
      chanceOfAmmo = 0.3;
      ammoTimer = 500;

      maxAISpeed = 2;
      keyInBaddie = true;
      bossType = 1;
      bossHealth = 100;
      stunnedTimer = 50;

      aIStunBulletDamage = 40;
      aIComboBulletDamage = 40;
      bossCollisionDamage = 1;
    } else { // very hard
      clusterHealth = 60;
      seekerHealth = 100;
      randomHealth = 100;
      guardHealth = 100;

      clusterWeaponPower = 0.3;
      seekerWeaponPower = 0.5;
      randomWeaponPower = 30;
      randomShootTime = 20;
      guardWeaponPower = 0.8;

      chanceOfClusters = 0.9;
      numberClusters = 8;
      chanceOfSeeker = 0.9;
      chanceOfRandom = 0.9;
      chanceOfGuard = 1;
      chance2AI = 0.3;
      chance3AI = 0.2;

      guardView = 200;
      seekerView = 500;
      clusterView = 250;

      chanceOfLife = 0.45;
      chanceOfAmmo = 0.5;
      ammoTimer = 300;

      maxAISpeed = 2.5;
      keyInBaddie = true;
      bossType = 2;
      bossHealth = 200;
      stunnedTimer = 50;

      aIStunBulletDamage = 50;
      aIComboBulletDamage = 50;
      bossCollisionDamage = 1.5;
    }
  }

  //PLANNING AI
  //Modify the values with the ratio
  void setDifficultiesWithRatio(float ratio) {
    if (ratio <= 0.2) {
      changeAIChances(-0.15);
      numberClusters-=2;
      randomShootTime+=50;
      changeWeaponsCollision(-0.05);
      changeWeaponsBullet(-5);
      changeViewRadius(-20);
    } else if (ratio > 0.2 && ratio <= 0.4) {
      changeAIChances(-0.1);
      numberClusters-=1;
      randomShootTime+=10;
      changeWeaponsCollision(-0.03);
      changeWeaponsBullet(-2);
      changeViewRadius(-10);
    } else if (ratio > 0.4 && ratio <= 0.8) {
      randomShootTime+=5;
    } else if (ratio > 0.8 && ratio <= 1.2) {
      changeAIChances(0.1);
      numberClusters+=1;
      changeWeaponsCollision(0.3);
      changeWeaponsBullet(2);
      changeViewRadius(10);
    } else if (ratio >1.2) {
      changeAIChances(0.1);
      numberClusters+=2;
      randomShootTime-=5;
      changeWeaponsCollision(0.5);
      changeWeaponsBullet(10);
      changeViewRadius(25);
    }
  }

  //modify chance of AIs
  void changeAIChances(float x) {
    chanceOfClusters+=x;
    chanceOfSeeker+=x;
    chanceOfRandom+=x;
    chanceOfGuard+=x;
    chance2AI+=x;
    chance3AI+=x;
  }

  //modify weapon on collisions
  void changeWeaponsCollision(float x) {
    clusterWeaponPower+=x;
    seekerWeaponPower+=x;
    guardWeaponPower+=x;
    bossCollisionDamage+=x;
  }

  //modify weapon bullet
  void changeWeaponsBullet(float x) {
    randomWeaponPower+=x;
    aIStunBulletDamage+=x;
    aIComboBulletDamage+=x;
  }

  //modify view radius
  void changeViewRadius(float x) {
    guardView+=x;
    seekerView+=x;
    clusterView+=x;
  }
}