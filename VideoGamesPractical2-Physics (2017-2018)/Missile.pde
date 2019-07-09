
final class Missile {
  
  public PVector position, velocity, v ;
  int xEnd,yEnd;

   private static final float DAMPING = .995f ;

  Missile(int x, int y, float xVel, float yVel, int xEnd, int yEnd, PVector v) {
    position = new PVector(x, y) ;
    velocity = new PVector(xVel, yVel) ;
    this.xEnd = xEnd;
    this.yEnd = yEnd;
    this.v = v;
    
  }
  
  
  void update(){
    velocity.add(v);
    velocity.mult(DAMPING*0.1);
    position.add(velocity) ;

  }


}