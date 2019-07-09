import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

public class Test {
	public static final int warmUpIteration = 100; 
	
	/**
	 * This function creates the random lists of Complex numbers and returns them to the main
	 * test suite to be used.
	 * @param k
	 * @return
	 */
	public static Complex [] populateArray(int k){
		Random random = new Random();
		Complex [] x = new Complex [k];
		for (int i = 0; i < k; i++) {
			x[i] = new Complex(random.nextDouble(), random.nextDouble());
		}
		return x;
	}
	
	/**
	 * Initialises the writer that writes to the csv file.
	 * @param writer
	 * @throws IOException
	 */
	public static void initialise(PrintWriter writer) throws IOException{
		writer.print("input_number");
		writer.print(',');
		writer.print("time_taken");
		writer.print(',');
		writer.print('\n');
	}
	
	/**
	 * This method 'warms up' java by making the class calling more optimised for the data
	 * being collected.
	 * @param x
	 */
	public static void warmUpDft(Complex [] x){
		for (int i = 0; i < warmUpIteration; i++) {
			System.out.println(i);
			DFT.dft(x);
		}
		
	}

	

	
	
	
	
}
