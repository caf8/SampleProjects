import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ServerThread extends Thread {

	private Socket socket;

	public ServerThread(Socket socket) {
		this.socket = socket;
	}

	@Override
	public void run() {

		// Loop continues until the client decides to no longer make any
		// requests.

		while (!Client.end) {

			// Takes in the name of the file from the user and returns it's
			// contents a line at a time, breaks from the loop if the file name
			// is null.
			String file;
			try {
				PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
				BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
				file = in.readLine();
				if (file == null) {
					break;
				}
				BufferedReader filereader = new BufferedReader(new FileReader(file));

				while (filereader.ready()) {
					out.println(filereader.readLine());
				}
				out.println("eof"); // sends a end of file character to show
									// that there is no more to be read.

			} catch (IOException e) {
				System.out.println("The file you entered is invlaid.");
				e.printStackTrace();
			}
		}

	}

	// Method to show that a thread has been successfully opened.
	@Override
	public void start() {
		super.start();
		System.out.println("Thread opened: " + socket.getInetAddress());
	}

}
