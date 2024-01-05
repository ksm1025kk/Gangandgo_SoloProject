package dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.AnswerVO;

public class AnswerDAO {

	@Autowired
	SqlSession sqlSession;
	
	public int answer_insert(AnswerVO vo) {
		return sqlSession.insert("a.answer_insert",vo);
	}
	
	public AnswerVO answer_selectOne(int h_idx) {
		return sqlSession.selectOne("a.answer_selectOne",h_idx);
	}
	
	public int answer_delete(int a_idx) {
		return sqlSession.delete("a.answer_delete",a_idx);
	}
}
