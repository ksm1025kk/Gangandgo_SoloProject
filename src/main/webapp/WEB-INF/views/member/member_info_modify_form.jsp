<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개인정보 수정</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/member/member_info_modify_form.css">
<script
	src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="resources/js/httpRequest.js"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://kit.fontawesome.com/99dfd86563.js"
	crossorigin="anonymous"></script>
<script type="text/javascript">
		
			var account = "${account}"

			if (account == '') {
				if (confirm('로그인이 필요한 서비스입니다.')) {
					location.href = "login_form.do";
				} else {
					history.back();
				}
			}
		
			var b_nicknameCheck = true;
			var b_telCheck = true;
			
			function windowopen() {
				window.open("address_info_form.do", "window", "width=500, height=500, left=700, top=250");
			}
			
			function member_info_modify(f){
				var m_pwd = f.m_pwd.value.trim();
				var re_pwd = f.re_pwd.value.trim();
				var m_nickname = f.m_nickname.value.trim();
				var nickname = "${account.m_nickname}"
				var nickname_check_alert = document.getElementById("nickname_check_alert");
				var password_check_alert = document.getElementById("password_check_alert");	
				var re_password_check_alert = document.getElementById("re_password_check_alert");
				//유효성
				
				if(m_nickname == ''){
					alert('닉네임을 입력하세요.');
					nickname_check_alert.innerText = "닉네임을 입력하세요.\n(현재 닉네임 : " + nickname + ")";
					nickname_check_alert.style.color = 'red';
					return;
				}
				if(m_pwd == ''){
					alert('비밀번호를 입력하세요.');
					password_check_alert.innerText = "비밀번호를 입력하세요";
					password_check_alert.style.color = 'red';
					return;
				}
				if(re_pwd == ''){
					alert('비밀번호를 다시 입력하세요.');
					re_password_check_alert.innerText = "비밀번호를 다시 입력하세요.";
					re_password_check_alert.style.color = 'red';
					return;
				}
				
				if(!b_nicknameCheck){
					alert('닉네임이 올바르지 않습니다.');
					return;
				}
				
				if(!b_telCheck){
					alert('전화번호가 올바르지 않습니다.');
					return;
				}
		
				f.action="member_info_modify.do";
				f.method="POST";
				f.submit();
			}
			
			function check_nickname() {
				var m_nickname = document.getElementById("m_nickname").value.trim(); 
				var m_idx = "${account.m_idx}";
				var nickname = "${account.m_nickname}"
				const nicknameRegex = /^[A-Za-z0-9가-힣][A-Za-z0-9가-힣]{1,5}$/;
				var nickname_check_alert = document.getElementById("nickname_check_alert");
				
				if(nickname == m_nickname){
					nickname_check_alert.innerText = "사용가능한 닉네임입니다.";
					nickname_check_alert.style.color = 'blue';
					b_nicknameCheck = true;
					return;
				}
				
				
				if(m_nickname == ""){
					nickname_check_alert.innerText = "닉네임을 입력하세요.";
					nickname_check_alert.style.color = 'red';
					b_nicknameCheck = false;
					return;
				}
				
				
				if(nicknameRegex.test(m_nickname)){
					
					var url = 'check_nickname.do';
					var param = "m_nickname="+encodeURIComponent(m_nickname);
					sendRequest(url, param, resFn, "post");
					
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
					}else{
						nickname_check_alert.innerText = "사용가능한 닉네임입니다.";
						nickname_check_alert.style.color = 'blue';
						b_nicknameCheck = true;
					}	
				}
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
			
			function tel_check(f) {
				var tel_check_alert = document.getElementById("tel_check_alert");
				var m_tel = f.m_tel.value;
				const telRegex = /^\d{10,11}$/;

				if(m_tel == ''){
					b_telCheck = true;
					tel_check_alert.innerText = "";
					tel_check_alert.style.color = 'red';
					return;
				}else{
					if(telRegex.test(m_tel)){
						b_telCheck = true;
						tel_check_alert.innerText = "유효한 전화번호입니다..";
						tel_check_alert.style.color = 'blue';
					}else{
						b_telCheck = false;
						tel_check_alert.innerText = "10~11자리의 숫자만 가능합니다.";
						tel_check_alert.style.color = 'red';
						return;
					}
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
			<input type="hidden" value="${account.m_idx}" name="m_idx"> <input
				type="hidden" value="${account.m_email}" name="m_email">

			<div class="item_title">개인정보 수정</div>
			<div class="item">
				<div class="item_img">
					<i class="fa-regular fa-envelope"></i>
				</div>
				<div class="item_text">${account.m_email}</div>

			</div>
			<div class="item">
				<div class="item_img">
					<i class="fa-regular fa-user"></i>
				</div>
				<div class="item_text">
					<input type="text" class="nickname_text" id="m_nickname"
						name="m_nickname" oninput="check_nickname()"
						value="${account.m_nickname}">
				</div>
			</div>
			<div class="item">
				<div class="item_img"></div>
				<div class="item_text" id="nickname_check_alert"></div>
			</div>
			<div class="item">
				<div class="item_img">
					<i class="fa-solid fa-lock"></i>
				</div>
				<div class="item_text">
					<input type="password" class="pwd_text" id="m_pwd" name="m_pwd"
						oninput="password_check(this.form)" autoComplete="off"
						value="${account.m_pwd}">
				</div>
			</div>
			<div class="item">
				<div class="item_img"></div>
				<div class="item_text" id="password_check_alert"></div>
			</div>
			<div class="item">
				<div class="item_img">
					<i class="fa-solid fa-lock"></i>
				</div>
				<div class="item_text">
					<input type="password" class="repwd_text" id="re_pwd" name="re_pwd"
						oninput="re_password_check(this.form)" autoComplete="off"
						value="${account.m_pwd}">
				</div>
			</div>
			<div class="item">
				<div class="item_img"></div>
				<div class="item_text" id="re_password_check_alert"></div>
			</div>
			<div class="item">
				<div class="item_img">
					<i class="fa-solid fa-phone"></i>
				</div>
				<div class="item_text">
					<input type="text" class="tel_text" name="m_tel" id="m_tel" 
						value="${account.m_tel}" oninput="tel_check(this.form)">
				</div>
			</div>
			<div class="item">
				<div class="item_img"></div>
				<div class="item_text" id="tel_check_alert"></div>
			</div>
			<div class="item_btn">
				<div>
					<button class="address_btn" type="button" onclick="windowopen()">배송지</button>
				</div>
			</div>
			<hr>
			<div class="item_btn">
				<div>
					<button type="button" class="save_btn"
						onclick="member_info_modify(this.form)">저장</button>
				</div>
			</div>
			<div class="item_delete">
				탈퇴를 원하시면 우측의 회원탈퇴 버튼을 눌러주세요.
				<button class="item_delete_btn" type="button"
					onclick="location.href='member_delete_form.do'">회원탈퇴</button>
			</div>
		</form>
	</main>
</body>
</html>