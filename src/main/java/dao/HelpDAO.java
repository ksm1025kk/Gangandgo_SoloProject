package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.HelpVO;
import vo.PagingVO;

public class HelpDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	public int help_insert(HelpVO vo) {
		return sqlSession.insert("h.help_insert",vo);
	}
	//모든 문의 리스트 조회
	public List<HelpVO> help_all_selectList(PagingVO pvo){
		return sqlSession.selectList("h.help_all_list",pvo);
	}
	
	//해당회원 문의리스트 조회
	public List<HelpVO> help_member_selectList(int m_idx){
		return sqlSession.selectList("h.help_member_list",m_idx);
	}
	
	//h_idx로 문의 1개조회
	public HelpVO help_selectOne(int h_idx){
		return sqlSession.selectOne("h.help_selectOne",h_idx);
	}
	
	//답변달렸을때 h_solved 1로 update
	public int solved_update(int h_idx) {
		return sqlSession.update("h.solved_update",h_idx);
	}
	
	//h_solved값으로 문의 갯수 조회
	public int count_help(int h_solved) {
		return sqlSession.selectOne("h.count_help",h_solved);
	}
	
	public int answer_delete_solved_update(int h_idx) {
		return sqlSession.update("h.answer_delete_solved_update",h_idx);
	}
	
	
}
