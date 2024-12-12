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

import java.lang.reflect.Method;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import kr.ac.kku.cs.wp.wsd.tools.message.MessageException;

/**
 * NullCheckAspect
 * 
 * @author kiseokjang
 * @since 2024. 11. 24.
 * @version 1.0
 */
@Aspect
@Component
public class NullCheckAspect {

	private static final Logger logger = LogManager.getLogger(NullCheckAspect.class);
	
	@Pointcut("within(@org.springframework.stereotype.Service *)")
	public void callMethods() {}
	
	@AfterReturning(pointcut = "callMethods()", returning = "reuslt")
	public void nullCheckAfterReturning(JoinPoint joinPoint, Object result) throws NoSuchMethodException {
		
		Method method = getMethodFromJoinPoint(joinPoint);
		
		logger.debug(method.getReturnType());
		
		if (!method.getReturnType().equals(Void.TYPE)) {
			String message = "";
			logger.trace("in nullcheck");
			if (result == null) {
				logger.trace("in nullcheck in null");
				if (joinPoint.getSignature().getName().equals("getUserById")) {
					message = "User not found : " + joinPoint.getArgs()[0];
					logger.debug("message : {}", message);
				}
				
				throw new MessageException(message);
			}
		}
	}
	
	/**
	 * joinpoint Method 객체 반환
	 * @param joinPoint
	 * @return
	 * @throws NoSuchMethodException
	 */
	private Method getMethodFromJoinPoint(JoinPoint joinPoint) throws NoSuchMethodException {
        // 실행 대상 클래스와 메서드 정보 추출
        String methodName = joinPoint.getSignature().getName();
        Class<?> targetClass = joinPoint.getTarget().getClass();

        // 메서드 파라미터 타입 추출
        Class<?>[] parameterTypes = ((MethodSignature) joinPoint.getSignature()).getParameterTypes();

        // 메서드 리플렉션으로 찾기
        return targetClass.getMethod(methodName, parameterTypes);
    }
	
}

