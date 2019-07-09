//This class is used for the Weapon Power Up.
final class WeaponUpgrade{
  
  //Position is where the power-up is spawned and timer is how long it appears on the map for.
  PVector position;
  public int timer;
 
 //Weapon Upgrade Constructor
  WeaponUpgrade(int x, int y, int age){
    position = new PVector(x,y);
    this.timer = age; 
  }
}