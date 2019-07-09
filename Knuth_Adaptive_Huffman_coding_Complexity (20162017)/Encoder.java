import java.io.*;
import java.util.Map;
import java.lang.*;

/**
 * This class contains the methods that encode the message from the file.
 * @author 140012021
 *
 */
public class Encoder {
	

	private Tree tree = new VitterTree();
	private DataOutputStream save;
	FileOutputStream saveFile;
	int counter = 0;
	
	//Constructor for the encoder class.
	public Encoder() throws FileNotFoundException {
		super();
		this.saveFile = new FileOutputStream("output.txt");
		this.save = new DataOutputStream(saveFile);
		
	}

	/**
	 * This method encodes the message from the input file by building up the encoded message from different paths.
	 * Calls the fillBuffer() method.
	 * @param message
	 * @return
	 * @throws IOException
	 */
	public String encode(String message) throws IOException{
		
		
		
		String encoded_message = "";
		String temp = "";
		System.out.println(message);
		
		for (int i = 0; i < message.length(); i++) {
			boolean nyt = tree.getEncodeSymbol(message.charAt(i));
			if(nyt){
				encoded_message += tree.getPath('¬');
				encoded_message += charToBit(message.charAt(i));
			}
			encoded_message += tree.getPath(message.charAt(i));
			
			
			if(encoded_message.length() >= 8){
				fillBuffer(encoded_message.substring(0,8));
				encoded_message = encoded_message.substring(8, encoded_message.length());
			}
		}
		
		if(encoded_message.length() >= 1){
			fillBuffer(encoded_message);
		}
		
		
		save.close();
		
		System.out.println("---------------------------------------");
	
		return temp;
		
	}



	/**
	 * This method fills up the byte with ones and zeros depending on the message being encoded. This is done using bitwise operations.
	 * Calls the charToBit().
	 * @param encoded_message
	 * @throws IOException
	 */

	private void fillBuffer(String encoded_message) throws IOException {
	
		
		byte b = 0;
		
		for (int i = 0; i < encoded_message.length()-1; i++) {
			if(encoded_message.charAt(i) == '1'){
				b ^= 1;
				
			}
				b <<= 1;
				
				if(i == 8 && encoded_message.length() >=8){
					fillBuffer(encoded_message.substring(8, encoded_message.length()));
				}
			
		}
		
		if(encoded_message.length() < 8){
			String nyt = tree.getPath('¬');
			counter  = 8 - encoded_message.length();
			tag: for (int i = encoded_message.length(); i < 8; i++) {
				for (int j = 0; j < nyt.length(); j++) {
					if(counter == 8){
						break tag;
					}
					if(encoded_message.charAt(j) == '1'){
						counter++;
						b ^= 1;
					}else{
						counter++;
						b <<= 1;
					}
				}
				
			}
		}
	
		
		save.writeByte(b);

	}
				
	
	/**
	 * This method takes a char and returns an 8 bit binary number to be written to file.
	 * 
	 * @param c
	 * @return
	 */
	public static String charToBit(char c) {
		
		int num = (int) c;
		
		String str = Integer.toBinaryString(num);
		
		String zero = "0";
		
		for (int i = str.length(); i < 8; i++) {
			String temp = zero + str;
			str = zero + str;
			temp = "";
			
		}
		
		System.out.println(str);
		return str;
		
		
		
	}
		
}
