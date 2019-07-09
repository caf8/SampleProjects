//This class is used for the healthpack.
final class HealthPack{
  
  //Position is where the pack is spawned and timer is how long it appears on the map for.
  PVector position;
  public int timer;
 
  //HealthPack Upgrade Constructor.
  HealthPack(int x, int y, int age){
    position = new PVector(x,y);
    this.timer = age;
  }
}