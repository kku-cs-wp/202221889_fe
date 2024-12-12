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
package kr.ac.kku.cs.wp.wsd.support.sql;

import java.util.Set;
import java.util.stream.Collectors;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.reflections.Reflections;
import org.reflections.ReflectionsException;

import jakarta.persistence.Entity;


/**
 * HibernateUtil
 * 
 * @author kiseokjang
 * @since 2024. 10. 6.
 * @version 1.0
 */
public class HibernateUtil {
	
	private static final Logger logger = LogManager.getLogger(HibernateUtil.class);
	
	private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
        	Configuration configuration =  new Configuration().configure();
        	
        	String packageName = configuration.getProperty("entity.package.scan");
        	
        	logger.debug("entity.package.scan : {}", packageName);
        	
        	if (packageName != null && !packageName.isBlank()) {
        		Set<Class<?>> entityClasses = findEntityClasses(packageName);
        		
        		if (entityClasses != null) {
	                for (Class<?> entityClass : entityClasses) {
	                	
	                	logger.debug(entityClass.getName());
	                    configuration.addAnnotatedClass(entityClass);
	                }
        		}
        	}
        	
            return configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        getSessionFactory().close();
    }
    
    private static Set<Class<?>> findEntityClasses(String packageName) {
    	Set<Class<?>> rtn = null;

        // Reflections 라이브러리를 통해 특정 패키지의 모든 엔티티 클래스 찾기
        Reflections reflections = new Reflections(packageName );
        
        try {
        	rtn = reflections.getTypesAnnotatedWith(Entity.class).stream()
            .filter(cls -> cls.isAnnotationPresent(Entity.class))
            .collect(Collectors.toSet());
		} catch (ReflectionsException e) {
			// TODO Auto-generated catch block
			logger.warn("No Entity Class : {} ", e.getMessage());
		}
        
        return rtn;
    }


}
