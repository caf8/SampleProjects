import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class Client {

	// Variable for both client and sever to know if another request will be
	// made.

	public static boolean end = false;

	public static void main(String[] args) throws IOException {

		// Initialising of variables to be used in network communication

		Socket socket = new Socket("localhost", 7869);
		PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
		BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
		BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));

		// Initialising of variables to be used for listing files.

		File folderDirectory = new File(".");
		File[] allFiles = folderDirectory.listFiles();

		// Beginning of do while loop overseeing the whole functionality of the
		// program.
		do {

			// for loop that gets the name of the files in the current directory
			// and only displays them if they are
			// a .txt file.
			System.out.println("These are the files in the same directory as the server.");
			for (int i = 0; i < allFiles.length; i++) {
				if (allFiles[i].isFile()
						&& allFiles[i].getName().substring((allFiles[i].getName()).length() - 4).equals(".txt")) {
					System.out.println(allFiles[i].getName());
				}
			}

			String filename = "";

			// Loop checking if file name entered is file in the directory.
			loop: while (true) {
				System.out.println();
				System.out.println("Please enter one of following text files to prefrom a process on.");

				while ((filename = stdIn.readLine()) != null) {
					System.out.println("Please enter one of following text files to prefrom a process on.");

					for (int i = 0; i < allFiles.length; i++) {
						if (filename.equals(allFiles[i].getName())) {
							break loop;
						}
					}
				}
			}

			// switch statement which performs different tasks depending on the
			// users input.
			PrintWriter writer = null;
			do {
				System.out.println("Enter option 1 to save the file and option 2 to print the file");
				switch (stdIn.readLine()) {
				case "1":
					writer = new PrintWriter("output/" + filename);
					break;
				case "2":
					writer = new PrintWriter(System.out);
					break;
				}
			} while (writer == null);

			// Process of sending the filename to the server and getting back a
			// response. Printing it out if
			// it is not the end of the file of null.
			out.println(filename);
			String netInput;
			while (!(netInput = in.readLine()).equals("eof") && (netInput != null)) {
				writer.println(netInput);
				writer.flush();
			}

			// Checking if the user would like to preform an action on another
			// .txt file
			System.out.println();
			System.out.println("Would you like to preform another task? 'Y' for yes 'N' for no");
			String checkString = stdIn.readLine();
			while (!(checkString.equals("Y")) || (!checkString.equals("N"))) {
				if (!(checkString.equals("Y")) && (!checkString.equals("N"))) {
					checkString = stdIn.readLine();
				}
				if (checkString.equals("N")) {
					end = true;
				}
				break;
			}
			if (end) {
				writer.close();
			}
		} while (!end);

		// Essential closing processes so the program can terminate.
		out.close();
		in.close();
		stdIn.close();
		socket.close();

	}

}
