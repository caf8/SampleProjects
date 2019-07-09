import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

/**
 * Main class of test suite
 * @author 140012021
 *
 */
public class main {
	//Final static variables to change number of iterations and what file it writes too.
	public final static int itertaions = 500;
	public static String file = "FFT.csv";
	static double totalTime = 0;
	
	public static void main(String[] args) throws IOException {
		Complex[] warmUp = new Complex [Test.warmUpIteration];
		
		Random random = new Random();
		double rand = random.nextDouble();
		for (int i = 0; i < warmUp.length; i++) {
			warmUp[i] = new Complex(random.nextDouble(), random.nextDouble());
		}
		Test test =  new Test();
		Test.warmUpDft(warmUp);
		
		
		PrintWriter writer = new PrintWriter(file);
		Test.initialise(writer);
		
		//Loop through the factors of 2 up to 2^13.
		for (int k = 1; k < 14; k++) {
			totalTime = 0;
			Complex [] x = Test.populateArray((int)Math.pow(2, k));
				
			for (int i = 0; i < itertaions; i++) {
				double startTime = System.nanoTime();
				FFT.fft(x);
				double endTime = System.nanoTime();
				totalTime = totalTime + (endTime - startTime);
			}
			
			//Works out average time and writes it to a CSV file names at top of code.
			double averageTime = totalTime/itertaions;
			
			System.out.println("n= " + (int)Math.pow(2, k) + ", average time = " + averageTime);
			writer.print((int)Math.pow(2, k));
			writer.print(',');
			writer.print(averageTime);
			writer.print(',');
			writer.print('\n');
			
			
			}
			writer.flush();
			writer.close();

	}

}
