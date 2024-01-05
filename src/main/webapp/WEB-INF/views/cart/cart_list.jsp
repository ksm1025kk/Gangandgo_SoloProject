<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- 천단위 콤마위한 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/cart/cart_list.css">
<script
	src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://kit.fontawesome.com/a8032e8555.js"
	crossorigin="anonymous"></script>
<script src="resources/js/httpRequest.js"></script>

<!-- 포트원 결제연동시 필요 라이브러리 -->
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<!-- jQuery -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- iamport.payment.js -->
<script type="text/javascript"
	src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<!-- 포트원 결제연동시 필요 라이브러리 -->

<script>
	var account = "${account}"

	if(account == ''){
		if(confirm('로그인이 필요한 서비스입니다.')){
			location.href="login_form.do"; 
		}else{
			history.back();
		}
	}

	function cart_delete(f) {
		var c_idx = f.c_idx.value;
		if (!confirm("해당 상품을 장바구니에서 삭제하시겠습니까?")) {
			return;
		}

		var url = "cart_delete.do";
		var param = "c_idx=" + encodeURIComponent(c_idx)+"&m_idx="+encodeURIComponent(${list[0].m_idx});

		sendRequest(url, param, delCheck, "POST");
	}

	function delCheck() {
		if (xhr.readyState == 4 && xhr.status == 200) {
			var data = xhr.responseText;
			var json = eval(data);

			if (json[0].result == "yes") { //컨트롤러에서 넘겨준 키값이 result임 
				alert("선택한 상품이 삭제되었습니다.");
				location.href = "cart_list.do?m_idx=${account.m_idx}"; //자동 새로고침
			} else {
				alert("ERROR");
			}
		}
	}

	function send(f) {

		f.action = "payment.do";
		f.method = "POST";
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
		<div class="menu_title"><i class="fa-solid fa-cart-shopping"></i> 장바구니</div>
		<br>
		<!-- 장바구니담김 -->
		<div class="main text">
			<c:if test="${not empty list}">
				<c:forEach var="vo" items="${list}">
					<form>
						<!-- 현재 시간 가져오기 -->
						<c:set var="now" value="<%=new java.util.Date()%>" />
						<c:set var="hours" value="${now.hours}" />
						<c:set var="minutes" value="${now.minutes}" />
						<c:set var="seconds" value="${now.seconds}" />
						<div class="content-container">
							<div class="content">
								<div>상품번호 : ${vo.p_idx}</div>
								<div style="display: none;">주문번호 :
									${vo.m_idx}_${hours}${minutes}${seconds}</div>
								<input type="hidden" name="c_idx" value="${vo.c_idx}">
								<div>상품명 : ${vo.p_name}</div>
								<div class="order_container">
									<img class="p_img"
										src="${pageContext.request.contextPath}/resources/upload/${vo.p_img}"
										width="200" height="140">
									<div class="order_info">
										<span>총수량 : ${vo.c_count}</span> <br> <span>구매금액 :
											<fmt:formatNumber value="${vo.c_count*vo.p_price}"
												pattern="#,##0" />원
										</span> <br> <span>
											<button type="button" class="cart_delete"
												onclick="cart_delete(this.form)">
												<i class="fa-solid fa-trash-can"></i>삭제
											</button>
										</span> <br>
									</div>
								</div>
							</div>
						</div>

					</form>
				</c:forEach>

				<form>
					<div class="total_price">
						총금액 :
						<fmt:formatNumber value="${total_price}" pattern="#,##0" />
						원
					</div>
					<button type="button" class="payment" onclick="send(this.form)">
						<i class="fa-regular fa-credit-card"></i> 배송지선택 및 결제
					</button>

					<button type="button" class="go_to_shoppinglist"
						onclick="location.href='product_list.do'">
						<i class="fa-solid fa-arrow-rotate-left"></i> 계속 쇼핑하기
					</button>

					<input type="hidden" name="c_idx" value="${list.get(0).c_idx}">
					<input type="hidden" name="total_price" value="${total_price}">

				</form>
			</c:if>
		</div>

		<div class="empty_list">
			<c:if test="${empty list}">
				<!-- 장바구니에 담긴 상품이 없을 때-->
				<div class="empty_cart">장바구니가 비어있습니다.</div>
				<button type="button" class="go_to_shoppinglist"
					onclick="location.href='product_list.do'">
					<i class="fa-solid fa-arrow-rotate-left"></i> 계속 쇼핑하기
				</button>
			</c:if>
		</div>
	</main>
</body>
</html>