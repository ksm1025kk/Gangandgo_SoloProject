<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 재입력</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/member/pwd_reenter_form.css">
<script
	src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://kit.fontawesome.com/99dfd86563.js" crossorigin="anonymous"></script>
<script type="text/javascript">

	var account = "${account}"

	if (account == '') {
		if (confirm('로그인이 필요한 서비스입니다.')) {
			location.href = "login_form.do";
		} else {
			history.back();
		}
	}

	function pwd_check(f) {

		var password = f.m_pwd.value;
		var account_pwd = f.account_pwd.value;

		if (password == '') {
			alert('비밀번호를 입력하세요');

			return;
		}
		if (password != account_pwd) {
			alert('비밀번호가 일치하지 않습니다.');
			return;
		}

		location.href = "member_info_modify_form.do";
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
		<form>
			<input type="hidden" value="${account.m_idx}" name="m_idx">
			<input type="hidden" value="${account.m_email}" name="m_email">
			<input type="hidden" value="${account.m_pwd}" name="account_pwd">
			
			<div class="item_title">비밀번호 확인</div>
			<div class="item">
				<div class="item_img"><i class="fa-regular fa-envelope"></i></div>
				<div class="item_text">
					<input type="text" class="email_text" value="${account.m_email}" disabled="disabled">
				</div>
			</div>
			
			<div class="item">
				<div class="item_img"><i class="fa-solid fa-lock"></i></div>
				<div class="item_text">
					<input type="password" class="pwd_text" id="m_pwd" name="m_pwd" placeholder="비밀번호">
				</div>
			</div>
			<div class="item_btn">
				<div><button type="button" class="enter_btn" value="확인" onclick="pwd_check(this.form)">확인</button></div>	 
			</div>
		</form>
	</main>
</body>
</html>