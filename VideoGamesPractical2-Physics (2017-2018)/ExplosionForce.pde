public final class ExplosionForce extends ForceGenerator{
  
  private PVector exForce;
  
  ExplosionForce(PVector exForce) {
    this.exForce = exForce;
  }
  
  void updateForce(Particle particle){
   particle.addForce(exForce);

  }
  
  
}