package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.CartVO;

public class CartDAO {
	
	@Autowired
	SqlSession sqlSession;
	
	
	//장바구니
	public List<CartVO> selectList(int m_idx){
		return sqlSession.selectList("c.selectList",m_idx);
	}
	
	// 장바구니에 상품 담기
	public int cart_insert(CartVO vo) {
		return sqlSession.insert("c.cart_insert", vo);
	}
	
	//  장바구니에 상품 담을때 중복체크 
	public int cart_check(CartVO vo) {
		return sqlSession.selectOne("c.cart_check", vo);
	}
	
	// 장바구니에 상품 담을 때 중복인경우 수량만 늘리는 업데이트
	public int cart_update(CartVO vo) {
		return sqlSession.update("c.cart_update", vo);
	}
		
	// 장바구니 상품삭제
	public int cart_delete(int c_idx) {
		return sqlSession.update("c.cart_delete",c_idx);
	}

	//바로결제 추가
	public int direct_cart_insert(CartVO vo) {
		return sqlSession.insert("c.direct_cart_insert", vo);
	}

	//바로결제 중복건의 p_idx로 c_idx 조회하기
	public int get_c_idx(int p_idx) {
		return sqlSession.selectOne("c.get_c_idx",p_idx);
	}
	
	// 바로결제 / 장바구니에 중복이 없을 시 / p_idx로 cartVO 한개 조회하기
	public CartVO selectOne_by_p_idx(int p_idx) {
		return sqlSession.selectOne("c.selectOne_by_p_idx", p_idx);
	}
	
	// c_idx로 cartvo 한개 조회하기
	public CartVO selectOne_by_c_idx(int c_idx) {
		return sqlSession.selectOne("c.selectOne_by_c_idx", c_idx);
	}
	
	// 결제 후 장바구니 비우기
	public int purchased_cart_delete(CartVO vo) {
		return sqlSession.delete("c.purchased_cart_delete", vo);
	}
	
	// 즉시 결제후 같은 상품의 수량이 남아있는 경우 업데이트
	public int purchased_cart_update(CartVO vo) {
		return sqlSession.update("c.purchased_cart_update", vo);
	}
}
