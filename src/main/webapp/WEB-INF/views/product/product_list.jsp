<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/navi.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/product/product_list.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="resources/js/httpRequest.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
<script src="https://kit.fontawesome.com/a8032e8555.js" crossorigin="anonymous"></script>
<script type="text/javascript">

	function product_write() {
		location.href = 'product_insert_form.do';
	}

	function search(f) {
		var keyword = f.keyword.value;

		if (keyword == '') {
			location.href = 'product_list.do';
		} else {

			f.action = "product_search.do";
			f.submit();
		}
	}
	
	function pettypeChange(){
		var p_pettype = document.querySelector('input[name="p_pettype"]:checked').value;
		var	p_category = "사료";
		var	orderby = document.querySelector('input[name="orderby"]:checked').value;
		location.href="product_list.do?p_pettype="+p_pettype+"&p_category="+p_category+"&orderby="+orderby;
	}
	
	
	function radioChange() {
        var p_pettype = document.querySelector('input[name="p_pettype"]:checked').value;
       	var	p_category = document.querySelector('input[name="p_category"]:checked').value;
       	var	orderby = document.querySelector('input[name="orderby"]:checked').value;
        
        location.href="product_list.do?p_pettype="+p_pettype+"&p_category="+p_category+"&orderby="+orderby;  
	}
</script>
<title>쇼핑몰</title>

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
		<div class="radios_pettype">
			<div>
				<input type="radio" id="강아지" class="radio" name="p_pettype"  value="강아지" onclick="pettypeChange()"  <c:if test="${pvo.p_pettype eq '강아지'}">checked</c:if>><label class="label" for="강아지"><i class="fa-solid fa-dog"></i> 강아지</label>
			</div>	
			<div>
				<input type="radio" id="고양이" class="radio" name="p_pettype"  value="고양이"  onclick="pettypeChange()" <c:if test="${pvo.p_pettype eq '고양이'}">checked</c:if>><label class="label" for="고양이"><i class="fa-solid fa-cat"></i> 고양이</label>
			</div>	
		</div>
		<div class="radios_category">
				<!-- 강아지 -->
			<c:if test="${pvo.p_pettype eq '강아지'}">
			<div id="dog_category">
				<div>
					<input type="radio" id="개사료" class="radio" name="p_category"  value="사료" onclick="radioChange()" <c:if test="${pvo.p_category eq '사료'}">checked</c:if>><label class="label_category" for="개사료">사료</label>
				</div>	
				<div>
					<input type="radio" id="배변패드" class="radio" name="p_category"  value="배변패드" onclick="radioChange()"<c:if test="${pvo.p_category eq '배변패드'}">checked</c:if>><label class="label_category" for="배변패드">배변패드</label>
				</div>	
				<div>
					<input type="radio" id="리드줄" class="radio" name="p_category"  value="리드줄" onclick="radioChange()"<c:if test="${pvo.p_category eq '리드줄'}">checked</c:if>><label class="label_category" for="리드줄">리드줄</label>
				</div>	
				<div>
					<input type="radio" id="강아지장난감" class="radio" name="p_category"  value="장난감" onclick="radioChange()"<c:if test="${pvo.p_category eq '장난감'}">checked</c:if>><label class="label_category" for="강아지장난감">장난감</label>
				</div>	
				<div>
					<input type="radio" id="이동가방" class="radio" name="p_category"  value="이동가방" onclick="radioChange()"<c:if test="${pvo.p_category eq '이동가방'}">checked</c:if>><label class="label_category" for="이동가방">이동가방</label>
				</div>	
				<div>
					<input type="radio" id="강아지간식" class="radio" name="p_category"  value="간식" onclick="radioChange()"<c:if test="${pvo.p_category eq '간식'}">checked</c:if>><label class="label_category" for="강아지간식">간식</label>
				</div>	
				<div>
					<input type="radio" id="샤워용품" class="radio" name="p_category"  value="샤워용품" onclick="radioChange()"<c:if test="${pvo.p_category eq '샤워용품'}">checked</c:if>><label class="label_category" for="샤워용품">샤워용품</label>
				</div>
			</div>
			</c:if>
				<!-- 고양이 -->	
			<c:if test="${pvo.p_pettype eq '고양이'}">
				<div id="cat_category">	
					<div>
						<input type="radio" id="고양이사료" class="radio" name="p_category"  value="사료" onclick="radioChange()"<c:if test="${pvo.p_category eq '사료'}">checked</c:if>><label class="label_category" for="고양이사료">사료</label>
					</div>	
					<div>
						<input type="radio" id="캣타워" class="radio" name="p_category"  value="캣타워" onclick="radioChange()"<c:if test="${pvo.p_category eq '캣타워'}">checked</c:if>><label class="label_category" for="캣타워">캣타워</label>
					</div>	
					<div>
						<input type="radio" id="화장실" class="radio" name="p_category"  value="화장실" onclick="radioChange()"<c:if test="${pvo.p_category eq '화장실'}">checked</c:if>><label class="label_category" for="화장실">화장실</label>
					</div>	
					<div>
						<input type="radio" id="모래" class="radio" name="p_category"  value="모래" onclick="radioChange()"<c:if test="${pvo.p_category eq '모래'}">checked</c:if>><label class="label_category" for="모래">모래</label>
					</div>	
					<div>
						<input type="radio" id="고양이장난감" class="radio" name="p_category"  value="장난감" onclick="radioChange()"<c:if test="${pvo.p_category eq '장난감'}">checked</c:if>><label class="label_category" for="고양이장난감">장난감</label>
					</div>	
					<div>
						<input type="radio" id="고양이간식" class="radio" name="p_category"  value="간식" onclick="radioChange()"<c:if test="${pvo.p_category eq '간식'}">checked</c:if>><label class="label_category" for="고양이간식">간식</label>
					</div>
				</div>
			</c:if>	
		</div>
		<hr>
		<div class="orderby_container">
			<div class="radios_orderby">
				<label class="orderby">
					<input type="radio"name="orderby" value="P_SALE_COUNT" onchange="radioChange()"<c:if test="${pvo.orderby eq 'P_SALE_COUNT'}">checked</c:if>> 인기순
				</label> 
				<label class="orderby">
					<input type="radio" name="orderby" value="P_IDX" onchange="radioChange()" <c:if test="${pvo.orderby eq 'P_IDX'}">checked</c:if>> 최신순
				</label> 
				<label class="orderby">
					<input type="radio" name="orderby" value="P_PRICE_ASC" onchange="radioChange()" <c:if test="${pvo.orderby eq 'P_PRICE_ASC'}">checked</c:if>> 가격낮은순
				</label> 
				<label class="orderby">
					<input type="radio" name="orderby" value="P_PRICE" onchange="radioChange()" <c:if test="${pvo.orderby eq 'P_PRICE'}">checked</c:if>> 가격높은순
				</label>
			</div>
			<c:if test="${account.m_auth eq 1}">
				<button type="button" onclick="product_write()" style="cursor: pointer; margin-left: 10px;">상품 추가하기</button>
			</c:if>
		</div>		
		<div id="product_container" class="product_container">
			<c:if test="${empty p_list}">
				<div style="margin-top:50px; color:gray;">
					상품이 존재하지 않습니다.
				</div>
			</c:if>
			<c:forEach var="vo" items="${p_list}">
				<div class="p_container" onclick="location.href='product_view.do?p_idx=${vo.p_idx}'" style="cursor: pointer;">	
					<div class="img_wrapper">
						<img class="p_img" src="${pageContext.request.contextPath}/resources/upload/${vo.p_img}">
					</div>
					<div class="name">${vo.p_name}</div>
					<div class="price"><fmt:formatNumber value="${vo.p_price }" pattern="#,##0" />원</div>
				</div>
			</c:forEach>
		</div>
	</main>	
</body>
</html>