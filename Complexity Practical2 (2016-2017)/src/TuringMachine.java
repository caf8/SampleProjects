import java.io.File;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
/**
 * This class is used to call methods on a TM to simulate one.
 * @author 140012021
 *
 */
public class TuringMachine {
	static int transitionMade = 0;
	static List<String> tape = new ArrayList<String>();
	
	/**
	 * This function simulates a Turing Machine and returns what state it ends in.
	 * @param table
	 * @param input
	 * @param current
	 * @param statesArray
	 * @param writer 
	 */
	public static void process(List<String[]> table, String input, States current, States[] statesArray, File file, PrintWriter writer){
		
		int head = 0;
		for (int i = 0; i < input.length(); i++) {
			tape.add(Character.toString(input.charAt(i)));
		}
		tape.add("_");
		boolean transition = false;
		while(!(current.isReject || current.isAccept)){

			transition = false;
			String currentLetter = tape.get(head);
			
			for(int i = 0; i < table.size(); i++){
				if(!transition){
					if(table.get(i)[0].equals(current.name)){
						if(table.get(i)[1].equals(currentLetter)){
							current = getNextState(statesArray, table.get(i)[2]);
							tape.set(head, table.get(i)[3]);
							
							if(table.get(i)[4].equals("R")){
								transitionMade++;
								head++;
								transition = true;
							}else if (table.get(i)[4].equals("L") && head != 0){
								transitionMade++;
								head--;
								transition = true;
							}
						}
					}
				}
			}
			if(current.isAccept == true){
				System.out.println(input + " " + "ACCEPTED");
				System.out.println("Transitions made " + transitionMade);
				writer.println(input.length() + "," + " " + transitionMade);
				transitionMade = 0;
				tape.clear();
			}
			if(current.isReject == true){
				System.out.println(input + " " + "Rejected");
				System.out.println("Transitions made " + transitionMade);
				writer.println(input.length() + "," + " " + transitionMade);
				transitionMade = 0;
				tape.clear();
			}
			
		}
	}

	/**
	 * This function gets the next state from the States array. It will be used to check if it is an accept state or not.
	 * @param statesArray
	 * @param string
	 * @return
	 */
	private static States getNextState(States[] statesArray, String string) {
		for (int i = 0; i < statesArray.length; i++) {
			if(statesArray[i].name.equals(string)){
				return statesArray[i];
			}
		}
		return null;
	}
	
	
}
