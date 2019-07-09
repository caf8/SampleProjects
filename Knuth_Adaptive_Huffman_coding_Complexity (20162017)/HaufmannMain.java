import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Base64.Decoder;

/**
 * This Class contains the main method of the program.
 * 
 * @author 140012021
 *
 */
public class HaufmannMain {

	
	
	/**
	 * This method is the main method of the program. It reads in the string of characters from the file.
	 * It then creates an Encoder and Decoder
	 * @param args
	 * @throws IOException
	 */
	public static void main(String[] args) throws IOException {
		String encoded_message = "";
		String message;
		
		BufferedReader reader = new BufferedReader(new FileReader("input.txt"));
				
		
		while ((message = reader.readLine()) != null) {
			encoded_message += message;
		}
		
		
		Encoder encoder = new Encoder();
		
		decode decoder = new decode();
		
		encoder.encode(encoded_message);
		
		//String code = encoder.encode(encoded_message);
		//decoder.decode(code);
		
		
	}
	
	
}
