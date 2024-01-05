<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품보기</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/product/product_view.css">
<script
	src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/httpRequest.js"></script>
<script src="https://kit.fontawesome.com/a8032e8555.js"
	crossorigin="anonymous"></script>
<script type="text/javascript">
	document.title = "상품 페이지 - ${pvo.p_name}";
	
	window.addEventListener('load', function() {
		var p_amount = "${pvo.p_amount}"
		
	    if (p_amount == 0) {
	        var count = document.getElementById('c_count');
	        var upbutton = document.getElementById('up_button');
	        var downbutton = document.getElementById('down_button');
			
	        count.value = 0;
	        upbutton.disabled = true;
	        downbutton.disabled = true;
	
	        alert("해당 상품은 품절되어 이용하실 수 없습니다.");
	    }
		
		document.addEventListener("click", function(event) {
	        var insert_btn_container = document.getElementById("insert_btn_container");
			
	        // 클릭된 요소가 myDiv 자체이거나 myDiv 내부의 요소인 경우에는 아무 작업도 하지 않음
	        if (event.target === insert_btn_container || insert_btn_container.contains(event.target)) {
	            return;
	        }
	
	        // 클릭된 요소가 myDiv 이외의 다른 요소일 때 myDiv를 숨김
	        pop_up.style.display = "none";
	    });
	});



	function up_count() {
		var count = document.getElementById('c_count');
		var value = parseInt(count.value, 10);
		var downbutton = document.getElementById('down_button');
		var upbutton = document.getElementById('up_button');

		var product_price = document.getElementById('product_price');
		var price = document.getElementById('p_price');
		var price_value = parseInt(price.value, 10);

		var amount = document.getElementById('p_amount');
		var amount_value = parseInt(amount.value, 10);

		value = isNaN(value) ? 0 : value;
		value++;
		if (value === 1) {
			downbutton.disabled = true;
		} else if (value === amount_value) {
			alert("현 재고를 초과하는 수량은 이용하실 수 없습니다. 대량구매는 관리자에게 문의하세요.");
			upbutton.disabled = true;
		} else if(amount_value === 0){
			alert("해당 상품은 품절되어 이용하실 수 없습니다.");
			value=0;
			upbutton.disabled = true;
			downbutton.disabled = true;
		} else {
			upbutton.disabled = false;
			downbutton.disabled = false;
		}
		
		var res = value * price_value;
		count.value = value;
		product_price.innerHTML = addCommas(res) + '원';
	}
	function down_count() {
		var count = document.getElementById('c_count');
		var value = parseInt(count.value, 10);

		var downbutton = document.getElementById('down_button');
		var upbutton = document.getElementById('up_button');

		var product_price = document.getElementById('product_price');
		var price = document.getElementById('p_price');
		var price_value = parseInt(price.value, 10);

		var amount = document.getElementById('p_amount');
		var amount_value = parseInt(amount.value, 10);

		value = isNaN(value) ? 0 : value;
		value--;
		if (value === 1) {
			downbutton.disabled = true;
		} else if (value === amount_value) {
			upbutton.disabled = true;
		} else {
			upbutton.disabled = false;
			downbutton.disabled = false;
		}
	
		var res = value * price_value;
		count.value = value;
		product_price.innerHTML = addCommas(res) + '원';
	}

	
	// 수량을 변경해도 천단위 콤마를 유지하는 함수
	function addCommas(value) {
	    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	
	//바로결제
	function direct_checkout(f) {
		var c_count = document.getElementById("c_count").value;
		if (c_count == 0) {
            alert("해당 상품은 품절되어 이용하실 수 없습니다."); //품절일때 
            return;
        }
		
		f.action = "direct_payment.do";
		f.method = "POST"
		f.submit();
	}

	function send_cart() {
		
		var c_count = document.getElementById("c_count").value;
		if (c_count == 0) {
            alert("해당 상품은 품절되어 이용하실 수 없습니다."); //품절일때 
            return;
        }

		var pop_up = document.getElementById("pop_up");

        
        var displayValue = pop_up.style.display;
		if (displayValue === 'none' || displayValue === '') {
			pop_up.style.display = 'block';
		} 

		
		var p_idx = "${pvo.p_idx}";
		var c_count = document.getElementById("c_count").value;
		var m_idx = "${account.m_idx}";

		var url = "send_cart.do";
		var param = "p_idx=" + encodeURIComponent(p_idx) + "&c_count=" + encodeURIComponent(c_count) + "&m_idx=" + encodeURIComponent(m_idx);		
		sendRequest(url, param, send_cart_result, "POST");
		}
	
		function send_cart_result(){
			if(xhr.readyState==4 && xhr.status==200){
				var data = xhr.responseText;
				var json=(new Function("return"+data))();
				
				if(json[0].result=='yes'){
					return;					
				}else{
					alert("장바구니 담기에 실패했습니다.");
				}
			}
		}
		
		function page1(){
			location.href='product_view.do?nowPage=${paging.startPage - 1}&cntPerPage=${paging.cntPerPage}&p_idx=${pvo.p_idx}';
		}
		
		
		function page2(p){
			location.href='product_view.do?nowPage='+p+'&cntPerPage=${paging.cntPerPage}&p_idx=${pvo.p_idx}';
		}
		
		function page3(){
			location.href='product_view.do?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage}&p_idx=${pvo.p_idx}';
		}
		
		function delete_product(f){
			f.action = "delete_product.do";
			f.method = "POSt";
			f.submit();
		}
	
</script>
</head>
<body>
	<header>
		<nav>
			<img class="logo_img"
				src="${pageContext.request.contextPath}/resources/images/logo.png">
			<img class="hamburger" onclick="hamburger()"
				src="${pageContext.request.contextPath}/resources/images/hamburger.png">
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
						<li class="nickname" id="nickname">${account.m_nickname}님
							<div class="dropdown_content" id="dropdown_content">
								<div
									onclick="location.href='member_view.do?m_idx=${account.m_idx}'">내글보기</div>
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
		<hr>
		<form>
			<div class="p_container">
				<c:if test="${pvo.p_img ne 'no_file'}">
					<img class= "item_img" src="${pageContext.request.contextPath}/resources/upload/${pvo.p_img}">				
				</c:if>
				<div class="product_info">
					<div class="product_name">${pvo.p_name}</div>
					<hr>
					<div class="product_price" id="product_price"><fmt:formatNumber value="${pvo.p_price}" pattern="#,##0"/>원</div>
					<hr>
					<div class="product_amount">재고량 : ${pvo.p_amount}</div>
					<hr>
					<input type="hidden" value="${pvo.p_price}" id="p_price" name="p_price">
					<input type="hidden" value="${pvo.p_idx}" id="p_idx" name="p_idx">
					<input type="hidden" value="${account.m_idx}" id="m_idx" name="m_idx">	
					<input type="hidden" value="${pvo.p_amount}" id="p_amount">

					<div class="item_button">
						<div class="count">
							<input value="1" class="prod_quantity" id="c_count"
								readonly="readonly" name="c_count">
							<div class="count_btn">
								<button type="button" id="up_button" onclick="up_count()">△</button>
								<button type="button" id="down_button" onclick="down_count()"
									disabled="disabled">▽</button>
							</div>
						</div>

						<div class="insert_btn_container" id="insert_btn_container">
							<button type="button" class="insert_cart_button" onclick="send_cart()">
								<i class="fa-solid fa-cart-shopping"></i> 담기
							</button>
							 
							<div class="pop_up" id="pop_up" >
								상품이 장바구니에<br>담겼습니다.
								<div class="pop_up_btn" onclick="location.href='cart_list.do'">장바구니로 이동</div>														 
							</div>
						</div>
					
						<button type="button" class="direct_payment_button" onclick="direct_checkout(this.form)">
						<i class="fa-regular fa-credit-card"></i> 바로구매</button>
						<c:if test="${account.m_auth eq 1}">							
							<input type="button" value="상품삭제" onclick="delete_product(this.form)">
						</c:if>
					</div>
				</div>	
			</div>
			<hr>
				<div class="product_info_text">상품정보 : <br>${pvo.p_info}</div>
			<hr>
		</form>
		<!-- 12/15 수정 -->
		<div class="product_review">
			상품리뷰
		</div>
		<c:forEach var="vo" items="${rv_list}">
			<div class="review_item">
				<div class="review_nickname">
					<i class="fa-regular fa-user"></i>${vo.m_nickname}</div>
				<div class="review_score_date">
					<div class="review_score">
						<c:forEach begin="1" end="${vo.rv_score}">
							<i class="fa-solid fa-star"
								style="color: orange; font-size: 18px;"></i>
						</c:forEach>
					</div>
					<div class="review_date">
						<i class="fa-regular fa-calendar-check"></i>
						${fn:split(vo.rv_postdate,' ')[0]}
					</div>
				</div>
				<c:if test="${vo.rv_img ne 'no_file'}">
					<div>
						<img class="review_img"
							src="${pageContext.request.contextPath}/resources/upload/${vo.rv_img}"
							style="width: 15%; height: 15%;">
					</div>
				</c:if>
				<div class="review_content">${vo.rv_content}</div>
			</div>
		</c:forEach>
		<!-- 페이징 -->
		<div class="paging">
			<c:if test="${paging.startPage != 1}">
				<span onclick="page1()">&lt;</span>
			</c:if>
			<c:forEach begin="${paging.startPage}" end="${paging.endPage}"
				var="p">
				<c:choose>
					<c:when test="${p == paging.nowPage}">
						<b>${p}</b>
					</c:when>
					<c:when test="${p != paging.nowPage}">
						<span onclick="page2(${p})">${p}</span>
					</c:when>
				</c:choose>
			</c:forEach>
			<c:if test="${paging.endPage != paging.lastPage}">
				<span onclick="page3()">&gt;</span>
			</c:if>
		</div>
	</main>
</body>
</html>