package com.korea.gangandgo;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import dao.AnswerDAO;
import dao.HelpDAO;
import util.MyCommon;
import vo.AnswerVO;
import vo.HelpVO;
import vo.MemberVO;
import vo.PagingVO;

@Controller
public class HelpController {

	@Autowired
	HelpDAO help_dao;

	@Autowired
	AnswerDAO answer_dao;

	@Autowired
	HttpSession session;

	// 고객센터 눌렀을때
	@RequestMapping("helpdesk.do")
	public String helpdesk(PagingVO pvo, Model model, @RequestParam(value = "nowPage", required = false) String nowPage,
			@RequestParam(value = "cntPerPage", required = false) String cntPerPage,
			@RequestParam(value = "h_solved", required = false) Integer h_solved) {

		MemberVO vo = (MemberVO) session.getAttribute("account");

		if (h_solved == null) {
			h_solved = 0;
		}

		int total = help_dao.count_help(h_solved);

		if (nowPage == null && cntPerPage == null) {
			nowPage = "1";
			cntPerPage = "10";
		} else if (nowPage == null) {
			nowPage = "1";
		} else if (cntPerPage == null) {
			cntPerPage = "10";
		}

		pvo = new PagingVO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));

		pvo.setH_solved(h_solved);

		List<HelpVO> list;
		//////////////////////////////////////////////////////////
		if (session.getAttribute("account") == null) {
			return "redirect:login_check.do";
		}
		///////////////////////////////////////////////////////////
		// 관리자 계정일때 모든 문의 리스트 조회
		if (vo.getM_auth() == 1) {

			list = help_dao.help_all_selectList(pvo);
			// 일반회원계정일때 해당회원 문의 리스트만 조회
		} else{
			list = help_dao.help_member_selectList(vo.getM_idx());
		}
		model.addAttribute("paging", pvo);
		model.addAttribute("help_list", list);
		return MyCommon.HELP_PATH + "helpdesk.jsp";
	}

	// 문의하기 눌렀을때
	@RequestMapping("help_insert_form.do")
	public String help_insert_form() {
		return MyCommon.HELP_PATH + "help_insert_form.jsp";
	}

	// 문의내용 추가
	@RequestMapping("help_insert.do")
	public String help_insert(HelpVO vo) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null || memberVO.getM_idx() != vo.getM_idx()) {
			return "redirect:member_check.do";
		}

		int res = help_dao.help_insert(vo);

		if (res > 0) {
			return "redirect:helpdesk.do";
		} else {
			return null;
		}

	}

	// 문의내용 보기
	@RequestMapping("help_view.do")
	public String help_view(Model model, int h_idx) {
		HelpVO vo = help_dao.help_selectOne(h_idx);

		vo.setH_content(vo.getH_content().replace("\r\n", "<br>"));
		AnswerVO answer_vo = answer_dao.answer_selectOne(h_idx);

		model.addAttribute("AnswerVO", answer_vo);
		model.addAttribute("HelpVO", vo);
		return MyCommon.HELP_PATH + "help_view.jsp";

	}
}
