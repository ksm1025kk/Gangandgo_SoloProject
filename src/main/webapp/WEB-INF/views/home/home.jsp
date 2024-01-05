<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Main Page</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css"> 
		<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
		<script type="text/javascript">
			window.addEventListener('load', function(){
				const show = document.querySelectorAll(".show");
				
				const screenH = window.innerHeight/3*2;
				
				const retVal = ele => ele.getBoundingClientRect().top;
				
				const showTit = x =>{
					let xval = retVal(x);
					if(xval<screenH && xval > 0){
						x.classList.add("on");
					}
				};
				
				window.addEventListener("scroll",()=>{
					for(let x of show) showTit(x);
				});
			});
		</script>
	</head> 
	<body>
		<div class="snowflakes" aria-hidden="true">
		  <div class="snowflake">
		  ❅
		  </div>
		  <div class="snowflake">
		  ❅
		  </div>
		  <div class="snowflake">
		  ❆
		  </div>
		  <div class="snowflake">
		  ❄
		  </div>
		  <div class="snowflake">
		  ❅
		  </div>
		  <div class="snowflake">
		  ❆
		  </div>
		  <div class="snowflake">
		  ❄
		  </div>
		  <div class="snowflake">
		  ❅
		  </div>
		  <div class="snowflake">
		  ❆
		  </div>
		  <div class="snowflake">
		  ❄
		  </div>
		</div>
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
			<img class="main_img1" src="${pageContext.request.contextPath}/resources/images/home_background.png">
			<div id="text1" class="show">
				국내 최대 반려동물 커뮤니티
			</div>
			<img id="main_logo" class="show" src="${pageContext.request.contextPath}/resources/images/logo.png">
			<div class="main_container">
				<img class="main_img2" src="${pageContext.request.contextPath}/resources/images/img2.png">
				<div class="main_btns">
					<span class="main_btns_text">지금 시작하기</span>
					<div id="main_btn" class="show" onclick="location.href='board_list.do'">소통하기</div>
					<div id="main_btn" class="show" onclick="location.href='product_list.do'">구매하기</div>
				</div>
			</div>
		</main>
		<footer>
			<div>
				대충 푸터
			</div>
		</footer>
	</body>
</html>