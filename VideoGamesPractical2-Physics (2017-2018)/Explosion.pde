
final class Explosion{
 public PVector position;
 int explosionX, explosionY;
 int age;
  
  Explosion(float exX, float exY){
    
    position = new PVector(exX, exY);
    age = 40;
  }
  
  
  void update(){
   age--; 
    
  }
 

 
}
 

  
  