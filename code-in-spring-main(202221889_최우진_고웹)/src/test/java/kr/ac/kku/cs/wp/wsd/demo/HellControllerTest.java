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

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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

/**
 * HellControllerTest
 * 
 * @author kiseokjang
 * @since 2024. 11. 6.
 * @version 1.0
 */

@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "file:src/main/webapp/WEB-INF/app-context.xml") 
@WebAppConfiguration
public class HellControllerTest {

	private static final Logger logger = LogManager.getLogger(HellControllerTest.class);
	
	private MockMvc mockMvc;
	
	private boolean isDebugEnabled = true;
	
	@BeforeEach
    public void setup(WebApplicationContext wac) {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();
    }

    @Test
    public void testHelloEndpoint() throws Exception {
        mockMvc.perform(get("/hello").queryParam("name", "ks"))
        .andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
        .andExpect(status().isOk())
        .andExpect(request().attribute("hello", "hello ks"));
        
        
        mockMvc.perform(post("/hello").param("name", "post"))
        .andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
        .andExpect(status().isOk())
        .andExpect(request().attribute("hello", "hello post"));
       
        
        MvcResult mvcResut =  mockMvc.perform(get("/hello"))
        .andDo(isDebugEnabled ? MockMvcResultHandlers.print() : result -> {})
        .andExpect(status().isBadRequest())
        .andReturn();
        
        logger.debug(mvcResut.getResponse().getContentAsString());
        assertEquals(mvcResut.getResponse().getErrorMessage(), "Required parameter 'name' is not present.");
        
    }
}

