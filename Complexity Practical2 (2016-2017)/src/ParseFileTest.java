import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.junit.Test;

public class ParseFileTest {

	
	@Test
	public void isIntialStateTest() throws FileNotFoundException {
		BufferedReader reader = new BufferedReader(new FileReader("Test1.txt"));
		
		ParseFile file1 = new ParseFile();
		States[] statesArray = new States[4];
		statesArray[0] = new States("q0", false, false, true);
		statesArray[1] = new States("q1", true, false, false);
		statesArray[2] = new States("q2", false, true, false);
		statesArray[3] = new States("q3", false, false, false);

		assertEquals(statesArray[0], file1.isIntial(statesArray));
	}

	@Test
	public void testTransitionTable(){
		ParseFile file1 = new ParseFile();
		States[] statesArray = new States[4];
		statesArray[0] = new States("q0", false, false, true);
		statesArray[1] = new States("q1", true, false, false);
		statesArray[2] = new States("q2", false, true, false);
		statesArray[3] = new States("q3", false, false, false);
		String[] alphabet = new String[2];
		alphabet[0] = "a";
		alphabet[1] = "b";
		String transition = "q0 a q0 a R";
		String[] transitionArr = transition.split(" ");
		
		assertEquals(true, file1.isState(transitionArr[0], statesArray));
		assertEquals(true, file1.isAlphabet(transitionArr[1], alphabet));
		assertEquals(true, file1.isLR(transitionArr[4]));
		
		assertEquals(false, file1.isLR("a"));
		assertEquals(false, file1.isAlphabet("V", alphabet));
		assertEquals(false, file1.isState("q4", statesArray));
		
	}
	
	@Test
	public void testCheckSymbol(){
		ParseFile file1 = new ParseFile();
		String line1 = "q1 +";
		String line2 = "q2";
		String line3 = "q3 -";
		String line4 = "q4 q5 +";
		String line5 = " ";
		String line6 = "-";
		String line7 = "+ -";
		
		
		assertEquals("+", file1.checkSymbol(line1));
		assertEquals("q2", file1.checkSymbol(line2));
		assertEquals("-", file1.checkSymbol(line3));
		assertEquals("%", file1.checkSymbol(line4));
		assertEquals("%", file1.checkSymbol(line5));
		assertEquals("-", file1.checkSymbol(line6));
		assertEquals("-", file1.checkSymbol(line7));
		
	}
	
	@Test(expected=InvalidInputFileException.class)
	public void testAlphabetSpelling() throws IOException, InvalidInputFileException{
		BufferedReader reader = new BufferedReader(new FileReader("testAlphabet1.txt"));
		ParseFile file1 = new ParseFile();
		file1.obtainAlphabet(reader);
	}
	
	
	@Test(expected=InvalidInputFileException.class)
	public void testAlphabetWrongSize() throws IOException, InvalidInputFileException{
		BufferedReader reader = new BufferedReader(new FileReader("testAlphabet2.txt"));
		ParseFile file1 = new ParseFile();
		file1.obtainAlphabet(reader);
	}
	
	@Test
	public void testisState(){
		ParseFile file1 = new ParseFile();
		States[] statesArray = new States[4];
		statesArray[0] = new States("q0", false, false, true);
		statesArray[1] = new States("q1", true, false, false);
		statesArray[2] = new States("q2", false, true, false);
		statesArray[3] = new States("q3", false, false, false);
		
		assertEquals(true, file1.isState("q0", statesArray));
		assertEquals(true, file1.isState("q1", statesArray));
		assertEquals(true, file1.isState("q2", statesArray));
		assertEquals(true, file1.isState("q3", statesArray));
		assertEquals(false, file1.isState("q5", statesArray));
		assertEquals(false, file1.isState(" ", statesArray));
		assertEquals(false, file1.isState("342583*&9", statesArray));
	}
	

}
