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

import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import jakarta.validation.Valid;
import kr.ac.kku.cs.wp.wsd.user.dto.UserDTO;
import kr.ac.kku.cs.wp.wsd.user.entity.User;
import kr.ac.kku.cs.wp.wsd.user.mapper.UserMapper;
import kr.ac.kku.cs.wp.wsd.user.service.UserService;

/**
 * UserControllerJpa
 * 
 * @author kiseokjang
 * @since 2024. 11. 25.
 * @version 1.0
 */
@Controller
public class UserControllerJpa {
	
	private static final Logger logger = LogManager.getLogger(UserControllerJpa.class);
	
	@Autowired
	@Qualifier("userServiceJpaImpl")
	private UserService userService;
	
	@Autowired
	private UserMapper userMapper;

	
	@RequestMapping(value="/jpa/user/view")
	public ModelAndView userView(@RequestParam(name = "userId", required = true) String userId) {
		User user = userService.getUserById(userId);
		
		ModelAndView mav = new ModelAndView();
		mav.setViewName("user/userView");
		mav.addObject("user", user);
		
		return mav;
	}
	
	
	
	@RequestMapping("/jpa/user/userlist")
	public ModelAndView userlist(@RequestParam(name = "queryString") String queryString) {
		ModelAndView mav = new ModelAndView();
		
		logger.debug("queryString : {}", queryString);
		
		List<User> users = userService.getUsersByQueryString(queryString);
		
		mav.addObject("users", users);
		mav.setViewName("/user/userList");
		
		return mav;
	}
	
	@RequestMapping(value="/jpa/user/create")
	public ModelAndView createUser(@ModelAttribute @Valid UserDTO userDTO, BindingResult bindingResult) {
		ModelAndView mav = new ModelAndView();
		
//		logger.debug("bindingResult.hasErrors {} ", );
//		bindingResult.addError(new ObjectError("test", "test"));
		
		logger.debug("bindingResult.hasErrors {} ", bindingResult.hasErrors());
		
		if (bindingResult.hasErrors()) {
			mav.setViewName("/user/userForm");
			mav.addObject("errors", bindingResult.getAllErrors());
			
		} else {
			User user = userMapper.toEntity(userDTO);
			
			logger.debug("user id {}", user.getUserRoles().get(0).getId().getUserId());
			logger.debug("role id {}",user.getUserRoles().get(0).getId().getRoleId());
			logger.debug("role name {} ",user.getUserRoles().get(0).getRoleName() );
			logger.debug("role {} ",user.getUserRoles().get(0).getRole() );
			
			userService.createUser(user);
			
			mav.setViewName("/user/userSuccess");
	        mav.addObject("user", userDTO);
		}
        
        return mav;
	}
}

