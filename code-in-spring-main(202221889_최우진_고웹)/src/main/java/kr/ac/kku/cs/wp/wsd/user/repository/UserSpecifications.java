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
package kr.ac.kku.cs.wp.wsd.user.repository;

import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.data.jpa.domain.Specification;

import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import jakarta.persistence.criteria.Predicate;
import kr.ac.kku.cs.wp.wsd.user.entity.User;
import kr.ac.kku.cs.wp.wsd.user.entity.UserRole;

/**
 * UserSpecification
 * 
 * @author kiseokjang
 * @since 2024. 11. 25.
 * @version 1.0
 */
public class UserSpecifications {

	private static final Logger logger = LogManager.getLogger(UserSpecifications.class);
	
	public static Specification<User> filterUsersByQueryString(String queryString) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Join for userRoles
            Join<User, UserRole> userRolesJoin = root.join("userRoles", JoinType.LEFT);

            // Dynamic conditions
            if (queryString != null) {
            	
            	logger.debug("in spec ");
                predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("id")), "%" + queryString.toLowerCase() + "%"));
                predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "%" + queryString.toLowerCase() + "%"));
                predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("email")), "%" + queryString.toLowerCase() + "%"));
                predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("status")), "%" + queryString.toLowerCase() + "%"));
                predicates.add(criteriaBuilder.like(userRolesJoin.get("roleName"), "%" + queryString + "%"));
            }

            return criteriaBuilder.or(predicates.toArray(new Predicate[0]));
        };
    }
	
	public static Specification<User> filterUsers(User user) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Join for userRoles
            Join<User, UserRole> userRolesJoin = root.join("userRoles", JoinType.LEFT);

            // Dynamic conditions
            if (user != null) {
                if (user.getId() != null && !user.getId().isEmpty()) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("id")), "%" + user.getId().toLowerCase() + "%"));
                }
                if (user.getName() != null && !user.getName().isEmpty()) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("name")), "%" + user.getName().toLowerCase() + "%"));
                }
                if (user.getEmail() != null && !user.getEmail().isEmpty()) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("email")), "%" + user.getEmail().toLowerCase() + "%"));
                }
                if (user.getStatus() != null && !user.getStatus().isEmpty()) {
                    predicates.add(criteriaBuilder.like(criteriaBuilder.lower(root.get("status")), "%" + user.getStatus().toLowerCase() + "%"));
                }
                if (user.getUserRoles() != null && !user.getUserRoles().isEmpty()) {
                    predicates.add(criteriaBuilder.like(userRolesJoin.get("roleName"), "%" + user.getUserRoles().get(0).getRoleName() + "%"));
                }
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };
    }
}

