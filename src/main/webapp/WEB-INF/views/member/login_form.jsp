<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/login_form.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"> <!-- 비밀번호눈알모양 -->
<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/httpRequest.js"></script>
<script src="https://kit.fontawesome.com/99dfd86563.js" crossorigin="anonymous"></script>
<script type="text/javascript"> 

	var account = "${account}"

	if (account != '') {
		location.href = document.referrer;
	}
	function login(f) {
		var m_email = f.m_email.value.trim();
		var m_pwd = f.m_pwd.value.trim();

		//유효성 체크 
		if (m_email == "") {
			alert("이메일을 입력해주세요");
			return;
		}

		if (m_pwd == "") {
			alert("비밀번호를 입력해주세요");
			return;
		}

		var url = "login.do";
		var param = "m_email=" + encodeURIComponent(m_email) + "&m_pwd="
				+ encodeURIComponent(m_pwd);

		sendRequest(url, param, LoginCheck, "POST");
	}

	//콜백함수
	function LoginCheck() {
		if (xhr.readyState == 4 && xhr.status == 200) {
			var data = xhr.responseText;
			var json = (new Function("return" + data))();

			if (json[0].param == "no_m_email") {
				alert("이메일이 존재하지 않습니다.");
			} else if (json[0].param == "no_m_pwd") {
				alert("비밀번호가 틀렸습니다..");
			} else {
				alert("로그인성공");
				if (document.referrer == 'http://localhost:10001/gangandgo/member_insert_form.do') {
					location.href = "home.do";
				} else if (document.referrer == 'http://localhost:10001/gangandgo/login_check.do') {
					location.href = "home.do";
				} else {
					location.href = document.referrer;
				}
			}
		}
	}
	
	
	
	/* 비밀번호 눈알모양 */
	 function togglePassword() {
       var input = document.querySelector('input[name="m_pwd"]');
       var icon = document.querySelector('.item_text i');

       input.classList.toggle('active');
       if (input.classList.contains('active')) {
           icon.className = 'fa fa-eye-slash fa-lg';
           input.type = 'text';
       } else {
           icon.className = 'fa fa-eye fa-lg';
           input.type = 'password';
       }
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
			<div class="item_title">로그인</div>
			<div class="item">
				<div class="item_img">
					<i class="fa-regular fa-envelope" style="text-align: center;"></i>
				</div>
				<div class="item_text">
					<input type="email" class="email_text" name="m_email" placeholder="이메일 입력">
				</div>
			</div>
			<div class="item">
				<div class="item_img">
					<i class="fa-solid fa-lock"></i>
				</div>
				<div class="item_text">
					<input type="password" class="pwd_text" name="m_pwd"  placeholder="비밀번호 입력">
					<i class="fa fa-eye fa-lg" onclick="togglePassword()"></i>
				</div>
			</div>
			<div class="item">
				<div class="item_img"></div>
				<div class="item_text_ex">
					<a class="a_tag" href="pwd_modify_form.do">비밀번호 찾기</a>
				</div>
			</div>
			<div class="item_btn">
				<div><button type="button" class="login_btn" onclick="login(this.form)">로그인</button></div>
			</div>
			<hr>
			<div class="item_btn">
				<div><button type="button" class="back_btn" onclick="location.href='member_insert_form.do'">회원가입</button></div>
			</div>
			
		</form>
	</main>
</body>
</html>