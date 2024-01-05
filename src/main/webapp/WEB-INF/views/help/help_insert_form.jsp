<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의작성</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/help/help_insert_form.css">
	<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
	<script src="https://kit.fontawesome.com/a8032e8555.js" crossorigin="anonymous"></script>
	<script type="text/javascript">
		var account = "${account}"
		if(account == ''){
			if(confirm('로그인이 필요한 서비스입니다.')){
				location.href="login_form.do";
			}else{
				history.back();
			}
		}
	
		function send(f) {
			
			
			var h_content = f.h_content.value;
			var h_type= f.h_type.value;
			if(h_type=='none'){
				alert("문의 종류를 선택해주세요")
				return;
			}

			if (h_content == '') {
				alert("문의할 내용을 입력해주세요");
				return;
			}
			f.action="help_insert.do?m_idx=${account.m_idx}&m_auth=${account.m_auth}";
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
			<form method="post">
				<input type="hidden" name="m_idx" value="${account.m_idx}">
				<div class="help_insert_head"><i class="fa-solid fa-headset"></i> 문의하기</div>
				<hr class="hr">
				<div class="explanation">저희 게시판을 이용하시면서 느끼신 불편사항이나 바라는 점을 알려주세요.<br>최대한 빠른시일내에 답변해 드리겠습니다.</div>
				<div class="type_text">
					<select id="h_type" name="h_type">
						<option value="none" selected>문의 종류를 선택해주세요</option>
						<option value="게시판 - 글작성/댓글">게시판 - 글작성/댓글</option>
						<option value="로그인/회원가입/개인정보수정">로그인/회원가입/개인정보수정</option>
						<option value="쇼핑몰">쇼핑몰</option>	
						<option value="장바구니/상품구매">장바구니/상품구매</option>
						<option value="기타">기타</option>
					</select> 
					
					<textarea class="h_content" rows="1" cols="1"  name="h_content" placeholder="문의할 내용을 입력해주세요"></textarea>
					
					<div class="help_insert_buttons">
						<input class="button" type="button" value="문의하기"onclick="send(this.form)">
					</div>
				</div>
				<div class="back_button_div">
				<input class="back_button" type="button" value="돌아가기" onclick="history.back()">
			</div>
			</form>
		</main>
</body>
</html>