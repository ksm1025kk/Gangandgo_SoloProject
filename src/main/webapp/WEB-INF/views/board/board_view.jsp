<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% pageContext.setAttribute("replaceChar", "<br>"); %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>${vo.b_idx}번째 글</title>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navi.css">
		<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/board_view.css">
		<script src="${pageContext.request.contextPath}/resources/js/dropdown_menu.js"></script>
		<script src="resources/js/httpRequest.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
		<script src="https://kit.fontawesome.com/a8032e8555.js" crossorigin="anonymous"></script>
		<script type="text/javascript">
			var status = "${vo.b_status}"
				if(status == 0){
					alert("삭제된 게시글입니다");
					history.back();
				}
			
			function board_update(){
				if(!confirm("글을 수정하시겠습니까?")){
					return;
				}
				
				f.action="board_modify_form.do";
				f.submit();
			}
		
			function board_del(){
				if(!confirm("글을 삭제하시겠습니까?")){
					return;
				} 
				
				f.action="board_delete.do";
				f.submit();
			}
		
			function thumbup(b_idx){
				var m_idx = "${account.m_idx}";
				if(m_idx == ''){
					alert("로그인 필요한 서비스입니다.");
					location.href='login_form.do';
				}
				var url="board_thumbup.do"
				var param="m_idx="+encodeURIComponent(m_idx)+"&b_idx="+encodeURIComponent(b_idx);
				
				sendRequest(url, param, thumbup_result, "post");
			}
		
			function thumbup_result(){
				if(xhr.readyState==4&&xhr.status==200){
					var data = xhr.responseText;
					var json=(new Function("return"+data))();
					
					if(json[0].result=='yes'){
						$("#board_thumbup").load(window.location.href + " #board_thumbup > *");
					} else if(json[0].result=='done'){
						alert("이미 추천한 글입니다.");
					}else if(json[0].result=='needlogin'){
						alert("로그인 필요한 서비스입니다.");
						location.href='login_form.do';
					} else{
						alert("추천에 실패했습니다.");
					}
				}
			}
		
			function reply_del(r_idx, m_idx){
				if(!confirm("댓글을 삭제하시겠습니까?")){
					return;
				}
				
				var url="reply_delete.do";
				var param="r_idx="+encodeURIComponent(r_idx)+"&m_idx="+encodeURIComponent(m_idx);
				
				sendRequest(url,param,reply_delete_result,"post");
			}
		
			function reply_delete_result(){
				if(xhr.readyState==4&&xhr.status==200){
					var data = xhr.responseText;
					var json=(new Function("return"+data))();
					
					if(json[0].result=='yes'){
						$("#reply_view_list").load(window.location.href + " #reply_view_list > *");
					} else {
						alert("댓글 삭제 실패");
					}
				}
			}
		
			function reply_insert(){
				var r_content = document.getElementById("r_content").value;
				var m_idx = "${account.m_idx}";
				var b_idx = "${vo.b_idx}";
				
				document.getElementById("r_content").value = '';
				
				if(r_content == ''){
					alert("내용을 입력해주세요");
					return;
				}
				
				var url="reply_insert.do";
				var param="m_idx="+encodeURIComponent(m_idx)+"&b_idx="+encodeURIComponent(b_idx)+"&r_content="+encodeURIComponent(r_content);
				
				sendRequest(url,param,reply_insert_result,"post");	
			}
		
			function reply_insert_result(){
				if(xhr.readyState==4&&xhr.status==200){
					
					var data = xhr.responseText;
					var json=(new Function("return"+data))();
					
					if(json[0].result=='yes'){
						$("#reply_view_list").load(window.location.href + " #reply_view_list > *");
					}else{
						alert("댓글 작성 실패");
					}
				}
			}
		
			function reply_reply_insert_form(r_idx){
				var form = document.getElementById("reply_reply_insert_form_"+r_idx);
				
				var account="${account}";
				if(account == ''){
					if(confirm('로그인이 필요한 서비스입니다.')){
						location.href='login_form.do';
					}else{
						return;
					}
				}
				
				var displayValue = form.style.display;
				if(displayValue === 'none' || displayValue === ''){
					form.style.display = 'block';
				}else{
					form.style.display = 'none';
				}
			}
		
			function reply_reply_insert(r_idx){
				var r_content = document.getElementById("r_r_content_"+r_idx).value;
				var m_idx = "${account.m_idx}";
				var b_idx = "${vo.b_idx}";
				
				document.getElementById("r_r_content_"+r_idx).value = '';
				
				if(r_content == ''){
					alert("내용을 입력해주세요");
					return;
				}
				
				var url="reply_reply_insert.do";
				var param="m_idx="+encodeURIComponent(m_idx)+"&b_idx="+encodeURIComponent(b_idx)+"&r_content="+encodeURIComponent(r_content)+"&r_parent_idx="+encodeURIComponent(r_idx);
				
				sendRequest(url,param,reply_reply_insert_result,"post");	
			}
		
			function reply_reply_insert_result(){
				if(xhr.readyState==4&&xhr.status==200){
					
					var data = xhr.responseText;
					var json=(new Function("return"+data))();
					
					if(json[0].result=='yes'){
						$("#reply_view_list").load(window.location.href + " #reply_view_list > *");
					}else{
						alert("댓글 작성 실패");
					}
				}
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
			<div class="board_title">
				${vo.b_title}
				<label class="label">
					<c:if test="${vo.b_category eq '강아지'}">
					<i class="fa-solid fa-dog"></i>
					</c:if>
					<c:if test="${vo.b_category eq '고양이'}">
					<i class="fa-solid fa-cat"></i>
					</c:if>
					${vo.b_category}
				</label>
			</div>
			<hr>
			<div class="board_content">
				${vo.b_content}
			</div>
			<c:if test="${not empty img_list}">
				<div class="board_img">
					<c:forEach var="img" items="${img_list}">
					<img src="${pageContext.request.contextPath}/resources/upload/${img.i_img}" style="width:50%; min-width:375px;">
					</c:forEach>
				</div>
			</c:if>
			<div id="board_thumbup">
				<div class="board_thumbup" onclick="thumbup(${vo.b_idx})">
					<i id="thumbup_img" class="fa-regular fa-thumbs-up"></i>
					<div>${vo.b_thumbup}</div>
				</div>
			</div>
			<hr>
			<div class="board_info">
				<i class="fa-regular fa-user"></i>
				<span onclick="location.href='member_view.do?m_idx=${vo.m_idx}'" style="cursor: pointer;"> ${vo.m_nickname}</span> |
				<i class="fa-regular fa-eye"></i> ${vo.b_readhit} |
				<i class="fa-regular fa-calendar-check"></i> ${vo.b_postdate}
			</div>
			<hr>
			<div class="board_to_reply">
				<div style="display:inline-block; font-size: 25px;">댓글</div>
				<div class="board_btns">
					<input type="button" class="board_btn" value="게시판 목록" onclick="location.href='board_list.do'">
					<form name="f" method="post" style="display:inline;">
						<c:if test="${account.m_idx eq vo.m_idx or account.m_auth eq 1}">
							<input type="hidden" name="b_idx" value="${vo.b_idx}">
							<input type="hidden" name="m_idx" value="${vo.m_idx}">
							<input type="button" class="board_btn" value="게시글 수정" onclick="board_update()">
							<input type="button" class="board_btn" value="게시글 삭제" onclick="board_del()">
						</c:if>
					</form>
				</div>
			</div>
			
			<hr>
			<div class="reply_all">
				<div id="reply_view_list">
					<c:if test="${empty reply_list}">
						<div style="margin:30px auto; color:gray; text-align: center;">
							작성된 댓글이 없습니다.
						</div>
					</c:if>
					<c:forEach var="replyVO" items="${reply_list}">
						<c:choose>
							<c:when test="${replyVO.r_status eq 1}">
								<div class="reply_view_wrapper" id="replay_view_wrapper_${replyVO.r_idx}" style="margin-left:${replyVO.r_depth * 30}px;">
									<div class="reply_view_info">
										<c:if test="${replyVO.r_depth ne 0}"> └▶ </c:if>
										
										<span onclick="location.href='member_view.do?m_idx=${replyVO.m_idx}'" style="cursor: pointer;">${replyVO.m_nickname}</span>
										
										<span style="position: absolute; top:3px; right: 7.5px;">
											${replyVO.r_postdate}
											<c:if test="${account.m_idx eq replyVO.m_idx}">
												<input type="button" class="reply_delete_button" value="삭제" onclick="reply_del(${replyVO.r_idx},${replyVO.m_idx})">
											</c:if>
							
											<input type="button" class="reply_reply_button" value="답글 달기" onclick="reply_reply_insert_form(${replyVO.r_idx})">
										</span>
									</div>
									<div class="reply_view_content">
										${replyVO.r_content}
									</div>
								</div>
								<div class="reply_reply_insert_form" id="reply_reply_insert_form_${replyVO.r_idx}" style="margin-left:${replyVO.r_depth * 30}px;">
									<div class="reply_reply_insert_info">
										<span>대댓글 작성</span> | <span>${account.m_nickname}</span>
										<input type="button" class="reply_reply_insert_button" value="대댓글 등록" onclick="reply_reply_insert(${replyVO.r_idx})">
									</div>
									<textarea rows="1" class="reply_reply_insert_content" id="r_r_content_${replyVO.r_idx}" oninput="autoResize(this)"></textarea>
								</div>
							</c:when>
							<c:when test="${replyVO.r_status eq 0}">
								<div class="reply_view_wrapper" id="replay_view_wrapper_${replyVO.r_idx}" style="margin-left:${replyVO.r_depth * 30}px;">
									<div class="reply_view_info">
										<c:if test="${replyVO.r_depth ne 0}"> └▶ </c:if>
										<span style="color:gray;">삭제된 댓글입니다.</span>							
									</div>
									<div class="reply_view_content" style="color:gray;">
										삭제된 댓글입니다.
									</div>
								</div>
							</c:when>
						</c:choose>
					</c:forEach>
					<!-- 페이지 선택 -->
					<div class="paging">		
						<c:if test="${paging.startPage != 1}">
							<span onclick="location.href='board_view.do?nowPage=${paging.startPage - 1}&cntPerPage=${paging.cntPerPage}&b_idx=${param.b_idx}'">&lt;</span>
						</c:if>
						<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="p">
							<c:choose>
								<c:when test="${p == paging.nowPage}">
									<b>${p}</b>
								</c:when>
								<c:when test="${p != paging.nowPage}">
									<span onclick="location.href='board_view.do?nowPage=${p}&cntPerPage=${paging.cntPerPage}&b_idx=${param.b_idx}'">${p}</span>
								</c:when>
							</c:choose>
						</c:forEach>
						<c:if test="${paging.endPage != paging.lastPage}">
							<span onclick="location.href='board_view.do?nowPage=${paging.endPage+1}&cntPerPage=${paging.cntPerPage}&b_idx=${param.b_idx}'">&gt;</span>
						</c:if>
					</div>
				</div>
				
				<c:if test="${not empty account }">
					<div class="reply_insert_form">
						<div class="reply_insert_info">
							<span>댓글 작성</span> | <span>${account.m_nickname}</span>
							<input type="button" class="reply_insert_button" value="댓글 등록" onclick="reply_insert()">
						</div>
						<textarea rows="1" class="reply_insert_content" id="r_content" oninput="autoResize(this)"></textarea>
						
					</div>
				</c:if>
				<c:if test="${empty account }">
					<div style="text-align: center;">
						댓글작성은 <span onclick="location.href='login_form.do'" style="font-weight: bold; font-size: 19px; cursor: pointer;">로그인</span>이 필요한 서비스 입니다
					</div>
				</c:if>
			</div>
		</main>
		<footer style="height: 500px;">
		</footer>
	</body> 
</html>