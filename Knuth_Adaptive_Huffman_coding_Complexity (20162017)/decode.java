/**
 * This class contains the methods that decode the message from the file.
 * 
 * @author 140012021
 *
 */
public class decode {

	
	private Tree tree = new VitterTree();
	
	
	/**
	 * This method turns the coded message back into its original form, by calling the decodeLeaf() method.
	 * Calls the bitToChar method().
	 * 
	 * @param code
	 * @return
	 */
	public String decode(String code) {
		System.out.println(code);
		
		String output = "";
		String decoded = "";
		
		
		for (int i = 0; i < code.length();) {
			char c = tree.decodeLeaf(output);
			
			if(c != '`'){
				if(c == '¬'){
					char newChar = bitToChar(code.substring(i, i+8));
					tree.addCharBack(newChar);
					i+=8;
					decoded += newChar;
					
				}else{
					decoded += c;
				}
				output = "";
			}
			if(i < code.length())output += code.charAt(i++);
		}
		if(output != "") decoded += tree.decodeLeaf(output);
		System.out.println(decoded);
		return decoded;
	}
			


	/**
	 * This method takes an 8 bit binary string and converts it into its corresponding character.
	 * 
	 * @param substring
	 * @return
	 */
	private char bitToChar(String substring) {
		int parseInt = Integer.parseInt(substring,2);
		
		char c = (char)parseInt;
		return c;
	}
	
	
	
}
