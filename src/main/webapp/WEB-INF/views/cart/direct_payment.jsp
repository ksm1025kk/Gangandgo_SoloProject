<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- 천단위 콤마위한 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품결제</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/cart/address_choice.css">
<script src="https://kit.fontawesome.com/99dfd86563.js" crossorigin="anonymous"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
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


<!-- 현재 시간 가져오기 -->
<c:set var="now" value="<%=new java.util.Date()%>" />
<c:set var="hours" value="${now.hours}" />
<c:set var="minutes" value="${now.minutes}" />
<c:set var="seconds" value="${now.seconds}" />
<script>
	var account = "${account}"

	if(account == ''){
		if(confirm('로그인이 필요한 서비스입니다.')){
			location.href="login_form.do"; 
		}else{
			history.back();
		}
	}	
	
	var buyerAddr = "";

	function kakaopay() {
		var IMP = window.IMP; // 생략 가능
		IMP.init('imp04740052'); // 예: imp00000000

		IMP.request_pay({
			pg : 'kakaopay',
			pay_method : 'card', //생략 가능
			merchant_uid : '${account.m_idx}_${hours}${minutes}${seconds}', // 상점에서 관리하는 주문 번호 //실제로는 결제 건마다 번호가 달라야함★★★
			name : '결제테스트',
			amount : '${cartVO.c_count * cartVO.p_price}', //실제로는 결제 건마다 금액 달라야함★★★
			buyer_email : `${account.m_email}`,
			buyer_name : `${account.m_nickname}`,
			//buyer_tel: '010-1234-5678',
			buyer_addr : buyerAddr /* `${account.m_addr1}` */,
		//buyer_postcode: '123-456',
		}, function(rsp) {
			if (rsp.success) {
				alert("결제가 완료되었습니다.");
				let msg = '결제가 완료되었습니다.\n';
				//msg += '고유ID : ' + rsp.imp_uid;
				//msg += '상점 거래ID : ' + rsp.merchant_uid;
				msg += '주문번호 : ' + rsp.merchant_uid + '\n';
				msg += '결제 금액 : ' + rsp.paid_amount + '\n';
				//msg += '카드 승인번호 : ' + rsp.apply_num;
				var o_addr = document
						.querySelector('input[name="o_addr"]:checked').value;
				location.href = "direct_purchase_complete.do?o_addr=" + o_addr+"&c_idx=${cartVO.c_idx}&c_count=${cartVO.c_count}"; //구매내역 창으로 감 
				/*  if (!alert(msg)) location.href="purchase_detail.do"; ///구매내역으로 이동
				 */} else {
				let msg = '결제에 실패하였습니다.\n';
				msg += '에러내용 : ' + rsp.error_msg;
				alert(msg);

			}
		});
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
		<form>
			<div class="menu_title">배송지 선택 및 결제</div>
			<br>
			<div class="item_box">
			<div class="item">
				<div class="item_img"><i class="fa-regular fa-envelope"></i></div>
				<div class="item_text">${account.m_email}</div>
			</div>
			<div class="item">
				<div class="item_img"><i class="fa-regular fa-user"></i></div>
				<div class="item_text">${account.m_nickname}</div>
			</div>
			<div class="item">
				<div class="item_img"><i class="fa-solid fa-location-dot"></i></div>
				<div class="item_text"><input type="radio" name="o_addr" value="${account.m_addr1}" checked> ${account.m_addr1}</div>
			</div>
			<div class="item">
			<c:if test="${not empty account.m_addr2}">
				<div class="item_img"><i class="fa-solid fa-location-dot"></i></div>
				<div class="item_text"><input type="radio" name="o_addr" value="${account.m_addr2}"> ${account.m_addr2}</div>
			</c:if>
			</div>
			<div class="item">
			<c:if test="${not empty account.m_addr3}">
				<div class="item_img"><i class="fa-solid fa-location-dot"></i></div>
				<div class="item_text"><input type="radio" name="o_addr" value="${account.m_addr3}"> ${account.m_addr3}</div>
			</c:if>
			</div>
			</div>
			
			
			<hr><br>
			
					<div class="content">
					<div>상품번호 : ${cartVO.p_idx}</div>
					<div>총 금액 : <fmt:formatNumber value='${cartVO.c_count * cartVO.p_price}' pattern="#,##0" />원</div>
					</div>

			<br><hr>
			
			
			
			
				<div class = "item_btn">
				<div><input class = "address_modify_btn" type="button" value="배송지수정" onclick="location.href='member_info_modify_form.do'"></div>
				</div>
				<br>
				<div class = "item_btn">
					<div class = "payment"><img src="resources/images/payment_icon2.png" onclick="kakaopay()" style="cursor: pointer;"></div> 				
					<div><input class = "continue" type="button" value="계속 쇼핑하기" onclick="location.href='product_list.do'"></div>
				</div>
		</form>
	</main>
</body>
</html>