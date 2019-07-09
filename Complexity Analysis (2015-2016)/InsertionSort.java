import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

public class InsertionSort {

	// Variables used to stop magic numbers.

	final static int arraySize = 100;
	final static int loopSize = 100000;

	public static void main(String[] args) throws FileNotFoundException {
		File file = new File("/cs/home/caf8/Documents/Graph/10000insertion10000size.csv");
		PrintWriter writer = new PrintWriter(file);
		long counter = 0;

		// External loops dictating how big the array is and how many
		// times each array size is tested on.

		writer.println("insertion_size, insertion_time");
		for (int k = 0; k < arraySize; k++) {
			counter = 0;
			for (int j = 1; j < loopSize; j++) {

				int[] array = new int[k];

				for (int i = 0; i < array.length; i++) {
					array[i] = (int) (Math.random() * 100);
				}

				long startTime = System.nanoTime();

				array = insertion(array);

				long endTime = System.nanoTime();

				long timeTaken = endTime - startTime;

				counter = counter + timeTaken;

			}
			counter = counter / loopSize;
			writer.println(k + "," + " " + counter);
			System.out.println("k" + " " + k);
		}
		writer.flush();
		writer.close();
	}

	/**
	 * This method implements an insertion sort on an int[] in ascending order.
	 * 
	 * @param array
	 * @return
	 */
	private static int[] insertion(int[] array) {
		for (int i = 0; i < array.length; i++) {
			int currentValue = array[i];
			int position = i;

			while (position > 0 && array[position - 1] > currentValue) {
				array[position] = array[position - 1];
				position = position - 1;

			}
			array[position] = currentValue;
		}
		return array;

	}

}
