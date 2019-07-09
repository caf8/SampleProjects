import java.util.Arrays;
PImage ladder;
final float chanceToStartAliveRoom = 0.45;
final int stoneHeightRoom = 25;
final int stoneWidthRoom = 25;

//Class with all the fields and methods for the room
public class Room extends Place {

  PVector leftExit = new PVector(0, 0);
  PVector topExit = new PVector(0, 0);
  PVector rightExit = new PVector(0, 0);
  PVector bottomExit = new PVector(0, 0);
  boolean leftBlocked = false;
  boolean topBlocked = false;
  boolean rightBlocked = false;
  boolean bottomBlocked = false;
  int numBlocksWidth;
  int numBlocksHeight;
  int i;
  int j;
  AI[] baddies;
  int difficulty = 1;
  PowerUp[] powerUps;
  boolean activateClusters = false;
  boolean finalRoom = false;
  PVector ladderPos;
  ArrayList<PVector> usedPositions = new ArrayList<PVector>();
  boolean bossDefeated = false; //change after debugging
  boolean roomVisited = false;
  boolean nextToFinal = false;
  int totalEnemiesInRoom = 0;

  int numSeekers = 0;
  int numRandoms = 0;
  int numGuards = 0;
  int numClusters = 0;
  int numHearts = 0;
  int numAmmo = 0;

  boolean containsKey = false;
  PVector keyPos;
  int numberSplitters = 0;

  public Room(int i, int j) {
    super(chanceToStartAliveRoom, stoneHeightRoom, stoneWidthRoom);
    this.i = i;
    this.j = j;
    numBlocksWidth = width/stoneWidthRoom;
    numBlocksHeight = height/stoneHeightRoom;
    setChances();
  }

  //set number of AIs and power ups according to values set by the dififculty level
  void setChances() {

    float number = random(0, 1);
    if (number<level.chanceOfRandom) numRandoms = 1;
    
    number= random(0, 1);
    if (number<level.chanceOfClusters) numClusters = level.numberClusters;

    number = random(0, 1);
    if (number<level.chanceOfSeeker) numSeekers = 1;
    if (number<0.1) numSeekers = 2;
    if (number<0.05) numSeekers = 3;

    number = random(0, 1);
    if (number<level.chanceOfGuard) numGuards = 1;

    number = random(0, 1);
    if (number<level.chanceOfLife) numHearts = 1;

    number = random(0, 1);
    if (number<level.chanceOfAmmo) numAmmo = 1;
  }


  //initialise the room with exits, powerups and baddies (including boss)
  void intialisePart2() {
    addExits();
    if (!finalRoom) {
      initialisePowerUps();
      initialiseBaddies(numSeekers,  numRandoms,  numGuards,  numClusters);
    } else {
      baddies = new AI[numSeekers + numRandoms + numGuards + numClusters + 1];
      ladderPos = createStartingPosition();
      if (level.bossType == 0) { 
        baddies[baddies.length-1] = new AIBossStun(this, level.maxAISpeed);
      } else if (level.bossType == 1) {
        baddies[baddies.length-1] = new AIBossSplit(this, level.maxAISpeed, 200);
        numberSplitters = 1;
      } else if (level.bossType == 2) {
        baddies[baddies.length-1] = new AIBossCombo(this, level.maxAISpeed, 200);
        numberSplitters = 1;
      }
    }
  }

  //create baddies in random positions on map
  void initialiseBaddies(int numSeekers, int numRandoms, int numGuards, int numClusters) {
    baddies = new AI[numSeekers + numRandoms + numGuards + numClusters];
    for (int i=0; i<baddies.length; i++) {
      if (i>=0 && i<numSeekers) {
        baddies[i] = baddies[i] = new AISeeker(this, level.maxAISpeed);
      } else if (i>=numSeekers && i<numSeekers+numRandoms) {
        baddies[i] = baddies[i] = new AIRandom(this, level.maxAISpeed);
      } else if (i>=numSeekers+numRandoms && i<numSeekers+numRandoms+numGuards) {
        baddies[i] = baddies[i] = new AIGuard(this, level.maxAISpeed);
      } else if (i>=numSeekers+numRandoms+numGuards && i<numSeekers+numRandoms+numGuards+numClusters) {
        baddies[i] = baddies[i] = new AICluster(this, level.maxAISpeed);
      }
    }
    totalEnemiesInRoom =  numSeekers + numRandoms + numGuards + numClusters;
    
  }

    //create powerups in random positions on map
  void initialisePowerUps() {
    powerUps = new PowerUp[numHearts + numAmmo];
    for (int i=0; i<powerUps.length; i++) {
      if (i<numHearts)  powerUps[i] = createLife();
      else powerUps[i] = createAmmo();
    }
  }

  //create a life power up
  PowerUp createLife() {
    PVector position = createStartingPosition();
    return new Life(position);
  }

  //create an ammo powerup
  PowerUp createAmmo() {
    PVector position = createStartingPosition();
    return new weaponUpgrade(position);
  }

  //get random starting position (but not one that has already been found)
  PVector createStartingPosition() {
    int i, j;
    do {
      i = (int) random(1, map.length-1);
      j = (int) random(1, map[0].length-1);
    } while (map[i][j] || positionIsUsed(i, j));

    int x = i*stoneWidthRoom;
    int y = j*stoneHeightRoom;
    PVector newPosition = new PVector(x, y);
    usedPositions.add(newPosition);
    return newPosition;
  }

  //check if that position has already been used
  boolean positionIsUsed(int i, int j) {
    int x = i*stoneWidthRoom;
    int y = j*stoneHeightRoom;

    for (int k=0; k<usedPositions.size(); k++) {
      if (usedPositions.get(k).x == x && usedPositions.get(k).y == y) return true;
    }
    return false;
  }

  //add exits to the room. If exit leads to final room, set them as blocked
  void addExits() {
    boolean[][] currentDungeon = level.currentDungeon;
    int finalRoomX = level.finalRoomX;
    int finalRoomY = level.finalRoomY;

    if (i>0 && !currentDungeon[i-1][j]) { //left
      if (finalRoomX == i-1 && finalRoomY == j) {
        nextToFinal = true;
        if(!level.foundKey) leftBlocked = true;
      }
      setExit(0);
    }
    if (i<currentDungeon.length-1 && !currentDungeon[i+1][j]) { //right
      if (finalRoomX == i+1 && finalRoomY == j) {
        nextToFinal = true;
        if(!level.foundKey) rightBlocked = true;
      }
      setExit(1);
    }
    if (j>0 && !currentDungeon[i][j-1]) { //top
      if (finalRoomX == i && finalRoomY == j-1) {
        nextToFinal = true;
        if(!level.foundKey) topBlocked = true;
      }
      setExit(2);
    }
    if (j<currentDungeon[0].length-1 && !currentDungeon[i][j+1]) { //bottom
      if (finalRoomX == i && finalRoomY == j+1) {
        nextToFinal = true;
        if(!level.foundKey) bottomBlocked = true;
      }
      setExit(3);
    }
  }


  //create the exits
  void setExit(int border) {
    int exit = 0;
    switch(border) {
    case 0:
      exit = (int) random(2, numBlocksHeight-2);
      map[0][exit-1] = false;
      map[0][exit] = false;
      map[0][exit+1] = false;
      leftExit = new PVector(0, exit);
      break;
    case 1:
      exit = (int) random(2, numBlocksHeight-2);
      map[numBlocksWidth-1][exit-1] = false;
      map[numBlocksWidth-1][exit] = false;
      map[numBlocksWidth-1][exit+1] = false;
      rightExit = new PVector(numBlocksWidth-1, exit);
      break;
    case 2:
      exit = (int) random(2, numBlocksWidth-2);
      map[exit-1][0] = false;
      map[exit][0] = false;
      map[exit+1][0] = false;
      topExit = new PVector(exit, 0);
      break;
    case 3:
      exit = (int) random(2, numBlocksWidth-2);
      map[exit-1][numBlocksHeight-1] = false;
      map[exit][numBlocksHeight-1] = false;
      map[exit+1][numBlocksHeight-1] = false;
      bottomExit = new PVector(exit, numBlocksHeight-1);
      break;
    }
    checkPathFromExit(border, exit);
  }

  //create a path from the exit
  void checkPathFromExit(int border, int exit) {
    int i, j;
    switch(border) {
    case 0:
      i=1;
      j=exit;
      while (map[i][j]) {
        if (i>=stoneWidthRoom-2) {
          initialise(false);
          break;
        }
        map[i][j-1] = false;
        map[i][j] = false;
        map[i][j+1] = false;
        i++;
      }
      break;
    case 1:
      i=numBlocksWidth-2;
      j=exit;
      while (map[i][j]) {
        if (i<=1) {
          initialise(false);
          break;
        }
        map[i][j-1] = false;
        map[i][j] = false;
        map[i][j+1] = false;
        i--;
      }
      break;
    case 2:
      i=exit;
      j=1;
      while (map[i][j]) {
        if (j>=stoneHeightRoom-2) {
          initialise(false);
          break;
        }
        map[i-1][j] = false;
        map[i][j] = false;
        map[i+1][j] = false;
        j++;
      }
      break;
    case 3:
      i=exit;
      j=numBlocksHeight-2;
      ;
      while (map[i][j]) {
        if (j<=1) {
          initialise(false);
          break;
        }
        map[i-1][j] = false;
        map[i][j] = false;
        map[i+1][j] = false;
        j--;
      }
      break;
    }
  }

  //update the room's baddies and powerups
  void updateRoom() {
    drawExits();
    if (!finalRoom) {
      updateBaddies();
      updatePowerUps();
      if (containsKey) checkKey();
    }

    if (finalRoom) {
      checkForLadder();
      updateBaddies();
    }
  }

  //draw the exits if they are blocked
  void drawExits() {
    fill(100);
    if (leftBlocked) {
      rect(leftExit.x*stoneWidthRoom, (leftExit.y-1)*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect(leftExit.x*stoneWidthRoom, leftExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect(leftExit.x*stoneWidthRoom, (leftExit.y+1)*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
    } else if (rightBlocked) {
      rect(rightExit.x*stoneWidthRoom, (rightExit.y-1)*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect(rightExit.x*stoneWidthRoom, rightExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect(rightExit.x*stoneWidthRoom, (rightExit.y+1)*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
    } else if (topBlocked) {
      rect((topExit.x-1)*stoneWidthRoom, topExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect(topExit.x*stoneWidthRoom, topExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect((topExit.x+1)*stoneWidthRoom, topExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
    } else if (bottomBlocked) {
      rect((bottomExit.x-1)*stoneWidthRoom, bottomExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect(bottomExit.x*stoneWidthRoom, bottomExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
      rect((bottomExit.x+1)*stoneWidthRoom, bottomExit.y*stoneHeightRoom, stoneWidthRoom, stoneHeightRoom);
    }
  }

  //update baddies
  void updateBaddies() {
    for (int i=0; i<baddies.length; i++) {
      if (baddies[i] != null) {
        baddies[i].integrate();
        baddies[i].updateAIStats();
        if (baddies[i].checkIfDead()) {
           AIdeathSound.play();
           AIdeathSound.rewind();
          level.totalEnemiesKilled++;
          if (baddies[i].ifBoss) { 
            numberSplitters --;
            if (numberSplitters <= 0) {
              bossDefeated = true;
            }
          }

          if (baddies[i].hasKey) {
            level.keyInBaddie = false;
            containsKey = true;
            keyPos = baddies[i].position;
            fill(255, 165, 0);
            rect(level.currentRoom.keyPos.x, level.currentRoom.keyPos.y, stoneWidthRoom, stoneHeightRoom);
          }
          baddies[i] = null;
          continue;
        }
        baddies[i].displayHealth(false);
        image(baddies[i].image, baddies[i].position.x, baddies[i].position.y, baddies[i].size, baddies[i].size);
      }
    }
  }

  //update power ups
  void updatePowerUps() {
    for (int i=0; i<powerUps.length; i++) {
      if (powerUps[i] != null) {
        if (player.checkCollision(powerUps[i].position, powerUps[i].sizeX, powerUps[i].sizeY)) {
          powerUps[i].doThing();
          player.addToPowerUps(powerUps[i]);
          powerUps[i] = null;
          continue;
        }
        powerUps[i].displayItem();
      }
    }
  }

  //check if key had been found
  void checkKey() {
    if (player.checkCollision(keyPos, stoneWidthRoom, stoneHeightRoom)) {
      keyPos = new PVector(0, 0);
      containsKey =false;
      level.foundKey = true;
      level.unblockExits();
    }
  }

  //check if player has hit ladder
  void checkForLadder() {
    if (bossDefeated && player.pointInsideCharacter(new PVector(ladderPos.x+stoneWidthRoom/2, ladderPos.y+stoneHeightRoom/2), player.position, (int) player.size)) {
      nextLevel();
    }
  }
}