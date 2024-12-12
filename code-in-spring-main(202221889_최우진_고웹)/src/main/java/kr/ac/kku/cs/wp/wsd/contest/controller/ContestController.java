package kr.ac.kku.cs.wp.wsd.contest.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.ac.kku.cs.wp.wsd.contest.entity.Contest;
import kr.ac.kku.cs.wp.wsd.contest.service.ContestService;

@Controller
public class ContestController {

    private static final Logger logger = LoggerFactory.getLogger(ContestController.class);

    private final ContestService contestService;

    @Autowired
    public ContestController(ContestService contestService) {
        this.contestService = contestService;
    }

    @RequestMapping("/contests")
    public String getAllContests(Model model) {
        logger.info("Fetching all contests...");

        // 데이터를 서비스에서 가져오기
        List<Contest> contests = contestService.getAllContests();

        // 데이터를 확인
        if (contests.isEmpty()) {
            logger.warn("No contests found in the database.");
        } else {
            logger.info("Found {} contests.", contests.size());
        }

        model.addAttribute("contests", contests); // 모델에 데이터 추가
        return "index"; // index.jsp로 데이터 전달
    }
}