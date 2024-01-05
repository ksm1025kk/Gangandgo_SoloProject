<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 검색</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/search.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/board_list.css">
<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://kit.fontawesome.com/a8032e8555.js" crossorigin="anonymous"></script>
<script type="text/javascript">
	window.addEventListener('load', function(){
		var type = "${type}";
		document.getElementById("type").value = type;
	});
	function search(f) {
		var option = f.type.value;
		var keyword = f.keyword.value;
		if(keyword == ''){
			location.href="board_list.do";
		}else{
			f.action = "search_board.do";
			f.submit();
		}
	}

	function selChange() {
		var type = document.getElementById("type").value;
		var keyword = document.getElementById("keyword").value;
		var orderby= document.querySelector('input[name="orderby"]:checked').value;
		var sel = document.getElementById('cntPerPage').value;
		location.href="search_board.do?type="+type+"&keyword="+keyword+"&nowPage=${paging.nowPage}&cntPerPage="+sel+"&orderby="+orderby;
	}
</script>
</head>
<body>
	<header> 
		<nav>
			<img class="logo_img" src="${pageContext.request.contextPath}/resources/images/logo.png">
			<img class="hamburger" onclick="hamburger()" src="${pageContext.request.contextPath}/resources/images/hamburger.png">
			<ul class="header_menu" id="header_menu">
				<li class="" onclick="location.href='home.do'">홈</li>
				<li onclick="location.href='board_list.do'">게시판</li>
				<li onclick="location.href='product_list.do'">쇼핑몰</li>
				<li onclick="location.href='helpdesk.do'">고객센터</li>
				<c:choose>
					<c:when test="${empty account}">
						<li onclick="location.href='login_form.do'">로그인</li>
						<li onclick="location.href='member_insert_form.do'">회원가입</li>
					</c:when>
					<c:when test="${not empty account}"> 
						<li class="nickname" id="nickname">
							${account.m_nickname}님
							<div class="dropdown_content" id="dropdown_content">
							   	<div onclick="location.href='member_view.do?m_idx=${account.m_idx}'">내글보기</div>
							   	<div onclick="location.href='pwd_reenter_form.do'">개인정보 수정</div>
							   	<div onclick="location.href='cart_list.do'">장바구니</div>
							   	<div onclick="location.href='order_list.do'">구매내역</div>
							   	<div onclick="location.href='logout.do'">로그아웃</div>
					  		</div>
	 					</li>
					</c:when>
				</c:choose>
			</ul>
		</nav>
	</header>
	<main>
		<form class="search_form">
				<select class="type" id="type" name="type">
					<option value="b_title">제목</option>
					<option value="b_content">내용</option>
					<option value="b_writer">작성자</option>	
				</select> 
				<input class="keyword" name="keyword" id="keyword" value="${keyword}">
				<input type="submit" class="search_button" value="&#xf002" onclick="search(this.form)">
			</form>
		<div class="board_buttons">
			<div class="radios">
				<label class="orderby"><input type="radio" name="orderby"  value="B_IDX" onchange="selChange()"
				<c:if test="${paging.orderby eq 'B_IDX'}">checked</c:if>> 최신순</label>
				<label class="orderby"><input type="radio" name="orderby"  value="B_THUMBUP" onchange="selChange()"
				<c:if test="${paging.orderby eq 'B_THUMBUP'}">checked</c:if>> 좋아요순</label>
				<label class="orderby"><input type="radio" name="orderby" value="B_READHIT" onchange="selChange()"
				<c:if test="${paging.orderby eq 'B_READHIT'}">checked</c:if>> 조회순</label>
				<label class="orderby"><input type="radio" name="orderby" value="B_REPLY_COUNT" onchange="selChange()"
				<c:if test="${paging.orderby eq 'B_REPLY_COUNT'}">checked</c:if>> 댓글순</label>
			</div>
			<div>
			    <!-- 옵션선택 -->
				<select class="cntpage" id="cntPerPage" name="sel" onchange="selChange()">
					<option value="5"
						<c:if test="${paging.cntPerPage == 5}">selected</c:if>>5개씩 보기</option>
					<option value="10"
						<c:if test="${paging.cntPerPage == 10}">selected</c:if>>10개씩 보기</option>
					<option value="15"
						<c:if test="${paging.cntPerPage == 15}">selected</c:if>>15개씩 보기</option>
					<option value="20"
						<c:if test="${paging.cntPerPage == 20}">selected</c:if>>20개씩 보기</option>
				</select>
				<div class="write_button" onclick="location.href='board_insert_form.do'"><i class="fa-solid fa-pencil"></i> 글쓰기</div>
			</div>
		</div>
		<hr class="first_hr">
		<c:choose>
			<c:when test="${not empty res_list}">
				<c:forEach var="vo" items="${res_list}">
					<div class="b_container">
							<div class="b_wrapper">
								<div class="b_title" onclick="location.href='board_view.do?b_idx=${vo.b_idx}'">${vo.b_title}
									<label class="label">
										<c:if test="${vo.b_category eq '강아지'}">
										<i class="fa-solid fa-dog"></i>
										</c:if>
										<c:if test="${vo.b_category eq '고양이'}">
										<i class="fa-solid fa-cat"></i>
										</c:if>
										<c:if test="${vo.b_category eq '기타'}">
										<i class="fa-solid fa-guitar"></i>
										</c:if>
										${vo.b_category}
									</label>
								</div>
								<div class="b_content" onclick="location.href='board_view.do?b_idx=${vo.b_idx}'">${vo.b_content}</div>
								
							</div>
							<div class="img_wrapper">
								<c:if test="${not empty vo.b_img}">
									<img class="b_img" src="${pageContext.request.contextPath}/resources/upload/${vo.b_img}">
								</c:if>
							</div>
						</div>
							<div class="b_info">
								<i class="fa-regular fa-user"></i> ${vo.m_nickname} | 
								<i class="fa-regular fa-thumbs-up"></i> ${vo.b_thumbup} | 
								<i class="fa-regular fa-eye"></i> ${vo.b_readhit} | 
								<i class="fa-regular fa-comment-dots"></i> ${vo.b_reply_count} | 
								<i class="fa-regular fa-calendar-check"></i> ${fn:split(vo.b_postdate,' ')[0]}
							</div>
					 	<hr class="board_hr">
				</c:forEach>
			</c:when>
			<c:when test="${empty res_list}">
				<div style="text-align: center; color:gray; margin:50px auto 70px;">검색 결과가 없습니다.</div>
				<hr class="first_hr">
			</c:when>
		</c:choose>
		<!-- 페이지 선택 -->
		<div style="display: block; text-align: center;">		
			<c:if test="${paging.startPage != 1}">
				<span onclick="location.href='board_list.do?nowPage=${paging.startPage - 1}&cntPerPage=${paging.cntPerPage}'">&lt;</span>
			</c:if>
			<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
				<c:choose>
					<c:when test="${p == paging.nowPage}">
						<b>${p}</b>
					</c:when>
					<c:when test="${p != paging.nowPage}">
						<span onclick="location.href='board_list.do?nowPage=${p}&cntPerPage=${paging.cntPerPage}'">${p}</span>
					</c:when>
				</c:choose>
			</c:forEach>
			<c:if test="${paging.endPage != paging.lastPage}">
				<span onclick="location.href='board_list.do?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage}'">&gt;</span>
			</c:if>
		</div>
	</main>
	<footer>
	</footer>
</body>
</html>