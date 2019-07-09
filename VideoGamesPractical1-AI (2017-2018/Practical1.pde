import ddf.minim.*;
float x=width/2;
float y=height/2;
float xvel=0;
float yvel=0;
float frict = 0.1;
float vel = 0.6;
float xSpeed = 5;
float ySpeed = 5;


int Healthtimer = 0;
int Speedtimer = 0;
int Weapontimer = 0;

float healthBarWidth = 50;
float MAX_HEALTH = 50;
float character_Max_Health = 1000;
float characterHealthBarWidth = 10;
public int startingHealth = 50;
final int MY_WIDTH = 800 ;
final int MY_HEIGHT = 800 ;
int testState = 0;
Character character;
AISeeker seeker;
AIBounce bounce;
int bounceDamage=30;
AIWall wall;
AITrapSetter setter;
PVector pursueTarget, direction ;
Bullet b1;
float targetX, targetY;
Bullet[] bullets = new Bullet[50];
AISeeker[] seekers = new AISeeker[25];
AIBounce[] bouncers = new AIBounce[10];
AIWall [] walls = new AIWall[10];
AITrapSetter [] setters = new AITrapSetter[15];
MineTrap [] traps = new MineTrap[50];
Explosion [] explosions = new Explosion[50];
HealthPack [] packs = new HealthPack[15];
SpeedUpgrade [] speeds = new SpeedUpgrade[15];
WeaponUpgrade [] weapons = new WeaponUpgrade[5];  
int planningTimer = 300;
int bounceNumberofSpawns = 2;
int bounceSpawnTimer = 0;
int bounceSpawncountDown = 300;
int seekerNumberofSpawns = 30;
int seekerSpawnTimer = 0;
int seekerSpawncountDown = 300;
int setterNumberofSpawns = 2;
int setterSpawnTimer = 0;
int setterSpawncountDown = 300;
int wallNumberofSpawns = 2;
int wallSpawnTimer = 0;
int wallSpawncountDown = 300;
int totalEnemyNum = 0;
int maxEnemy = 50;
float totalDamageDealt = 1;
float totalDamageTaken = 1;
float totalDamageTakenBounce = 1;
float totalDamageTakenSeeker = 1;
float totalDamageTakenWall = 1;
float totalDamageTakenSetter = 1;
int healthPackTimer = 100;
int speedUpgradeTimer = 150;
int planningAIState = 0;
int bounceState = 0;
int seekerState = 0;
int setterState = 0;
int wallState = 0;
int healthpackState = 0; //taking lots of damge
int trapState = 0; //
int speedState = 0; //taking lots of damageaa
int weaponState = 0; //not as many kills
float ratio = 0;
int score = 0;
int lives = 3;
PImage speedImage, healthImage, voidImage, weaponImage, trapImage, charLeftImage, charRightImage, seekerKamiImage, seekerSuckerImage, setterImage;
PImage turretLeftImage, turretRightImage, turretDownImage, turretUpImage, damageImage, turretDownHit, turretLeftHit, turretUpHit, turretRightHit;  
AudioPlayer player;
AudioPlayer bullet;
AudioPlayer AIdeath;
Minim minim;
boolean isLeft, isRight, isUp, isDown; 

  //This method is the setup for the processing program and is called when the program is first ran.
  void setup() {
    //Music and sounds effect files
    minim = new Minim(this);
    player = minim.loadFile("MusicP2.mp3");
    bullet = minim.loadFile("bullet.mp3");
    AIdeath = minim.loadFile("AIDeath.mp3");
    player.loop();

    //Setting the size of the window and the frame rate of the game.
    size(800, 800);
    frameRate(30);
    
    //Loading in the assets that are used in the game, from the data folder.
    speedImage = loadImage("Speed.png");
    healthImage = loadImage("health.png");
    voidImage = loadImage("void.png");
    weaponImage = loadImage("weapon.png");
    trapImage = loadImage("trap.png");
    charLeftImage = loadImage("characterleft.png");
    charRightImage = loadImage("characterright.png");
    seekerKamiImage = loadImage("seekerKami.png");
    seekerSuckerImage = loadImage("seekerSucker.png");
    setterImage = loadImage("setter.png");
    turretLeftImage = loadImage("turretLeft.png");
    turretRightImage = loadImage("turretRight.png");
    turretDownImage = loadImage("turretDown.png");
    turretUpImage = loadImage("turretUp.png");
    damageImage = loadImage("damage.png");
    turretDownHit = loadImage("turretDownHit.png");
    turretLeftHit = loadImage("turretLeftHit.png");
    turretUpHit = loadImage("turretUpHit.png");
    turretRightHit = loadImage("turretRightHit.png");
    
    //Creating character and Vectors to be used through practical
    character = new Character(MY_WIDTH/2, MY_HEIGHT/2, 0f,0f,0f,1000);
    x=width/2;
    y=height/2;
    pursueTarget = new PVector(0, 0) ;
    direction = new PVector(0, 0) ;
  }
   
  //This method is the main method of the code and is continuely looped through.
  void draw() {
    
    //Decreasing Spawn Timers for next wave of spawning.
    planningTimer--;
    bounceSpawnTimer--;
    seekerSpawnTimer--;
    setterSpawnTimer--;
    wallSpawnTimer--;
    
    //Calculating which AI is causing the most damage, then spawns twice as many of them in the next spawning phase.
    float max = 0;
    String maxName = "";
    if(totalDamageTakenBounce > max){
      max = totalDamageTakenBounce; 
      maxName = "Bounce";
    }
    if(totalDamageTakenSeeker > max){
      max = totalDamageTakenSeeker; 
      maxName = "Seeker";
    }
    if(totalDamageTakenWall > max){
      max = totalDamageTakenWall; 
      maxName = "Wall";
    }
    if(totalDamageTakenSetter > max){
      max = totalDamageTakenSetter; 
      maxName = "Setter";
    } 
    if(maxName == "Bounce"){
      bounceNumberofSpawns = bounceNumberofSpawns *2;
    }else if(maxName == "Seeker"){
      seekerNumberofSpawns = seekerNumberofSpawns *2;
    }else if(maxName == "Wall"){
      wallNumberofSpawns = wallNumberofSpawns *2;
    }else if(maxName == "Setter"){
     setterNumberofSpawns = setterNumberofSpawns *2;
    }
    
    
    //Forces enemy spawning when there are no enemies left on the screen.
     if(totalEnemyNum == 0){
      planningAIState = 0;
      seekerSpawnTimer = -1;
      setterSpawnTimer = -1;
      wallSpawnTimer= -1;
      bounceSpawnTimer = -1;
      score = score + 1000;
    }
    totalEnemyNum=0;
 
   //Spawning of the Seeker AIs. Checks if there are too many enemeies to be spawned .
   //Spawns one of the two different AI Seekers randomly, either the sucker version or the kamikaze version.
     if(seekerSpawnTimer < 0){
      for(int i = 0; i < seekerNumberofSpawns; i++){
        for(int j =0; j < seekers.length; j++){
          if(seekers[j] == null){
            if(totalEnemyNum < maxEnemy){
              float decision = random(0,1);
              if(decision <= 0.5){
              seekers[j] = new AISeeker((int)random(0, width),(int)random(0, height), 0f,1f, false);;
              }else{
              seekers[j] = new AISeeker((int)random(0, width),(int)random(0, height), 0f,1f, true);
            }
           }
            break;
          }
        }
      }
      seekerSpawnTimer = seekerSpawncountDown ;
    }
    
  if(setterSpawnTimer < 0){
      for(int i = 0; i < setterNumberofSpawns; i++){
        for(int j =0; j < setters.length; j++){
          if(setters[j] == null){
            if(totalEnemyNum < maxEnemy){
              setters[j] =  new AITrapSetter((int)random(0, width),(int)random(0, height),(int)random(0, width),(int)random(0, height), (int)random(100, 250));
            }
            break;
          }
        }
      }
      setterSpawnTimer = setterSpawncountDown ;
    }
      
  //Spawning of the Wall AIs. Checks if there are too many enemeies to be spawned .  
  if(wallSpawnTimer < 0){
      for(int i = 0; i < wallNumberofSpawns; i++){
        for(int j =0; j < walls.length; j++){
          if(walls[j] == null){
            if(totalEnemyNum < maxEnemy){
               walls[j] = new AIWall((int)random(0, width), 15, 4f, 4f);
            }
            break;
          }
        }
      }
      wallSpawnTimer = wallSpawncountDown ;
    }
    
    //Spawning of the Bouncing AIs. Checks if there are too many enemeies to be spawned .
    if(bounceSpawnTimer < 0){
      for(int i = 0; i < bounceNumberofSpawns; i++){
        for(int j =0; j < bouncers.length; j++){
          if(bouncers[j] == null){
            if(totalEnemyNum < maxEnemy){
              bouncers[j] = new AIBounce((int)random(20, width),(int)random(20, height), random(3,5), random(3,5));
            break;
            }
          }
        }
      }
      bounceSpawnTimer = bounceSpawncountDown ;
    }
    
    //Sets background colour of game.
    background(40);
    
    //Text to display score, num of lives and heath
    fill(255);
    text("Score: " + score, 10, 20);
    text("Lives: " + lives, 100, 20);
    text("Health: ", 160,20);
    if(character.health < 1){
      lives--;
      if(lives > 0){
       character.health = 1000; 
      }else{
      exit();
      }
    }
    
    //Changes the timers on the powerups depending on how much health the user is on. The lower the health the more upgrades the user gets, the more health the fewer.
    if(character.health <= 1000 && character.health > 800){
       healthPackTimer = 100; 
       speedUpgradeTimer = 150;
    }else if(character.health <= 800 && character.health > 600){
       healthPackTimer = 80;
       speedUpgradeTimer = 120;
    }else if(character.health <= 600 && character.health > 400){
      healthPackTimer = 60;
      speedUpgradeTimer = 90;
    }else if(character.health <= 400 && character.health > 200){
      healthPackTimer = 40;
      speedUpgradeTimer = 60;
    }else if(character.health <= 200 && character.health > 0){
      healthPackTimer = 20;
      speedUpgradeTimer = 30;
    }
   
   //Works out the difficulty of the current game the user is in, by calculating a ratio of damage taken to given, the more damage recieved to given the easier the game is made.
   //It changes the states in the indivdual AIs to make them easier or harder, depending on how the user is doing.
   ratio = totalDamageTaken/totalDamageDealt;
   if(planningTimer < 0){
   if(ratio <= 0.4){
      planningAIState = 4;
   }else if(ratio > 0.2 && ratio <= 0.4){
     planningAIState = 3;
   }else if(ratio > 0.4 && ratio <= 0.6){
     planningAIState = 2; 
   }else if(ratio > 0.6 && ratio <= 0.8){
     planningAIState = 1; 
   }else if(ratio > 0.8 && ratio <= 1.2){
     planningAIState = 0;
   }else if(ratio >1.2){
    planningAIState = 5; 
   }
   
   //Resetting the values to stop AI getting stuck in a state.
   ratio = 0;
   totalDamageTaken = 0;
   totalDamageDealt = 0;
   totalDamageTakenBounce = 1;
   totalDamageTakenSeeker = 1;
   totalDamageTakenWall = 1;
   totalDamageTakenSetter = 1;
   planningTimer = 300;
   }
  
    //Main swtich statement that sets the values of all the AIs spawn rates and how many of them
    //Also sets the states that each AI is in.
    switch(planningAIState){
     case 0:
      bounceNumberofSpawns = 1;
      bounceSpawncountDown = 1200;
      seekerNumberofSpawns = 15;
      seekerSpawncountDown = 1200;
      setterNumberofSpawns = 1;
      setterSpawncountDown = 1200;
      wallNumberofSpawns = 1;
      wallSpawncountDown = 1200;
      bounceState = 0;
      seekerState = 0;
      setterState = 0;
      wallState = 0;
      break;
     
     case 1:
      bounceNumberofSpawns = 2;
      bounceSpawncountDown = 1000;
      seekerNumberofSpawns = 2;
      seekerSpawncountDown = 1000;
      setterNumberofSpawns = 2;
      setterSpawncountDown = 1000;
      wallNumberofSpawns = 2;
      wallSpawncountDown = 1000;
      bounceState = 1;
      seekerState = 1;
      setterState = 1;
      wallState = 1;
       break;
     
     case 2:
      bounceNumberofSpawns = 3;
      bounceSpawncountDown = 800;
      seekerNumberofSpawns = 3;
      seekerSpawncountDown = 800;
      setterNumberofSpawns = 3;
      setterSpawncountDown = 800;
      wallNumberofSpawns = 3;
      wallSpawncountDown = 800;
      bounceState = 2;
      seekerState = 2;
      setterState = 2;
      wallState = 2;
       break;
       
     case 3:
      bounceNumberofSpawns = 3;
      bounceSpawncountDown = 600;
      seekerNumberofSpawns = 3;
      seekerSpawncountDown = 1000;
      setterNumberofSpawns = 3;
      setterSpawncountDown = 1000;
      wallNumberofSpawns = 3;
      wallSpawncountDown = 600;
      bounceState = 3;
      seekerState = 3;
      setterState = 3;
      wallState = 3;
       break;
       
     case 4:
      bounceNumberofSpawns = 4;
      bounceSpawncountDown = 500;
      seekerNumberofSpawns = 4;
      seekerSpawncountDown = 500;
      setterNumberofSpawns = 4;
      setterSpawncountDown = 500;
      wallNumberofSpawns = 4;
      wallSpawncountDown = 800;
      bounceState = 4;
      seekerState = 4;
      setterState = 4;
      wallState = 4;
       break;
     
     case 5:
      bounceNumberofSpawns = 1;
      bounceSpawncountDown = 1000;
      seekerNumberofSpawns = 15;
      seekerSpawncountDown = 1000;
      setterNumberofSpawns = 1;
      setterSpawncountDown = 1000;
      wallNumberofSpawns = 1;
      wallSpawncountDown= 1000;
    }

//Below is where each of the methods in the program are called.


    //This method spawns healthpacks in random positions in the game when the spawntime is 0 for healthpacks.
    healthPackUpdate();
    
    //This method spawns speed power-ups in random positions in the game when the spawntime is 0 for speed power-ups.
    speedBoostUpdate();
    
    //This method spawns weapon power-ups in random positions in the game when the spawntime is 0 for weapon power-ups.
    weaponBoostUpdate();
    
    //This method reduces the age of all the powerups and the length of time left that the already picked up power-ups have left on the user.
    timerUpdates();
    
    //This method draws the character in the game correspinding to its current position.
    drawCharacter();
    
    //This method checks whether or not the character has collided with the Seeker. If the seeker is a kamikaze version then the seeker dies
    //This method also takes the damage away from the user for the above line.
    //This method displays the health bars of the seekers on the screen.
    //Finally the method works out where the character is heading and choose which bevaour of the seeker will be chosen, flocking or normal seeking
    seekersUpdate();
    
    //This method checks if the setter has reached its random destination and if it has it spawns a trap.
    //This method displays the health bars of the setters on the screen.
    settersUpdate();
    
    //This method checks if the age of the traps are low enough for them to explode and create an explosion
    trappersUpdate();
    
    //This method displays the explosions on the screen and then checks if that character is in any of them, if the character is then it takes health away from the character.
    explosionsUpdate();
    
    //This method checks whether or not the character has collided with the bouncer, it takes health away if it has and destroys the bouncer.
    //This method displays the health bars of the bouncer on the screen.
    bouncersUpdate();
    
    //Displays a different orientation of the wall AI depending on what rail it is on.
    //This method displays the health bars of the walls AI on the screen.
    //Finally this method checks if the wall AI is allowed to shoot again and creats a bullet.
    //The bullet is random if the user is on a lower difficulty and shoots the player the game is on a harder difficulty.
    wallsUpdate();
    
    //This method displays the healthpack on the screen.
    healthPacksUpdate();
    
    //This method displays the speed power up on the screen.
    speedPowerUpdate();
    
    //This method displays the weapon power up on the screen.
    weaponPowerUpdate();
    
    //This method calls all the different bullet collisions there can be. There is a method for each of the things the bullets can hit. Each of them check if there has been a collission
    //between the bullet and the AI which has a circular hitbox. If the AI has no health left it is removed from the screen with a sounds effect.
    bulletCollisions();
    
    //This method updates the postion of the character on the screen.
    character.update(isLeft, isRight, isUp, isDown);
   
  }
  
  void bulletCollisions(){
    for(int i =0; i < bullets.length; i ++){
      if(bullets[i]!=null){
        bullets[i].bulletUpdate();
      }
      if(bullets[i]!=null && bullets[i].character){
        for(int j = 0; j < seekers.length; j++){
          if(bullets[i] != null && seekers[j] != null){
            if(detectCollisionS(bullets[i], seekers[j])){
              bullets[i] = null;
              if(seekers[j].health > 0){
               seekers[j].health  = seekers[j].health - character.weaponPower;
               totalDamageDealt = totalDamageDealt + character.weaponPower;
               image(damageImage, seekers[j].position.x, seekers[j].position.y, 30, 30);
              }
            if(seekers[j].health <= 0){
              totalEnemyNum--;
              AIdeath.play();
              AIdeath.rewind();
              score += 30;
              seekers[j] = null;
            } 
            }
          }
        }
        for(int k = 0; k < walls.length; k++){
          if(bullets[i] != null && walls[k] != null){
            if(detectCollisionW(bullets[i], walls[k])){
             bullets[i] = null;
             if(walls[k].health > 0){
               walls[k].health  = walls[k].health - character.weaponPower;
               totalDamageDealt = totalDamageDealt + character.weaponPower;
               if(walls[k].rail == 0){
                 image(turretDownHit, walls[k].position.x,walls[k].position.y-15, 30, 30);
               }else if(walls[k].rail == 1){
                 image(turretLeftHit, walls[k].position.x-15,walls[k].position.y, 30, 30);
               }else if(walls[k].rail == 2){
                 image(turretUpHit, walls[k].position.x, walls[k].position.y -15, 30, 30);
               }else{
                 image(turretRightHit, walls[k].position.x-15, walls[k].position.y, 30, 30);     
               }
             }
            if(walls[k].health <= 0){
              totalEnemyNum--;
              AIdeath.play();
              AIdeath.rewind();
              walls[k] = null;
              score+=20;
            }
          }
        }
      }

      for(int g =  0; g < setters.length; g++){
        if(bullets[i] != null && setters[g] != null){
          if(detectCollisionTrap(bullets[i], setters[g])){
            bullets[i] = null;
            if(setters[g].health > 0){
              setters[g].health  = setters[g].health - character.weaponPower;
              totalDamageDealt = totalDamageDealt + character.weaponPower;
              image(damageImage, setters[g].position1.x, setters[g].position1.y, 20, 20);
            }
            if(setters[g].health <= 0){
              totalEnemyNum--;
              AIdeath.play();
              AIdeath.rewind();
              setters[g] = null;
              score+=20;
            }
            }
          }
        }
        
      for (int m = 0; m < bouncers.length; m++) {
       if (bullets[i] != null && bouncers[m] != null) {
        if (detectCollisionB(bullets[i], bouncers[m])) {
          bullets[i] = null;
          if (bouncers[m].health > 0) {
            bouncers[m].health  = bouncers[m].health - character.weaponPower;
            totalDamageDealt = totalDamageDealt + character.weaponPower;
            fill(255);
            ellipse(bouncers[m].position.x, bouncers[m].position.y, 20, 20); 
          }
          if (bouncers[m].health <= 0) {
            totalEnemyNum--;
            AIdeath.play();
            AIdeath.rewind();
            bouncers[m] = null;
          }
        }
      }
    }     
   }

   if(bullets[i] != null){
      fill(200);
      ellipse(bullets[i].position.x, bullets[i].position.y, 5, 5);
   }
      
   if(bullets[i] != null && !bullets[i].character){
      if(detectCollisionCharacterBullet(bullets[i])){
         bullets[i] = null;
         character.health = character.health - powerWall;
         totalDamageTaken = totalDamageTaken + powerWall;
         totalDamageTakenWall = totalDamageTakenWall + powerWall;
      }
      if(bullets[i] != null){
        fill(200);
        ellipse(bullets[i].position.x, bullets[i].position.y, 5, 5);
      }
   }
   if(bullets[i] != null){
      if(bullets[i].position.x > width || bullets[i].position.x < 0 || bullets[i].position.y > height || bullets[i].position.y < 0){
         bullets[i] = null;
       }   
    }  
  }
 }

  void weaponPowerUpdate(){
    for(int i =0; i < weapons.length; i++){
      if(weapons[i] != null){
        fill(0,255,255);
        image(weaponImage, weapons[i].position.x, weapons[i].position.y, 30, 30);
        weapons[i].timer--;
        if(weapons[i].timer < 1){
          weapons[i] = null;
        }
      }
    }
  
    for(int i =0; i < weapons.length; i++){
      if(weapons[i] != null){
        if(detectCollisionWeapon(weapons[i])){
          weapons[i] = null;
         }
      }
    }
 }
  
 void speedPowerUpdate(){
  for(int i =0; i < speeds.length; i++){
    if(speeds[i] != null){
      fill(255,0,255);
      image(speedImage, speeds[i].position.x, speeds[i].position.y, 30, 30);
      speeds[i].timer--;
      if(speeds[i].timer < 1){
        speeds[i] = null;
      }
    }
  }
  for(int i =0; i < speeds.length; i++){
    if(speeds[i] != null){
       if(detectCollisionSpeed(speeds[i])){
          speeds[i] = null;
       }
    }
  }  
 }
   
  void healthPacksUpdate(){
   for(int i =0; i < packs.length; i++){
    if(packs[i] != null){
      fill(255,255,0);
      image(healthImage, packs[i].position.x, packs[i].position.y, 30, 30);
      packs[i].timer--;
      if(packs[i].timer < 1){
        packs[i] = null;
      }
    }
  }
  
  for(int i =0; i < packs.length; i++){
    if(packs[i] != null){
      if(detectCollisionH(packs[i])){
         packs[i] = null;
       }
    }
  }
 }
  
  
 void bouncersUpdate(){
   for(int j = 0; j < bouncers.length; j++){
     if(bouncers[j] != null){
        totalEnemyNum++;
        if(detectCollisionBounceChar(bouncers[j])){
           character.health = character.health - bounceDamage;
           totalDamageTaken = totalDamageTaken + bounceDamage;
           totalDamageTakenBounce = totalDamageTakenBounce + bounceDamage;
           AIdeath.play();
           AIdeath.rewind();
           bouncers[j] = null;
         }
      }
    }

  for(int i = 0; i < bouncers.length; i++){
    if(bouncers[i] != null){
      bouncers[i].AIBounceUpdate(bounceState);
      fill(0,255,0);
      ellipse(bouncers[i].position.x, bouncers[i].position.y, 20, 20); 
      noStroke();
      float healthPercentage = bouncers[i].health / MAX_HEALTH;
      float drawWidth = (healthPercentage) * healthBarWidth;
      if(healthPercentage <= 1 && healthPercentage > 0.7){
        fill(0,255,0);
      }else if(healthPercentage <= 0.7 && healthPercentage > 0.3){
        fill(255,255,0);
        rect(bouncers[i].position.x + 15, bouncers[i].position.y + 15, drawWidth, 5);
      }else{
         fill(255,0,0); 
       rect(bouncers[i].position.x + 15, bouncers[i].position.y + 15, drawWidth, 5);
    }
    }
  }

  }
  
  void wallsUpdate(){
    for(int i = 0; i < walls.length; i++){
      if(walls[i] != null){
        totalEnemyNum++;
        walls[i].AIWallUpdate(wallState);
        if(walls[i].rail == 0){
          image(turretDownImage, walls[i].position.x,walls[i].position.y-15, 30, 30);
        }else if(walls[i].rail == 1){
          image(turretLeftImage, walls[i].position.x-15,walls[i].position.y, 30, 30);
        }else if(walls[i].rail == 2){
          image(turretUpImage, walls[i].position.x, walls[i].position.y -15, 30, 30);
        }else{
          image(turretRightImage, walls[i].position.x-15, walls[i].position.y, 30, 30);     
       } 
      noStroke();
      float healthPercentage = walls[i].health / MAX_HEALTH;
      float drawWidth = (healthPercentage) * healthBarWidth;
      if(healthPercentage <= 1 && healthPercentage > 0.7){
        fill(0,255,0);
      }else if(healthPercentage <= 0.7 && healthPercentage > 0.3){
        fill(255,255,0);
        rect(walls[i].position.x + 15, walls[i].position.y + 15, drawWidth, 5);
      }else{
       fill(255,0,0); 
       rect(walls[i].position.x + 15, walls[i].position.y + 15, drawWidth, 5);
      }
      
     if(walls[i].shootTimer < 0){
        walls[i].shootTimer = (int)random(200, 400);
        for(int j= 0; j < bullets.length; j++){
          if(bullets[j] == null){
            if(walls[i].currentState <= 2 || walls[i].currentState == 5){
              b1 = new Bullet(walls[i].position.x, walls[i].position.y, (int)random(width), (int)random(height), false);
            }else if(walls[i].currentState > 2 && walls[i].currentState < 5){
              b1 = new Bullet(walls[i].position.x, walls[i].position.y, character.position.x, character.position.y, false);
            }
             bullets[j] = b1;
             break;
          }
        }     
      }    
    }         
  } 
 }

 void explosionsUpdate(){
   for(int i = 0; i < explosions.length; i++){
     if(explosions[i] != null){
       explosions[i].update();
       fill(100,100,100);
       image(voidImage, explosions[i].position.x -  explosions[i].radius/3, explosions[i].position.y -  explosions[i].radius/3, explosions[i].radius, explosions[i].radius);
       if(explosions[i].radius < 1){
         explosions[i] = null;
       }
     }
  }
  
  for(int i = 0; i < explosions.length; i++){
      if(explosions[i] != null){
         if(detectCollisionCExplosion(character, explosions[i])){
           character.health = character.health - voidDamage;
           totalDamageTaken = totalDamageTaken + voidDamage;
           totalDamageTakenSetter = totalDamageTakenSetter+ voidDamage;
         }
      }
    }    
  }

 void seekersUpdate(){
   for(int j = 0; j < seekers.length; j++){
     if(seekers[j] != null){
       totalEnemyNum++;
       if(detectCollisionCS(character, seekers[j])){
         if(seekers[j].sucker){
           character.health = character.health - suckerDamage;
           totalDamageTaken = totalDamageTaken + suckerDamage;
           totalDamageTakenSeeker = totalDamageTakenSeeker + suckerDamage;
         }else{
             character.health  = character.health - kamikazeDamage;
             totalDamageTaken = totalDamageTaken + kamikazeDamage;
             totalDamageTakenSeeker = totalDamageTakenSeeker + kamikazeDamage;
             seekers[j] = null;
         }
       }
     }
   }

  for(int i = 0; i < seekers.length; i++){
    if(seekers[i] != null){
      float xt = seekers[i].position.x, yt = seekers[i].position.y ;
      fill(0) ;
      if(seekers[i].sucker){
        image(seekerSuckerImage, xt, yt, 30, 30) ;
      }else{
        image(seekerKamiImage, xt, yt, 30, 30) ;
      }
    noStroke();
    float healthPercentage = seekers[i].health / MAX_HEALTH;
    float drawWidth = (healthPercentage) * healthBarWidth;
    if(healthPercentage <= 1 && healthPercentage > 0.7){
      fill(0,255,0);
    }else if(healthPercentage <= 0.7 && healthPercentage > 0.3){
      fill(255,255,0);
      rect(seekers[i].position.x + 15, seekers[i].position.y + 15, drawWidth, 5);
    }else{
     fill(255,0,0); 
     rect(seekers[i].position.x + 15, seekers[i].position.y + 15, drawWidth, 5);
    }

    direction.x = character.position.x  - xt ;
    direction.y = character.position.y - yt ;
    float distance = direction.mag() ;
    float speed = seekers[i].velocity.mag() ;
    float prediction = distance / speed ;
    
    pursueTarget = character.velocity.get() ;
    pursueTarget.mult(prediction) ;
    pursueTarget.add(character.position) ;
    line(character.position.x, character.position.y, 
         pursueTarget.x, pursueTarget.y) ;
    
    int counter = 0;
    for(int p = 0; p < seekers.length; p++){
      if(seekers[p] != null){
        counter++;
      }
    }

    if(counter < 10){
      seekers[i].integrate(pursueTarget, 0, character.position, testState) ;
    }else{    
      seekers[i].run(seekers, pursueTarget);
    }
  }
 }  
}

 void trappersUpdate(){
   for(int i = 0; i < traps.length; i++){
    if(traps[i] != null){
      totalEnemyNum++;
      image(trapImage, traps[i].position.x, traps[i].position.y, 30,30);
      traps[i].update();
      if(traps[i].age < 0){
        for(int j = 0; j < explosions.length; j++){
          if(explosions[j] == null){
            Explosion ex = new Explosion(traps[i].position.x+15, traps[i].position.y+20, 1);
            explosions[j] = ex;
            break;
          }
        }
       traps[i] = null;
      }
    }
  }
 }
    
 void settersUpdate(){   
  for(int i = 0; i < setters.length; i ++){
    if(setters[i] != null){
      fill(255,14,127);
      setters[i].update(setterState);
      image(setterImage, setters[i].position1.x, setters[i].position1.y, 20, 20);   
      noStroke();
      float healthPercentage = setters[i].health / MAX_HEALTH;
      float drawWidth = (healthPercentage) * healthBarWidth;
      if(healthPercentage <= 1 && healthPercentage > 0.7){
        fill(0,255,0);
      }else if(healthPercentage <= 0.7 && healthPercentage > 0.3){
        fill(255,255,0);
        rect(setters[i].position1.x + 15, setters[i].position1.y + 15, drawWidth, 5);
      }else{
       fill(255,0,0); 
       rect(setters[i].position1.x + 15, setters[i].position1.y + 15, drawWidth, 5);
      }

      if(setters[i].position1.x <= setters[i].position2.x + 1 && setters[i].position1.x >= setters[i].position2.x - 1 
        && setters[i].position1.y <= setters[i].position2.y + 1 && setters[i].position1.y >= setters[i].position2.y - 1){
              setters[i].position1 = setters[i].position2;
              setters[i].position2 = new PVector((int)random(0,width), (int)random(0,height));
      }
      
      if(setters[i].timer < 0){
        setters[i].timer = (int)random(100, 250);
        for(int j= 0; j < traps.length; j++){
          if(traps[j] == null){
             MineTrap trap = new MineTrap(setters[i].position1.x, setters[i].position1.y, 80); 
             traps[j] = trap;
             break;
          }
        }   
      }
    }   
  }   
 }
    
 void drawCharacter(){
  float xe = character.position.x, ye = character.position.y ;
  fill(255,0,0) ;
  if(character.velocity.x < 0){
    image(charLeftImage,xe, ye, 30, 30);
  }else{
    image(charRightImage,xe, ye, 30, 30);
  }
  fill(0);
  fill(50);
  noStroke();
  float healthPercentage = character.health / character_Max_Health;
  float drawWidth = (healthPercentage) * healthBarWidth;
  if(healthPercentage <= 1 && healthPercentage > 0.7 || healthPercentage > 1){
    fill(0,255,0);
  }else if(healthPercentage <= 0.7 && healthPercentage > 0.3){
    fill(255,255,0);
  }else{
   fill(255,0,0); 
  }
  rect(200, 12, drawWidth, 10);
 }
 
 boolean detectCollisionTrap(Bullet b1, AITrapSetter s1){
  PVector bullet = new PVector(b1.position.x, b1.position.y);
  bullet.sub(s1.position1);
  if(bullet.mag() < 17.5){
    return true;
  }
    return false;  
 }

 boolean detectCollisionWeapon(WeaponUpgrade p1){ 
  PVector pos = character.position;
  PVector p2 = p1.position;
    if(pos.x >= p2.x - 25 && pos.x < (p2.x + 35)){
      if(pos.y >= p2.y - 25 && pos.y < (p2.y + 35)){
        character.weapontimer = 50;
        return true;
      }
    }
    return false;
  }
  
 boolean detectCollisionSpeed(SpeedUpgrade p1){
  PVector pos = character.position;
  PVector p2 = p1.position;
  if(pos.x >= p2.x - 25 && pos.x < (p2.x + 35)){
    if(pos.y >= p2.y - 25 && pos.y < (p2.y + 35)){
      character.speedtimer = 50;
      return true;
    }
  }
  return false;
 }
  

boolean detectCollisionH(HealthPack p1){
  PVector pos = character.position;
  PVector p2 = p1.position;
  if(pos.x >= p2.x - 25 && pos.x < (p2.x + 35)){
    if(pos.y >= p2.y - 25 && pos.y < (p2.y + 35)){
      character.health = character.health + 50;
      return true;
    }
  }
  return false;
}

boolean detectCollisionS(Bullet b1, AISeeker s1){
  PVector bullet = new PVector(b1.position.x, b1.position.y);
  bullet.sub(s1.position);
  if(bullet.mag() < 17.5){
    return true;
  }
  return false;   
}


 boolean detectCollisionCExplosion(Character c1, Explosion e1){
  PVector character = new PVector(c1.position.x, c1.position.y);
  character.sub(e1.position);
  if(character.mag() < e1.radius/2){
    return true;
  }else{
     return false; 
  }
}
  
boolean detectCollisionBounceChar(AIBounce b1){
  PVector c1 = new PVector(character.position.x, character.position.y);
  c1.sub(b1.position);
  if(c1.mag() < 25){
    return true;   
  }
  return false;
}

boolean detectCollisionCS(Character c1, AISeeker s1){
  PVector character = new PVector(c1.position.x, c1.position.y);
  character.sub(s1.position);
  if(character.mag() < 30){
    return true;
  }else{
   return false; 
  }
}

boolean detectCollisionB(Bullet b1, AIBounce ab1){
  PVector bullet = new PVector(b1.position.x, b1.position.y);
  bullet.sub(ab1.position);
  if(bullet.mag() < 12.5){
    return true;
  }else{
    return false;
  } 
}
  
boolean detectCollisionW(Bullet b1, AIWall w1){
 PVector bullet = new PVector(b1.position.x, b1.position.y);
 bullet.sub(w1.position);
 if(bullet.mag() < 17.5){
    return true;
 }else{
   return false;
 }
}
    
 boolean detectCollisionCharacterBullet(Bullet b1){     
   PVector bullet = new PVector(b1.position.x, b1.position.y);
   bullet.sub(character.position);
   if(bullet.mag() < 17.5){
     return true;
    }else{  
      return false;
    }
 }
    
 void healthPackUpdate(){
   if(Healthtimer < 0){
     for(int i = 0; i < packs.length; i ++){
       if(packs[i] == null){
          packs[i] = new HealthPack((int)random(0, width),(int)random(0, height), (int)random(300,400));
          Healthtimer = healthPackTimer;
          break;
        }
      }
    }      
  }
    
 void speedBoostUpdate(){
   if(Speedtimer == 0){
     for(int i = 0; i < speeds.length; i ++){
       if(speeds[i] == null){
          speeds[i] = new SpeedUpgrade((int)random(0, width),(int)random(0, height), (int)random(300,400));
          Speedtimer = speedUpgradeTimer;
          break;
        }
      }
   }
 }
    
void weaponBoostUpdate(){
  if(Weapontimer == 0){
    for(int i = 0; i < weapons.length; i ++){
      if(weapons[i] == null){
        weapons[i] = new WeaponUpgrade((int)random(0, width),(int)random(0, height), (int)random(300,400));
        Weapontimer = (int)random(30, 80);
        break;
       }
    }
  }      
}
    
    
void timerUpdates(){
  if(character.speedtimer > 0){
    character.speedtimer--;
   } 
  if(character.weapontimer > 0){
    character.weapontimer--;
  }
  Healthtimer--;
  Speedtimer--;
  Weapontimer--;    
}
     
   
 //This method is called when the mouse is pressed, it creates a bullet in the direction of where the mouse was clicked.
 void mousePressed(){
   bullet.play();
   bullet.rewind();
   targetX = mouseX;
   targetY = mouseY;
   b1 = new Bullet(character.position.x, character.position.y, targetX, targetY, true);
   for(int i =0; i < bullets.length; i ++){
     if(bullets[i]==null){
        bullets[i] = b1;
        return;
      }
    }        
}
  
   
 void keyPressed() {
   setMove(keyCode, true);
 }
   
 void keyReleased() {
   setMove(keyCode, false);
 }
   
  //Sets what keys have been pressed in order for the character.update to move the character propely.
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
   
   default:
     yvel = 0;
      xvel = 0;
      return b;
    }
  }