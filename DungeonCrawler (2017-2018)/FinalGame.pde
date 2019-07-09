import ddf.minim.*; //<>//

boolean isLeft, isRight, isDown, isUp, isMap;
Player player;
int Stone_Height;
int Stone_Width;
final int MY_HEIGHT = height;
final int MY_WIDTH = width;
Menu startMenu = new Menu();
Menu pauseMenu = new Menu();
boolean dead = false;
boolean finishedGame = false;
Level[] allLevels;
Level level;
int currentLevelNumber = 0;
int numberLevels = 5;

AudioPlayer playerMusic;
AudioPlayer bulletSound;
AudioPlayer AIdeathSound;
Minim minim;

//Setup the inital game
void setup() {
  setupImagesAndMusic();
  size(1025, 800);
  initialiseLevels();
  player = new Player();
  startMenu.showMenu = true;
}

//Load all the images and music
void setupImagesAndMusic() {
  playerImage = loadImage("characterright.png");
  seekerImage = loadImage("seeker.png");
  randomImage = loadImage("random.png");
  clusterImage = loadImage("cluster.png");
  guardImage = loadImage("guard.png");
  heart = loadImage("heart.png");
  ammo = loadImage("ammo.png");
  ladder = loadImage("ladder.png");
  
  //Music and sounds effect files
    minim = new Minim(this);
    playerMusic = minim.loadFile("MusicP2.mp3");
    bulletSound = minim.loadFile("bullet.mp3");
    AIdeathSound = minim.loadFile("AIDeath.mp3");
    playerMusic.loop();
}

//Create all the levels but only initialise the first one 
void initialiseLevels() {
  allLevels = new Level[numberLevels];
  for (int i=0; i<numberLevels; i++) {
    allLevels[i] = new Level(i+1);
    if (i==0) {
      level = allLevels[i];
      allLevels[i].intialiseMap();
    }
  }
  level = allLevels[0];
}

//draw the game
void draw() {
  stroke(1);
  if (finishedGame) { //player has completed the game
    displayFinishedGame();
  } else if (dead) { //player has died
    displayDeadScreen();
  } else if (startMenu.showMenu) { //start menu
    startMenu.drawMenu(true);
  } else if (pauseMenu.showMenu) { //game is paused
    pauseMenu.drawMenu(false);
  } else { //the actual game
    background(0);
    fill(255);
    level.currentRoom = level.dungeon[level.currentRoomX][level.currentRoomY]; 
    if (!level.currentRoom.roomVisited) {
      level.numberAIsTotal += level.currentRoom.totalEnemiesInRoom;
      level.currentRoom.roomVisited = true;
    }
    if (level.currentRoom.nextToFinal) level.showFinalRoom = true;
    if (!isMap) { //show the dungeon map
      level.drawRoom();
      level.updateBullets();
      level.currentRoom.updateRoom();
      updateCharacter();
    } else {
      level.drawMap();
    }
  }
}

//update the character and draw it
void updateCharacter() {
  player.update(isLeft, isRight, isUp, isDown);
  player.checkExits();
  player.updatePlayerStats();
  player.displayPlayerStats();
  image(playerImage, player.position.x, player.position.y, player.size, player.size);
}

//checks for mouse Pressed (to shoot bullets)
void mousePressed() {
  newBullet(mouseX, mouseY, player, level.bullets, 5);
}

//creates a new bullet
void newBullet(float targetX, float targetY, Character character, Bullet[] bulletList, int bulletSize) {
  Bullet b1 = new Bullet(character.position.x, character.position.y, targetX, targetY, character, bulletSize);
  bulletSound.play();
  bulletSound.rewind();
  for (int i =0; i < bulletList.length; i ++) {
    if (bulletList[i]==null) {
      bulletList[i] = b1;
      return;
    }
  }
}

//check for key pressed (either for menu or for moving the character)
void keyPressed() {
  if (keyCode == 'P') pauseMenu.showMenu = !pauseMenu.showMenu;
  if (startMenu.showMenu) {
    startMenu.checkKey(keyCode);
  } else if (pauseMenu.showMenu) {
    pauseMenu.checkKey(keyCode);
  } else {
    setMove(keyCode, true);
  }
}

//check for key released (for moving the character)
void keyReleased() {
  setMove(keyCode, false);
}



//Sets what keys have been pressed in order for the character.update to move the character properly.
boolean setMove(int k, boolean b) {
  switch (k) {
  case 'W':
    return isUp = b;

  case 'S':
    return isDown = b;

  case 'A':
    return isLeft = b;

  case 'D':
    return isRight = b;

  case 'M':
    return isMap = b;

  default:
    return b;
  }
}

//set the level to the next one (once the character has gone down the ladder)
void nextLevel() {
  float ratio = setRatio();
  currentLevelNumber++;
  if (currentLevelNumber == numberLevels) {
    finishedGame = true;
  } else {

    level = allLevels[currentLevelNumber];
    level.ratio = ratio;
    allLevels[currentLevelNumber].intialiseMap();
    player.position = level.currentRoom.createStartingPosition();
    player.score += 1000;
  }
}


float setRatio() {
  float ratio;
  if (level.totalEnemiesKilled == 0) ratio = 0;
  else {
    ratio = (float) level.totalEnemiesKilled/level.numberAIsTotal;
  }
  return ratio;
}



//display screen when player has completed the game
void displayFinishedGame() {
  background(0);
  text("Congratulations you have escaped the COLE mine!", 200, 100);
  text("Your score is: " + player.score, 400, 500);
}

//display screen when player has died
void displayDeadScreen() {
  background(0);
  text("The COLE mine baddies have defeated you", 200, 100);
  text("Your score is: " + player.score, 400, 500);
}