import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;

public class MergeSort {

	// Variables used to stop magic numbers.

	final static int arraySize = 100;
	final static int loopSize = 100000;

	public static void main(String[] args) throws IOException {
		PrintWriter writer = new PrintWriter(
				new FileWriter("/cs/home/caf8/Documents/Graph/100000Merge60sizereversed.csv", true));
		long counter = 0;

		// External loops dictating how big the array is and how many
		// times each array size is tested on.

		writer.println("merge_size, merge_time");
		for (int k = 0; k < arraySize; k++) {
			counter = 0;
			for (int j = 1; j < loopSize; j++) {

				int[] array = new int[k];

				for (int i = 0; i < array.length; i++) {
					array[i] = (int) (Math.random() * 100);
				}

				long startTime = System.nanoTime();

				array = mergeSort(array);

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
	 * This method implements a merge sort on an int[] in ascending order.
	 * 
	 * @param array
	 * @return
	 */
	
	private static int[] mergeSort(int[] array) {
		if (array.length > 1) {

			int middle = array.length / 2;
			int[] left = Arrays.copyOfRange(array, 0, middle);
			int[] right = Arrays.copyOfRange(array, middle, array.length);
			left = mergeSort(left);
			right = mergeSort(right);

			int i = 0;
			int j = 0;
			int k = 0;

			while (i < left.length && j < right.length) {
				if (left[i] < right[j]) {
					array[k] = left[i];
					i++;
				} else {
					array[k] = right[j];
					j++;
				}
				k++;
			}
			while (i < left.length) {
				array[k] = left[i];
				i++;
				k++;
			}

			while (j < right.length) {
				array[k] = right[j];
				j++;
				k++;
			}

		}
		return array;
	}

}
