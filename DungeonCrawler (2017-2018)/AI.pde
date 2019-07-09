int aIMaxSpeed = 2;

//AI class which holds fields and methods needed by more than one AI character
abstract class AI extends Character {

  public int damage = 1;
  PImage image;
  boolean shootsBullets;
  public PVector linear ;
  public float MAX_SPEED1 = 1 ;
  float maxSpeed = 2;
  public float orientation;
  int timer=0;
  int viewRadius;
  boolean isCluster = false;
  float MAX_ACCEL = 0.1f ;
  int bulletSize;
  PVector acceleration = new PVector(0,0);
  float maxforce = 0.3;
  PVector defaultVector = new PVector(0, 0);
  int AIType; //0 = AIBossStun, 1 = AIRandom, -1 other, 2 = AIBossSplit, 3 = AIBossCombo

  //constructor to set up values and call the Character constructor
  AI(float size, Room room, float weaponDamage, PImage image, int viewRadius, boolean shootsBullets, float aiHealth, boolean isCluster, float speed, int AIType, Boolean ifBoss, float collisionDamage) {
    super(aiHealth, aIMaxSpeed, size, room, weaponDamage, ifBoss, collisionDamage);
    this.image = image;
    this.shootsBullets = shootsBullets;
    this.viewRadius = viewRadius;
    this.isCluster = isCluster;
    this.maxSpeed = speed;
    this.AIType = AIType;
    this.ifBoss = ifBoss;
    this.collisionDamage = collisionDamage;
  }
  
  //empty method as each AI charcater has their own "integrate" method
  void integrate() {
  }

  //Updates stats for AIs, mainly for the AI's health (if it has been hit by the player's bullet)
  void updateAIStats() {
    Bullet[] bullets = level.bullets;
    for (int i=0; i<bullets.length; i++) {
      if (bullets[i] == null) continue;
      if (checkCollision(bullets[i].position, bullets[i].size, bullets[i].size)) {
        if (AIType == 2 && size>30) splitAI(); 
        else if (AIType == 3 && size>30) splitAICombo();
        else {
          takeDamage(characterWeaponPower);
          level.totalDamageDealt+=characterWeaponPower;
        }
        player.score+=characterWeaponPower;
        bullets[i] = null;
        if (!room.activateClusters) { //if a AI has been hit, set activate clusters to true
          room.activateClusters = true;
        }
      }
    }
  }

  //check if AI hits block
  public boolean checkForBlock() {
    PVector vel = velocity.copy();
    vel.normalize() ; 
    vel.mult(25) ;
    boolean noBlock = true;
    if (!level.checkBlocksI(vel, position, size)) {
      noBlock = false;
      velocity.x = -velocity.x;
    }
    if (!level.checkBlocksJ(vel, position, size)) {
      velocity.y = -velocity.y;
      noBlock = false;
    }
    position.add(velocity);
    return noBlock;
  }

  //method to make an AI walk randomly
  public void walkRandomly() {

    velocity.x = cos(orientation) ;
    velocity.y = sin(orientation) ;

    velocity.normalize();
    velocity.mult(MAX_SPEED1) ;

    if (!level.checkBlocks(velocity, position, size) || outOfBounds(velocity, position, size)) {
      orientation -= PI/2;
      velocity.x = velocity.x * -1;
      velocity.y = velocity.y * -1;
    } 
    position.add(velocity);
    // randomly update orientation a little
    orientation += random(0, PI/32) - random(0, PI/32) ;
  }

  //checks if the player is in the AI's view radius
  public boolean checkIfPlayerInView() {
    PVector aiPosition = position.copy();
    PVector playerPosition = player.position.copy();
    PVector newVelocity = PVector.sub(playerPosition, aiPosition);
    if (newVelocity.mag() < viewRadius) {
      return true;
    } else return false;
  }

  //method to make AI walk towards the player
  public void walkTowardsPlayer(float maxSpeed) {
    PVector linear = new PVector();
    position.add(velocity);
    linear.x = player.position.x - position.x ;
    linear.y = player.position.y - position.y ;

    if (linear.mag() < 400) { //line of sight?
      linear.normalize() ;
      velocity.add(linear) ;
      if (velocity.mag() > maxSpeed) {
        velocity.normalize() ; 
        velocity.mult(maxSpeed) ;
      }
    } else {
      linear.normalize() ;
      linear.mult(MAX_ACCEL) ;
      velocity.add(linear) ;
      if (velocity.mag() > MAX_SPEED1) {
        velocity.normalize() ; 
        velocity.mult(MAX_SPEED1);
      }
    }
  }

  //split the AI split boss in half (also reduce weapon damage and size of new AIs)
  void splitAI() {
    int numBaddies = room.baddies.length;
    AI[] newBaddies = new AI[numBaddies + 1];
    for (int i=0; i<room.baddies.length; i++) {
      newBaddies[i] = room.baddies[i];
    }
    newBaddies[room.baddies.length] = new AIBossSplit(room, level.maxAISpeed, size/2);
    room.numberSplitters ++;
    newBaddies[room.baddies.length].weaponDamage =  newBaddies[room.baddies.length].weaponDamage/2;
    weaponDamage = weaponDamage/2;
    size = size/2;
    room.baddies = newBaddies;
  }

  //split the AI combo boss in half (also reduce weapon damage and size of new AIs)
  void splitAICombo() {
    int numBaddies = room.baddies.length;
    AI[] newBaddies = new AI[numBaddies + 1];
    for (int i=0; i<room.baddies.length; i++) {
      newBaddies[i] = room.baddies[i];
    }
    newBaddies[room.baddies.length] = new AIBossCombo(room, level.maxAISpeed, size/2);
    newBaddies[room.baddies.length].bulletSize /= 2;
    newBaddies[room.baddies.length].maxSpeed -= 0.75;
    maxSpeed -= 0.75;
    room.numberSplitters ++;
    newBaddies[room.baddies.length].weaponDamage = newBaddies[room.baddies.length].weaponDamage/2;
    weaponDamage = weaponDamage/2;
    bulletSize /= 2;
    size = size/2;
    room.baddies = newBaddies;
  }

  //method to make the AI run towards player and implement flocking algorithm
  public void run(AI[] baddies) {
    flocking(baddies);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration = new PVector(0, 0);
    if ((position.x < 0) || (position.x + size > width - stoneWidthRoom)) velocity.x = -velocity.x ;
    if ((position.y < 0) || (position.y + size > height - stoneWidthRoom)) velocity.y = -velocity.y ;
  }

  //method to implement flocking algorithm
  void flocking(AI[] baddies) {
    PVector separation = separate(baddies);
    PVector allign = allignment(baddies);
    PVector cohesion = cohesionFunc(baddies);

    separation.mult(1.5);
    allign.mult(1);
    cohesion.mult(1);

    acceleration.add(separation);
    acceleration.add(allign);
    acceleration.add(cohesion);
  }

  //implement separation value in flocking algorithm
  PVector separate(AI[] baddies) {
    float space = 20;
    PVector factor = new PVector(0, 0, 0);
    int count = 0;
    for (int i = 0; i < baddies.length; i++) {
      if (baddies[i] != null) {
        float distance  = PVector.dist(position, baddies[i].position);  
        if (distance > 0 && distance < space) {
          PVector gap = PVector.sub(position, baddies[i].position);
          gap.normalize();
          gap.div(distance);        
          factor.add(gap);
          count++;
        }
      }
    }
    if (count != 0) {
      factor.div((float)count);
    }
    // As long as the vector is greater than 0
    if (factor.mag() > 0) {
      factor.setMag(maxSpeed);
      factor.sub(velocity);
      factor.limit(maxforce);
    }
    return factor;
  }

  //implement allignment value in flocking algorithm
  PVector allignment(AI[] baddies) {
    float desiredseparation = 50;
    PVector runningTotal = new PVector(0, 0);
    int counter = 0;
    for ( int i = 0; i < baddies.length; i++) {
      if (baddies[i] != null) {
        float distance = PVector.dist(position, baddies[i].position);
        if (distance > 0 && distance < desiredseparation) {
          runningTotal.add(baddies[i].velocity);
          counter++;
        }
      }
    }
    if (counter > 0) {
      runningTotal.div((float)counter);
      runningTotal.setMag(maxSpeed);
      PVector factor = PVector.sub(runningTotal, velocity);
      factor.limit(maxforce);
      return factor;
    } else {
      return defaultVector;
    }
  }

  //implement cohesion function in flocking algorithm
  PVector cohesionFunc(AI[] baddies) {
    float desiredseparation = 5000;
    PVector runningTotal = new PVector(0, 0);
    int counter = 0;
    for (int i = 0; i < baddies.length; i++) {
      if (baddies[i] != null) {
        float distance = PVector.dist(position, baddies[i].position);
        if (distance > 0 && distance < desiredseparation) {
          runningTotal.add(baddies[i].position);
          counter++;
        }
      }
    }
    if (counter > 0) {
      runningTotal.div(counter);
      PVector find = find(new PVector(player.position.x, player.position.y));
      return find;
    } else {
      return defaultVector;
    }
  }

  //find target PVector
  PVector find(PVector target) {
    PVector desired = PVector.sub(target, position);  
    desired.setMag(maxSpeed);
    PVector factor = PVector.sub(desired, velocity);
    factor.limit(maxforce); 
    return factor;
  }
}