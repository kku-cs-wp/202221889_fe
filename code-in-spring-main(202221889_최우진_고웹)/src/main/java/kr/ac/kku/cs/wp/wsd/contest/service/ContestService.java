package kr.ac.kku.cs.wp.wsd.contest.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.kku.cs.wp.wsd.contest.dao.ContestDAO;
import kr.ac.kku.cs.wp.wsd.contest.entity.Contest;

@Service
public class ContestService {

    private static final Logger logger = LoggerFactory.getLogger(ContestService.class);

    private final ContestDAO contestDAO;

    @Autowired
    public ContestService(ContestDAO contestDAO) {
        this.contestDAO = contestDAO;
    }

    public List<Contest> getAllContests() {
        logger.info("Fetching contests from DAO...");

        // DAO에서 공모전 목록 가져오기
        List<Contest> contests = contestDAO.getAllContests();

        // 데이터 상태 확인
        if (contests.isEmpty()) {
            logger.warn("No contests found in DAO.");
        } else {
            logger.info("Found {} contests in DAO.", contests.size());
        }

        return contests;
    }
}