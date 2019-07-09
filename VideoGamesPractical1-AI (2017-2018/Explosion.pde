//This class is used for the Explosion.
final class Explosion{
  
  //Position is where the pack is spawned, radius is the size of the explosions and grow shows the direction of growth.
  public PVector position;
  public int radius;
  boolean grow = false;
  
  //Explosion Constructor.
  Explosion(float x, float y, int r){
    position = new PVector(x,y);
    this.radius = r;
  }
 
  //Method to expand and contract the size of the explosion.
  void update(){
    if(!grow){
      radius = radius + 2;
      position.x -= 0.5;
      position.y -= 0.5;
      if(radius == 101){
        grow = true;
       }
    }else{
      radius = radius - 2;
      position.x += 0.5;
      position.y += 0.5;
    }
  }
}