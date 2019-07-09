import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Random;
import java.util.Scanner;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;;
/**
 * This class is the main class of the chatbot program. It contains the main method
 * and other methods that are used throughout the program.
 * 
 * @author 140012021
 *
 */
public class main {

	/**
	 * The main method contains a loop that keeps taking input until someone wants to exit.
	 * It calls other methods throughout the program as well.
	 * @param args
	 * @throws IOException
	 * @throws ParseException
	 */
	public static void main(String[] args) throws IOException, ParseException {
		System.out.println("DR Mathison: Hello my name is Dr Mathison, I'm a psychiatrist. Enter exit to quit.");
		FileReader reader = new FileReader("data.json");
		MarkovChain markov = new MarkovChain();
		markov.createDictionary();
		JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(reader);
		List<String> keyWordsList = getKeyWords(obj);
		
		Scanner scanner = new Scanner(System.in);
		boolean seen = false;
		String in;
		while(!(in = scanner.nextLine()).equals("exit")){ 
			PriorityQueue<keyWordObj> queue = new PriorityQueue<keyWordObj>();
			String [] words = in.split(" ");
			
			for (int i = 0; i < words.length; i++) {
				if(keyWordsList.contains(words[i].toLowerCase())){
					seen = true;
					 JSONArray response = (JSONArray) obj.get(words[i].toLowerCase());
					 String[] arr = response.toString().replace("},{", " ,").split(" ");
					 String temp = arr[0].substring(1,3);
					 temp = temp.replaceAll(" ", "");
					 temp = temp.replaceAll(",", "");
					 int weight = Integer.parseInt((temp));
					 queue.add(new keyWordObj(words[i], weight));
				}
			}
		
			if(seen){
				String word = queue.peek().name;
				getResponseData(word, obj, in);
			}else{
				words = sortWords(words);
				boolean alreadyPosted = false;
				for (int i = 0; i < words.length; i++) {
					String output = markov.createResponse(words[i]);
					if(!output.equals("")){
						alreadyPosted = true;
						System.out.println("DR Mathison: " + output);
						break;
					}
				}
				if(!alreadyPosted){
					noKeyWordRepsonse(obj);
				}		
			}
			seen = false;
		}
	}
	
	/**
	 * This method uses a bubble sort to sort the String array of words by
	 * length of word in descending order.
	 * 
	 * @param words
	 * @return
	 */
	private static String[] sortWords(String[] words) {
		String temp;
		
		for (int i = 0; i < words.length; i++) {
			for (int j = 1; j < words.length - i; j++) {
				if (words[j-1].length() < words[j].length()){
					temp = words[j-1];
					words[j-1] = words[j];
					words[j] = temp;
				}
			}
		}
		return words;
	}

	/**
	 * This method is used to when no response could be found from the JSON file or
	 * the Markov chain.
	 * @param obj
	 */
	private static void noKeyWordRepsonse(JSONObject obj) {
		JSONArray response2 = (JSONArray) obj.get("xnone");
		String[] split = response2.get(1).toString().split("\",\"");
		
		for (int j = 0; j < split.length; j++) {
			split[j] =  split[j].replace("\"", "").replace("[", "").replace("]", "").replace("*", "").replace(",", "");
		}
		
		Random rn = new Random();
		int choice = rn.nextInt(split.length);
		
		System.out.println("DR Mathison: " + split[choice]);
	}

	/**
	 * This method is used the structure of the reply that will be used i.e "* word * word" or "*".
	 * If it is just a "*" it will get a response from there, otherwise it goes to the method sendResponse
	 * which decomposes it. Checks for goto and if is seen then it does getResponseData again with the new
	 * word.
	 * 
	 * @param word
	 * @param obj
	 * @param in
	 */
	private static void getResponseData(String word, JSONObject obj, String in){
		JSONArray response2 = (JSONArray) obj.get(word.toLowerCase());
		
		for (int i = 0; i < ((ArrayList) response2.get(1)).size(); i++) {
			String [] commaParse = (String[]) ((ArrayList) response2.get(1)).get(i).toString().split(",");
			commaParse[0] = commaParse[0].replace("[", "").replace("\"", "");
			if(commaParse[0].equals("*")){
				for (int j = 0; j < commaParse.length; j++) {
					commaParse[j] =  commaParse[j].replace("\"", "").replace("[", "").replace("]", "").replace("*", "").replace(",", "");
				}
				Random rn = new Random();
				int choice = rn.nextInt(commaParse.length-1) + 1;
				if(commaParse[choice].contains("goto")){
					String [] nextWord = commaParse[choice].split(" ");
					in = in.replace(word, nextWord[1]);
					getResponseData(nextWord[1], obj, in);
				}else{
					if(commaParse[choice].matches(".*\\d+.*")){
						commaParse[choice] = commaParse[choice].replaceAll("[0-9]", in);
						commaParse[choice] = commaParse[choice].replace("(", "").replace(")", "");
					}
					System.out.println("DR Mathison: " + commaParse[choice]);
				}
			}else{
				if (in.contains(commaParse[0].substring(2, commaParse[0].length()-2))) {
					sendResponse(in, commaParse[0], commaParse[0].substring(2, commaParse[0].length()-2),obj,word);
				}
			}
		}
	}
	
	/**
	 * This method parses the decomposition structure and uses regex to check that the
	 * input matches the decomposition structure that the JSON file returned. It also then
	 * puts the right section of the input into the output at the corresponding number.
	 * 
	 * @param in
	 * @param commaParse
	 * @param phrase
	 * @param obj
	 * @param word
	 */
	private static void sendResponse(String in, String commaParse, String phrase, JSONObject obj, String word) {
		String originalcommaParse = commaParse;
		commaParse = commaParse.replace("*", ".*[a-zA-Z]+.*");
		if(in.matches(commaParse)){
			JSONArray response3 = (JSONArray) obj.get(word.toLowerCase());
			for (int i = 0; i < ((ArrayList) response3.get(1)).size(); i++) {
				String [] commaParse2 = (String[]) ((ArrayList) response3.get(1)).get(i).toString().split(",");
				commaParse2[0] = commaParse2[0].replace("[", "").replace("\"", "");
				if(commaParse2[0].equals(originalcommaParse)){
					Random rn = new Random();
					int choice = rn.nextInt(commaParse2.length-1)+1;
					String chosenReply = commaParse2[choice].replace("[", "").replace("\"", "").replace("]", "");
					
					if(chosenReply.matches(".*\\d+.*")){
						in = in.replace(phrase, "$");
						String [] tokenSplit = in.split(" ");
						String [] numberArr  = new String[tokenSplit.length];
						for (int j = 0; j < numberArr.length; j++) {
							numberArr[j] = "";
						}
						int counter = 0;
						for (int j = 0; j < tokenSplit.length; j++) {
							if(!tokenSplit[j].equals("$")){
								numberArr[counter] = numberArr[counter] + tokenSplit[j] + " ";
							}else{
								counter++;
								numberArr[counter] = numberArr[counter] + tokenSplit[j] + " ";
								counter++;
							}
						}
						int part = 0;
						for (int k = 0; k < chosenReply.length(); k++) {
							if(Character.isDigit(chosenReply.charAt(k))){
								part = Character.getNumericValue(chosenReply.charAt(k));
							}
						}
						chosenReply = chosenReply.replaceAll("[0-9]", numberArr[part]);
						chosenReply = chosenReply.replace("(", "");
						chosenReply = chosenReply.replace(")", "");
						if(chosenReply.contains("goto")){
							String [] nextWord = chosenReply.split(" ");
							getResponseData(nextWord[1], obj, in);
						}else{
							System.out.println("DR Mathison: " + chosenReply);
						}
					}else{
						if(chosenReply.contains("goto")){
							String [] nextWord = chosenReply.split(" ");
							getResponseData(nextWord[1], obj, in);
						}else{
							System.out.println("DR Mathison: " + chosenReply);
						}
					}
				}
			}
		}
	}

	/**
	 * This method creates the list of all key words from the JSON file.
	 * 
	 * @param obj
	 * @return
	 */
	private static List<String> getKeyWords(JSONObject obj) {
		 List<String> keyList = new ArrayList<String>();
		 
		 for(Iterator iterator = obj.keySet().iterator(); iterator.hasNext();) {
			    String key = (String) iterator.next();
			    keyList.add(key);
		 }
		return keyList;
	}
}