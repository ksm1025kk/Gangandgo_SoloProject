<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의목록</title>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/help/helpdesk.css">
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
	
	function solved_che(){
		var h_solved = document.querySelector('input[name="h_solved"]:checked').value;		
		location.href='helpdesk.do?h_solved='+h_solved;
		
		
	}
	
	
	function page1(){
		var h_solved = document.querySelector('input[name="h_solved"]:checked').value;
		location.href='helpdesk.do?nowPage=${paging.startPage - 1}&cntPerPage=${paging.cntPerPage}&h_solved='+h_solved;
	}
	
	
	function page2(p){
		var h_solved = document.querySelector('input[name="h_solved"]:checked').value;
		location.href='helpdesk.do?nowPage='+p+'&cntPerPage=${paging.cntPerPage}&h_solved='+h_solved;
	}
	
	function page3(){
		var h_solved = document.querySelector('input[name="h_solved"]:checked').value;
		location.href='helpdesk.do?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage}&h_solved='+h_solved;
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
			<div class="h_head">
				<div class="helpdesk_head" >
					<i class="fa-solid fa-headset"></i>
					<c:if test="${account.m_auth eq 1}">모든 문의 내용</c:if>
					<c:if test="${account.m_auth eq 0}">나의 문의 내용</c:if>
				</div>
				<c:if test="${account.m_auth eq 0}">
					<div class="help_button_div">
						<input class="help_button" type="button" value="문의하기" onclick="location.href='help_insert_form.do'">
					</div>
				</c:if>
			</div>
			<hr class="hr">
			<c:if test="${account.m_auth eq 1}">
			<div class="radios">
					<div>
						<input type="radio" id="h_solved_0" class="radio" name="h_solved"  value="0" onclick="solved_che()"
						<c:if test="${paging.h_solved eq 0}">checked</c:if>><label class="label" for="h_solved_0"> 답변미완료</label>
					</div>	
					<div>
						<input type="radio" id="h_solved_1" class="radio" name="h_solved"  value="1" onclick="solved_che()"
						<c:if test="${paging.h_solved eq 1}">checked</c:if>><label class="label" for="h_solved_1"> 답변완료</label>
					</div>	
			</div>
			
			</c:if>
			
			<c:if test="${empty help_list}">
					<div class="empty_list">문의하신 내용이 없습니다.</div>
			</c:if>
			<c:forEach var="vo" items="${help_list}">
				<div class="h_container" onclick="location.href='help_view.do?h_idx=${vo.h_idx}'">	
					<div class="h_type"><b>문의 종류 : </b>${vo.h_type}</div>
					<div class="h_content"><span style="cursor: pointer;"> ${vo.h_content}</span></div>
					<div class="nickname_solved">	
						<c:if test="${account.m_auth eq 1}">						
							<span><b>작성자</b>: ${vo.m_nickname}</span>
						</c:if>
						<div class="h_solved">		
							<c:if test="${vo.h_solved eq 1 }">
								<span style="color:blue;">답변완료</span>
							</c:if>
							<c:if test="${vo.h_solved eq 0 }">
								<span style="color:gray;">문의내용확인중</span>
							</c:if>
						</div>
					</div>	
				</div>
			</c:forEach>
			<!-- 페이지 선택 -->
		<c:if test="${account.m_auth eq 1}">
		<div class="paging">
			<c:if test="${paging.startPage != 1}">
				<span
					onclick="page1()">&lt;</span>
			</c:if>
			<c:forEach begin="${paging.startPage}" end="${paging.endPage}"
				var="p">
				<c:choose>
					<c:when test="${p == paging.nowPage}">
						<b>${p}</b>
					</c:when>
					<c:when test="${p != paging.nowPage}">
						<span
							onclick="page2(${p})">${p}</span>
					</c:when>
				</c:choose>
			</c:forEach>
			<c:if test="${paging.endPage != paging.lastPage}">
				<span
					onclick="page3()">&gt;</span>
			</c:if>
		</div>
		</c:if>
		</main>
</body>
</html>