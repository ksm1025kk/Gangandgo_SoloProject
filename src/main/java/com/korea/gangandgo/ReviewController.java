package com.korea.gangandgo;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import dao.OrderDAO;
import dao.ReviewDAO;
import util.MyCommon;
import vo.MemberVO;
import vo.OrderdetailVO;
import vo.ReviewVO;

@Controller
public class ReviewController {

	@Autowired
	SqlSession sqlSession;

	@Autowired
	HttpSession session;

	@Autowired
	HttpServletRequest request;

	@Autowired
	OrderDAO order_dao;

	@Autowired
	ReviewDAO review_dao;

	@RequestMapping("review_insert_form.do")
	public String review_insert_form(int od_idx, Model model) {
		OrderdetailVO odvo = order_dao.od_selectOne(od_idx);
		model.addAttribute("odvo", odvo);

		return MyCommon.RV_PATH + "review_insert_form.jsp";
	}

	@RequestMapping("review_insert.do")
	public String review_insert(ReviewVO vo) {
		MemberVO member_vo = (MemberVO) session.getAttribute("account");
		if (member_vo == null || member_vo.getM_idx() != vo.getM_idx()) {
			return "redirect:member_check.do";
		}
		String webPath = "/resources/upload";
		String savePath = request.getServletContext().getRealPath(webPath);
		MultipartFile photos = vo.getPhotos();
		String filename = "no_file";
		System.out.println(savePath);
		if (!photos.isEmpty()) {
			filename = photos.getOriginalFilename();
			File saveFile = new File(savePath, filename);

			if (!saveFile.exists()) {
				saveFile.mkdirs();
			} else {
				long time = System.currentTimeMillis();
				filename = String.format("%d_%s", time, filename);
				saveFile = new File(savePath, filename);

			}
			try {
				photos.transferTo(saveFile);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}

		vo.setRv_img(filename);
		int res = review_dao.review_insert(vo);
		OrderdetailVO odvo = order_dao.od_selectOne(vo.getOd_idx());
		if (res > 0) {
			res = order_dao.review_check_update(vo.getOd_idx());
			return "redirect:product_view.do?p_idx=" + odvo.getP_idx();
		}
		return null;
	}

}
