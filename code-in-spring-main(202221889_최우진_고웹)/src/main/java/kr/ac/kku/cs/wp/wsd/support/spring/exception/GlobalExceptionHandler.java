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
package kr.ac.kku.cs.wp.wsd.support.spring.exception;

import java.nio.charset.StandardCharsets;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import kr.ac.kku.cs.wp.wsd.tools.message.MessageException;

/**
 * GlobalExceptionHandler
 * 
 * @author kiseokjang
 * @since 2024. 11. 4.
 * @version 1.0
 */
@ControllerAdvice
public class GlobalExceptionHandler {

	private static final Logger logger = LogManager.getLogger(GlobalExceptionHandler.class);
	
	@ExceptionHandler(MessageException.class)
    public ResponseEntity<String> handleMessageException(MessageException e) {
		logger.debug(e.getMessage());
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(new MediaType("text", "plain", StandardCharsets.UTF_8));
		
        return new ResponseEntity<>(e.getMessage(), headers, HttpStatus.BAD_REQUEST);
    }
	
//	@ExceptionHandler(MissingServletRequestParameterException.class)
//    public ResponseEntity<String> handleMissingServletRequestParameterException(MissingServletRequestParameterException e) {
//		logger.error(e.getMessage(), e);
//        return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
//    }
//	
//	
//	@ExceptionHandler(Throwable.class)
//    public ResponseEntity<String> handleThrowable(Throwable e) {
//		logger.error(e.getMessage(), e);
//		
//		return new ResponseEntity<>("{error : \"An error has occurred.\"}", HttpStatus.INTERNAL_SERVER_ERROR);
//    }
}

