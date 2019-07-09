import javax.swing.plaf.synth.SynthSeparatorUI;

import processing.core.PApplet;

public class UsingProcessing extends PApplet{
	//String[] options = { "East", "SouthEast", "South", "SouthWest", "West", "NorthWest", "North", "NorthEast" };
	String [] options = {"1", "2", "3", "4", "5", "6", "7", "8"};
	//String [] options = {"Red", "Blue","Dog","House","Holiday","Ice", "Old","Cup"};
	//int []  experiment1 = {8,3,1,7,2,7,5,4,8,3,6,1,4,3,8}; //Directions
	//int []  experiment1 = {6,3,2,7,1,8,3,4,8,4,1,4,2,6,5}; //Objects
	int []  experiment1 = {8,2,4,5,1,3,6,6,7,2,8,1,4,3,4}; //Numbers
	//String [] experiment1Text = {"Ice", "Dog", "Blue", "Old", "Red", "Cup", "Dog", "House", "Cup", "House", "Red", "House", "Blue", "Ice", "Holiday"};
	 //String [] experiment1Text  = {"NorthEast", "South","East", "North", "SouthEast", "North", "West","SouthWest", "NorthEast", "South", "NorthWest","East","SouthWest","South","NorthEast"};
	 String []  experiment1Text = {"8", "2", "4", "5", "1", "3","6","6","7","2","8","1","4","3","4"};
	/*
	 * Red = 1
	 * Blue = 2
	 * Dog = 3
	 * House = 4
	 * Holiday = 5
	 * Ice = 6
	 * Old = 7
	 * Cup = 8
	 * 
	 * 
	 * 
	 * 
	 */
	
	
	
	
float diam, textdiam;
int selected;
int counter = 1;
int choiceCounter = 1;
long startTime;
int numAttempts = 0;
int error = 0;
    public static void main(String[] args) {
        PApplet.main("UsingProcessing");
    }

    public void settings(){
        size(400,400);
    }

    public void setup(){
    	  textAlign(CENTER, CENTER);
    	  noStroke();
    	  smooth();
    	  diam = (float) (min(width, height) * 0.8);
    	  textdiam = (float) (diam/3.5);
    	  background(255);
    	  
      	  fill(125);
      	  ellipse(width/2, height/2, 50, 50);
    	  

    }

    public void draw(){
    	
    }
 
    public void mousePressed() {
    	if(mouseButton == RIGHT){
    		fill(125);
      	  ellipse(width/2, height/2, diam+10, diam+10);
      	 
      	 float mouseTheta = atan2(mouseY-height/2, mouseX-width/2);
      	  float piTheta = mouseTheta>=0?mouseTheta:mouseTheta+TWO_PI;
      	  float op = options.length/TWO_PI;
      	 
      	  selected = -1;
      	  for (int i=0; i<options.length; i++) {
      	    float s = (float) (i/op-PI*0.125);
      	    float e = (float) ((i+0.98)/op-PI*0.125);
      	    fill(255);
      	    if (piTheta>= s && piTheta <= e) {
      	      
      	      selected = i;
      	    }
      	    arc(width/2, height/2, diam, diam, s, e);
      	  }
      	 
      	  fill(0);
      	  for (int i=0; i<options.length; i++) {
      	    float m = i/op;
      	    //text(options[i], width/2+cos(m)*textdiam, height/2+sin(m)*textdiam);
      	  textSize(12);
      	    text(options[i], width/2+cos(m)*textdiam, height/2+sin(m)*textdiam);
      	  }
      	 
      	  fill(125);
      	  ellipse(width/2, height/2, 50, 50);
    		startTime = System.nanoTime();
    		fill(255);
  		  	rect(0, 0, 50, 50);
    		fill(0);
    		textSize(20);
    		text(experiment1Text[choiceCounter], 50, 30);
    	
    	}
    	if(mouseButton == LEFT){
    	  if (selected>-1) {
    		  float x = mouseX - width/2;
    		  float y = mouseY - height/2;
    		  float pyth = sqrt((float)(x*x) + (float)y*y);
    		 // System.out.println(pyth);
    		  if(pyth > 90 && pyth< 160){
    			  
		    		long endTime = System.nanoTime();
		    		long duration = (endTime - startTime);
		    		System.out.println("Time taken" + " " + duration/777600000.0);
    			  float mouseTheta = atan2(mouseY-height/2, mouseX-width/2);
    		  	  float piTheta = mouseTheta>=0?mouseTheta:mouseTheta+TWO_PI;
    		  	 float op = options.length/TWO_PI;
    		  	 float s = (float) ((experiment1[counter]-1)/op-PI*0.125);
    			    float e = (float) (((experiment1[counter]-1)+0.98)/op-PI*0.125);
    			    //System.out.println(piTheta);
    			    if (piTheta>= s && piTheta <= e) {
    			    	
    		    		
    		 
    		  	     // System.out.println("S: " + s + "E: " + e);
    		  	      System.out.println("Number of errors was: " + error);
    		 	      System.out.println(experiment1[counter]);
    		  	      counter++;
    		  	      choiceCounter++;
    		  	      error = 0;
    		  	    fill(255);
    	  		  	rect(0, 0, 1024, 1024);
    	  		  
    	        	  fill(125);
    	        	  ellipse(width/2, height/2, 50, 50);
    		  	    }else{
    		  	    	error++;
    		  	    }
    		  }else{
    			  error++;
    		  }
    	    
    	  }
    	}
    }

}