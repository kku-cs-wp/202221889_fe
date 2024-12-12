/*
 * Copyright (C) 2024 Kiseok Jang. All rights reserved.
 *
 * This software is licensed under the Personal and Limited Commercial Use License.
 * You may use this software for personal, educational, or non-commercial purposes.
 * For commercial use, ensure that your use does not infringe on the rights of others.
 *
 * For full license details, see the LICENSE file in the root directory of this project.
 *
 * Contact information: lecture4cs@gmail.com
 * 
 * 
 * 
 * 저작권 (C) 2024 장기. 모든 권리 보유.
 *
 * 이 소프트웨어는 개인 및 제한적인 상업적 사용 라이선스 하에 제공됩니다.
 * 이 소프트웨어는 개인적, 교육적 또는 비상업적 목적으로 자유롭게 사용할 수 있습니다.
 * 상업적 사용을 위해서는 타인의 권리를 침해하지 않도록 주의해야 합니다.
 *
 * 전체 라이선스 내용은 이 프로젝트의 루트 디렉토리에 있는 LICENSE 파일을 참조하십시오.
 *
 * 연락처: lecture4cs@gmail.com
 * 
 */
package kr.ac.kku.cs.wp.wsd.tools.secure;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * CryptoUtil
 * 
 * @author kiseokjang
 * @since 2024. 10. 28.
 * @version 1.0
 */
public class CryptoUtil {

	private static final Logger logger = LogManager.getLogger(CryptoUtil.class);
	
	/**
	 * 
	 * @param message
	 * @param salt
	 * @return
	 * @throws NoSuchAlgorithmException
	 */
	public static String hash(String message, byte[] salt) throws NoSuchAlgorithmException {
		StringBuffer hasedMessageAndSalt = new StringBuffer();
	
		MessageDigest md = MessageDigest.getInstance("SHA-256");
		
		md.update(salt);
		
		byte[] hashedMessage = md.digest(message.getBytes());
		
		String base64Salt = Base64.getEncoder().encodeToString(salt);
		String base64HashedMessage = Base64.getEncoder().encodeToString(hashedMessage);
		
		hasedMessageAndSalt.append(base64HashedMessage).append(base64Salt);
		
		logger.debug("salt:" + base64Salt);
		logger.debug("hashedMessage:" + base64HashedMessage);
		logger.debug("hasedMessageAndSalt:" + hasedMessageAndSalt.toString());
			
		
		return hasedMessageAndSalt.toString();
	}
	
	/**
	 * 
	 * @return
	 */
	public static byte[] genSalt() {
		//generate salt
		SecureRandom sr = new SecureRandom();
		byte[] salt = new byte[16];
		sr.nextBytes(salt);

		return salt;
	}
	
	/**
	 * 
	 * @param base64HassedMessageAndSalt
	 * @return
	 */
	public static byte[] extractSalt(String base64HassedMessageAndSalt) {
		byte[] salt;
		
		String base64Salt = base64HassedMessageAndSalt.substring(44);
		
		logger.debug("base64Salt:" + base64Salt );
		
		salt = Base64.getDecoder().decode(base64Salt);
		
		return salt;
	}
	
	/**
	 * 
	 * @param base64hasedMessageAndSalt
	 * @param message
	 * @return
	 * @throws NoSuchAlgorithmException
	 */
	public static boolean isMatch(String base64hasedMessageAndSalt, String message) throws NoSuchAlgorithmException{
		boolean isMatch = false;
		
		if (base64hasedMessageAndSalt == null || message == null) {
			logger.debug("is null");
			throw new NullPointerException();
		}
		
		byte[] salt = extractSalt(base64hasedMessageAndSalt);
		
		String base64HasedMAS = hash(message, salt);
		
		if (base64hasedMessageAndSalt.equals(base64HasedMAS)) {
			isMatch = true;
		}
		
		return isMatch;
	}
}

