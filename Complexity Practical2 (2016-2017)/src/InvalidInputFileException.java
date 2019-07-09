/**
 * This class is an exception that extends the Exception class and prints out a custom message.
 * @author 140012021
 *
 */
public class InvalidInputFileException extends Exception {

	public InvalidInputFileException(String msg){
		System.out.println(msg);
	}

}
