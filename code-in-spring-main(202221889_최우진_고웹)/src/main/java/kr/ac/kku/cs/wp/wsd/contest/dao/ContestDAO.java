package kr.ac.kku.cs.wp.wsd.contest.dao;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import kr.ac.kku.cs.wp.wsd.contest.entity.Contest;

@Repository
public class ContestDAO {

    private static final Logger logger = LoggerFactory.getLogger(ContestDAO.class);
    private final JdbcTemplate jdbcTemplate;

    public ContestDAO(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Contest> getAllContests() {
        logger.info("Executing SQL query to fetch all contests...");

        String sql = "SELECT * FROM contests";

        List<Contest> contests = jdbcTemplate.query(sql, (rs, rowNum) -> {
            Contest contest = new Contest();
            contest.setId(rs.getLong("id"));
            contest.setTitle(rs.getString("title"));
            contest.setOrganizer(rs.getString("organizer"));
            contest.setStartDay(rs.getDate("start_day"));
            contest.setFinishDay(rs.getDate("finish_day"));
            contest.setField(rs.getString("field"));
            return contest;
        });

        if (contests.isEmpty()) {
            logger.warn("No contests returned from SQL query.");
        } else {
            logger.info("Found {} contests from SQL query.", contests.size());
        }

        return contests;
    }
}