package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.MemberVO;
import vo.ProductVO;

public class ProductDAO {

	@Autowired
	SqlSession sqlSession;

	public List<ProductVO> selectList(ProductVO vo) {
		return sqlSession.selectList("p.product_list", vo);
	}

	public List<ProductVO> selectList_orderby_asc(ProductVO vo) {
		return sqlSession.selectList("p.product_list_orderby_asc", vo);
	}

	public int product_insert(ProductVO vo) {
		return sqlSession.insert("p.product_insert", vo);
	}

	public ProductVO selectOne(int p_idx) {
		return sqlSession.selectOne("p.product_selectOne", p_idx);
	}

	public List<ProductVO> select_search_p_name_List(String p_name) {
		return sqlSession.selectList("p.product_search_name_list", p_name);
	}

	public List<ProductVO> select_search_p_info_List(String p_info) {
		return sqlSession.selectList("p.product_search_info_list", p_info);
	}

	// 상품삭제
	public int delete_product(int p_idx) {
		return sqlSession.update("p.delete_product", p_idx);
	}

}
