//Global variables to be used throughout the practical.
final float MAX_SPEED = 15f;

//This class is used for the Bullet.
final class Bullet{
  //Variables to be accessed through the project that are easily stored in the bullet object.
  public float orientation ;
  public PVector position, velocity, target;
  PVector targetVelocity = new PVector(0,0);
  public boolean character;
  
  //Bullet Constructor.
  Bullet(float x, float y, float targetX, float targetY, boolean character){
    position = new PVector(x,y);
    target = new PVector(targetX, targetY);
    this.character = character;
    setUp();
  }
  
  //Method to get intermediate value on how close current position of bullet is to where the mouse was clicked.
  void setUp(){
    target.x = target.x - position.x;
    target.y = target.y - position.y;
  }
  
  //This method updates the velocity and position of the bullet object.
  void bulletUpdate(){
    float distance = target.mag();
    
    if(distance < SAT_RADIUS){
        return;
    }

    velocity = target.get();
    if(distance >  MAX_SPEED){
      velocity.normalize();
      velocity.mult(MAX_SPEED);
    }
    position.add(velocity);
  }
}
  