//This class is used for the MineTrap.
final class MineTrap{
  
  //Position is where the mine is spawned and timer is how long it appears on the map for.
  public PVector position;
  int age;
  
  //MineTrap Constructor.
  MineTrap(float x, float y, int age){
    position = new PVector(x,y);
    this.age = age;
  }
  
  //Method to reduce the age of the trap by one.
  void update(){
    age--;
  }
  
  
  
  
  
  
}