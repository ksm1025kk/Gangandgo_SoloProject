package com.korea.gangandgo;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import dao.CartDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import util.MyCommon;
import vo.CartVO;
import vo.MemberVO;
import vo.OrderVO;
import vo.OrderdetailVO;
import vo.ProductVO;

@Controller
public class OrderController {

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	@Autowired
	CartDAO cart_dao;

	@Autowired
	OrderDAO order_dao;

	@Autowired
	ProductDAO product_dao;

	// 결제후 구매내역으로 이동 (장바구니)
	@RequestMapping("purchase_complete.do")
	public String purchase_complete(Model model) {
		String o_addr = request.getParameter("o_addr");
		MemberVO member_vo = (MemberVO) session.getAttribute("account");
		List<CartVO> cartList = cart_dao.selectList(member_vo.getM_idx());
		OrderVO orderVO = new OrderVO();
		orderVO.setM_idx(member_vo.getM_idx());
		orderVO.setO_addr(o_addr);
		orderVO.setO_count(cartList.size());
		orderVO.setP_idx(cartList.get(0).getP_idx());
		int res = order_dao.order_insert(orderVO);
		int o_idx = order_dao.selectOne(member_vo.getM_idx());
		for (CartVO cart_vo : cartList) {
			OrderdetailVO odVO = new OrderdetailVO();
			odVO.setO_idx(o_idx);
			odVO.setP_idx(cart_vo.getP_idx());
			odVO.setOd_count(cart_vo.getC_count());
			int res2 = order_dao.od_insert(odVO);
			res2 = cart_dao.cart_delete(cart_vo.getC_idx());
			res2 = order_dao.decreaseProductStock(cart_vo.getP_idx(), cart_vo.getC_count()); // 주문이 완료된 후에 상품의 재고량을 감소시킴
		}
		List<OrderVO> order_list = order_dao.selectList(member_vo.getM_idx());
		model.addAttribute("list", order_list);
		return MyCommon.O_PATH + "order_list.jsp";
	}

	// 결제후 구매내역으로 이동 (바로결제)
	@RequestMapping("direct_purchase_complete.do")
	public String direct_purchase_complete(Model model) {
		int c_count = Integer.parseInt(request.getParameter("c_count"));
		int c_idx = Integer.parseInt(request.getParameter("c_idx"));
		String o_addr = request.getParameter("o_addr");
		MemberVO member_vo = (MemberVO) session.getAttribute("account");

		CartVO cart_vo = cart_dao.selectOne_by_c_idx(c_idx);
		OrderVO orderVO = new OrderVO();
		orderVO.setM_idx(member_vo.getM_idx());
		orderVO.setO_addr(o_addr);
		orderVO.setO_count(1);
		orderVO.setP_idx(cart_vo.getP_idx());
		int res = order_dao.order_insert(orderVO);
		int o_idx = order_dao.selectOne(member_vo.getM_idx());
		OrderdetailVO odVO = new OrderdetailVO();
		odVO.setO_idx(o_idx);
		odVO.setP_idx(cart_vo.getP_idx());
		odVO.setOd_count(c_count);
		int res2 = order_dao.od_insert(odVO);
		System.out.println("기존 수량 : " + cart_vo.getC_count() + "\n바로결제 수량 : " + c_count);
		if (cart_vo.getC_count() == c_count) {
			res2 = cart_dao.purchased_cart_delete(cart_vo);
		} else {
			cart_vo.setC_count(c_count);
			res2 = cart_dao.purchased_cart_update(cart_vo);
		}

		order_dao.decreaseProductStock(cart_vo.getP_idx(), c_count); // 주문이 완료된 후에 상품의 재고량을 감소시킴

		List<OrderVO> order_list = order_dao.selectList(member_vo.getM_idx());
		model.addAttribute("list", order_list);
		return MyCommon.O_PATH + "order_list.jsp";
	}

	// 주문내역 가져오기
	@RequestMapping("order_list.do")
	public String order_list(Model model) {
		MemberVO member_vo = (MemberVO) session.getAttribute("account");
		int m_idx = member_vo.getM_idx();

		List<OrderVO> order_list = order_dao.selectList(m_idx);
		model.addAttribute("list", order_list);
		return MyCommon.O_PATH + "order_list.jsp";
	}

	// 주문 상세 뷰
	@RequestMapping("order_view.do")
	public String order_view(Model model, OrderVO order_vo) {
		int o_idx = order_vo.getO_idx();
		int m_idx = order_vo.getM_idx();
		MemberVO member_vo = (MemberVO) session.getAttribute("account");
		if (m_idx != member_vo.getM_idx()) {
			return "redirect:member_check.do";
		}

		List<OrderdetailVO> list = order_dao.od_selectList(o_idx);

		// 각 OrderdetailVO에 해당하는 p_name과 p_img 설정
		for (OrderdetailVO vo : list) {
			ProductVO product = product_dao.selectOne(vo.getP_idx());
			vo.setP_name(product.getP_name());
			vo.setP_img(product.getP_img());
		}

		model.addAttribute("list", list);

		// 총결제금액 계산
		int totalAmount = 0;
		for (OrderdetailVO vo : list) {
			totalAmount += vo.getOd_price() * vo.getOd_count();
		}
		model.addAttribute("totalAmount", totalAmount);

		return MyCommon.O_PATH + "order_view.jsp";
	}
}
