package com.portfordev.pro.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.portfordev.pro.domain.Member_log;

@Repository
public class member_log_dao {
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public void insert_log(Member_log log) {
		sqlSession.insert("Member_logs.insert_log", log);
	}
	public int get_log_count(String MEMBER_ID) {
		return sqlSession.selectOne("Member_logs.get_log_count", MEMBER_ID);
	}
	public List<Member_log> get_log_list(Map<String, Object> map) {
		System.out.println("map = " + map);
		List<Member_log> log = sqlSession.selectList("Member_logs.get_log_list", map);
		return log;
	}
}
