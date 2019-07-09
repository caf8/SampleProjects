final float SAT_RADIUS = 0.1f;
float healthBarWidth = 30;

//class which includes player and AIs
abstract class Character {

  public PVector position, velocity;
  float maxHealth;
  float health;
  int maxSpeed = 3;
  float size;
  float weaponDamage;
  float collisionDamage;
  Room room;
  boolean ifBoss;
  boolean isStunned = false;
  int stunnedTimer = 0;
  boolean hasKey = false;

  Character(float health, int maxSpeed, float size, Room room, float weaponDamage, boolean ifBoss, float collisionDamage) {
    velocity = new PVector(0, 0);
    this.health = health;
    maxHealth = health;
    this.maxSpeed = maxSpeed;
    this.size = size;
    this.weaponDamage = weaponDamage;
    this.collisionDamage = collisionDamage;
    if (!ifBoss) {
      position = room.createStartingPosition();
    } else {
      position = new PVector(400, 400); //Bosses always start in middle of the room
    }
    this.room = room;
  }


  void setPosition(int x, int y) {
    position.x = x;
    position.y = y;
  }

  //check if another character is on top of another
  boolean twoCharactersEqual(Character c) {
    if ((abs(position.x - c.position.x) < 10) && (abs(position.y - c.position.y) < 10)) {
      return true;
    } else {
      return false;
    }
  }

  //check if the character walks into block
  boolean checkNoBlock(PVector positionToCheck) {
    int i = level.getCurrentBlockI(positionToCheck);
    int j = level.getCurrentBlockJ(positionToCheck);

    if (level.currentRoom.map[i][j]) {
      return false;
    } else return true;
  }

  //decrease the health
  void takeDamage(float damage) {
    //print("health: " + health);
    health = health-damage;
  }



  //Display the health bar of the character (different according to which character)
  void displayHealth(boolean isThePlayer) {
    noStroke();
    float healthPercentage = health / maxHealth;
    float drawWidth = (healthPercentage) * healthBarWidth;
    if (healthPercentage <= 1 && healthPercentage > 0.7) {
      fill(0, 255, 0);
    } else if (healthPercentage <= 0.7 && healthPercentage > 0.3) {
      fill(255, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    if (isThePlayer) {
      rect(position.x + 20, position.y + size-5, drawWidth, 5);
    } else  if (ifBoss) {
      drawWidth = (healthPercentage) * size;
      rect(position.x, position.y + size + 15, drawWidth, 10);
    } else {
      rect(position.x, position.y + size + 5, drawWidth, 2);
    }
  }

  //check if there is a collision which a bullet or object
  boolean checkCollision(PVector otherPosition, int otherSizeX, int otherSizeY) {
    PVector thisPosition = position.copy();
    int thisSize = (int) size;
    if (otherSizeX>size) {
      thisPosition = otherPosition;
      thisSize = max(otherSizeX, otherSizeY);
      otherSizeX = (int) size;
      otherSizeY = (int) size;
      otherPosition = position.copy();
    }

    PVector p1 = otherPosition;
    PVector p2 = new PVector(otherPosition.x + otherSizeX, otherPosition.y);
    PVector p3 = new PVector(otherPosition.x, otherPosition.y + otherSizeY);
    PVector p4 = new PVector(otherPosition.x+ otherSizeX, otherPosition.y + otherSizeY);

    if (pointInsideCharacter(p1, thisPosition, thisSize) 
      || pointInsideCharacter(p2, thisPosition, thisSize)
      || pointInsideCharacter(p3, thisPosition, thisSize) 
      || pointInsideCharacter(p4, thisPosition, thisSize)) {
      return true;
    } else {
      return false;
    }
  }


  boolean pointInsideCharacter(PVector otherPosition, PVector thisPosition, int thisSize) {
    if (otherPosition.x >= thisPosition.x && otherPosition.x <= thisPosition.x+thisSize 
      && otherPosition.y >= thisPosition.y && otherPosition.y <= thisPosition.y+thisSize) {

      return true;
    } else { 
      return false;
    }
  }

  boolean checkIfDead() {
    if (health <= 0) {
      return true;
    } else {
      return false;
    }
  }

  //check if player is out of bounds with next move
  boolean outOfBounds(PVector vel, PVector pos, float size) {
    PVector newPos = pos.copy();
    newPos.add(vel);
    if (newPos.x < 0 || newPos.x+size > width || newPos.y < 0 || newPos.y+size > height) return true;
    else return false;
  }
}