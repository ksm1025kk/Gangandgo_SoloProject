package com.korea.gangandgo;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.CartDAO;
import dao.ProductDAO;
import util.MyCommon;
import vo.CartVO;
import vo.MemberVO;
import vo.ProductVO;

@Controller
public class CartController {

	@Autowired
	ProductDAO product_dao;

	@Autowired
	CartDAO cart_dao;

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	// 상품 한개를 카트에 담기
	@RequestMapping("send_cart.do")
	@ResponseBody
	public String send_cart(int p_idx, int c_count, int m_idx) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null || memberVO.getM_idx() != m_idx) {
			return "<script>location.href='member_check.do'</script>";
		}
		CartVO cart_vo = new CartVO();
		cart_vo.setP_idx(p_idx);
		cart_vo.setC_count(c_count);
		cart_vo.setM_idx(m_idx);

		int res = cart_dao.cart_update(cart_vo);
		if (res > 0) {
			return "[{'result':'yes'}]";
		} else {
			res = cart_dao.cart_insert(cart_vo);
			if (res > 0) {
				return "[{'result':'yes'}]";
			} else {
				return "[{'result':'no'}]";
			}
		}
	}

	// product view에서 바로결제 클릭 시 결제페이지로 이동
	@RequestMapping("direct_payment.do")
	public String direct_payment(Model model, CartVO cart_vo) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null || memberVO.getM_idx() != cart_vo.getM_idx()) {
			return "redirect:member_check.do";
		}
		int c_count = cart_vo.getC_count(); // 일단 바로결제할 수량 쟁여두기
		int res = cart_dao.cart_update(cart_vo); // 장바구니에 중복된 상품이 있다면 개수만 추가
		if (res == 0) {
			res = cart_dao.cart_insert(cart_vo); // 만약 중복된 상품이 없다면 새로 추가
		}
		cart_vo = cart_dao.selectOne_by_p_idx(cart_vo.getP_idx()); // c_idx 가져오기
		cart_vo.setC_count(c_count); // 아까 쟁여둔 결제 수량 세팅해주기
		model.addAttribute("cartVO", cart_vo);
		if (res > 0) {
			return MyCommon.C_PATH + "direct_payment.jsp";
		} else {
			return null;
		}
	}

	// 장바구니로 이동
	@RequestMapping("cart_list.do")
	public String cart_list(Model model) {
		MemberVO vo = (MemberVO) session.getAttribute("account"); // 계정정보
		List<CartVO> list = cart_dao.selectList(vo.getM_idx());
		int total_price = 0; // 초기화
		for (CartVO cartVO : list) {
			total_price += cartVO.getP_price() * cartVO.getC_count();
		}
		model.addAttribute("list", list);
		model.addAttribute("total_price", total_price);
		return MyCommon.C_PATH + "cart_list.jsp";
	}

	// 장바구니삭제
	@RequestMapping("cart_delete.do")
	@ResponseBody
	public String cart_delete(int c_idx, int m_idx) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null || memberVO.getM_idx() != m_idx) {
			return "<script>location.href='member_check.do'</script>";
		}
		int res = cart_dao.cart_delete(c_idx);

		if (res > 0) {
			return "[{'result':'yes'}]";
		} else {
			return "[{'result':'no'}]";
		}
	}

	// 장바구니결제 주소지선택이동
	@RequestMapping("payment.do")
	public String address_choice(Model model, int c_idx, int total_price) {
		MemberVO vo = (MemberVO) session.getAttribute("account");
		List<CartVO> list = cart_dao.selectList(vo.getM_idx());

		// p_name 넘기기위한
		for (CartVO cartVO : list) {
			ProductVO product = product_dao.selectOne(cartVO.getP_idx());
			if (product != null) {
				cartVO.setP_name(product.getP_name());
			}
			if (cartVO.getC_count() > product.getP_amount()) {
				model.addAttribute("reject", 1);
				return MyCommon.C_PATH + "payment.jsp";
			}
		}

		model.addAttribute("c_idx", c_idx);
		model.addAttribute("total_price", total_price);
		model.addAttribute("list", list); // list를 모델에 추가
		return MyCommon.C_PATH + "payment.jsp";
	}

}
