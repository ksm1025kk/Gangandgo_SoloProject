<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><!-- 천단위 콤마위한 -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>구매내역</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/order/order_list.css">	
<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://kit.fontawesome.com/a8032e8555.js" crossorigin="anonymous"></script>
<script src="resources/js/httpRequest.js"></script>
<script type="text/javascript">
	var account = "${account}"

	if(account == ''){
		if(confirm('로그인이 필요한 서비스입니다.')){
			location.href="login_form.do"; 
		}else{
			history.back();
		}
	}
	
	function order_view(f){
		f.action="order_view.do";
		f.method="post";
		f.submit();
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
	<main style="margin:150px auto 0;">
		<div class="menu_title"><i class="fa-solid fa-file-lines"></i> 구매내역</div>
		<div class="main text">
			<c:forEach var="vo" items="${list}">
				<form>
					<div class="content-container">					
						<div class="content">				
						<div class="o_idx">주문번호 : ${vo.o_idx}</div>
						<div class="order_container">
								<img class="p_img" src="${pageContext.request.contextPath}/resources/upload/${vo.p_img}" style="width:20%; height:20%;">		
							<div class="order_info">
								 <c:choose>
				                       	<c:when test="${vo.o_count - 1 > 0}">
				                           <span>${vo.p_name} 외 ${(vo.o_count)-1}건</span><br>
				                        </c:when>
				                        <c:otherwise>
				                        	<span>${vo.p_name}</span><br>
				                        </c:otherwise>                 
				                </c:choose>
									<span>주문일 : ${vo.o_date}</span><br>
									<span>배송지 : ${vo.o_addr}</span><br>
							</div>
						</div>
						</div>
						<input type="hidden" name="o_idx" value="${vo.o_idx}">
						<input type="hidden" name="m_idx" value="${vo.m_idx}">
						<input type="button" class="order_view_button" value="주문 상세보기" onclick="order_view(this.form)">
					</div>
				</form>	
			</c:forEach>
		</div>
		<!-- <div class="back">
		<input type="button" value="홈으로" onclick="location.href='home.do'">
		</div> -->
		<div class="back" onclick="location.href='home.do'">
				<i class="fa-solid fa-house"></i> 홈으로
		</div>
		
	</main>
</body>
</html>