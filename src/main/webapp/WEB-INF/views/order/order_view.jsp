<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><!-- 천단위 콤마위한 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 상세보기</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/order/order_view.css">
<script
	src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://kit.fontawesome.com/a8032e8555.js"
	crossorigin="anonymous"></script>
<script type="text/javascript">
	var account = "${account}"

	if(account == ''){
		if(confirm('로그인이 필요한 서비스입니다.')){
			location.href="login_form.do"; 
		}else{
			history.back();
		}
	}

	function review_write(f) {

		f.action = "review_insert_form.do";
		f.method = "post";
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
	<main style="margin: 150px auto 0;">
		<div class="order_number">주문번호 : ${list.get(0).o_idx}</div>
		<div class="main_text">
			<c:forEach var="vo" items="${list}">
				<form>
				<input type="hidden" value="${vo.od_idx}" name="od_idx">
					<div class="content-container">
						<div class="content">
							<div class="o_idx">상품명 : ${vo.p_name}</div>
							<div class="order_container">
								<img class="p_img"
									src="${pageContext.request.contextPath}/resources/upload/${vo.p_img}"
									width="200" height="140">
								<div class="order_info">
									<span>
										단가 : <fmt:formatNumber value="${vo.od_price}" pattern="#,##0" />원
									</span>
									<br> 
									<span>
										수량 : ${vo.od_count}
									</span>
									<br>
									<span>
										합계 : <fmt:formatNumber value="${vo.od_price*vo.od_count}" pattern="#,##0" />원
									</span>
									<br>
									
									<span>
										<c:if test="${vo.od_review_check eq 0}">
											<button class="review_btn" type="button" onclick="review_write(this.form)">리뷰 작성하기</button>
										</c:if>
									</span>
									<br>
								</div>
							</div>
						</div>			
					</div>
				</form>
			</c:forEach>
			<div class="total_price">
				총 결제금액 :
				<fmt:formatNumber value="${totalAmount}" pattern="#,##0" />
				원<br> <br>
			</div>
			<div class="back" onclick="location.href='order_list.do'">
				<i class="fa-solid fa-house"></i> 돌아가기
			</div>
		</div>
	</main>
</body>
</html>

