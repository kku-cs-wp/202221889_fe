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
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import kr.ac.kku.cs.wp.wsd.tools.message.MessageException;
import kr.ac.kku.cs.wp.wsd.user.dao.UserDAO;
import kr.ac.kku.cs.wp.wsd.user.entity.User;

/**
 * UserServiceImple
 * 
 * @author kiseokjang
 * @since 2024. 10. 6.
 * @version 1.0
 */
//@Service
public class UserServiceHImpl implements UserService {
	
	private static final Logger logger = LogManager.getLogger(UserServiceHImpl.class);
	
	@Autowired
	private UserDAO dao;
	

	@Override
	public User getUserById(String userId) {
		// TODO Auto-generated method stub
		User user= dao.getUserById(userId);
		
		if (user == null) {
			throw new MessageException("Not Found User : " + userId);
		}
		
		return user;
	}

	@Override
	public User getUser(User user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public User updateUser(User user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void deleteUser(User user) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public User createUser(User user) {
		// TODO Auto-generated method stub
		return dao.createUser(user);
		
	}

	@Override
	public List<User> getUsers(User user) {
		// TODO Auto-generated method stub
		return dao.getUsers(user);
	}
	
	@Override
	@Transactional
	public List<User> getUsersByQueryString(String queryString) {
		return null;
	}
	
	
}

