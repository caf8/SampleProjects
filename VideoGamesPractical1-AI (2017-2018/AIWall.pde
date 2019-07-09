//Global variables to be used throughout the practical.
public int powerWall= 1;

//This class is used for the Wall.
final class AIWall {

  //Variables to be accessed through the project that are easily stored in the AIWall object.
  int rail;
  public PVector position, velocity;
  public int health = 50;
  public int shootTimer;
  int countDown = 10;
  int currentState = 0;

  //AIWall Constructor.
  AIWall(int x, int y, float xVel, float yVel) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
  }

  //This method sets the bevaiour of the wall, changing how often is shoots, how powerful it is and it's current state. 
  //It makes this decision based ont the state passed in, this is set by the main planningAI depending on how the game is going.
  void AIWallUpdate(int state) {
    switch(state) {
    case 0:
      countDown = 2;
      powerWall = 5;
      currentState = 0;    
      break;

    case 1:
      countDown = 3;
      powerWall = 10;
      currentState = 1;  
      break;
    case 2:
      countDown = 4;
      powerWall = 25; 
      currentState = 2;    
      break;
    case 3:
      countDown = 6;
      powerWall = 30;
      currentState = 3;
      break;
    case 4:
      countDown = 8;
      powerWall = 50;
      currentState = 4;    
      break;
    case 5:
      countDown = 5;
      powerWall = 1;
      currentState = 5;
      break;
    }
    shootTimer = shootTimer - countDown;

    //Works out what side of the window the AI is currently on.
    if (position.x <= 15 && position.x >= -1 && position.y <= 15 && position.y >= -1) {
      rail = 0;
    } else if (position.x <= width+1 && position.x >= width-15 && position.y <= 15 && position.y >= -1) {
      rail = 1;
    } else if (position.x <= width+1 && position.x >= width-15 && position.y <= height+1 && position.y >= height-15) {
      rail = 2;
    } else if (position.x <= 15 && position.x >= -1 && position.y <= height+1 && position.y >= height-15) {
      rail = 3;
    }
    
    //After knowing what rail it is on, it then works out what the change in velocity needs ot be to keep it on track.
    if (rail == 0) {
      position.x += velocity.x;
    } else if (rail == 1) {
      position.y += velocity.y;
    } else if (rail == 2) {
      position.x -= velocity.x;
    } else {
      position.y -= velocity.y;
    }
  }
}