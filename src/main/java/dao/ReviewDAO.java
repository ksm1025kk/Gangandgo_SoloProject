package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.PagingVO;
import vo.ReviewVO;

public class ReviewDAO {

	@Autowired
	SqlSession sqlSession;
	
	public int review_insert(ReviewVO vo) {
		return sqlSession.insert("rv.review_insert", vo);
	}
	
	public List<ReviewVO> review_selectList(PagingVO pvo){
		return sqlSession.selectList("rv.review_selectList", pvo);
	}
	
	public int count_review(int p_idx) {
		return sqlSession.selectOne("rv.count_review",p_idx);
	}
		
}
