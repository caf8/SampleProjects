import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

import javax.activity.InvalidActivityException;
import javax.swing.plaf.synth.SynthSeparatorUI;

/**
 * This class contains the main class of the program.
 * @author 140012021
 *
 */
public class ParseFile {
	
	/**
	 * This is the main method of the program. It calls several other methods in the program. It reads the
	 * two input files to the program. Finally it creates the Turing machine and calls the process on it.
	 * @param args
	 * @throws IOException
	 * @throws InvalidInputFileException
	 */
	
	public static void main(String[] args) throws IOException, InvalidInputFileException {
		BufferedReader reader = new BufferedReader(new FileReader("PalendromeInput.txt"));
		BufferedReader reader1 = new BufferedReader(new FileReader("PalnedromeStringsInvalid.txt"));
		
		
		int numStates = checkFirstLine(reader);
		if(numStates == -1){
			throw new InvalidInputFileException("The first line descirbing the number of states is invalid");
		}
		States[] statesArray = new States[numStates];
		for (int i = 0; i < numStates; i++) {
			String line = reader.readLine();
			if(line != null){
				String symbol = checkSymbol(line);
				if(symbol.equals("%")){
					throw new InvalidInputFileException("The name of a State is not in a valid format");
				}else if(symbol.equals("+")){
					String[] str1 = line.split(" ");
					statesArray[i] = new States(str1[0], true, false, (i==0));
				}else if(symbol.equals("-")){
					String[] str1 = line.split(" ");
					statesArray[i] = new States(str1[0], false, true, (i==0));
				}else{
				statesArray[i] = new States(symbol, false, false, (i==0));	
				}
			}
		}
		
		String[] alphabet = obtainAlphabet(reader);
		
		
		
		String transition;
		String[] row = new String[5];
		List<String[]> table = new ArrayList<String[]>();
		while((transition = reader.readLine()) != null){
			row = parseTransition(transition, alphabet, statesArray);
			if(row.length == 5){
				table.add(row);
			}else{
				throw new InvalidInputFileException("The table in the input file is of an invalid input");
			}
			
		}
		
		File file = new File("/cs/home/caf8/Documents/3rdYear/CS3052/Practical1/PalendromeInvalid.csv");
		PrintWriter writer = new PrintWriter(file);
		writer.println("length, transitions");
		
		
		States intial = isIntial(statesArray);
		TuringMachine tm = new TuringMachine();
		String input;
		while((input = reader1.readLine()) != null){
			for (int i = 0; i < input.length(); i++) {
				if(!isAlphabet(Character.toString(input.charAt(i)), alphabet)){
					throw new InvalidInputFileException("The TM input had characters not in the alphabet");
				}
			}
			TuringMachine.process(table, input, intial, statesArray, file, writer);
		}
		writer.flush();
		writer.close();
		
	}

	/**
	 * This method parses the transition table of the TM input checking that it is in the correct format then returns
	 * the parsed table in array form
	 * @param transition
	 * @param alphabet
	 * @param statesArray
	 * @return
	 * @throws InvalidInputFileException
	 */
	private static String[] parseTransition(String transition, String[] alphabet, States[] statesArray) throws InvalidInputFileException {
		String[] transitionArr = transition.split(" ");
		if(transitionArr.length != 5){
			throw new InvalidInputFileException("Not correct format of transition table");
		}
		
			if(isState(transitionArr[0], statesArray) &&
			isAlphabet(transitionArr[1], alphabet) &&
			isState(transitionArr[2], statesArray) &&
			isAlphabet(transitionArr[3], alphabet) &&
			isLR(transitionArr[4])){
				return transitionArr;
			}
			return new String[0];
	}
	
	/**
	 * This function checks whether or not a state is an initial state. 
	 * @param statesArray
	 * @return
	 */
	public static States isIntial(States[] statesArray){
		for (int i = 0; i < statesArray.length; i++) {
			if (statesArray[i].isIntial) {
				return statesArray[i];
			}
		}
		return null;
	}
	
	/**
	 * This function checks whether the final character in the table is a L or R.
	 * @param string
	 * @return
	 */
	public static boolean isLR(String string) {
		if(string.equals("L") || string.equals("R")){
		}
		return(string.equals("L") || string.equals("R"));
		
	}

	/**
	 * This function checks if a letter is in the alphabet, returns true if it is.
	 * @param letter
	 * @param alphabet
	 * @return
	 */
	public static boolean isAlphabet(String letter, String[] alphabet) {
		for (int i = 0; i < alphabet.length; i++) {
			if(alphabet[i].equals(letter) || letter.equals("_")){
				return true;
			}
		}
		return false;
	}

	
	/**
	 * This functions checks if the state in the transition table is actually a state or not.
	 * @param stateName
	 * @param statesArray
	 * @return
	 */
	public static boolean isState(String stateName, States[] statesArray) {
		for (int i = 0; i < statesArray.length; i++) {
			if(statesArray[i].name.equals(stateName)){
				return true;
			}
		}
		return false;
	}

	/**
	 * This function checks that the alphabet has been defined correctly and returns the alphabet in a String array.
	 * @param reader
	 * @return
	 * @throws IOException
	 * @throws InvalidInputFileException
	 */
	public static String[] obtainAlphabet(BufferedReader reader) throws IOException, InvalidInputFileException {
		String alphabetString = reader.readLine();
		
		String[] alphabetArr = alphabetString.split(" ");
		
		if(!alphabetArr[0].equals("alphabet")){
			throw new InvalidInputFileException("The alphabet isn't defined correctly");
		}
		
		try{
			int sizeOfAlphabet = Integer.parseInt(alphabetArr[1]);
			
			if(alphabetArr.length != sizeOfAlphabet + 2){
				throw new InvalidInputFileException("The alphabet is not of the correct size");
			}
			
			String[] alphabet = new String[sizeOfAlphabet];
			
			for (int i = 0; i < sizeOfAlphabet; i++) {
				alphabet[i] = alphabetArr[i + 2];
			}
			
			return alphabet;
		
		
		}catch(NumberFormatException e){
			System.out.println("The size of the alpabet is probably stated in the input file");
			System.out.println(e.getMessage());
		}
		return null;
	}

	
	/**
	 * This function checks that if there is something following the name of the state, if so checks whether it
	 * is to show accept or reject state.
	 * @param line
	 * @return
	 */
	public static String checkSymbol(String line) {
		String [] parseString = line.split(" ");
		if(parseString.length == 2){
			if(parseString[1].equals("+") || parseString[1].equals("-")){
				return parseString[1];
			}
		}else if (parseString.length == 1){
			return parseString[0];
		}
			return "%";
	}

	
	/**
	 * This function parses the first line of the function to see if it is in a valid format.
	 * @param reader
	 * @return
	 * @throws IOException
	 */
	public static int checkFirstLine(BufferedReader reader) throws IOException {
		String firstLine = reader.readLine();
		String [] array = firstLine.split(" ");
		
		if(!array[0].equals("states")){
			return -1;
		}else{
			try{
			int numStates = Integer.parseInt(array[1]);
			if(numStates > 0){
				return numStates;
			}
			} catch (NumberFormatException e){
				System.out.println("Second part of String from first line is not a number");
				System.out.println(e.getMessage());
			}
			
		}
		return -1;
	}
	
}
