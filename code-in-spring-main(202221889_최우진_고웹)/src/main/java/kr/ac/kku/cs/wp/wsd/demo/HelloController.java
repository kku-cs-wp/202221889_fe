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
package kr.ac.kku.cs.wp.wsd.demo;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

/**
 * UserController
 * 
 * @author kiseokjang
 * @since 2024. 11. 3.
 * @version 1.0
 */
@Controller
public class HelloController {

	private static final Logger logger = LogManager.getLogger(HelloController.class);
	
	@RequestMapping("/hello")
	public ModelAndView hello(@RequestParam(name = "name", required = true) String name) {
		
		final String formattedGreeting = "hello %s";
	    String greeting = formattedGreeting.formatted(name);
	    
	    logger.debug("greeting : {}", greeting);

	    ModelAndView mav = new ModelAndView();
	    mav.addObject("hello", greeting);
	    mav.setViewName("HelloView");
	   

	    return mav;
	}
	
}

