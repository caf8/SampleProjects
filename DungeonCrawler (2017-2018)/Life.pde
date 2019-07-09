PImage heart;

//life object
class Life extends PowerUp{
  
   Life(PVector position){
     super(position, heart, PowerUpEnum.LIFE, 10, 10, 0); //maxTimer is 0 as an extra life doesn't have a timer
  }
  
  
  
  
  
}