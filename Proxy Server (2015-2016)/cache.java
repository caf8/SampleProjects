import java.net.URL;

/**
 * This class is used to create the cache objects to be stored in the
 * ConnectedHashMap. It also calculates the TTL of the cached object.
 * 
 * @author 140012021
 *
 */

public class cache {

	private byte[] bytes;
	private long timeCreated;
	private String urlHead;
	private URL url;

	//Getters for the cache class.
	
	public byte[] getBytes() {
		return bytes;
	}

	public long getTimeCreated() {
		return timeCreated;
	}

	public static int getMax_age() {
		return max_age;
	}

	public URL getUrl() {
		return url;
	}

	public String getUrlHead() {
		return urlHead;
	}

	static int max_age;

	/**
	 * This constructor creates a cache object for the user while getting the max-age of the url.
	 * 
	 * @param bytes
	 * @param timeCreated
	 * @param urlHead
	 * @param url
	 */
	
	public cache(byte[] bytes, long timeCreated, String urlHead, URL url) {

		this.bytes = bytes;
		this.timeCreated = timeCreated;
		this.urlHead = urlHead;
		this.url = url;

		String age = null;
		String[] head = urlHead.split(" ");

		if (head[0].equals("public,")) {
			for (int i = 0; i < head.length; i++) {
				if (head[i].contains("max-age")) {
					age = head[i];
				}
			}
			System.out.println(age);
			age = age.substring(8);
			System.out.println(age);
			max_age = Integer.parseInt(age);
		}

	}

}
