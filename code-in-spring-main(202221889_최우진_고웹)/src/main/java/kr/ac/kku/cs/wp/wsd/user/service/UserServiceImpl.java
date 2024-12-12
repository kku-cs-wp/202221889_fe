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
package kr.ac.kku.cs.wp.wsd.user.service;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.ac.kku.cs.wp.wsd.user.dao.UserDAO;
import kr.ac.kku.cs.wp.wsd.user.entity.User;
import kr.ac.kku.cs.wp.wsd.user.repository.UserRepository;
import kr.ac.kku.cs.wp.wsd.user.repository.UserSpecifications;

/**
 * UserServiceSH
 * 
 * @author kiseokjang
 * @since 2024. 11. 23.
 * @version 1.0
 */
@Service
public class UserServiceImpl implements UserService{
	
	@Autowired
	@Qualifier("userDAOImpl")
	private UserDAO dao;
	
	@Autowired
	private UserRepository userRepository;

	private static final Logger logger = LogManager.getLogger(UserServiceImpl.class);

	@Override
	@Transactional(transactionManager = "hTransactionManager")
	public User getUserById(String userId) {
		User user = dao.getUserById(userId);
		
//		if (user == null) {
//			throw new MessageException("user not found : " +   userId);
//		}
		
		return user;
	}

	@Override
	@Transactional(transactionManager = "hTransactionManager")
	public User getUser(User user) {
		return dao.getUser(user);
	}

	@Override
	@Transactional(transactionManager = "hTransactionManager")
	public User updateUser(User user) {
		return dao.updateUser(user);
	}

	@Override
	@Transactional(transactionManager = "hTransactionManager")
	public void deleteUser(User user) {
		dao.deleteUser(user);
		
	}

	@Override
	@Transactional(transactionManager = "hTransactionManager")
	public User createUser(User user) {
		return dao.createUser(user);
		
	}

	@Override
	@Transactional(transactionManager = "hTransactionManager")
	public List<User> getUsers(User user) {
		return dao.getUsers(user);
	}
	
	@Override
	@Transactional
	public List<User> getUsersByQueryString(String queryString) {
		Specification<User> spec = UserSpecifications.filterUsersByQueryString(queryString);
        return userRepository.findAll(spec);
	}
	
	
}

