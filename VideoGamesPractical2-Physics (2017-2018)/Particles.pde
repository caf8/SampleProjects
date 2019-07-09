public static PVector gravity = new PVector(0, 0.01f) ;
final class Particle{
 public PVector position, velocity;
 public PVector forceAccumulator;
 public float invMass;
 public boolean hit;
 public int age;
 private float getMass(){return 1/invMass;}

 
 Particle(float x, float y, float xVel, float yVel, float invM, boolean hit, int age){
  position = new PVector(x,y);
  velocity = new PVector(xVel, yVel);
  forceAccumulator = new PVector(0,0);
  invMass = invM;
  this.hit = hit;
  this.age = age;
 }
 
 void addForce(PVector force){
  forceAccumulator.add(force); 
 }

 void integrate(){
   if (invMass <= 0f) return;      
   PVector resultingAcceleration = forceAccumulator.get() ;
   position.add(velocity);
   resultingAcceleration.mult(invMass) ;
   velocity.add(resultingAcceleration) ;
   forceAccumulator.x = 0 ;
   forceAccumulator.y = 0 ;        
}
  
  boolean update(){
    age--;
    return age == 0 || position.y < 0 || (position.x < 0) || (position.x > width) || position.y > 800;
  }

 }