import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Random;
import java.util.Vector;


/**
 * This class contains the methods that create the data for the Markov chain and work out a response from it.
 * 
 * @author 140012021
 *
 */
public class MarkovChain {
	//Global variables used in MarkovChain, HashMap used to look up possible words that could be
	//added to the output sentence.
	public static HashMap<String, Vector<String>> markovDictionary = new HashMap<String, Vector<String>>();
	static boolean lastSection = false;
	
	/**
	 * This method creates the Dictionary that the program looks up from to get a word. It is populated from 
	 * the text file included with it using the addWordsToDictionary method.
	 * @throws IOException
	 */
	public static void createDictionary() throws IOException{
		markovDictionary.put("$", new Vector<String>());
		markovDictionary.put("£", new Vector<String>());
		BufferedReader reader = new BufferedReader(new FileReader("sherlock.txt"));
		String line;
		
		while((line = reader.readLine()) != null){
			if(!line.equals("")){
				addWordsToDictionary(line.substring(5, line.length()));
			}
		}
	}

	/**
	 * This method takes in a line from the text file and splits it up adding it to the Dictionary
	 * if its not already in it and it adds the word after it to the vector in the corresponding place
	 * in the hashmap.
	 * @param line
	 */
	private static void addWordsToDictionary(String line) {
		String[] words = line.split(" ");
		
		for (int i = 0; i < words.length; i++) {
			if(i==0){
				Vector<String> initialWord = markovDictionary.get("$");
				initialWord.add(words[0]);
				previouslySeen(i,words);
			}else if(i == words.length-1){
				Vector<String> lastWord = markovDictionary.get("£");
				lastWord.add(words[i]);
			}else{
				lastSection = true;
				previouslySeen(i, words);
				lastSection = false;
			}
		}
	}

	/**
	 * This method creates the response from the Markov chain by concatenating possible next words
	 * from the markovDictionary.
	 * 
	 * @param str
	 * @return
	 */
	public static String createResponse(String str){
		String response = "";
		String nextWord;
		Random rn = new Random();
		
		Vector<String> initialWord = markovDictionary.get(str);
		if (initialWord == null){
			return "";
		}
		
		nextWord = initialWord.get(rn.nextInt(initialWord.size()));
		response = response + (nextWord) + " ";
		
		int counter = 0;
		while(nextWord.charAt(nextWord.length()-1)!= '.'){
			Vector<String> nextWordChoices = markovDictionary.get(nextWord);
			if(nextWordChoices != null){
				nextWord = nextWordChoices.get(rn.nextInt(nextWordChoices.size()));
				response = response + (nextWord) + " ";
				counter++;
			}
			if(counter >20){
				return response;
			}
		}
		return response;
	}

	/**
	 * This method is used to add the words to the dictionary and the words
	 * after it to the vector.
	 * 
	 * @param i
	 * @param words
	 */
	private static void previouslySeen(int i, String[] words) {
		Vector<String> seen = markovDictionary.get(words[i]);
		
		if(seen == null){
			seen = new Vector<String>();
			if(words.length > 1){
				seen.add(words[i+1]);
			}
			markovDictionary.put(words[i], seen);
		}else if(lastSection){
			if(words.length > 1){
				seen.addElement(words[i+1]);
			}
			markovDictionary.put(words[i], seen);
		}
	}
}