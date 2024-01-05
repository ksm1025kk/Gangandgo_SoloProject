package com.korea.gangandgo;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import dao.BoardDAO;
import dao.ReplyDAO;
import util.MyCommon;
import vo.BoardVO;
import vo.ImageVO;
import vo.MemberVO;
import vo.PagingVO;
import vo.ReplyVO;

@Controller
public class BoardController {

	@Autowired
	BoardDAO board_dao;

	@Autowired
	ReplyDAO reply_dao;

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	@RequestMapping("board_list.do") // 게시판
	public String selectList(PagingVO vo, Model model,
			@RequestParam(value = "nowPage", required = false) String nowPage,
			@RequestParam(value = "cntPerPage", required = false) String cntPerPage,
			@RequestParam(value = "orderby", required = false) String orderby) {

		session.removeAttribute("show");

		int total = board_dao.countBoard();
		if (nowPage == null && cntPerPage == null) {
			nowPage = "1";
			cntPerPage = "5";
		} else if (nowPage == null) {
			nowPage = "1";
		} else if (cntPerPage == null) {
			cntPerPage = "5";
		}
		vo = new PagingVO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));

		if (orderby != null) {
			vo.setOrderby(orderby);
		}

		List<BoardVO> list = board_dao.selectList(vo);
		model.addAttribute("paging", vo);
		model.addAttribute("b_list", list);

		return MyCommon.B_PATH + "board_list.jsp";
	}

	@RequestMapping("board_insert_form.do") // 게시글 작성폼
	public String insert_form() {
		return MyCommon.B_PATH + "board_insert_form.jsp";
	}

	@RequestMapping("board_insert.do") // 게시글 작성
	public String board_upload(BoardVO vo) {
		if (session.getAttribute("account") == null) {
			return "redirect:login_check.do";
		}
		MultipartFile[] photos = vo.getPhotos();
		String webPath = "/resources/upload";
		String savePath = request.getServletContext().getRealPath(webPath);
		String filename = "no_file";
		List<String> filenames = new ArrayList<>();

		if (!photos[0].isEmpty()) {
			for (MultipartFile photo : photos) {
				filename = photo.getOriginalFilename();

				File saveFile = new File(savePath, filename);

				if (!saveFile.exists()) {
					saveFile.mkdirs();
					filenames.add(filename);
				} else {
					long time = System.currentTimeMillis();
					filename = String.format("%d_%s", time, filename);
					saveFile = new File(savePath, filename);
					filenames.add(filename);
				}

				try {
					photo.transferTo(saveFile);
				} catch (Exception e) {
					// TODO: handle exception
				}
				filename = "no_file";
			}
		}
		vo.setB_thumbup(0);
		vo.setB_readhit(0);

		int res = board_dao.board_insert(vo);

		ImageVO ivo = new ImageVO();
		ivo.setB_idx(board_dao.board_selectOne_by_m_idx(vo.getM_idx()));

		for (String fn : filenames) {
			ivo.setI_img(fn);
			res = board_dao.image_insert(ivo);
		}

		if (res > 0) {
			return "redirect:board_list.do";
		} else {
			return null;
		}
	}

	// 게시글 들어가서 상세보기
	@RequestMapping("board_view.do")
	public String view(PagingVO pvo, Model model, int b_idx,
			@RequestParam(value = "nowPage", required = false) String nowPage,
			@RequestParam(value = "cntPerPage", required = false) String cntPerPage) {

		int total = reply_dao.countReply(b_idx);
		if (nowPage == null && cntPerPage == null) {
			nowPage = "1";
			cntPerPage = "10";
		} else if (nowPage == null) {
			nowPage = "1";
		} else if (cntPerPage == null) {
			cntPerPage = "10";
		}

		pvo = new PagingVO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));
		pvo.setB_idx(b_idx);

		List<ReplyVO> list = reply_dao.selectList(pvo);
		BoardVO vo = board_dao.selectOne(b_idx);
		vo.setB_content(vo.getB_content().replace("\r\n", "<br>"));

		String show = (String) session.getAttribute("show");

		if (show == null) {
			int res = board_dao.update_readhit(b_idx);
			session.setAttribute("show", "0");
		}

		List<ImageVO> img_list = board_dao.img_selectList(b_idx);

		model.addAttribute("img_list", img_list);
		model.addAttribute("paging", pvo);
		model.addAttribute("reply_list", list);
		model.addAttribute("vo", vo);
		return MyCommon.B_PATH + "board_view.jsp?b_idx=" + b_idx;
	}

	// 게시글 삭제
	@RequestMapping("board_delete.do")
	public String delete(int b_idx, int m_idx) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null) {
			return MyCommon.H_PATH + "login_check.do";
		}
		if (memberVO.getM_auth() != 1 && memberVO.getM_idx() != m_idx) {
			return MyCommon.H_PATH + "auth_check.do";
		}
		int res = reply_dao.board_reply_delete(b_idx);
		res = board_dao.board_delete(b_idx);
		if (res > 0) {
			return "redirect:board_list.do";
		} else {
			return null;
		}
	}

	// 게시글 수정 폼
	@RequestMapping("board_modify_form.do")
	public String board_update_form(Model model, int b_idx) {
		BoardVO vo = board_dao.selectOne(b_idx);
		List<ImageVO> img_list = board_dao.img_selectList(b_idx);

		model.addAttribute("img_list", img_list);
		model.addAttribute("vo", vo);

		return MyCommon.B_PATH + "board_modify_form.jsp";
	}

	// 게시글 수정
	@RequestMapping("board_update.do")
	public String board_update(BoardVO vo) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null) {
			return MyCommon.H_PATH + "login_check.do";
		}
		if (memberVO.getM_auth() != 1 && memberVO.getM_idx() != vo.getM_idx()) {
			return MyCommon.H_PATH + "member_check.do";
		}
		MultipartFile[] photos = vo.getPhotos();
		String webPath = "/resources/upload";
		String savePath = request.getServletContext().getRealPath(webPath);
		String filename = "no_file";
		List<String> filenames = new ArrayList<>();

		if (!photos[0].isEmpty()) {
			for (MultipartFile photo : photos) {
				filename = photo.getOriginalFilename();

				File saveFile = new File(savePath, filename);

				if (!saveFile.exists()) {
					saveFile.mkdirs();
					filenames.add(filename);
				} else {
					long time = System.currentTimeMillis();
					filename = String.format("%d_%s", time, filename);
					saveFile = new File(savePath, filename);
					filenames.add(filename);
				}

				try {
					photo.transferTo(saveFile);
				} catch (Exception e) {
					// TODO: handle exception
				}
				filename = "no_file";
			}
		}

		int res = board_dao.board_update(vo);

		ImageVO ivo = new ImageVO();
		ivo.setB_idx(vo.getB_idx());

		for (int i = 0; i < filenames.size(); i++) {
			ivo.setI_img(filenames.get(i));
			res = board_dao.image_insert(ivo);
		}

		if (res > 0) {
			return "redirect:board_view.do?b_idx=" + vo.getB_idx();
		} else {
			return null;
		}

	}

	// 이미지삭제
	@RequestMapping("board_modify_image_delete.do")
	@ResponseBody
	public String board_modify_image_delete(int i_idx, int m_idx) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null || memberVO.getM_idx() != m_idx) {
			return "<script>location.href='member_check.do'</script>";
		}
		
		
		int res = board_dao.board_modify_image_delete(i_idx);

		if (res > 0) {
			return "[{'result':'yes'}]";

		} else {
			return "[{'result':'no'}]";
		}
	}

	// 게시글 추천
	@RequestMapping("board_thumbup.do")
	@ResponseBody
	public String board_thumbup(int m_idx, int b_idx) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO == null || memberVO.getM_idx() != m_idx) {
			return "<script>location.href='member_check.do'</script>";
		}
		HashMap<String, Integer> map = new HashMap<String, Integer>();
		map.put("m_idx", m_idx);
		map.put("b_idx", b_idx);

		int res = board_dao.thumbup_check(map);

		if (res > 0) {
			return "[{'result':'done'}]";
		}

		res = board_dao.board_thumbup_update(b_idx);
		res = board_dao.member_thumbup_insert(map);
		if (res > 0) {
			return "[{'result':'yes'}]";
		} else {
			return "[{'result':'no'}]";
		}
	}

	@RequestMapping("search_board.do")
	public String search_b_title(PagingVO vo, Model model, String type, String keyword,
			@RequestParam(value = "nowPage", required = false) String nowPage,
			@RequestParam(value = "cntPerPage", required = false) String cntPerPage,
			@RequestParam(value = "orderby", required = false) String orderby) {

		int total;

		switch (type) {
		case "b_title":
			vo.setKeyword(keyword);
			total = board_dao.countBoard_b_title(keyword);
			break;
		case "b_content":
			vo.setKeyword(keyword);
			total = board_dao.countBoard_b_content(keyword);
			break;
		case "b_writer":
			vo.setKeyword(keyword);
			total = board_dao.countBoard_b_nickname(keyword);
			break;
		default:
			return null;
		}
		if (nowPage == null && cntPerPage == null) {
			nowPage = "1";
			cntPerPage = "5";
		} else if (nowPage == null) {
			nowPage = "1";
		} else if (cntPerPage == null) {
			cntPerPage = "5";
		}

		vo = new PagingVO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));

		if (orderby != null) {
			vo.setOrderby(orderby);
		}

		List<BoardVO> res_list;
		switch (type) {
		case "b_title":
			vo.setKeyword(keyword);
			res_list = board_dao.selectList_b_title(vo);
			break;
		case "b_content":
			vo.setKeyword(keyword);
			res_list = board_dao.selectList_b_content(vo);
			break;
		case "b_writer":
			vo.setKeyword(keyword);
			res_list = board_dao.selectList_b_nickname(vo);
			break;
		default:
			return null;
		}
		model.addAttribute("paging", vo);
		model.addAttribute("res_list", res_list);
		model.addAttribute("type", type);
		model.addAttribute("keyword", keyword);

		return MyCommon.B_PATH + "board_res_list.jsp";
	}
}
