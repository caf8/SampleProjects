import static org.junit.Assert.*;

import java.util.HashMap;
import java.util.Map;

import org.junit.Test;

/**
 * This class contains the JUnit Tests for the program.
 * 
 * @author 140012021
 *
 */
public class JunitTest {
	int id = 0;
	private Tree.Node root;
	boolean swapLeadingRight;
	boolean swapNodeRight;
	char charAt = 'c';
	char charAt1 = 'b';
	Map <Character, Tree.Node> map = new HashMap<Character, Tree.Node>(); 
	
	/**
	 * This test checks if a new character is being added correctly to the Tree.
	 * 
	 */
	@Test
	public void addNewChar() {
		 
		root = new Tree.Node(0, 0, '¬', "","",0, null, null);	
		map.put('¬', root);
		
		
		Tree.Node nytNode = map.get('¬');
		map.remove(nytNode);
		createNewNode(nytNode, '¬', false);
		createNewNode(nytNode, charAt, true);
		
		assertEquals(root.right.character, 'c');
		
		
	}
	/**
	 * This test checks if the weight of a node is being correctly incremented after the Tree is updated.
	 * 
	 */
	
	@Test
	public void checkWeightIncrease(){
		
		root = new Tree.Node(0, 0, '¬', "","",0, null, null);	
		map.put('¬', root);
		
		
		Tree.Node nytNode = map.get('¬');
		map.remove(nytNode);
		createNewNode(nytNode, '¬', false);
		createNewNode(nytNode, charAt, true);
		
			
			Tree.Node node = map.get(charAt);
			updateTree(node);
			updateTree(node);
			
		assertEquals(node.weight, 2);
		
	}
	
	/**
	 * This test checks that the locateLeader method is returning the correct node. It also checks that the swaps are being performed
	 * correctly too.
	 * 
	 */
	
	@Test
	public void checkLocateLeader(){
		
		root = new Tree.Node(0, 0, '¬', "","",0, null, null);	
		map.put('¬', root);
		
		
		Tree.Node nytNode = map.get('¬');
		map.remove(nytNode);
		createNewNode(nytNode, '¬', false);
		createNewNode(nytNode, charAt, true);
		
			
			Tree.Node node = map.get(charAt);
			updateTree(node);
		
			Tree.Node nytNode1 = map.get('¬');
			map.remove(nytNode1);
			createNewNode(nytNode1, '¬', false);
			createNewNode(nytNode1, charAt1, true);
			
			Tree.Node node1 = map.get(charAt1);
			updateTree(node1);
			

			assertEquals(root.right.character, 'c');
			
			updateTree(node1);
			
			assertEquals(root.right.character, 'b');
			
			
			Tree.Node leadingNode = locateLeader(root, node.weight);
			
			
			assertEquals(leadingNode.character, 'b');
		
		
		
		
	}
	

	/**
	 * This method creates a new node, adding it to the map and tree. Adds to the right or left of the node passed into
	 * the method depending on the boolean value also passed into it.
	 * 
	 * @param node
	 * @param c
	 * @param right
	 */
	public void createNewNode(Tree.Node node, char c, boolean right){
		if(!right){
			node.left = new Tree.Node(id++,0,c , "" , node.path + "0", node.level +1);
			node.left.parent = node;
			map.put(c, node.left);
		}else{
			node.right= new Tree.Node(id++, 0, c, "", node.path + "1",  node.level +1);
			node.right.parent = node;
			map.put(c, node.right);
		}
		
	}
	
	/**
	 * This method is used to increment the weight of the nodes and perform the swaps necessary to keep to Vitter's algorithm.
	 * Swaps are made depending on what type of node is being swapped. (Leaf or Internal). The method calls another method called
	 * leadingNode(), while also recursively calling itself.
	 * 
	 * @param node
	 */
	
	public void updateTree(Tree.Node node){
		Tree.Node leadingNode;
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
					
					Tree.Node temp = node.parent;
					
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
				
				Tree.Node tempParent = leadingNode.parent;
				if(swapLeadingRight){
					Tree.Node tempChild = leadingNode.parent.right;
				}else{
					Tree.Node tempChild = leadingNode.parent.left;
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
	
	public Tree.Node locateLeader(Tree.Node node, int weight){
	
		
		Tree.Node ls = new Tree.Node(0,0 ,'¬',"","", Integer.MAX_VALUE);
		Tree.Node rs = new Tree.Node(0,0 ,'¬',"","",Integer.MAX_VALUE);
		
		
		
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
	
}
