<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/board_insert_form.css">
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
		var b_category = f.b_category.value;
		var b_title = f.b_title.value;
		var b_content = f.b_content.value;

		if (b_title == '') {
			alert("제목을 입력해주세요");
			return;
		}

		if (b_content == '') {
			alert("내용을 입력해주세요");
			return;
		}
		
		if(b_category==''){
			alert("카테고리를 선택해주세요");
			return;
		}

		f.action = "board_insert.do";
		f.method = "POST";
		f.submit();
	}
	

    // 파일 추가
    function addFile() {
        const fileDiv = document.createElement('div');
        fileDiv.innerHTML =`
            <div class="file_input">            
                 <input type="file" name="photos" onchange="selectFile(this);" />
                 <button type="button" onclick="removeFile(this);" class="btns del_btn"><span>삭제</span></button>
            </div>
        `;
        document.querySelector('.file_list').appendChild(fileDiv);
    }
    
    
    // 파일 비우기
    function clearFile() {
    	 var firstFile = document.getElementById('firstFile');

         // 파일 입력 필드의 값 지우기
         firstFile.value = '';
    }
    
    
    

    // 파일 삭제
    function removeFile(element) {
        const fileAddBtn = element.nextElementSibling;
        if (fileAddBtn) {
            const inputs = element.previousElementSibling.querySelectorAll('input');
            inputs.forEach(input => input.value = '')
            return false;
        }
        element.parentElement.remove();
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
		<div class="insert_form">
				<div class="board_insert_head">게시글 쓰기</div>
				<hr class="hr">
				<div class="radios">
					<div>
						<input type="radio" id="강아지" class="radio" name="b_category"  value="강아지" onclick=""><label class="label" for="강아지"><i class="fa-solid fa-dog"></i> 강아지</label>
					</div>	
					<div>
						<input type="radio" id="고양이" class="radio" name="b_category"  value="고양이" onclick=""><label class="label" for="고양이"><i class="fa-solid fa-cat"></i> 고양이</label>
					</div>	
					<div>
						<input type="radio" id="기타" class="radio" name="b_category"  value="기타" onclick=""><label class="label" for="기타"><i class="fa-solid fa-guitar"></i> 기타</label>
					</div>	
				</div>
				
				<div class="title_form"><span class="title">제목</span><input class="b_title" name="b_title" placeholder="제목을 입력하세요"></div>
				<div class="textbox" id="textbox">
					<textarea class="b_content" rows="1" cols="1"  name="b_content" placeholder="내용을 입력하세요"></textarea>
				</div>
				<div class="image">
					<i class="fa-regular fa-image"></i>
					<button type="button" onclick="addFile()" class="btns_fn_add_btn"><span style="color:#50bcdf;"><i style="color:#50bcdf;" class="fa-solid fa-plus"></i>파일 추가</span></button>
				</div>
				<div class="file_list">
					
	                <div>
	                    <div class="file_input">                  
	                        <input id="firstFile" class="button"  type="file" name="photos" onchange="selectFile(this)" />
	                   		<button class="button" type="button" onclick="clearFile()" class="btns del_btn"><span>삭제</span></button>      
	                   	</div>            
	                </div>
           	 	</div>
				<div class="board_insert_buttons">
					<input class="button" type="button" value="작성하기" onclick="send(this.form)">
					 <input class="button" type="button" value="돌아가기" onclick="history.back()">
				</div>
		</div>
	</form>
	</main>
</body>
</html>
