import java.io.IOException;
import java.net.ServerSocket;

public class Server {

	public static void main(String[] args) throws IOException {

		// Initialising of the socket on the server side.
		ServerSocket server = new ServerSocket(7869);

		// Creating a new ServerThread every time a new client tries to start up
		// communication with the server
		while (true) {
			new ServerThread(server.accept()).start();
		}
	}

}
