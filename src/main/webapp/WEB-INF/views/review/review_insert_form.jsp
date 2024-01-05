<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/review/review_insert_form.css">
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
		var rv_score = f.rv_score.value;
		var rv_content = f.rv_content.value;
		var m_idx = f.m_idx.value;
		
		if(rv_score == ''){
			alert('평점을 입력하세요.');
			return;
		}
		
		f.action = 'review_insert.do';
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
	<form method="post" enctype="multipart/form-data">
		<input type="hidden" name="m_idx" value="${account.m_idx}">
		<input type="hidden" name="od_idx" value="${odvo.od_idx}">
		
		<div class="insert_form">
				<div class="board_insert_head">리뷰 작성하기</div>
				<hr class="hr">
				
				<div class="item">
					<div class="item_img">
						<img class="img" src="${pageContext.request.contextPath}/resources/upload/${odvo.p_img}">
					</div>
					<div class="item_text">
						<div class="p_name">${odvo.p_name}</div>
						<div class="p_rate">
							<div class="star-rating space-x-4 mx-auto">
								<input type="radio" id="5-stars" name="rv_score" value="5" v-model="ratings"/>
								<label for="5-stars" class="star pr-4">★</label>
								<input type="radio" id="4-stars" name="rv_score" value="4" v-model="ratings"/>
								<label for="4-stars" class="star">★</label>
								<input type="radio" id="3-stars" name="rv_score" value="3" v-model="ratings"/>
								<label for="3-stars" class="star">★</label>
								<input type="radio" id="2-stars" name="rv_score" value="2" v-model="ratings"/>
								<label for="2-stars" class="star">★</label>
								<input type="radio" id="1-star" name="rv_score" value="1" v-model="ratings" />
								<label for="1-star" class="star">★</label>
							</div>
						</div>
					</div>
				</div>
				<hr>
				
				<div class="textbox">
					<textarea class="b_content" rows="1" cols="1"  name="rv_content" placeholder="내용을 입력하세요"></textarea>
				</div>
				<div class="file_list">
	                <div>
	                    <div class="file_input">                  
	                        <input type="file" name="photos" onchange="selectFile(this);" />           
	                   	</div>            
	                </div>
           	 	</div>
				<div class="board_insert_buttons">
					<button type="button" class="btn" onclick="send(this.form)">작성하기</button>
					<button type="button" class="btn" onclick="history.back()">돌아가기</button>
				</div>
		</div>
	</form>
	</main>
</body>
</html>
