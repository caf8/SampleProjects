//Global variables to be used throughout the practical.
public int voidDamage = 10;

//This class is used for the AITrapSetter.
final class AITrapSetter{
  
  //Variables to be accessed through the project that are easily stored in the AIWall object.
  public PVector position1;
  public PVector position2;
  public PVector velocity;
  PVector targetVelocity = new PVector(0,0);
  public float MAX_SPEED_Trap = 4;
  public int timer;
  public int health = 50;
  int countDown = 1;

  //AITrapSetter Constructor.
  AITrapSetter(int x1, int y1, int x2, int y2, int timer){
    position1 = new PVector(x1,y1);
    position2 = new PVector(x2,y2);
    this.timer = timer;
  }
  
  //This method sets the bevaiour of the setter, changing how often it lays traps, how powerful the traps are and and its max speed. 
  //It makes this decision based ont the state passed in, this is set by the main planningAI depending on how the game is going.
  void update(int state){
    switch (state){
      case 0:
        MAX_SPEED_Trap = 3;
        countDown = 2;
        voidDamage = 2;
        break;
      
      case 1:
        MAX_SPEED_Trap = 4;
        voidDamage = 3;
        break;
        
      case 2:
        countDown = 3;
        voidDamage = 4;
        break;
        
      case 3:
        MAX_SPEED_Trap = 5;
        countDown = 4;
        voidDamage = 5;
        break;
       
      case 4:
        MAX_SPEED_Trap = 5;
        countDown = 1;
        voidDamage = 6;
        break;
        
      case 5:
        MAX_SPEED_Trap = 2;
        countDown = 4;
        voidDamage = 1;
        break;
    }
    
    //Updating of the position and velocity of the AITrapSetter.
    
    timer = timer - countDown;
    targetVelocity.x = position2.x - position1.x;
    targetVelocity.y = position2.y - position1.y;
    float distance = targetVelocity.mag();
    
    if(distance < SAT_RADIUS){
        return;
    }
    
    velocity = targetVelocity.get();
    if(distance >  MAX_SPEED_Trap){
      velocity.normalize();
      velocity.mult(MAX_SPEED_Trap);
    }
    
    position1.add(velocity);
  } 
}