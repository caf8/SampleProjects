//Global variables to be used throughout the practical.
final float SAT_RADIUS = 0.1f;
final float speed = 5;

//This class is used for the Character.
final class Character{
  //Variables to be accessed through the project that are easily stored in the character object.
  public PVector position, velocity;
  int health;
  int speedtimer = 0;
  int weapontimer = 0;
  int weaponPower = 1000;
  int MaxSpeed = 8;
  
  //Character Constructor.
  Character(int x, int y, float or, float xVel, float yVel, int health){
    position = new PVector(x,y);
    velocity = new PVector(xVel, yVel);
    this.health = health;
  }
  
  //This method updates the power of the weapon of the character depedning on whether they have the power-up active or not.
  //This method also controls the max speed of the character depedning on whether they have the speed power up active or not.
  //This method also controls the velocity and direction which the character is travelling in, taken from what keys are pressed down.
  void update(boolean isLeft, boolean isRight, boolean isUp, boolean isDown){
    velocity.x = 0;
    velocity.y = 0;
    
    if(speedtimer > 0){
      MaxSpeed = 12;
    }else{
      MaxSpeed = 8;
    }
  
    if(weapontimer > 0){
      weaponPower = 40;
    }else{
      weaponPower = 15;
    }

    if (isLeft && position.x>=10){
      velocity.x=(-MaxSpeed);
    }
    if (isRight && position.x <= width-10){
      velocity.x=(MaxSpeed);
    }
    if (isDown && position.y <= height-10){
      velocity.y=(MaxSpeed);
    }
    if (isUp && position.y >= 10){
      velocity.y=(-MaxSpeed);
    }
  
    if(isLeft && isUp || isRight && isUp || isLeft && isDown || isRight && isDown){
      velocity.x = velocity.x /1.4;
      velocity.y = velocity.y /1.4;
    }
    
    position.x+=velocity.x; 
    position.y+=velocity.y;   
  }
}
  