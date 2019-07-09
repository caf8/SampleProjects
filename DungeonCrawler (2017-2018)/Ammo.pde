PImage ammo;

//object to make the player's bullets take more damage
class weaponUpgrade extends PowerUp{
  
   weaponUpgrade(PVector position){
     super(position, ammo, PowerUpEnum.AMMO, 20, 10, level.ammoTimer);
  }
  
  
  
  
  
}