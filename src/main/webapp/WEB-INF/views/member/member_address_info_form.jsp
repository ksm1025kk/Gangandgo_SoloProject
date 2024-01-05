<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/member_addr_info_form.css">
<title>배송지</title>
<script type="text/javascript">
	var account = "${account}"

	if(account == ''){
		if(confirm('로그인이 필요한 서비스입니다.')){
			location.href="login_form.do"; 
		}else{
			history.back();
		}
	}

</script>
</head>
<body>
	<div class="title">
		<div>
			<button type="button" onclick="location.href='address_info_form.do'">←</button>
		</div>
		<div class="text">배송지 목록</div>
	</div>
	<hr>
	<div class="addr">
		<div>배송지1</div>
		<hr>
		<div>
			<c:if test="${not empty account.m_addr1}">
				${account.m_addr1}
			</c:if>
			<c:if test="${empty account.m_addr1}">
				입력된 배송지가 없습니다
			</c:if>
		</div>
		<div>
			<input type="button" value="수정"
				onclick="location.href='address_form.do?addr_num=1'">
		</div>
	</div>
	<div class="addr">
		<div>배송지2</div>
		<hr>
		<div>
			<c:if test="${not empty account.m_addr2}">
				${account.m_addr2}
			</c:if>
			<c:if test="${empty account.m_addr2}">
				입력된 배송지가 없습니다
			</c:if>
		</div>
		<div>
			<input type="button" value="수정"
				onclick="location.href='address_form.do?addr_num=2'">
		</div>
	</div>
	<div class="addr">
		<div>배송지3</div>
		<hr>
		<div>
			<c:if test="${not empty account.m_addr3}">
				${account.m_addr3}
			</c:if>
			<c:if test="${empty account.m_addr3}">
				입력된 배송지가 없습니다
			</c:if>
		</div>
		<div>
			<input type="button" value="수정"
				onclick="location.href='address_form.do?addr_num=3'">
		</div>
	</div>
</body>
</html>