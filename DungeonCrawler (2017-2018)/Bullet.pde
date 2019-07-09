final float MAX_SPEED = 3;
int bulletSize = 5;

//a bullet which is shot by some AIs and the character
final class Bullet {

  public float orientation;
  public PVector position, velocity, target;
  PVector targetVelocity = new PVector(0, 0);
  Character character;
  int size = 5;
  int bulletSize = 5;

  //Bullet Constructor.
  Bullet(float x, float y, float targetX, float targetY, Character character, int bulletSize) {
    position = new PVector(x, y);
    target = new PVector(targetX, targetY);
    this.character = character;
    this.bulletSize = bulletSize;
    setUp();
  }

  //Method to get intermediate value on how close current position of bullet is to where the mouse was clicked or where the player is
 void setUp() {
    target.x = target.x+player.size/2 - position.x;
    target.y = target.y+player.size/2 - position.y;
  }

  void updateBullet() {
    integrate();
    fill(255);
    ellipse(position.x, position.y, bulletSize, bulletSize);

  }

  //This method updates the velocity and position of the bullet object.
  void integrate() {
    float distance = target.mag();
    if (distance < SAT_RADIUS) {
      return;
    }

    velocity = target.get();
    if (distance >  MAX_SPEED) {
      velocity.normalize();
      velocity.mult(MAX_SPEED);
    }
    position.add(velocity);
  }

  //check if the bullet has left the screen
  boolean hasLeftScreen() {
    if (position.x < 0 || position.x > width || position.y < 0 || position.y > height) {
      return true;
    } else {
      return false;
    }
  }

  //check if the bullet has hit a block
  public boolean checkBlocksForBullet() {
    PVector newPos = position.add(velocity);
    newPos = newPos.add(velocity);
    newPos = newPos.add(velocity);
    if (hasLeftScreen()) return false;
    if (level.currentRoom.map[level.getCurrentBlockI(newPos)][level.getCurrentBlockJ(newPos)]) return false;
    else return true;
  }
}