package dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.BoardVO;
import vo.ImageVO;
import vo.PagingVO;

public class BoardDAO {

	@Autowired
	SqlSession sqlSession;

	// 게시물 총 갯수 조회
	public int countBoard() {
		return sqlSession.selectOne("b.countBoard");
	}

	// 게시글 전체 조회
	public List<BoardVO> selectList(PagingVO vo) {
		return sqlSession.selectList("b.board_list", vo);
	}

	// 게시글 작성
	public int board_insert(BoardVO vo) {
		return sqlSession.insert("b.board_insert", vo);
	}

	// 게시글 한개 조회
	public BoardVO selectOne(int b_idx) {
		return sqlSession.selectOne("b.board_selectOne", b_idx);
	}

	// 조회수 증가
	public int update_readhit(int b_idx) {
		return sqlSession.update("b.update_readhit", b_idx);
	}

	// 게시글 삭제
	public int board_delete(int b_idx) {
		return sqlSession.delete("b.board_delete", b_idx);
	}

	// 이미지 삭제
	public int board_modify_image_delete(int i_idx) {
		return sqlSession.update("b.board_modify_image_delete", i_idx);
	}

	// 게시글 수정
	public int board_update(BoardVO vo) {
		return sqlSession.update("b.board_update", vo);
	}

	// 좋아요 증가
	public int board_thumbup_update(int b_idx) {
		return sqlSession.update("b.board_thumbup_update", b_idx);
	}

	// 멤버가 해당글의 좋아요를 이미 눌렀는지 체크
	public int thumbup_check(HashMap<String, Integer> map) {
		return sqlSession.selectOne("b.thumbup_check", map);
	}

	// 해당 글의 좋아요를 누른 멤버 추가
	public int member_thumbup_insert(HashMap<String, Integer> map) {
		return sqlSession.insert("b.member_thumbup_insert", map);
	}

	// 멤버 idx으로 게시글 조회
	public List<BoardVO> selectList_by_m_idx(int m_idx) {
		return sqlSession.selectList("b.selectList_by_m_idx", m_idx);
	}

	// 제목이 비슷한 게시물 총 갯수 조회
	public int countBoard_b_title(String keyword) {
		return sqlSession.selectOne("b.countBoard_b_title", keyword);
	}

	// 내용이 비슷한 게시물 총 갯수 조회
	public int countBoard_b_content(String keyword) {
		return sqlSession.selectOne("b.countBoard_b_content", keyword);
	}

	// 작성자가 비슷한 게시물 총 갯수 조회
	public int countBoard_b_nickname(String keyword) {
		return sqlSession.selectOne("b.countBoard_b_nickname", keyword);
	}

	// 제목으로 게시글 검색
	public List<BoardVO> selectList_b_title(PagingVO vo) {
		return sqlSession.selectList("b.selectList_search_by_title", vo);

	}

	// 내용으로 게시글 검색
	public List<BoardVO> selectList_b_content(PagingVO vo) {
		return sqlSession.selectList("b.b_selectList_search_by_content", vo);
	}

	// 작성자로 게시글 검색
	public List<BoardVO> selectList_b_nickname(PagingVO vo) {
		return sqlSession.selectList("b.selectList_b_nickname", vo);
	}

	// 게시글 삭제시 연관된 좋아요 삭제
	public int board_thumbup_delete(int b_idx) {
		return sqlSession.delete("b.board_thumbup_delete", b_idx);
	}
	
	//댓글 작성시 댓글수 증가
	public int reply_count_increase(int b_idx) {
		return sqlSession.update("b.reply_count_increase",b_idx);
	}
	
	//게시글에 이미지 이미지테이블에 추가
	public int image_insert(ImageVO ivo) {
		return sqlSession.insert("b.image_insert",ivo);
	}
	
	//방금 쓴게시글 1개 m_idx로 b_idx조회
	public int board_selectOne_by_m_idx(int m_idx) {
		return sqlSession.selectOne("b.board_selectOne_by_m_idx",m_idx);
	}
	
	//b_idx로 이미지 전체 조회
	public List<ImageVO> img_selectList(int b_idx){
		return sqlSession.selectList("b.img_selectList",b_idx);
	}
	
}
