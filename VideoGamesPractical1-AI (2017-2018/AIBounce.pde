//This class is used for the Wall.
final class AIBounce{
  
  //Variables to be accessed through the project that are easily stored in the AIBounce object.
  public PVector position, velocity;
  public int health = 20;
  int speedFactor;
  
  //AIBounce Constructor.
  AIBounce(int x, int y, float xVel, float yVel){
    position = new PVector(x,y);
    velocity = new PVector(xVel, yVel); 
  }
  
  //This method sets the bevaiour of the wall, how fast it goes and how powerful it is. 
  //It makes this decision based ont the state passed in, this is set by the main planningAI depending on how the game is going.
  void AIBounceUpdate(int state){
    switch(state){
      case 0:
      speedFactor = 100;
      bounceDamage= 50;
        break;
        
      case 1:
      speedFactor = 90;
      bounceDamage= 60;
        break;
        
      case 2:
      speedFactor = 80;
      bounceDamage= 70;
        break;
        
      case 3:
      speedFactor = 70;
        bounceDamage = 80;
        break;
        
      case 4:
      speedFactor = 60;
      bounceDamage= 100;
        break;
        
      case 5:
        bounceDamage = 20;
        break;
    }


    //Updating of the postion and veloctiy of th AIBounce, makes sure it bounces of the of the window.
    position.add(velocity);
    
    if ((position.x <= 10) || (position.x >= width-10)){
      velocity.x =  -velocity.x;
      position.add(velocity);
      if(velocity.x < 0){
        velocity.x = -character.position.x/speedFactor;
      }else{
        velocity.x = character.position.x/speedFactor;
      }
    }
    if ((position.y <= 10) || (position.y >= height -10)){
      velocity.y =  -velocity.y;
      position.add(velocity);
      if(velocity.y < 0){
        velocity.y = -character.position.y/speedFactor;
      }else{
        velocity.y = character.position.y/speedFactor;
      }
    }
  }
}