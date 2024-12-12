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

import java.sql.PreparedStatement;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import kr.ac.kku.cs.wp.wsd.user.entity.Role;
import kr.ac.kku.cs.wp.wsd.user.entity.User;
import kr.ac.kku.cs.wp.wsd.user.entity.UserRole;
import kr.ac.kku.cs.wp.wsd.user.entity.UserRoleId;

/**
 * UserJDBCRepository
 * 
 * @author kiseokjang
 * @since 2024. 11. 29.
 * @version 1.0
 */
@Repository
public class UserJdbcRepository {

	private static final Logger logger = LogManager.getLogger(UserJdbcRepository.class);
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	
	public List<User> findAll() {
		
//		RowMapper<User> userRowMappler = new RowMapper<User>() {
//			
//			@Override
//			public User mapRow(ResultSet rs, int rowNum) throws SQLException {
//				User user = new User();
//				user.setId(rs.getString("id"));
//				user.setName(rs.getString("name"));
//				user.setEmail(rs.getString("email"));
//				user.setPhoto(rs.getString("photo"));
//				user.setStatus(rs.getString("status"));
//				user.setCreatedAt(rs.getDate("created_at"));
//				user.setUpdatedAt(rs.getDate("updated_at"));
//				
//				
//				return user;
//			}
//		};
			
		String query4User = "SELECT * FROM user ";
		List<User> users =  jdbcTemplate.query(query4User, getRowMapper4User());
		
//		RowMapper<UserRole> userRoleRowMappler = new RowMapper<UserRole>() {
//			
//			@Override
//			public UserRole mapRow(ResultSet rs, int rowNum) throws SQLException {
//				UserRole userRole = new UserRole();
//				UserRoleId userRoleId = new UserRoleId();
//				userRole.setId(userRoleId);
//				
//				userRole.getId().setUserId(rs.getString("user_id"));
//				userRole.getId().setRoleId(rs.getString("role_id"));
//				userRole.setRoleName(rs.getString("role"));
//				
//				Role role = new Role();
//				role.setId(rs.getString("role_id"));
//				role.setRole(rs.getString("role"));
//				
//				userRole.setRole(role);
//				
//				return userRole;
//			}
//		};
		
		String query4UserRole = "select * from user_role where user_id = ?";
		
		for (User user : users) {
			List<UserRole> userRoles = jdbcTemplate.query((conn) ->{
				PreparedStatement ps = conn.prepareStatement(query4UserRole);
		        ps.setString(1, user.getId());
				
				return ps;
				}, getRowMapper4UserRole());
			
			for (UserRole userRole : userRoles) {
				userRole.setUser(user);
			}
			
			user.setUserRoles(userRoles);
		}
		
		
		return users;
	}
	
	private  RowMapper<User> getRowMapper4User() {
		return (rs, rowNum) -> {
			User user = new User();
			user.setId(rs.getString("id"));
			user.setName(rs.getString("name"));
			user.setEmail(rs.getString("email"));
			user.setPhoto(rs.getString("photo"));
			user.setStatus(rs.getString("status"));
			user.setCreatedAt(rs.getDate("created_at"));
			user.setUpdatedAt(rs.getDate("updated_at"));
			
			
			return user;
		};
	}
	
	private RowMapper<UserRole> getRowMapper4UserRole() {
		return (rs, rowNum) -> {
			UserRole userRole = new UserRole();
			UserRoleId userRoleId = new UserRoleId();
			userRole.setId(userRoleId);
			
			userRole.getId().setUserId(rs.getString("user_id"));
			userRole.getId().setRoleId(rs.getString("role_id"));
			userRole.setRoleName(rs.getString("role"));
			
			Role role = new Role();
			role.setId(rs.getString("role_id"));
			role.setRole(rs.getString("role"));
			
			userRole.setRole(role);
			
			return userRole;
		};
	}
	
}

