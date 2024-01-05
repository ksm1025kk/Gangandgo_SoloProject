<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품추가</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/product/product_insert_form.css">
<script
	src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://kit.fontawesome.com/a8032e8555.js"
	crossorigin="anonymous"></script>
<script type="text/javascript">
	var auth = "${account.m_auth}";
	if(auth == null || auth == 0){
		alert("접근이 불가한 페이지입니다.");
		location.href="home.do";
	}
	
	function send(f) {
		var p_pettype = f.p_pettype.value;
		var dog_category = f.dog_category.value;
		var cat_category = f.cat_category.value;
		
		var p_name = f.p_name.value;
		var p_price = f.p_price.value;
		var p_info = f.p_info.value;
		var p_amount = f.p_amount.value;
		
		if(p_pettype == '강아지' && dog_category ==''){
			alert("카테고리을 입력해주세요");
			return;
		}
		
		if(p_pettype == '고양이' && cat_category ==''){
			alert("카테고리을 입력해주세요");
			return;
		}
		
		if (p_name == '') {
			alert("상품명을 입력해주세요");
			return;
		}
		if (p_price == '') {
			alert("상품 가격을 입력해주세요");
			return;
		}
		if (p_info == '') {
			alert("상품 정보를 입력해주세요");
			return;
		}
		if (p_amount == '') {
			alert("상품 수량을 입력해주세요");
			return;
		}

		f.action = "product_insert.do";
		f.submit();

	}

	function category() {
		var dog_category = document.getElementById("dog_category");
		var cat_category = document.getElementById("cat_category");
		var p_pettype = document.querySelector('input[name="p_pettype"]:checked').value;
		
		if (p_pettype == '강아지') {
			dog_category.style.display = '';
			cat_category.style.display = 'none';
		}
		if (p_pettype == '고양이') {
			cat_category.style.display = '';
			dog_category.style.display = 'none';
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
		<form method="post" enctype="multipart/form-data">
			<div class="insert_form">
				<div class="board_insert_head">상품 등록</div>
				<hr class="hr">
				<div class="radios">
					<div class="dog_pettype">
						<input checked="checked" type="radio" id="강아지" class="radio" name="p_pettype"
							value="강아지" onclick="category()"><label class="label"
							for="강아지"><i class="fa-solid fa-dog"></i> 강아지</label>
					</div>
					<div>
						<input type="radio" id="고양이" class="radio" name="p_pettype"
							value="고양이" onclick="category()"><label class="label"
							for="고양이"><i class="fa-solid fa-cat"></i> 고양이</label>
					</div>
				</div>

				<select class="category" name="dog_category" id="dog_category"> 
					<option value="" selected="selected">카테고리를 선택해주세요</option>
					<option value="사료" id="dog_food">사료</option>
					<option value="배변패드">배변패드</option>
					<option value="리드줄">리드줄</option>
					<option value="장난감">장난감</option> 
					<option value="이동가방">이동가방</option>
					<option value="간식">간식</option>
					<option value="샤워용품">샤워용품</option>	
				</select>
				<select class="category" name="cat_category" id="cat_category" style="display: none;"> 	
					<option value="" selected="selected">카테고리를 선택해주세요</option>
					<option value="사료" id="cat_food">사료</option>
					<option value="캣타워" id="cat_tower">캣타워</option>
					<option value="화장실">화장실</option>
					<option value="모래">모래</option>
					<option value="장난감">장난감</option>
					<option value="이동가방">이동가방</option>
					<option value="간식">간식</option>
					<option value="샤워용품">샤워용품</option>
				</select>



				<div class="title_form">
					<span class="title">제목</span><input class="b_title" name="p_name"
						placeholder="제목을 입력하세요">
				</div>
				<div class="title_form">
					<span class="title">가격</span><input class="b_title" name="p_price"
						placeholder="가격을 입력하세요">
				</div>
				<div class="title_form">
					<span class="title">수량</span><input class="b_title" name="p_amount"
						placeholder="수량을 입력하세요">
				</div>

				<div class="textbox" id="textbox">
					<textarea class="b_content" rows="1" cols="1" name="p_info"
						placeholder="내용을 입력하세요"></textarea>
				</div>
				<!-- <div class="image">
					<i class="fa-regular fa-image"></i>
					<button type="button" onclick="addFile();" class="btns_fn_add_btn"><span style="color:#50bcdf;"><i style="color:#50bcdf;" class="fa-solid fa-plus"></i>파일 추가</span></button>
				</div> -->
				<div class="file_list">
					<div>
						<div class="file_input">
							<input type="file" name="photo" onchange="selectFile(this);" />
							<!-- <button type="button" onclick="removeFile(this);" class="btns del_btn"><span>삭제</span></button>       -->
						</div>
					</div>
				</div>
				<!-- <div class="item">
					<div class="item_img">상품 이미지</div>
					<div class="item_text">
						<input type="file" name="photo">
					</div>
				</div> -->
				<div class="board_insert_buttons">
					<input type="button" value="작성하기" onclick="send(this.form)">
					<input type="button" value="돌아가기"
						onclick="location.href='product_list.do'">
				</div>
			</div>
		</form>
	</main>
</body>
</html>