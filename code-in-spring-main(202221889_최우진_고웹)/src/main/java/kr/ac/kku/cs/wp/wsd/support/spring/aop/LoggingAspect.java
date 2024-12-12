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
package kr.ac.kku.cs.wp.wsd.support.spring.aop;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

/**
 * LoggingAspect
 * 
 * @author kiseokjang
 * @since 2024. 11. 7.
 * @version 1.0
 */

@Aspect
@Component
public class LoggingAspect {

	private static final Logger logger = LogManager.getLogger(LoggingAspect.class);
	
	@Pointcut("within(@org.springframework.stereotype.Controller *)|| within(@org.springframework.stereotype.Service *) || within(@org.springframework.stereotype.Repository *)")
	public void callMethods() {}
	
	@Before("callMethods()")
	public void logBefore(JoinPoint joinPoint) {
		logger.trace("before {} ", joinPoint.getTarget().getClass().getName(), joinPoint.getSignature().getName());
		
	}
	
	@After("callMethods()")
	public void logAter(JoinPoint joinPoint) {
		logger.trace("after {} ", joinPoint.getTarget().getClass().getName(), joinPoint.getSignature().getName());
	}
	
	@AfterReturning(pointcut = "callMethods()", returning = "reuslt")
	public void logAfterReturning(JoinPoint joinPoint, Object result) {
		logger.trace("after returning {} result {} ", joinPoint.getTarget().getClass().getName(), joinPoint.getSignature().getName(), result);
	}
	
	@AfterThrowing(pointcut = "callMethods()", throwing = "error")
    public void logAfterThrowing(JoinPoint joinPoint, Throwable error) {
        logger.trace("after throwing {} {} Exception : {} ", joinPoint.getTarget().getClass().getName(), joinPoint.getSignature().getName(), error);
    }
	
}

