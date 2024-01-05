package com.korea.gangandgo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import dao.BoardDAO;
import dao.MemberDAO;
import util.MyCommon;

@Controller
public class HomeController {

	@Autowired
	MemberDAO member_dao;

	@Autowired
	BoardDAO board_dao;

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	@RequestMapping(value = { "/", "home.do" }) // 메인 페이지
	public String home() {
		
		
		return MyCommon.H_PATH + "home.jsp";
	}

	@RequestMapping("login_check.do")
	public String login_check() {
		return MyCommon.H_PATH + "login_check.jsp";
	}
	
	@RequestMapping("auth_check.do")
	public String auth_check() {
		return MyCommon.H_PATH + "auth_check.jsp";
	}
	
	@RequestMapping("member_check.do")
	public String member_check() {
		return MyCommon.H_PATH + "member_check.jsp";
	}
}
