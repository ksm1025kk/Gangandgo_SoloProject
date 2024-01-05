package dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import vo.OrderVO;
import vo.OrderdetailVO;

public class OrderDAO {

	@Autowired
	SqlSession sqlSession;

	public int order_insert(OrderVO vo) {
		return sqlSession.insert("o.order_insert", vo);
	}

	public List<OrderVO> selectList(int m_idx) {
		return sqlSession.selectList("o.selectList", m_idx);
	}

	public int selectOne(int m_idx) {
		return sqlSession.selectOne("o.order_selectOne", m_idx);
	}

	public int od_insert(OrderdetailVO vo) {
		return sqlSession.insert("o.od_insert", vo);
	}

	public List<OrderdetailVO> od_selectList(int o_idx) {
		return sqlSession.selectList("o.od_selectList", o_idx);
	}

	// 재고량삭제?
	public int decreaseProductStock(int p_idx, int quantity) {
		HashMap<String, Integer> map = new HashMap<>();
		map.put("p_idx", p_idx);
		map.put("quantity", quantity);
		return sqlSession.update("o.decreaseProductStock", map);
	}

	public OrderdetailVO od_selectOne(int od_idx) {
		return sqlSession.selectOne("o.od_selectOne", od_idx);
	}
	
	public int review_check_update(int od_idx) {
		return sqlSession.update("o.review_check_update", od_idx);
	}
}
