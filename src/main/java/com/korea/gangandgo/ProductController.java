package com.korea.gangandgo;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import dao.ProductDAO;
import dao.ReviewDAO;
import util.MyCommon;
import vo.MemberVO;
import vo.PagingVO;
import vo.ProductVO;
import vo.ReviewVO;

@Controller
public class ProductController {

	@Autowired
	ProductDAO product_dao;

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	@Autowired
	ReviewDAO review_dao;

	@RequestMapping("product_list.do")
	public String product_list(Model model, @RequestParam(value = "p_pettype", required = false) String p_pettype,
			@RequestParam(value = "p_category", required = false) String p_category,
			@RequestParam(value = "orderby", required = false) String orderby) {
		ProductVO vo = new ProductVO();
		if (p_pettype == null) {
			vo.setP_pettype("강아지");
		} else {
			vo.setP_pettype(p_pettype);
		}
		if (p_category == null) {
			vo.setP_category("사료");
		} else {
			vo.setP_category(p_category);
		}
		if (orderby == null) {
			vo.setOrderby("P_SALE_COUNT");
		} else {
			vo.setOrderby(orderby);
		}

		List<ProductVO> list = new ArrayList<ProductVO>();

		if (vo.getOrderby().equals("P_PRICE_ASC")) {
			list = product_dao.selectList_orderby_asc(vo);
		} else {
			list = product_dao.selectList(vo);
		}

		model.addAttribute("pvo", vo);
		model.addAttribute("p_list", list);
		return MyCommon.P_PATH + "product_list.jsp";
	}

	@RequestMapping("product_insert_form.do")
	public String insert_form() {
		return MyCommon.P_PATH + "product_insert_form.jsp";
	}

	@RequestMapping("product_insert.do")
	public String product_insert(ProductVO vo, String dog_category, String cat_category) {
		MemberVO member_vo = (MemberVO)session.getAttribute("account");
		if(member_vo == null || member_vo.getM_auth() == 0) {
			return "redirect:auth_check.do";
		}
		
		
		String webPath = "/resources/upload";
		String savePath = request.getServletContext().getRealPath(webPath);
		MultipartFile photo = vo.getPhoto();
		String filename = "no_file";
		System.out.println(savePath);
		if (!photo.isEmpty()) {
			filename = photo.getOriginalFilename();
			File saveFile = new File(savePath, filename);

			if (!saveFile.exists()) {
				saveFile.mkdirs();
			} else {
				long time = System.currentTimeMillis();
				filename = String.format("%d_%s", time, filename);
				saveFile = new File(savePath, filename);

			}
			try {
				photo.transferTo(saveFile);
			} catch (Exception e) {
				// TODO: handle exception
			}
		}

		vo.setP_img(filename);
		if (vo.getP_pettype().equals("강아지")) {
			vo.setP_category(dog_category);
		} else {
			vo.setP_category(cat_category);
		}

		int res = product_dao.product_insert(vo);
		if (res > 0) {
			return "redirect:product_list.do";
		} else {
			return null;
		}
	}

	@RequestMapping("product_view.do")
	public String product_view(PagingVO pagingvo, Model model, int p_idx,
			@RequestParam(value = "nowPage", required = false) String nowPage,
			@RequestParam(value = "cntPerPage", required = false) String cntPerPage) {

		int total = review_dao.count_review(p_idx);

		if (nowPage == null && cntPerPage == null) {
			nowPage = "1";
			cntPerPage = "5";
		} else if (nowPage == null) {
			nowPage = "1";
		} else if (cntPerPage == null) {
			cntPerPage = "5";
		}
		pagingvo = new PagingVO(total, Integer.parseInt(nowPage), Integer.parseInt(cntPerPage));
		pagingvo.setP_idx(p_idx);

		ProductVO vo = product_dao.selectOne(p_idx);
		vo.setP_info(vo.getP_info().replace("\r\n", "<br>"));
		model.addAttribute("pvo", vo);
		model.addAttribute("paging", pagingvo);
		List<ReviewVO> rv_list = review_dao.review_selectList(pagingvo);
		model.addAttribute("rv_list", rv_list);

		return MyCommon.P_PATH + "product_view.jsp?p_idx=" + p_idx;
	}

	@RequestMapping("delete_product.do")
	public String delete_product(int p_idx) {
		MemberVO memberVO = (MemberVO) session.getAttribute("account");
		if (memberVO.getM_auth() == 1 || memberVO == null) {
			return "redirect:auth_check.do";
		}
		int res = product_dao.delete_product(p_idx);

		if (res > 0) {
			return "redirect:product_list.do";
		} else {
			return null;
		}

	}
}
