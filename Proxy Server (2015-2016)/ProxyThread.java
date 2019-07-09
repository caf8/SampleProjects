import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import javax.net.ssl.HttpsURLConnection;
import javax.swing.plaf.synth.SynthSeparatorUI;

/**
 * This class provides the main functionality of the program. It contains the
 * majority of the the methods of the program, that will make a connection to a
 * URL secure.
 * 
 * @author 140012021
 *
 */

public class ProxyThread extends Thread {

	private HttpsURLConnection con = null;
	private Socket socket;

	public ProxyThread(Socket socket) {
		this.socket = socket;
	}

	@Override
	public void run() {

		try {

			BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));

			String inputUrl;

			if ((inputUrl = in.readLine()) != null) {

				cleanUrl(inputUrl);

			}

		} catch (IOException e) {
			System.out.println(
					"There was an error from the website's side of the proxy, which" + "is not possible to handle");
		}

		try {
			socket.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * This method takes in the URL and cleans it so only the http address is
	 * remaining. The method also calls setUpConnection().
	 * 
	 * @param inputUrl
	 * @throws IOException
	 */

	private void cleanUrl(String inputUrl) throws IOException {
		String[] array = inputUrl.split(" ");
		inputUrl = array[1];
		System.out.println(inputUrl);
		setUpConnection(inputUrl);

	}

	/**
	 * This method sets up the secure connection. It takes in the URL and makes
	 * a new one while changing http to https. It then initiates a https
	 * connection to send the data back over. It also calls checkCache(),
	 * checkHttpCodes() and getHttpBytes().
	 * 
	 * @param inputUrl
	 * @throws IOException
	 */

	public void setUpConnection(String inputUrl) throws IOException {

		URL url1 = new URL(inputUrl);

		URL url2 = new URL("https", url1.getHost(), url1.getPort(), url1.getFile());

		System.out.println("URL: " + url2);

		checkCache(url2.toString());

		con = (HttpsURLConnection) url2.openConnection();

		con.setRequestProperty("User-Agent",
				"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36");

		checkHttpCodes(con);

		getHttpBytes(url2, con);
		con.disconnect();

	}

	/**
	 * This method checks the http response codes to see if any of them redirect
	 * and if so makes the redirect secure.
	 * 
	 * @param connection
	 * @throws IOException
	 */

	private void checkHttpCodes(HttpsURLConnection connection) throws IOException {

		int httpCode = connection.getResponseCode();

		System.out.println(httpCode);

		if (httpCode >= 300 && httpCode <= 400) {
			URL url1 = new URL(con.getHeaderField("Location"));

			URL url2 = new URL("https", url1.getHost(), url1.getPort(), url1.getFile());

			con = (HttpsURLConnection) url2.openConnection();
			con.setRequestProperty("User-Agent",
					"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36");
		}

	}

	/**
	 * This method reads in the bytes into a Bytes[] which is then written out
	 * back over the socket using a secure connection. The output streams are
	 * then flushed to make sure all the bytes have been written. The method
	 * then calls createCache().
	 * 
	 * @param url
	 * @param con
	 * @throws IOException
	 */

	private void getHttpBytes(URL url, HttpsURLConnection con) throws IOException {

		InputStream in = new BufferedInputStream(con.getInputStream());
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		BufferedOutputStream out2 = new BufferedOutputStream(socket.getOutputStream());

		byte[] buf = new byte[1024];
		int n = 0;
		while (-1 != (n = in.read(buf))) {
			out.write(buf, 0, n);
		}
		out.close();
		in.close();
		byte[] response = out.toByteArray();
		out2.write(response);
		out2.flush();

		createCache(response, con, url);

	}

	/**
	 * This method creates the cache object to be stored in the
	 * ConnectedHashMap. It only adds it to the cache/Map if it as a TTL greater
	 * than 0.
	 * 
	 * @param response
	 * @param con
	 * @param url
	 */

	private void createCache(byte[] response, HttpsURLConnection con, URL url) {

		String name = url.toString();

		String str = con.getHeaderField("Cache-Control");

		cache cache = new cache(response, System.currentTimeMillis(), str, url);

		if (cache.getMax_age() > 0) {
			Proxy.cached.put(name, cache);
		}

	}

	/**
	 * This method checks the cache to see if a URL and its bytes have already
	 * been visited and stored. If they have it then checks if the bytes are
	 * still up to date by using it's time to live. It removes the cached
	 * element if it's TTL is 0, if not it writes out the bytes from the cache.
	 * 
	 * @param url1
	 * @throws IOException
	 */

	private void checkCache(String url1) throws IOException {
		if (Proxy.cached.containsKey(url1)) {
			long timeCreated = Proxy.cached.get(url1).getTimeCreated();
			long currentTime = System.currentTimeMillis();
			if ((currentTime - timeCreated) > Proxy.cached.get(url1).getMax_age()) {
				Proxy.cached.remove(url1);

			} else {
				BufferedOutputStream out2 = new BufferedOutputStream(socket.getOutputStream());
				out2.write(Proxy.cached.get(url1).getBytes());
				out2.flush();
			}
		}

	}

	@Override

	public void start() {
		super.start();
		System.out.println("Thread opened: " + socket.getInetAddress());

	}

}
