
//power up objects class
class PowerUp{
  
  PVector position;
  PImage image;
  int sizeX;
  int sizeY;
  PowerUpEnum enumType;
  int timer = 0;
  boolean onTimer = false;
  int maxTimer;
  
  PowerUp(PVector position, PImage image, PowerUpEnum enumType, int sizeX, int sizeY, int maxTimer){
    this.position = position;
    this.image = image;
    this.enumType = enumType;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.maxTimer = maxTimer;
  }
 
  //display power up
  void displayItem(){
    image(image, position.x, position.y, sizeX, sizeY);
   
  }
  
  //implement the action for that power up
  void doThing(){
    switch(enumType){
      case LIFE:
        player.lives++;
      break;
      case AMMO:
        characterWeaponPower += 10;
        onTimer = true;
        timer = 0;
      break;
    }
  }
  
  //reverse the action for that power up
  void reverseThing(){
    switch(enumType){
      case LIFE:
      break;
      case AMMO:
        characterWeaponPower -= 10;
      break;
    }
    
  }
  
}