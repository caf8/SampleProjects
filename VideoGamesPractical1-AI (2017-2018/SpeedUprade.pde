//This class is used for the Speed Power Up.
final class SpeedUpgrade{
  
  //Position is where the power-up is spawned and timer is how long it appears on the map for.
  PVector position;
  public int timer;
 
 //Speed Upgrade Constructor.
  SpeedUpgrade(int x, int y, int age){
   position = new PVector(x,y);
   this.timer = age;
  }
}