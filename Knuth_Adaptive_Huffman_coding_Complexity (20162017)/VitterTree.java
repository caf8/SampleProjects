import java.util.*;


/**
 * This class VitterTree implements Tree. This class contains the main code of the program that performs the increments and swapped.
 * 
 * @author 140012021
 *
 */
public class VitterTree implements Tree{


	
	private Node root;
	String return_path;
	boolean swapLeadingRight;
	boolean swapNodeRight;
	int id = 0;
	
	 Map <Character, Node> map = new HashMap<Character, Node>(); 
	
	public VitterTree(){
		root = new Node(0, 0, '¬', "","",0, null, null);	
		map.put('¬', root);
	}

	

	/**
	 * This method places the characters that come from the message into the HashMap which will be referenced later. It also places
	 * the nodes on the Tree with instantiated values. 
	 * 
	 * Returns a boolean according to whether a symbol had been seen before.
	 */
	public boolean getEncodeSymbol(char charAt) {
		if(map.containsKey(charAt)){
			
			Node node = map.get(charAt);
			updateTree(node);
			return false;
			
			
		}else{
			Node nytNode = map.get('¬');
			map.remove(nytNode);
			System.out.println("nytNode character is" + nytNode.character);
			createNewNode(nytNode, '¬', false);
			createNewNode(nytNode, charAt, true);
			
			updateTree(nytNode.right);
			return true;
		}
		

	}
	
	/**
	 * This method works out what character has been sent from the message, by rebuilding the Tree with the binary code.
	 */
	
	
	public char decodeLeaf(String message){
		Node node = root;
		for(int i = 0; i < message.length(); i++){
			char c = message.charAt(i);
			
			if(c == '1'){
				node = node.right;
			}else{
				node = node.left;
			}
		}
		
		if(node.isLeaf()){
			if(node.character != '¬'){
				
				updateTree(node);
				return node.character;
			}
		}
			
		return '¬';
		
	}
	
	
	/**
	 * This method is used to increment the weight of the nodes and perform the swaps necessary to keep to Vitter's algorithm.
	 * Swaps are made depending on what type of node is being swapped. (Leaf or Internal). The method calls another method called
	 * leadingNode(), while also recursively calling itself.
	 * 
	 * @param node
	 */
	public void updateTree(Node node){
		Node leadingNode;
		if(node.parent == null){
			node.weight++;
			return;
		}
		
		leadingNode = locateLeader(root, node.weight);
		
		if(leadingNode.equals(node.parent)){
			node.weight++;
			updateTree(node.parent);
			return;
		}
		
		if(node.left == null && node.right == null){
			
			if(leadingNode != node){
				
				if(leadingNode.character == '¬' || node.character == '¬'){
					
					Node temp = node.parent;
					
					node.parent = leadingNode.parent;
					node.left = leadingNode.left;
					node.right = leadingNode.right;
					
					leadingNode.parent = temp;
					leadingNode.left = null;
					leadingNode.right = null;
					
					char temp1 = leadingNode.character;
					leadingNode.character = node.character;
					node.character = temp1;
	
					map.remove(leadingNode.character);
					map.remove(node.character);
					map.put(leadingNode.character, leadingNode);
					map.put(node.character, node);
					
					
					
				}else{
				
					
					char temp = leadingNode.character;
					leadingNode.character = node.character;
					node.character = temp;
	
					map.remove(leadingNode.character);
					map.remove(node.character);
					map.put(leadingNode.character, leadingNode);
					map.put(node.character, node);
				}

			}

			leadingNode.weight++;
			if(node.parent != null){
				updateTree(node.parent);
			}
			
			

		}else{
			
			if (leadingNode.bit != null) {
				
			
			if(leadingNode != node){
				
			
				if(leadingNode.bit == "1"){
					 swapLeadingRight = true;
				}else{
					swapLeadingRight = false;
				}
				
				if(node.bit == "1"){
					swapNodeRight = true;
				}else{
					swapNodeRight = false;
				}
				
				Node tempParent = leadingNode.parent;
				if(swapLeadingRight){
					Node tempChild = leadingNode.parent.right;
				}else{
					Node tempChild = leadingNode.parent.left;
				}
				
						
				leadingNode.parent = node.parent;
				
				if(swapNodeRight){
					node.parent.right = leadingNode;
				}else{
					node.parent.left = leadingNode;
				}
				
				node.parent = tempParent;
				
				if(swapNodeRight){
					leadingNode.parent.right = node;
				}else{
					leadingNode.parent.left = node;
				}
				
				String temp = leadingNode.bit;
				leadingNode.bit = node.bit;
				node.bit = temp;
				
				
			}
				
			}
			node.weight++;
			if(node.parent != null){
				updateTree(node.parent);
			}
		}
	}
	
	
	/**
	 * This method is used to locate the leader of a block. The node passed in is the root node. A breadth first search is then
	 * used to find a node with the same weight, which will then be used in the swap updateTree.
	 * 
	 * @param node
	 * @param weight
	 * @return
	 */
	
	public Node locateLeader(Node node, int weight){
	
		
		Node ls = new Node(0,0 ,'¬',"","", Integer.MAX_VALUE);
		Node rs = new Node(0,0 ,'¬',"","",Integer.MAX_VALUE);
		
		
		
		if(node.isLeaf()){
			if(node.weight == weight){
				return node;
			}
		}
		
		if(node.right != null){
			if(node.right.weight == weight){
				return node.right;
			}else{
				rs = locateLeader(node.right, weight);
			}
		}
		
		if(node.left != null){
			if(node.left.weight == weight){
				return node.left;
			}else{
				ls = locateLeader(node.left, weight);
			}
		}
		
		if(rs.level <= ls.level) return rs;
		return ls;
		
		
	}
	
	/**
	 * This method creates a new node, adding it to the map and tree. Adds to the right or left of the node passed into
	 * the method depending on the boolean value also passed into it.
	 * 
	 * @param node
	 * @param c
	 * @param right
	 */
	
	public void createNewNode(Node node, char c, boolean right){
		if(!right){
			node.left = new Node(id++,0,c , "" , node.path + "0", node.level +1);
			node.left.parent = node;
			map.put(c, node.left);
		}else{
			node.right= new Node(id++, 0, c, "", node.path + "1",  node.level +1);
			node.right.parent = node;
			map.put(c, node.right);
		}
		
	}
	
	/**
	 * This method will return the path to a character in the form of a string of 1's and 0's.
	 * 
	 * 
	 */
	
	public String getPath(char c) {
		Node node = map.get(c);
		return node.path;
	}
	
	/**
	 * This method is used during the decoding section of the program. Used to add Nodes to the tree when rebuilding it.
	 * 
	 */

	public void addCharBack(char newChar) {
		Node nytNode = map.get('¬');
		map.remove(nytNode);
		System.out.println("nytNode character is" + nytNode.character);
		createNewNode(nytNode, '¬', false);
		createNewNode(nytNode, newChar, true);
		
		updateTree(nytNode.right);
		
	}
	
	

}
