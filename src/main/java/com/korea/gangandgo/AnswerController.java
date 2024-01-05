package com.korea.gangandgo;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.AnswerDAO;
import dao.HelpDAO;
import util.MyCommon;
import vo.AnswerVO;
import vo.MemberVO;

@Controller
public class AnswerController {

	@Autowired
	AnswerDAO answer_dao;

	@Autowired
	HelpDAO help_dao;

	@Autowired
	HttpSession session;

	@RequestMapping("answer_insert.do")
	public String answer_insert(AnswerVO vo) {
		MemberVO member_vo = (MemberVO)session.getAttribute("account");
		if(member_vo == null || member_vo.getM_auth() == 0) {
			return "redirect:auth_check.do";
		}
		vo.setA_content(vo.getA_content().replace("\n", "<br>"));
		int res = answer_dao.answer_insert(vo);
		res = help_dao.solved_update(vo.getH_idx());

		if (res > 0) {
			return "redirect:help_view.do?h_idx=" + vo.getH_idx();
		} else {
			return null;
		}
	}

	@RequestMapping("answer_delete.do")
	public String answer_delete(int a_idx, int h_idx) {
		MemberVO member_vo = (MemberVO)session.getAttribute("account");
		if(member_vo == null || member_vo.getM_auth() == 0) {
			return "redirect:auth_check.do";
		}

		int res = answer_dao.answer_delete(a_idx);
		res = help_dao.answer_delete_solved_update(h_idx);

		if (res > 0) {
			return "redirect:help_view.do?h_idx=" + h_idx;
		} else {
			return null;
		}
	}

}
