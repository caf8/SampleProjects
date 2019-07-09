import ddf.minim.*;

final int MY_HEIGHT = 800;
final int MY_WIDTH = 800;
final int MAX_PARTICLES_BASE = 1000;
final int num_intial_Particles = 20;
final int OBJECT_SIZE = 20;
final int NO_Missiles= 100 ;
final int Max_Ammo = 50;
final int payload = 2;
final int MAIN_MENU = 0;
final int GAME = 1;
final int PAUSE = 2;
final int INSTRUCTIONS = 3;
final int EXIT = 4;
final int GAMEOVER = 5;
int state = 0;
int finalScore = 0;
int wavefactor = 0;
int prevstate = 0;

int numParticles = num_intial_Particles;




int numExplosions = 0;
int score =0;
int age = 0;
int timer = 100;
int wave = 1;
int max_Particle_Wave = (wave * 20);
int current_wave_particles = (wave * 20);
int initial_wave_particles = (wave);
int increse_wave_particles = (wave);
int Ammo = (500);


Particle[] particles;
Missile[] missiles ;
Explosion[] explosions;

boolean Tower1 = false;
boolean Tower2 = false;
boolean Tower3 = false;
boolean Tower4 = false;
boolean Tower5 = false;
boolean hit = false;


int xStart, yStart, xEnd, yEnd ;
int mouseposx, mouseposy;
PImage img, img1, background;
AudioPlayer playerMusic;
AudioPlayer player;
AudioPlayer main;
Minim minim;


ExplosionForce explosionforce;
ForceRegistry forceRegistry ;

void setup() {
  cursor(CROSS);
  minim = new Minim(this);
  player = minim.loadFile("explosion.mp3");
  playerMusic = minim.loadFile("music.mp3");
  playerMusic.loop();
  
  img = loadImage("Town-PNG-File.png");
  img1 = loadImage("explosionpng.png");
  background = loadImage("background.png");
  size(800, 800);
  particles = new Particle[MAX_PARTICLES_BASE*10];
  explosions =  new Explosion[10];
  missiles = new Missile[NO_Missiles] ;

  Gravity gravity = new Gravity(new PVector(0f, .1)) ; 
  Drag drag = new Drag(30, 30) ;

  //Create the ForceRegistry
  forceRegistry = new ForceRegistry() ;  



  for (int i =0; i < initial_wave_particles; i++) {
    age = randomCarrier();
    particles[i] = new Particle((int)random(0, MY_WIDTH), 
      10, 
      random(-2f, 2f), 
      random(.1f, .5f)*wave/15, 
      random(0.001f, 0.002f), false, age) ;
    forceRegistry.add(particles[i], gravity) ;
    forceRegistry.add(particles[i], drag) ;
  }
}

void addParticle(Particle p) {
  Gravity gravity = new Gravity(new PVector(0f, .1f)) ; 
  Drag drag = new Drag(15, 15) ;
  for (int i =0; i < (MAX_PARTICLES_BASE*10); i++) {
    if (particles[i] == null) {
      particles[i] = p;
      forceRegistry.add(particles[i], gravity) ;
      forceRegistry.add(particles[i], drag) ;
      return;
    }
  }
}

void draw() {
  switch(state){
    case MAIN_MENU:
      prevstate = MAIN_MENU;
      background(0) ;
      clear();
      textSize(42);
      fill(255);
      text("MAIN MENU", 290, 100);
      text("G: GAME", 290, 300);
      text("I: Instructions", 290, 400);
      text("E: Exit", 290, 500);
    break;   
    
    case GAME:
    prevstate = GAME;
    
    
     background (background);
  if(!Tower1){
    //rect(10, 710, 80, 70);
    image(img, 0, 700, 100, 100);
  }

  if(!Tower2){
    //rect(190, 710, 80, 70);
    image(img, 180, 700, 100, 100);
  }

  if(!Tower3){
    //rect(340, 710, 80, 70);
    image(img, 330, 700, 100, 100);
  }
 
 if(!Tower4){
   //rect(490, 710, 80, 70);
   image(img, 480, 700, 100, 100);
 }
  
  if(!Tower5){
    //rect(640, 710, 80, 70);
    image(img, 630, 700, 100, 100);
  }
  
  if(Tower1 && Tower2 && Tower3 && Tower4 && Tower5){

    background(background);
    state = GAMEOVER;
    clear();
  
  }
  
  
  fill(255);
  textSize(24);
  text("Score: " + score, 10, 20);
  text("Ammo :" + Ammo, 200, 20);
  text("Wave :" + wave, 400, 20);
  text("Asteroids Left: " + current_wave_particles, 550, 20);
  
  forceRegistry.updateForces();

  for (int i = 0; i  < NO_Missiles; i++) {
    if (missiles[i] != null) {
      missiles[i].update() ;
      PVector position = missiles[i].position ;
      if (position.x < xStart && position.y < yStart) {
        for (int j = 0; j < explosions.length; j++) {
          if (explosions[j] == null) {
            explosions[j] = new Explosion(mouseposx, mouseposy);
            break;
          }
        }
        missiles[i] = null;
      } else {
        ellipse(position.x, position.y, 20, 20) ;
      }
    }
  }
  for (int i =0; i < (MAX_PARTICLES_BASE*10); i++) {

      if(timer < 0){
        timer = 100;
        if (current_wave_particles - increse_wave_particles < max_Particle_Wave) {  
            for (int j =0; j < increse_wave_particles; j++) {
              age = randomCarrier();
              Particle p = new Particle((int)random(0, MY_WIDTH),10, random(-2f, 2f), random(.1f, .5f)*wave/15, random(0.001f, 0.002f), false, age);
              addParticle(p);
            }
            numParticles = numParticles + increse_wave_particles;
          }else{
            if (current_wave_particles > 0) {  
              age = randomCarrier();
              Particle p = new Particle((int)random(0, MY_WIDTH),10, random(-2f, 2f), random(.1f, .5f)*wave/15, random(0.001f, 0.002f), false, age);
              addParticle(p);
              numParticles++;
            }
          }
     
      }
        
        if (particles[i] != null) {
      particles[i].integrate();
      PVector position = particles[i].position;

          if (particles[i].update()) {
            
             if(particles[i].age == 0){
          if (current_wave_particles - payload > 0) {  
            for (int j =0; j < payload; j++) {
                      
              age = randomCarrier();
              Particle p = new Particle(position.x,position.y, random(-8f, 8f), random(.1f, .5f)*wave/15, random(0.001f, 0.002f), false, age);
              
              addParticle(p);
            }
            numParticles = numParticles + payload;

          }
         }
            
            
            
            
          if((position.x < 0 || position.x > MY_WIDTH || position.y < 800) && particles[i].hit){
            score = score + 10;
            current_wave_particles --;
            numParticles--;
            particles[i] = null;
          }else{

            particles[i] = null;
          }

        
       
     }else {
        fill(100, 100, 200);
        if (particles[i].hit) {
          fill(0, 0, 0);
          ellipse(position.x, position.y, 20, 20);
        } else {
          ellipse(position.x, position.y, 20, 20);
        }
    }
     for (int j =0; j < numParticles; j++) {
       for (int m = 0; m < explosions.length; m++) {
         Particle p1 = particles[j];
         Explosion e1 = explosions[m];
         if (p1 != null && e1 != null ) {
            detectCollision(p1, e1);
          }
       }
     }
    }
  } 



  for (int k = 0; k < explosions.length; k++) {
    if (explosions[k] != null) {
      //ellipse(explosions[k].position.x, explosions[k].position.y, 230, 230);
      image(img1, explosions[k].position.x-115, explosions[k].position.y-115, 230, 230);
      explosions[k].update();
      if (explosions[k].age <= 0) {
        explosions[k] = null;
      }
    }
  }
  buildingCollision();
   timer--;
  if(current_wave_particles < 0){
    newWave();
    
  }
    
    break;
    
    
    
     case PAUSE:
     
    for(int i = 0; i < 100; i++){
      i = 0;
      textSize(42);
      fill(255);
      text("PAUSE", 290, 400);
      if(key == 'P' || key == 'p'){
        break;
      }
    }
    
    break;
    
   case INSTRUCTIONS:
     if(prevstate == MAIN_MENU){
  
       prevstate = INSTRUCTIONS;
     }
     if(prevstate == GAME){
  
        state = GAME;
     }

   break;
   
   case GAMEOVER:
     prevstate = GAMEOVER;
     textSize(40);
     text("GAME OVER", 200, 350);
     text("Your Score was: " + finalScore, 200, 750);
   break;
   
   case EXIT:
     exit();
    
    
  }
  
 

 
}

void mouseClicked() {
  if(state != GAMEOVER){
  player.play();
  player.rewind();
  }
  mouseposx = mouseX;
  mouseposy = mouseY;
  if(Ammo > 0){
    xStart = mouseX ;
    yStart = mouseY ;
    PVector force = new PVector(xStart-780, yStart-780) ;
    for (int i = 0; i < NO_Missiles; i++) {
      if (missiles[i] == null) {
        missiles[i] = new Missile(780,780,0,0,xStart, yStart, force);
        Ammo--;
      return;
      }
    } 
  }
}


void detectCollision(Particle p1, Explosion e1) {
  PVector particle = new PVector(p1.position.x, p1.position.y);
  particle.sub(e1.position);
  if (particle.mag() < 125) {
    particle.normalize();
    if (!p1.hit) {
     float x = (float)(p1.position.x-e1.position.x)*20;
      float y = (float)(p1.position.y-e1.position.y)*20;
      explosionforce = new ExplosionForce(new PVector(x, y)) ;
      forceRegistry.add(p1, explosionforce);
    }
    p1.hit = true;
  }
}


void buildingCollision(){
  for(int i = 0; i < numParticles; i++){
    if(particles[i] != null){
      PVector position = new PVector(particles[i].position.x, particles[i].position.y);
      if(position.y > 710 && position.y < 780){
        if(position.x > 10 && position.x < 80 && !Tower1){
            drawExplosion(position);
            Tower1 = true;
              particles[i] = null;
        }else if(position.x > 190 && position.x < 270  && !Tower2){
           drawExplosion(position);
            Tower2 = true;
            particles[i] = null;
        }else if(position.x > 340 && position.x < 410 && !Tower3){
            drawExplosion(position);
            Tower3 = true;
            particles[i] = null;
        }else if(position.x > 490 && position.x < 560 && !Tower4){
           drawExplosion(position);
            Tower4 = true;
            particles[i] = null;
        }else if(position.x > 640 && position.x < 710 && !Tower5){
           drawExplosion(position);
            Tower5 = true;
            particles[i] = null;
        }
      }
    }
  }
}


void drawExplosion(PVector position){
  for (int j = 0; j < explosions.length; j++) {
    if (explosions[j] == null) {
       explosions[j] = new Explosion(position.x, position.y);
       break;
    }
  }
}


void newWave(){
  rebuildTower();
  particles = new Particle[MAX_PARTICLES_BASE*10];
  explosions =  new Explosion[10];
  missiles = new Missile[NO_Missiles] ; //<>//
  wave++;
  if(wave > 5){
    wavefactor = 6;
  }else{
    wavefactor = wave;
  }
  max_Particle_Wave = (wavefactor * 20);
  current_wave_particles = max_Particle_Wave;
  initial_wave_particles = (wavefactor * 4);
  increse_wave_particles = (wavefactor);
  Ammo = (wavefactor * 19);


}

 int randomCarrier(){
    double d = Math.random();
     if(d > 1-((float)wave/30)){
       return (int)random(100,150);
     }else{
        return 10000000;
     }
   
  }
  
  
  void rebuildTower(){
    if(Tower1){
      Tower1 = false;
      return;
    }else if(Tower2){
      Tower2 = false;
      return;
    }else if(Tower3){
      Tower3 = false;
      return;
    }else if(Tower4){
      Tower4 = false;
      return;
    }else if(Tower5){
      Tower5 = false;
      return;
    }
    
  }
  
  
  
  
  
  void keyPressed(){
     if(key == 'M' || key == 'm'){
    state = MAIN_MENU;
  }else if(key == 'G' || key == 'g'){
    state = GAME;
  }else if(key == 'P' || key == 'p'){
    state = PAUSE;
  }else if(key == 'I' || key == 'i'){
    state = INSTRUCTIONS;
  }else if(key == 'E' || key == 'e'){
    state = EXIT;
  } 

  }
  
  void clear(){
    finalScore = score;
    numParticles = num_intial_Particles;
    numExplosions = 0;
    score =0;
    age = 0;
    timer = 100;
    wave = 1;
    max_Particle_Wave = (wave * 20);
    current_wave_particles = (wave * 20);
    initial_wave_particles = (wave);
    increse_wave_particles = (wave);
    Ammo = (500);
    particles = new Particle[MAX_PARTICLES_BASE*10];
    explosions =  new Explosion[10];
    missiles = new Missile[NO_Missiles] ;
    Tower1 = false;
    Tower2 = false;
    Tower3 = false;
    Tower4 = false;
    Tower5 = false;
    hit = false; 
  }