<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>회원가입</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/member_insert_form.css">
<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="resources/js/httpRequest.js"></script>
<script src="https://kit.fontawesome.com/99dfd86563.js" crossorigin="anonymous"></script>
<script type="text/javascript">
	var b_emailCheck = false;
	var b_nicknameCheck = false;
	var b_email_auth = false;
	
	function send(f) {
		var m_email = f.m_email.value.trim();
		var m_pwd = f.m_pwd.value.trim();
		var re_pwd = f.re_pwd.value.trim();
		 
		if(!b_emailCheck){
			alert('이메일 중복체크를 하세요')
			return;
		}
		if(!b_nicknameCheck){
			alert('닉네임 중복체크를 하세요');
			return;
		}
		if(!b_email_auth){
			alert('이메일 인증을 하세요');
			return;
		}
		
		
		f.action = "member_insert.do";
		f.submit();
	}
	
	function check_email() {
		var email_check_alert = document.getElementById("email_check_alert");
		var secret_tr = document.getElementById("secret_tr");
		var m_email = document.getElementById("m_email").value.trim();
		const emailRegex = /^[A-Za-z0-9]+@gmail\.com$/;

		if(m_email == ''){
			email_check_alert.innerText = '이메일을 입력하세요';
			email_check_alert.style.color = 'red';
			secret_tr.style.display = 'none';
			b_emailCheck = false;
			b_email_auth = false;
			return;
		}
		
		if(emailRegex.test(m_email)){
			
			var url = 'check_email.do';
			var param = "m_email="+encodeURIComponent(m_email);
			
			sendRequest(url,param,resultFn,"POST");
		}else{
			email_check_alert.innerText = '이메일 형식이 맞지 않습니다.';
			email_check_alert.style.color = 'red';
			secret_tr.style.display = 'none';
			b_emailCheck = false;
			b_email_auth = false;
			return;
		}
		
	}
	
	function resultFn() {
		var email_check_alert = document.getElementById("email_check_alert");
		var secret_tr = document.getElementById("secret_tr");
		
		if(xhr.readyState == 4 && xhr.status == 200){
			var data = xhr.responseText;
			var json = (new Function('return'+data))();
			
			if(json[0].res == 'no'){
				email_check_alert.innerText = "이미 사용중인 이메일입니다.";
				email_check_alert.style.color = 'red';
				secret_tr.style.display = 'none';
				b_emailCheck = false;
				return;
			} else {
				email_check_alert.innerText = "사용가능한 이메일입니다.";
				email_check_alert.style.color = 'blue';
				secret_tr.style.display = '';
				b_emailCheck = true;
				b_email_auth = false;
			}
		}
	}
	
	function check_nickname() {
		var nickname_check_alert = document.getElementById("nickname_check_alert");
		var m_nickname = document.getElementById("m_nickname").value.trim();
		const nicknameRegex = /^[A-Za-z0-9가-힣][A-Za-z0-9가-힣]{1,5}$/;

		if(m_nickname == ''){
			nickname_check_alert.innerText = "닉네임을 입력하세요.";
			nickname_check_alert.style.color = 'red';
			b_nicknameCheck = false;
			return;
		}
		if(nicknameRegex.test(m_nickname)){

			var url = 'check_nickname.do';
			var param = "m_nickname="+encodeURIComponent(m_nickname);
		
			sendRequest(url,param,resFn,"POST");
		}else{
			nickname_check_alert.innerText = "2~6글자 사이의 닉네임을 입력하세요.";
			nickname_check_alert.style.color = 'red';
			b_nicknameCheck = false;
			return;
		}
	}
	
	function resFn() {
		var nickname_check_alert = document.getElementById("nickname_check_alert");
		
		if(xhr.readyState == 4 && xhr.status == 200){
			var data = xhr.responseText;
			var json = (new Function('return'+data))();
			
			if(json[0].res == 'no'){
				nickname_check_alert.innerText = "이미 사용중인 닉네임입니다.";
				nickname_check_alert.style.color = 'red';
				b_nicknameCheck = false;
				return;
			} else {
				nickname_check_alert.innerText = "사용가능한 닉네임입니다.";
				nickname_check_alert.style.color = 'blue';
				b_nicknameCheck = true;
			}
		}
	}
	
	function cheee(){
		b_email_auth = false;
	}
	
	function password_check(f) {
		var password_check_alert = document.getElementById("password_check_alert");	
		var m_pwd = f.m_pwd.value;
		const passwordRegex = /^[a-zA-Z\d]{6,}$/;

		if(m_pwd == ''){
			password_check_alert.innerText = "비밀번호를 입력하세요";
			password_check_alert.style.color = 'red';
			return;
		}else{
			if(passwordRegex.test(m_pwd)){
				password_check_alert.innerText = "유효한 비밀번호입니다..";
				password_check_alert.style.color = 'blue';
			}else{
				password_check_alert.innerText = "6글자 이상의 비밀번호를 입력하세요.";
				password_check_alert.style.color = 'red';
				return;
			}
		}
	}
	function re_password_check(f) {
		var password_check_alert = document.getElementById("password_check_alert");
		var re_password_check_alert = document.getElementById("re_password_check_alert");
		
		var m_pwd = f.m_pwd.value;
		var re_pwd = f.re_pwd.value;
		
		if(re_pwd == ''){
			re_password_check_alert.innerText = "비밀번호를 다시 입력하세요.";
			re_password_check_alert.style.color = 'red';
			return;
		}else if(m_pwd != re_pwd){
			re_password_check_alert.innerText = "비밀번호가 다릅니다.";
			re_password_check_alert.style.color = 'red';
			return;	
		}else{
			re_password_check_alert.innerText = "비밀번호가 같습니다.";
			re_password_check_alert.style.color = 'blue';
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
		<div class="item_title">회원가입</div>	
		<div class="item">
			<div class="item_img"><i class="fa-regular fa-envelope"></i></div>
			<div class="item_text"><input type="email" class="email_text" name="m_email" id="m_email" oninput="check_email()" placeholder="이메일"></div>
		</div>
		<div class="item">
			<div class="item_img"></div>
			<div class="item_text" id="email_check_alert"></div>
		</div>
		<div class="item" id="secret_tr" style="display: none">
			<div class="item_img"></div>
			<div class="item_text">
				<input class="mail-check-input" disabled="disabled" oninput="cheee();" placeholder="인증번호">
				<button type="button" id="auth_btn" style="width: 170px;">인증번호 보내기</button>
			</div>
		</div>
		<div class="item">
			<div class="item_img"></div>
			<div class="item_text" id="mail-check-input-info"></div>
		</div>
		<script src="${pageContext.request.contextPath }/resources/js/email_auth.js"></script>
		<div class="item">
			<div class="item_img"><i class="fa-regular fa-user"></i></div>
			<div class="item_text"><input type="text" class="nickname_text" name="m_nickname" id="m_nickname" oninput="check_nickname()" placeholder="닉네임"></div>
		</div>
		<div class="item">
			<div class="item_img"></div>
			<div class="item_text" id="nickname_check_alert"></div>
		</div>
		<div class="item">
			<div class="item_img"><i class="fa-solid fa-lock"></i></div>
			<div class="item_text"><input type="password" class="pwd_text" name="m_pwd" placeholder="비밀번호" oninput="password_check(this.form)"></div>
		</div>
		<div class="item">
			<div class="item_img"></div>
			<div class="item_text" id="password_check_alert"></div>
		</div>
		<div class="item">
			<div class="item_img"><i class="fa-solid fa-lock"></i></div>
			<div class="item_text"><input type="password" class="repwd_text" name="re_pwd" placeholder="비밀번호 확인" oninput="re_password_check(this.form)"></div>
		</div>
		<div class="item">
			<div class="item_img"></div>
			<div class="item_text" id="re_password_check_alert"></div>
		</div>
		<div class="item_btn">
			<div><button type="button" class="reg_btn" onclick="send(this.form)">가입하기</button></div>
		</div>
		
	</form>
	</main>
</body>
</html>