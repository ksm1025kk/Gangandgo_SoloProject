package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.PagingVO;
import vo.ReplyVO;

public class ReplyDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	
	//게시물 총 갯수 조회
	public int countReply(int b_idx) {
		return sqlSession.selectOne("r.countReply",b_idx);
	}
		
	public int reply_insert(ReplyVO vo) {
		return sqlSession.insert("r.reply_insert", vo);
	}
	
	public List<ReplyVO> selectList(PagingVO pvo){
		return sqlSession.selectList("r.reply_list",pvo);
	}
	
	public int board_reply_delete(int b_idx) {
		return sqlSession.delete("r.board_reply_delete", b_idx);
	}
	
	// 댓글 삭제처리 (삭제된 댓글 업데이트)
	public int reply_delete(int r_idx) {
		return sqlSession.update("r.reply_delete", r_idx);
	}
	
	public ReplyVO selectOne(int r_idx) {
		return sqlSession.selectOne("r.selectOne", r_idx);
	}
	
	public int reply_reply_insert(ReplyVO vo) {
		return sqlSession.insert("r.reply_reply_insert", vo);
	}
	
	public int maxStep(int r_ref) {
		return sqlSession.selectOne("r.maxStep", r_ref);
	}
	
	public int updateStep(ReplyVO vo) {
		return sqlSession.update("r.updateStep", vo);
	}
	
	// member view - 본인이 작성한 댓글 조회
	public List<ReplyVO> selectList_by_m_idx(int m_idx){
		return sqlSession.selectList("r.selectList_by_m_idx",m_idx);
	}
	
	public int updateNested(ReplyVO vo) {
		return sqlSession.update("r.updateNested", vo);
	}
}
