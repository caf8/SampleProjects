import java.io.IOException;
import java.net.ServerSocket;
import java.util.concurrent.ConcurrentHashMap;

/**
 * This class initiates the each of the threads in the multi-threading, along with setting up
 * the server socket to be used throughout the program. It also contains the ConcurrentHashMap that
 * will be used to store data for the cache.
 * 
 * 
 * @author 140012021
 *
 */

public class Proxy {

	static ConcurrentHashMap<String, cache> cached = new ConcurrentHashMap<String, cache>();

	public static void main(String[] args) throws IOException {

		ServerSocket socket = new ServerSocket(14700);

		while (true) {
			new ProxyThread(socket.accept()).start();
		}

	}

}
