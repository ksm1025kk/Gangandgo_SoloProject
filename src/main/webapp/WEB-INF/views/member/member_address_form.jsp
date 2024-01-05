<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://kit.fontawesome.com/99dfd86563.js"
	crossorigin="anonymous"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/member/member_addr_form.css">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script> <!-- 추가 -->
<script type="text/javascript">
	var account = "${account}"

	if(account == ''){
		if(confirm('로그인이 필요한 서비스입니다.')){
			location.href="login_form.do"; 
		}else{
			history.back();
		}
	}

//배송지1 주소 연동 ------------------------------------------------------------------------------------------------------------
function execution_daum_address(){
 
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.
        	// 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
             // 조합된 참고항목을 해당 필드에 넣는다.
                addr += extraAddr;
            
            } else {
            	// 추가해야할 코드
            	document.getElementById("m_addr1_extra").value = '';
            }

            //주소 정보를 해당 필드에 넣는다.
            document.getElementById("m_addr1").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("m_addr1_extra").focus();
         	// 주소찾기 누르면 기존 상세주소 입력란 초기화
            document.getElementById("m_addr1_extra").value = "";
        }
    	
    }).open();   
}

function send(f) {
	
	f.action = "member_addr_modify.do";
	f.method = "post";
	f.submit();
	
}
function del(f) {
	
	f.action = "member_addr_del.do";
	f.method = "post";
	f.submit();
	
}

</script>
<title>배송지</title>
</head>
<body>
	<main>
		<form>
			<input type="hidden" value="${addr_num}" name="addr_num">
			<input type="hidden" value="${account.m_idx}" name="m_idx">
			<div class="title">
				<div>
					<button type="button"
						onclick="location.href='address_info_form.do'">←</button>
				</div>
				<div class="text">배송지 수정</div>
			</div>
			<hr>
			<div class="item">
				<div class="item_img"> 
					<i class="fa-regular fa-envelope"></i>
				</div>
				<div class="item_text">${account.m_email}</div>
			</div>
			<div class="item_addr">
				<div class="item_img_addr">
					<i class="fa-solid fa-lock"></i>
				</div>
				<div class="item_text_addr">
					<div class="addr1" onclick="execution_daum_address()">
						<c:if test="${addr_num eq 1}">
							<input class="addr_search" id="m_addr1" name="m_addr1" type="text" value="${fn:split(account.m_addr1,'/')[0]}" readonly="readonly">
						</c:if>
						<c:if test="${addr_num eq 2}">
							<input class="addr_search" id="m_addr1" name="m_addr2" type="text" value="${fn:split(account.m_addr2,'/')[0]}" readonly="readonly">
						</c:if>
						<c:if test="${addr_num eq 3}">
							<input class="addr_search" id="m_addr1" name="m_addr3" type="text" value="${fn:split(account.m_addr3,'/')[0]}" readonly="readonly">
						</c:if>
					</div>
					<div class="addr1">
						<c:if test="${addr_num eq 1}">
							<input id="m_addr1_extra" name="m_addr1_extra" type="text" value="${fn:split(account.m_addr1,'/')[1]}">
						</c:if>
						<c:if test="${addr_num eq 2}">
							<input id="m_addr1_extra" name="m_addr2_extra" type="text" value="${fn:split(account.m_addr2,'/')[1]}">
						</c:if>
						<c:if test="${addr_num eq 3}">
							<input id="m_addr1_extra" name="m_addr3_extra" type="text" value="${fn:split(account.m_addr3,'/')[1]}">
						</c:if>
					</div>
				</div>
			</div>
			<div class="item_btn">
				<div class="item_save_btn">
					<input type="button" value="저장" onclick="send(this.form)">
				</div>
				<div class="item_delete_btn">
					<input type="button" value="삭제" onclick="del(this.form)">
				</div>
			</div>

		</form>
	</main>
</body>
</html>