import java.awt.Dimension;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.AbstractAction;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenuItem;
import javax.swing.JPopupMenu;
public class Test extends JFrame {
  JPopupMenu menu = new JPopupMenu("Popup");
  JLabel label = new MyLabel("Ice");
  
  long startTime;
  //String [] options  = {"NorthEast", "South","East", "North", "SouthEast", "North", "West","SouthWest", "NorthEast", "South", "NorthWest","East","SouthWest","South","NorthEast"}; 
  //String [] options = {"8", "2", "4", "5", "1", "3","6","6","7","2","8","1","4","3","4"};
  String [] options = {"Ice", "Dog", "Blue", "Old", "Red", "Cup", "Dog", "House", "Cup", "House", "Red", "House", "Blue", "Ice", "Holiday"};
  int option = 0;
  int error = 0;
  boolean found = true;
  boolean firstTime = true;
  class MyLabel extends JLabel {
    public MyLabel(String text) {
      super(text);
      
      addMouseListener(new PopupTriggerListener());
    }

    class PopupTriggerListener extends MouseAdapter {
      public void mousePressed(MouseEvent ev) {
        if (ev.isPopupTrigger()) {
        	
        	if(found){
        		startTime = System.nanoTime();
        		found = false;
        		if(!firstTime){
        		System.out.println("The number of errors was: " + error);
        		error = 0;
        		}
        		firstTime = false;
        	}
          menu.show(ev.getComponent(), ev.getX(), ev.getY());
        }
      }

      public void mouseReleased(MouseEvent ev) {
        if (ev.isPopupTrigger()) {
          menu.show(ev.getComponent(), ev.getX(), ev.getY());
        }
      }

      
    }
  }

  

  public Test() {
	label.setFont(new Font("Serif", Font.PLAIN, 30));
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    JMenuItem item = new JMenuItem(new AbstractAction("Red") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});
    
   
    item.setPreferredSize(new Dimension(150, 35));
    menu.add(item);

    
    
    
    
    
    item = new JMenuItem(new AbstractAction("Blue") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});

    
    item.setPreferredSize(new Dimension(150, 35));
    menu.add(item);
    
    
    
    
    
 item = new JMenuItem(new AbstractAction("Dog") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});
 
    
    item.setPreferredSize(new Dimension(150, 35));
    menu.add(item);
    
    
    
    
    
 item = new JMenuItem(new AbstractAction("House") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});
  
    
    item.setPreferredSize(new Dimension(150, 35));
    menu.add(item);
    
    
    
    
    
item = new JMenuItem(new AbstractAction("Holiday") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});
   
    
    item.setPreferredSize(new Dimension(150, 35));
    
    
    menu.add(item);
    
    
    
    
    
item = new JMenuItem(new AbstractAction("Ice") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});
   
    
    item.setPreferredSize(new Dimension(150, 35));
    
    
    menu.add(item);
    
    
    
item = new JMenuItem(new AbstractAction("Old") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});
 
    
    item.setPreferredSize(new Dimension(150, 35));
    
    
    menu.add(item);
    
    
    
    
item = new JMenuItem(new AbstractAction("Cup") {
		
		@Override
		public void actionPerformed(ActionEvent e) {
			String name = e.paramString().substring(21,e.paramString().length()-37);
			if(name.equals(options[option])){
				long endTime = System.nanoTime();
	    		long duration = (endTime - startTime);
	    		System.out.println("Time taken" + " " + duration/777600000.0);
				System.out.println(name);
				option++;
				label.setText(options[option]);
				found = true;
			}else{
				error++;
			}
			
		}
	});
   
    
    item.setPreferredSize(new Dimension(150, 35));
    
    
    menu.add(item);
    
    
    

    getContentPane().add(label);
    pack();
    setSize(400, 400);
  }

  public static void main(String[] args) {
    new Test().setVisible(true);
  }

}
