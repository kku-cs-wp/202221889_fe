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
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.validation.ObjectError;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.servlet.ModelAndView;

import kr.ac.kku.cs.wp.wsd.tools.secure.CryptoUtil;
import kr.ac.kku.cs.wp.wsd.user.entity.User;
import kr.ac.kku.cs.wp.wsd.user.entity.UserRole;


/**
 * UserControllerTest
 * 
 * @author kiseokjang
 * @since 2024. 11. 9.
 * @version 1.0
 */
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/app-context.xml") 
@WebAppConfiguration
public class UserControllerTest {

	private static final Logger logger = LogManager.getLogger(UserControllerTest.class);
	
//	@Mock
//	private UserMapper userMapper;
	
	private MockMvc mockMvc;
	
	private boolean isDebugEnabled = true;
	
	@BeforeEach
    public void setup(WebApplicationContext wac) {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(wac)
        		.build();
        
    }
	
	@Test
	public void testGetUser() throws Exception {

		MvcResult mvcResult = mockMvc.perform(get("/user/view").param("userId", "kku_1000"))
				.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
				.andExpect(status().isOk())
				.andExpect(model().attributeExists("user"))
				.andReturn();

		ModelAndView mav = mvcResult.getModelAndView();

		User user = (User) mav.getModel().get("user");

		assertEquals(user.getId(), "kku_1000");
		
		logger.debug("user id : {} ", user.getId());
		
		
		mvcResult = mockMvc.perform(get("/user/view").param("userId", "kku_100011"))
				.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
				.andExpect(status().is(400))
				.andReturn();
		
		assertEquals(mvcResult.getResponse().getContentAsString(), "User not found : kku_100011");
		
		logger.debug(mvcResult.getResponse().getContentAsString());
		
		

	}
	
	@Test
	public void testUpdateUser() throws Exception {
		
		MvcResult mvcResult = mockMvc.perform(get("/user/view").param("userId", "kku_1000"))
				.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
				.andExpect(status().isOk())
				.andExpect(model().attributeExists("user"))
				.andReturn();

		ModelAndView mav = mvcResult.getModelAndView();

		User user = (User) mav.getModel().get("user");
		
		mvcResult = mockMvc.perform(post("/user/update")
                .contentType("application/x-www-form-urlencoded")
                // UserDTO 필드
                .param("id", user.getId())
                .param("name", user.getName()+ "test")
                .param("email", "changed@example.com")
                .param("password", "zaqwsx123!")
                .param("status", "퇴직")
                // UserRoleDTO 필드 (다중 값 처리)
                .param("userRoles[0].userId", user.getId())
                .param("userRoles[0].roleId", "1001")
                .param("userRoles[0].roleName", "개발자")
                .param("userRoles[1].userId", user.getId())
                .param("userRoles[1].roleId", "1002")
                .param("userRoles[1].roleName", "관리자"))
		 		.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
                .andExpect(status().isOk())
                .andExpect(model().attributeExists("user"))
                .andReturn();
		
		mav = mvcResult.getModelAndView();
		
		User updatedUser = (User) mav.getModel().get("user");
		
		assertEquals( user.getName() + "test", updatedUser.getName());
		assertEquals("changed@example.com", updatedUser.getEmail());
		byte[] salt = CryptoUtil.extractSalt(updatedUser.getPassword());
		assertEquals(CryptoUtil.hash("zaqwsx123!", salt), updatedUser.getPassword());
		
		
		List<UserRole> userRoles = updatedUser.getUserRoles();
		List<String> riList = new ArrayList<String>();
		List<String> testRiList = new ArrayList<String>();
		testRiList.add("1001");
		testRiList.add("1002");
		
		for (UserRole userRole : userRoles) {
			logger.debug("role id {}",userRole.getId().getRoleId());
			riList.add(userRole.getId().getRoleId());
		}
		
		assertEquals(new HashSet(testRiList), new HashSet(riList));
		
		//error
		mvcResult = mockMvc.perform(post("/user/update")
                .contentType("application/x-www-form-urlencoded")
                // UserDTO 필드
                .param("id", updatedUser.getId())
                .param("name", updatedUser.getName()+ "_test")
                .param("email", "changed@example.com")
                .param("password", "zaqwsx123!")
                .param("status", "퇴직")
                // UserRoleDTO 필드 (다중 값 처리)
                .param("userRoles[0].userId", user.getId())
                .param("userRoles[0].roleId", "1001")
                .param("userRoles[0].roleName", "개발자")
                .param("userRoles[1].userId", user.getId())
                .param("userRoles[1].roleId", "1002")
                .param("userRoles[1].roleName", "관리자"))
		 		.andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
                .andExpect(status().is(400))
                .andReturn();
		
		
		assertEquals(mvcResult.getResponse().getContentAsString(), "이름에는 특수문자를 사용할 수 없습니다.<br>");
		
	}
	
	@Test
	public void testUserlist() throws Exception {
	
		MvcResult mvcResult =  mockMvc.perform(get("/user/userlist"))
	        .andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
	        .andExpect(status().isOk())
	        .andExpect(model().attributeExists("users"))
	        .andReturn();
		
		ModelAndView mav = mvcResult.getModelAndView();
		
		List<User> users = (List<User>) mav.getModel().get("users");
		
		assertEquals(users.get(0).getId(), "kku_1000");
		
	}
	
	@Test
	public void testCreateUser() throws Exception {
		ClassPathResource imageResource = new ClassPathResource("man.png");
        MockMultipartFile photoFile = new MockMultipartFile(
            "photoFile", 
            imageResource.getFilename(),
            "image/png",
            imageResource.getInputStream()
        );
        
		
		mockMvc.perform(multipart("/user/create")
				.file(photoFile)
//                .contentType("application/x-www-form-urlencoded")
                // UserDTO 필드
//                .param("id", "testUser")
                .param("name", "Test")
                .param("email", "testexample.com")
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
                .andExpect(status().is(400));
                
    
	}
}

