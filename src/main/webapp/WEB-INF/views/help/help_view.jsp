<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의내용</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/help/help_view.css">
	<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
	<script src="resources/js/httpRequest.js"></script>
	<script src="https://kit.fontawesome.com/a8032e8555.js" crossorigin="anonymous"></script>
	<script type="text/javascript">
	var account = "${account}";
	var m_idx = "${account.m_idx}";
	var m_auth = "${account.m_auth}";
	if(account == ''){
		alert("로그인이 필요한 페이지입니다.");
		location.href="login_form.do";
	}
	
	if(m_auth != 1 && m_idx != "${HelpVO.m_idx}"){
		alert("접근이 불가능한 페이지입니다.");
		location.href="home.do";
	}
	

	function answer_insert(f){
		var a_content = document.getElementById("a_content").value;
		
		if(a_content == ''){
			alert("답변내용을 입력해주세요");
			return;
		}
		
		f.action = "answer_insert.do";
		f.method = "POST";
		f.submit();
	}
	
	
	function answer_delete(f){
		f.action="answer_delete.do";
		f.method = "POST";
		f.submit();
	}

	
	function autoResize(textarea) {
	    textarea.style.height = 'auto';
	    textarea.style.height = (textarea.scrollHeight) + 'px';
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
		<div class="view_form">
			<div class="help_view_head"><i class="fa-solid fa-headset"></i> 문의내용</div>
			
			<hr class="hr">
			
			<div class="h_container">
				<div class="h_info">
					<div class="type">문의종류 : ${HelpVO.h_type}</div>
					<c:if test="${account.m_auth eq 1}">
						<div class="h_writer">작성자 : ${HelpVO.m_nickname}</div>
					</c:if>
				</div>
				<div class="h_content">${HelpVO.h_content}</div>
			</div>
		</div>
			
			<div id="answer_view">
				<c:if test="${HelpVO.h_solved eq 0 and account.m_auth eq 0}">
						<div style="padding:10px 0; color:gray; text-align: center;">
							문의 내용 확인중입니다
						</div>
				</c:if>
				
				<c:if test="${HelpVO.h_solved eq 1}">
				<form>
					<div class="answer_view_wrapper">
						<div class="answer_view_info">	
								관리자 답변
							<span style="float:right;">
								<c:if test="${account.m_auth eq 1}">
									<input type="button" class="answer_delete_button" value="삭제" onclick="answer_delete(this.form)">
									<input type="hidden" name="a_idx" value="${AnswerVO.a_idx}">
									<input type="hidden" name="h_idx" value="${HelpVO.h_idx}">
								</c:if> 
							</span>
						</div>
						<div class="answer_view_content">
							${AnswerVO.a_content}
						</div>
					</div>
				</form>
				</c:if>
				
				<c:if test="${account.m_auth eq 1 and empty AnswerVO}">
				<form>
					<hr>
					<div class="admin">
						<span style="font-size:20px;">관리자 답변하기</span>
						<div class="answer_insert_form">		
							<textarea rows="1" class="answer_insert_content" id="a_content" name="a_content" oninput="autoResize(this)"></textarea>
							<input type="button" class="answer_insert_button" value="답변하기" onclick="answer_insert(this.form)">
							<input type="hidden" name="h_idx" value="${HelpVO.h_idx}">
						</div>
					</div>
				</form>
				</c:if>
			</div>
			<div class="back_button_div">
				<input class="back_button" type="button" value="돌아가기" onclick="history.back()">
			</div>
		</main>
</body>
</html>