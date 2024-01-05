package com.korea.gangandgo;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.BoardDAO;
import dao.MemberDAO;
import dao.ReplyDAO;
import util.MyCommon;
import vo.BoardVO;
import vo.MemberVO;
import vo.ReplyVO;

@Controller
public class MemberController {

	@Autowired
	MemberDAO member_dao;

	@Autowired
	BoardDAO board_dao;

	@Autowired
	ReplyDAO reply_dao;

	@Autowired
	SqlSession sqlSession;

	@Autowired
	HttpSession session;

	@Autowired
	HttpServletRequest request;

	@RequestMapping("login_form.do") // 로그인 폼 이동
	public String login_form() {
		String pre_page = request.getParameter("pre_page");
		if (pre_page == null) {
			return MyCommon.M_PATH + "login_form.jsp";
		} else {
			return MyCommon.M_PATH + "login_form.jsp?pre_page=" + pre_page;
		}
	}

	@RequestMapping("login.do") // 로그인
	@ResponseBody // 에이젝스 썼으니까 리스펀스바디
	public String login(String m_email, String m_pwd) {

		// 이메일의 존재 여부 체크
		MemberVO vo = member_dao.email_exist_check(m_email);

		// 이메일 없는경우(이메일이 unknown 일경우)
		if (vo == null) {
			return "[{'param':'no_m_email'}]";
		}
		if (vo.getM_nickname().equals("UNKNOWN")) {
			return "[{'param':'no_m_email'}]";
		}
		// 비밀번호가 일치하지 않는 경우
		if (!vo.getM_pwd().equals(m_pwd)) {
			return "[{'param' : 'no_m_pwd'}]";
		}

		session.setAttribute("account", vo);

		// 로그인에 성공한 경우
		return "[{'param' : 'clear'}]";
	}

	@RequestMapping("logout.do") // 로그아웃
	public String logout() {
		session.removeAttribute("account");

		return "redirect:home.do";
	}

	// ------------------------------------------------------------

	@RequestMapping("member_insert_form.do") // 회원가입 폼 이동
	public String register_form() {
		return MyCommon.M_PATH + "member_insert_form.jsp";
	}

	@RequestMapping("member_insert.do") // 회원가입
	public String member_insert(MemberVO vo) {
		int res = member_dao.member_insert(vo);
		if (res > 0) {
			return "redirect:login_form.do";
		}
		return null;
	}

	@RequestMapping("check_email.do") // 이메일 중복체크 회원가입 시
	@ResponseBody
	public String check_email(String m_email) {
		int res = member_dao.email_check(m_email);
		if (res == 0) {
			return "[{'res' : 'yes'}]";
		}
		return "[{'res' : 'no'}]";
	}

	@RequestMapping("check_nickname.do") // 닉네임 중복체크
	@ResponseBody
	public String check_nickname(String m_nickname) {
		int res = member_dao.nickname_check(m_nickname);
		if (res == 0) {
			return "[{'res' : 'yes'}]";
		}
		return "[{'res' : 'no'}]";
	}

	// 비밀번호찾기 폼
	@RequestMapping("pwd_modify_form.do")
	public String pwd_find_form() {
		return MyCommon.M_PATH + "pwd_modify_form.jsp";

	}

	// 비밀번호 변경
	@RequestMapping("pwd_modify.do")
	public String pwd_modify(MemberVO vo) {

		int res = member_dao.newpwd_update(vo);

		if (res > 0) {
			return "redirect:login_form.do";
		}
		return null;
	}

	// 비밀번호 확인
	@RequestMapping("pwd_reenter_form.do")
	public String delete_membetship_form() {
		return MyCommon.M_PATH + "pwd_reenter_form.jsp";
	}

	// 개인정보 수정 폼으로 이동
	@RequestMapping("member_info_modify_form.do")
	public String user_info_modify() {
		return MyCommon.M_PATH + "member_info_modify_form.jsp";
	}

	// 멤버의 개인정보 수정후 세션 업데이트
	@RequestMapping("member_info_modify.do")
	public String member_info_modify(MemberVO vo) {
		MemberVO member_vo = (MemberVO) session.getAttribute("account");
		if (member_vo == null || member_vo.getM_idx() != vo.getM_idx()) {
			return "redirect:member_check.do";
		}
		MemberVO ori_vo = member_dao.selectOne(vo.getM_idx());
		ori_vo.setM_nickname(vo.getM_nickname());
		ori_vo.setM_pwd(vo.getM_pwd());
		ori_vo.setM_tel(vo.getM_tel());
		int res = member_dao.member_info_modify(ori_vo);

		session.removeAttribute("account");
		session.setAttribute("account", ori_vo);

		if (res > 0) {
			return "redirect:home.do"; // 임시로 일단 감
		}
		return null;
	}

	@RequestMapping("member_view.do")
	public String member_view(Model model, int m_idx) {
		MemberVO vo = member_dao.selectOne(m_idx);
		List<BoardVO> list = board_dao.selectList_by_m_idx(m_idx);
		List<ReplyVO> re_list = reply_dao.selectList_by_m_idx(m_idx);
		model.addAttribute("memberVO", vo);
		model.addAttribute("b_list", list);
		model.addAttribute("re_list", re_list);

		return MyCommon.M_PATH + "member_view.jsp";
	}

	@RequestMapping("member_delete_form.do")
	public String secession_info_for_delete_membership() {
		return MyCommon.M_PATH + "member_delete_form.jsp";
	}

	@RequestMapping("member_delete.do")
	public String delete_membership() {
		MemberVO vo = (MemberVO) session.getAttribute("account");
		int res = member_dao.delete_membership(vo.getM_idx());
		if (res > 0) {
			session.removeAttribute("account");
			return "redirect:home.do";
		}
		return null;
	}

	@RequestMapping("address_info_form.do")
	public String address_info_form() {
		return MyCommon.M_PATH + "member_address_info_form.jsp";
	}

	@RequestMapping("address_form.do")
	public String address_form(Model model) {
		int addr_num = Integer.parseInt(request.getParameter("addr_num"));
		model.addAttribute("addr_num", addr_num);
		return MyCommon.M_PATH + "member_address_form.jsp";
	}

	// 12/11 수정
	// 배송지1 수정
	@RequestMapping("member_addr_modify.do")
	public String member_addr_modify(MemberVO vo, int addr_num) {
		MemberVO ori_account = (MemberVO) session.getAttribute("account");
		if (ori_account == null || ori_account.getM_idx() != vo.getM_idx()) {
			return "redirect:member_check.do";
		}
		session.removeAttribute("account");
		int res;
		switch (addr_num) {
		case 1:
			vo.setM_addr1(vo.getM_addr1() + "/" + vo.getM_addr1_extra());
			vo.setM_addr2(ori_account.getM_addr2());
			vo.setM_addr3(ori_account.getM_addr3());
			res = member_dao.member_addr_modify(vo);
			ori_account.setM_addr1(vo.getM_addr1());
			break;
		case 2:
			vo.setM_addr2(vo.getM_addr2() + "/" + vo.getM_addr2_extra());
			vo.setM_addr1(ori_account.getM_addr1());
			vo.setM_addr3(ori_account.getM_addr3());
			res = member_dao.member_addr_modify(vo);
			ori_account.setM_addr2(vo.getM_addr2());
			break;
		case 3:
			vo.setM_addr3(vo.getM_addr3() + "/" + vo.getM_addr3_extra());
			vo.setM_addr1(ori_account.getM_addr1());
			vo.setM_addr2(ori_account.getM_addr2());
			res = member_dao.member_addr_modify(vo);
			ori_account.setM_addr3(vo.getM_addr3());
			break;
		}

		session.setAttribute("account", ori_account);

		return "redirect:address_info_form.do";
	}

	@RequestMapping("member_addr_del.do")
	public String member_addr(MemberVO vo, int addr_num) {
		MemberVO ori_account = (MemberVO) session.getAttribute("account");
		if (ori_account == null || ori_account.getM_idx() != vo.getM_idx()) {
			return "redirect:member_check.do";
		}
		session.removeAttribute("account");
		int res;
		switch (addr_num) {
		case 1:
			ori_account.setM_addr1("");
			res = member_dao.member_addr_modify(ori_account);
			break;
		case 2:
			ori_account.setM_addr2("");
			res = member_dao.member_addr_modify(ori_account);
			break;
		case 3:
			ori_account.setM_addr3("");
			res = member_dao.member_addr_modify(ori_account);
			break;
		}

		session.setAttribute("account", ori_account);

		return "redirect:address_info_form.do";
	}
}
