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
package kr.ac.kku.cs.wp.wsd.user.controller;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;

import kr.ac.kku.cs.wp.wsd.user.entity.User;

/**
 * UserControllerJPATest
 * 
 * @author kiseokjang
 * @since 2024. 11. 25.
 * @version 1.0
 */
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/app-context.xml") 
@WebAppConfiguration
public class UserControllerJpaTest {

	private static final Logger logger = LogManager.getLogger(UserControllerJpaTest.class);
	
	private MockMvc mockMvc;
	
	private boolean isDebugEnabled = true;
	
	@BeforeEach
    public void setup(WebApplicationContext wac) {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(wac)
        		.build();
        
    }
	
//	@Test
	public void testGetUser() throws Exception {

		MvcResult mvcResult = mockMvc.perform(get("/jpa/user/view").param("userId", "kku_1000"))
				.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
				.andExpect(status().isOk())
				.andExpect(model().attributeExists("user"))
				.andReturn();

		ModelAndView mav = mvcResult.getModelAndView();

		User user = (User) mav.getModel().get("user");

		assertEquals(user.getId(), "kku_1000");
		
		logger.debug("user id : {} ", user.getId());
		
		
		mvcResult = mockMvc.perform(get("/jpa/user/view").param("userId", "kku_100011"))
				.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
				.andExpect(status().isOk())
				.andReturn();
		
		assertEquals(mvcResult.getResponse().getContentAsString(), "User not found : kku_100011");
		
		logger.debug(mvcResult.getResponse().getContentAsString());
		
	}
	
	@Test
	public void testUserlist() throws Exception {
	
		MvcResult mvcResult =  mockMvc.perform(get("/jpa/user/userlist").param("queryString", "안중근"))
	        .andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
	        .andExpect(status().isOk())
	        .andExpect(model().attributeExists("users"))
	        .andReturn();
		
		ModelAndView mav = mvcResult.getModelAndView();
		
		List<User> users = (List<User>) mav.getModel().get("users");
		
		logger.debug(" users size : {}", users.size());
		assertTrue(users.get(0).getName().contains("안중근"));
		
	}
	
//	@Test
	public void testCreateUser() throws Exception {
		
		mockMvc.perform(post("/jpa/user/create")
                .contentType("application/x-www-form-urlencoded")
                // UserDTO 필드
//                .param("id", "testUser")
                .param("name", "jpa Test User")
                .param("email", "test@example.com")
                .param("password", "zaqwsx123!")
                .param("status", "퇴직")
                // UserRoleDTO 필드 (다중 값 처리)
                .param("userRoles[0].userId", "testUser")
                .param("userRoles[0].roleId", "1001")
                .param("userRoles[0].roleName", "개발자")
                .param("userRoles[1].userId", "testUser")
                .param("userRoles[1].roleId", "1000")
                .param("userRoles[1].roleName", "관리자"))
		 		.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
                .andExpect(status().isOk());
                
    
	}
}

