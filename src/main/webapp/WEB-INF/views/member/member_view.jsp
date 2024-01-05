<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${memberVO.m_nickname}님의 프로필</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/member_view.css">
		<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
		<script src="https://kit.fontawesome.com/a8032e8555.js" crossorigin="anonymous"></script>
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
			<div class="welcome">
				${memberVO.m_nickname}님의 프로필
			</div>
			<hr>
			<div class="title">
				최신 게시글
			</div>
			<c:choose>
				<c:when test="${not empty b_list}">
					<c:forEach var="vo" end="10" items="${b_list}">
						<div class="b_container" onclick="location.href='board_view.do?b_idx=${vo.b_idx}'">
							<div>
								<span class="b_title"><b>제목</b> :  ${vo.b_title}</span>
								<span class="b_postdate" ><i class="fa-regular fa-calendar-check"></i> ${vo.b_postdate}</span>							
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:when test="${empty b_list}">
					<div style="color:gray; padding:10px 0;">작성한 게시글이 없습니다</div>
				</c:when>
			</c:choose>
			<hr>
			<div class="title">
				최신 작성 댓글
			</div>
			<c:choose>
				<c:when test="${not empty re_list}">
				 	<c:forEach var="vo" end="10" items="${re_list}">
						<div class="r_container" onclick="location.href='board_view.do?b_idx=${vo.b_idx}'">	
							<div>
								<b>내용</b> :  ${vo.r_content}
								<span style="float:right;"><i class="fa-regular fa-calendar-check"></i> ${vo.r_postdate}</span>			
							</div>
						</div>
					</c:forEach>
				</c:when>
				<c:when test="${empty re_list}">
					<div style="color:gray; padding:10px 0;">작성한 댓글이 없습니다.</div>
				</c:when>
			</c:choose>
			<hr>
			<%-- <div class="title">
			최신 상품 리뷰
			 </div>
		 	<c:forEach var="vo" end="10" items="${re_list}">
				<div class="r_container" onclick="location.href='board_view.do?b_idx=${vo.b_idx}'">	
						<div>
							<b>내용</b> :  ${vo.r_content}
							<span style="float:right;"><b style="text-align:right">작성일</b> : ${vo.r_postdate}</span>			
						</div>
				</div>
			</c:forEach> --%>

	</main>
</body>
</html>