import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;

public class BubbleSort {

	// Variables used to stop magic numbers.

	final static int arraySize = 100;
	final static int loopSize = 100000;

	public static void main(String[] args) throws FileNotFoundException {
		File file = new File("/cs/home/caf8/Documents/Graph/Bubble60.csv");
		PrintWriter writer = new PrintWriter(file);
		long counter = 0;

		// External loops dictating how big the array is and how many
		// times each array size is tested on.

		writer.println("bubble_size1, bubble_time1");
		for (int k = 0; k < arraySize; k++) {
			counter = 0;
			for (int j = 1; j < loopSize; j++) {

				int[] array = new int[k];

				for (int i = 0; i < array.length; i++) {
					array[i] = (int) (Math.random() * 100);
				}

				long startTime = System.nanoTime();

				array = bubbleSort(array);

				long endTime = System.nanoTime();

				long timeTaken = endTime - startTime;

				counter = counter + timeTaken;

				System.currentTimeMillis();

			}
			counter = counter / loopSize;
			writer.println(k + "," + " " + counter);
			System.out.println("k" + " " + k);
		}
		writer.flush();
		writer.close();
	}

	/**
	 * This method implements a bubble sort on an int[] in ascending order.
	 * 
	 * if (!swapped) break;  Makes the method optimal, remove to make regular bubble sort again.
	 * 
	 * @param array
	 * @return
	 */
	
	private static int[] bubbleSort(int[] array) {
		boolean swapped = true;
		int j = 0;
		int temp;

		while (swapped) {
			swapped = false;
			j++;
			for (int i = 0; i < array.length - j; i++) {
				if (array[i] > array[i + 1]) {
					temp = array[i];
					array[i] = array[i + 1];
					array[i + 1] = temp;
					swapped = true;
				}
			}
			if (!swapped)
				break;
		}
		return array;
	}

}
