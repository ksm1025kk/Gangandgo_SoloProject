<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
	<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/member/member_delete_form.css">
<script type="text/javascript">
	var account = "${account}"

	if(account == ''){
		if(confirm('로그인이 필요한 서비스입니다.')){
			location.href="login_form.do"; 
		}else{
			history.back();
		}
	}

	function member_delete(f) {
		var checkbox = document.getElementById("checkbox");

		if (!checkbox.checked) {
			alert('동의 하시면 체크박스에 체크해주세요.');
			return;
		}

		if (!confirm('정말 탈퇴 하시겠습니까?')) {
			return;
		}

		f.action = "member_delete.do";
		f.method = "post"
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
	<main>
		<form>
			<input type="hidden" value="${account.m_idx}" name="m_idx">
			<div class="delete_title">회원 탈퇴</div>
			<div class="delete_info_item">
				<div class="delete_info">탈퇴를 하시면 모든 닉네임이 UNKWOWN 으로 변하고 모든
					게시물이 비활성화되고 로그아웃 처리 됩니다.
					다만, 관련 법령 및 개인정보 처리방침에 따라 회사가 개인회원 정보를 보유할 수 있는 경우는 보유 목적에 필요한 최소한의 정보를 보관할 수 있습니다.</div>
			</div>
			<div class="check_box">
				<div><input type="checkbox" id="checkbox"><label for="agree">위 내용에 동의합니다.</label></div>
			</div>
			<div class="modify_button">
				<div><button type="button" class="delete_btn" value="저장"onclick="member_delete(this.form)">탈퇴하기</button></div>
			</div>
			<div class="modify_button">
				<div><button type="button" class="back_btn" value="취소" onclick="history.back()">돌아가기</button></div>
			</div>
		</form>
	</main>
</body>
</html>