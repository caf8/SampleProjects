public int kamikazeDamage = 20;
public int suckerDamage = 1;
final float MAX_ACCEL = 0.1f ;
final float MAX_ROTATION = PI/4 ;

// A representation of a kinematic character
final class AISeeker {
  
  // I'm allowing public access to keep things snappy
  // Static Data
  public PVector position ;
  public float orientation ;
  // Kinematic Data
  public PVector velocity ;
  
  public PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  
  public float rotation ;
  // Accel is calculated at each integration
  private PVector linear ;
  public float MAX_SPEED1 = 3f ;
  public boolean sucker;
  public int health = 50;
  public PVector defaultVector = new PVector(0,0);
  
 AISeeker(int x, int y, float xVel, float yVel,  boolean sucker){
    position = new PVector(x, y) ;
    acceleration = new PVector(0,0);
    velocity = new PVector(random(1, 3),random(1, 3));
    linear = new PVector(0, 0) ;
    this.sucker = sucker;
     r = 2.0;
    maxspeed = 4;
    maxforce = 0.03;
  }
  
  
  
  public void run(AISeeker[] seekers, PVector target){
    flocking(seekers);
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration = new PVector(0,0);
    if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
    if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ;
  }
  
  void flocking(AISeeker[] seekers){
    PVector seperation = seperate(seekers);
    PVector allign = allignment(seekers);
    PVector cohesion = cohesionFunc(seekers);
    
    seperation.mult(1.5);
    allign.mult(1);
    cohesion.mult(1);
    
    acceleration.add(seperation);
    acceleration.add(allign);
    acceleration.add(cohesion);
    
  }

  
    PVector find(PVector target) {
    PVector desired = PVector.sub(target, position);  
    //float dist = desired.mag();

    desired.setMag(maxspeed);
    PVector factor = PVector.sub(desired, velocity);
    factor.limit(maxforce); 
    return factor;
    
  }
  
  PVector seperate(AISeeker[] seekers){
    float space = 30.0f;
    PVector factor = new PVector(0, 0, 0);
    int count = 0;
    for(int i = 0; i < seekers.length; i ++){
      if(seekers[i] != null){
      float distance  = PVector.dist(position, seekers[i].position);  
      if(distance > 0 && distance < space){
        PVector gap = PVector.sub(position, seekers[i].position);
        gap.normalize();
        gap.div(distance);        
        factor.add(gap);
        count++; 
        
      }
      }
    }
      if (count != 0) {
      factor.div((float)count);
    }

    // As long as the vector is greater than 0
    if (factor.mag() > 0) {
      factor.setMag(maxspeed);
      factor.sub(velocity);
      factor.limit(maxforce);
    }
 
    return factor;
  }
  
  PVector allignment(AISeeker[] seekers){
    float desiredseparation = 50;
    PVector runningTotal = new PVector(0,0);
    int counter = 0;
    for( int i = 0; i < seekers.length; i++){
      if(seekers[i] != null){
      float distance = PVector.dist(position, seekers[i].position);
      if(distance > 0 && distance < desiredseparation){
        runningTotal.add(seekers[i].velocity);
        counter++;
      }
      }
    }
    if (counter > 0) {
      runningTotal.div((float)counter);
      runningTotal.setMag(maxspeed);
      PVector factor = PVector.sub(runningTotal, velocity);
      factor.limit(maxforce);
      return factor;
    } 
    else {
      return defaultVector;
    }
    
  }
  
  PVector cohesionFunc(AISeeker[] seekers){
    float desiredseparation = 500;
    PVector runningTotal = new PVector(0,0);
    int counter = 0;
    for(int i = 0; i < seekers.length; i++){
      if(seekers[i] != null){
      float distance = PVector.dist(position, seekers[i].position);
      if(distance > 0 && distance < desiredseparation){
        runningTotal.add(seekers[i].position);
        counter++;
      }  
    }
    }
    if(counter > 0){
      runningTotal.div(counter);
      return find(new PVector(pursueTarget.x, pursueTarget.y));
    }else{
      return defaultVector;
      
    }
 
  }
  
  
  
  // update position, orientation, velocity and rotation
  void integrate(PVector targetPos, float angular, PVector charpos, int state) {
    
    switch(state){
      case 0:
        MAX_SPEED1 = 3;
        suckerDamage = 1;
        
      case 1:
        suckerDamage = 2;
        break;
       
      case 2:
         MAX_SPEED1 = 4f;
        break;
         
      case 3:
        MAX_SPEED1 = 5f;
        suckerDamage = 3;
        kamikazeDamage = 60;
        break;
         
      case 4:
        MAX_SPEED1 = 5f;
        suckerDamage = 5;
        kamikazeDamage = 80;
        break;
        
      case 5:
        MAX_SPEED1 = 2f;
        suckerDamage = 1;
        kamikazeDamage = 20;
        break;
      
    }

    
    
    
    position.add(velocity) ;
    // Apply an impulse to bounce off the edge of the screen
    if ((position.x < 0) || (position.x > width)) velocity.x = -velocity.x ;
    if ((position.y < 0) || (position.y > height)) velocity.y = -velocity.y ;
        
    orientation += rotation ;
    if (orientation > PI) orientation -= 2*PI ;
    else if (orientation < -PI) orientation += 2*PI ;
    
    linear.x = targetPos.x - position.x ;
    linear.y = targetPos.y - position.y ;
    

   // if(linear.mag() < 50){
     // MAX_SPEED1 = 5;
    //}else{
     // MAX_SPEED1 = 5;
   //}
    
    if(linear.mag() > 400){
    //MAX_SPEED1 = 3f;
    linear.normalize() ;
    linear.mult(MAX_ACCEL) ;
    velocity.add(linear) ;
    if (velocity.mag() > MAX_SPEED1) {
      velocity.normalize() ; 
      velocity.mult(MAX_SPEED1);
    }
    }else if(linear.mag() < 400 && linear.mag() > 0){

    linear.x = charpos.x - position.x;
    linear.y = charpos.y - position.y;
    linear.normalize() ;
    linear.mult(5) ;
    velocity.add(linear) ;
     if (velocity.mag() > MAX_SPEED1*1.8) {
      velocity.normalize() ; 
      velocity.mult(MAX_SPEED1*2) ;
      
    }
    }else{
      velocity = new PVector(0,0);
    }
   
    
    rotation += angular ;
    if (rotation > MAX_ROTATION) rotation = MAX_ROTATION ;
    else if (rotation  < -MAX_ROTATION) rotation = -MAX_ROTATION ; 
  }
}