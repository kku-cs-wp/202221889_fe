package kr.ac.kku.cs.wp.wsd.contest.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import kr.ac.kku.cs.wp.wsd.contest.entity.Contest;

@Repository
public interface ContestRepository extends JpaRepository<Contest, Long> {

    // field를 기준으로 공모전 목록을 조회하는 메서드
    List<Contest> findByFieldContaining(String field);

    // 예시: startDay를 기준으로 공모전 목록을 조회하는 메서드 (추가적인 기능)
    List<Contest> findByStartDayAfter(java.util.Date startDay);
}