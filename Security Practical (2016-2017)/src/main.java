import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.swing.plaf.synth.SynthSeparatorUI;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;



public class main {
	static long startTime = 0;
	static long endTime = 0;
	public static void main(String[] args) throws IOException, InvalidKeyException, InvalidKeySpecException, NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, NoSuchProviderException {

		Path path = Paths.get("/cs/home/caf8/Documents/4th Year/Security/SecurityP1/text.txt");
		
		byte[] data =  Files.readAllBytes(path);
		int inputLength = data.length;
		System.out.println(inputLength);
		int keyLength = (inputLength+11)*8;
		System.out.println(keyLength);
		KeyPair aliceKeys = keyPair(keyLength);
		byte[] alicePublic = aliceKeys.getPublic().getEncoded();
		byte[] alicePrivate = aliceKeys.getPrivate().getEncoded();
		KeyPair bobKeys = keyPair(keyLength);
		byte[] bobPublic = bobKeys.getPublic().getEncoded();
		byte[] bobPrivate =bobKeys.getPrivate().getEncoded();
		byte[] encryption = encrypt(data, alicePublic);
		byte[] decryption = decrypt(encryption, alicePrivate);
		System.out.println("Took "+(endTime - startTime)/1000000000.0 + " s"); 
		//System.out.println(new String(decryption));
		md5Hash(data);
	}
	
	public static KeyPair keyPair(int keyLength) throws NoSuchAlgorithmException, NoSuchProviderException{
		startTime =  System.nanoTime();
		KeyPairGenerator keyGen = KeyPairGenerator.getInstance("RSA");
		SecureRandom random = SecureRandom.getInstance("SHA1PRNG", "SUN");
		keyGen.initialize(keyLength, random);
		KeyPair keys = keyGen.generateKeyPair();
		return keys;
	}
	
	public static byte[] encrypt(byte[] data, byte[] publicK) throws InvalidKeySpecException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException{
		PublicKey key = KeyFactory.getInstance("RSA").generatePublic(new X509EncodedKeySpec(publicK));
		Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(cipher.PUBLIC_KEY, key);
		byte[] encryption = cipher.doFinal(data);
		return encryption;
	}
	
	public static byte[] decrypt(byte[] encryption, byte[] privateK) throws InvalidKeySpecException, NoSuchAlgorithmException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidKeyException{
		PrivateKey key = KeyFactory.getInstance("RSA").generatePrivate( new PKCS8EncodedKeySpec(privateK));
		Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(cipher.PRIVATE_KEY, key);
		byte[] decryption = cipher.doFinal(encryption);
		endTime = System.nanoTime();
		return decryption;
		
	}
	
	public static void md5Hash(byte[] data) throws NoSuchAlgorithmException{
		MessageDigest message = MessageDigest.getInstance("MD5");
		message.update(data);
		byte[] dataToEncrypt = message.digest();
		StringBuilder hashed = new StringBuilder();
		for(int i=0; i < dataToEncrypt.length; i++){
			hashed.append(Integer.toString(dataToEncrypt[i]));
		}
		String hashedMessage = hashed.toString();
		System.out.println(hashedMessage);
	}
	

}
