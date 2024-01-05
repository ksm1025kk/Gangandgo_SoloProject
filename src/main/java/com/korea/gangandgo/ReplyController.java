package com.korea.gangandgo;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.BoardDAO;
import dao.ReplyDAO;
import vo.MemberVO;
import vo.ReplyVO;

@Controller
public class ReplyController {

	@Autowired
	ReplyDAO reply_dao;
	
	@Autowired
	BoardDAO board_dao;
	
	@Autowired
	HttpSession session;

	@RequestMapping("reply_insert.do")
	@ResponseBody
	public String reply_insert(ReplyVO vo) {
		MemberVO member_vo = (MemberVO)session.getAttribute("account");
		if(member_vo == null || member_vo.getM_idx() != vo.getM_idx()) {
			return "<script>location.href='member_check.do'</script>";
		}
		vo.setR_content(vo.getR_content().replace("\n", "<br>"));
		vo.setR_depth(0);
		vo.setR_step(0);
		int res = reply_dao.reply_insert(vo);
		res=board_dao.reply_count_increase(vo.getB_idx());

		if (res > 0) {
			return "[{'result':'yes'}]";

		} else {
			return "[{'result':'no'}]";
		}
	}

	@RequestMapping("reply_delete.do")
	@ResponseBody
	public String reply_delete(int r_idx, int m_idx) {
		MemberVO member_vo = (MemberVO)session.getAttribute("account");
		if(member_vo == null || member_vo.getM_idx() != m_idx) {
			return "<script>location.href='member_check.do'</script>";
		}
		int res = reply_dao.reply_delete(r_idx);

		if (res > 0) {
			return "[{'result':'yes'}]";

		} else {
			return "[{'result':'no'}]";
		}
	}

	@RequestMapping("reply_reply_insert.do")
	@ResponseBody
	public String reply_reply_insert(ReplyVO vo) {
		MemberVO member_vo = (MemberVO)session.getAttribute("account");
		if(member_vo == null || member_vo.getM_idx() != vo.getM_idx()) {
			return "<script>location.href='member_check.do'</script>";
		}
		vo.setR_content(vo.getR_content().replace("\n", "<br>"));
		ReplyVO parent_reply = reply_dao.selectOne(vo.getR_parent_idx());
		
		vo.setR_ref(parent_reply.getR_ref());
		vo.setR_depth(parent_reply.getR_depth()+1);
		vo.setR_step(parent_reply.getR_step()+parent_reply.getR_nested()+1);
		int res = reply_dao.updateStep(vo);
		res = reply_dao.updateNested(vo);
		res=board_dao.reply_count_increase(vo.getB_idx());
		
		for(int i=1; i<vo.getR_depth(); i++) {
			reply_dao.updateNested(parent_reply);
			parent_reply = reply_dao.selectOne(parent_reply.getR_parent_idx());
		}
		
		res = reply_dao.reply_reply_insert(vo);

		if (res > 0) {
			return "[{'result':'yes'}]";

		} else {
			return "[{'result':'no'}]";
		}
	}
}
