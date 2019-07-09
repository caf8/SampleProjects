

/**
 * This is a interface for the Trees used in the program. 
 * 
 * @author 140012021
 *
 */
public interface Tree {
	
	//Methods that appear in VitterTree class.
	public  boolean getEncodeSymbol(char charAt);	
	public String getPath(char c);
	public char decodeLeaf(String temp);
	public void addCharBack(char newChar);
	public class Node {
		
		
		//Fields of Node
		public int weight;
		public int index;
		public char character;
		public int level;
		public Node left = null;
		public Node right = null;
		public Node parent;
		public String bit;
		public String path;
		
		
		
		
		
		public Node(int weight, int index, char character, int level, Node left, Node right, Node parent, String bit, String path){
			this.weight = weight;
			this.index = index;
			this.character = character;
			this.level = level;
			this.left  = left;
			this.right = right;
			this.parent = parent;
			this.bit = bit;
			this.path = path;
			
		}
		
		
		public Node(int index, int weight, char character, String bit, String path,int level, Node left, Node rigtht) {
			this.index = index;
			this.weight = weight;
			this.character = character;
			this.bit = bit;
			this.path = path;
			this.level = level;
			this.left = left;
			this.right = right;
			
		}
		
		public Node(int index, int weight, char character, String bit, String path,int level) {
			this.index = index;
			this.weight = weight;
			this.character = character;
			this.bit = bit;
			this.path = path;
			this.level = level;
		}

		/**
		 * This method checks if a node is a leaf or not.
		 * @return
		 */
		public boolean isLeaf(){
			return (left == null && right == null);
		}
		
		/**
		 * This method checks if a node is a root or not.
		 * @return
		 */
		public boolean isRoot(){
			return (parent == null);
		}
		
 
		
		
	}
	
	



	
	
	
	
	
	
	
}
