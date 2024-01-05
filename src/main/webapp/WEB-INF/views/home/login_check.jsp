<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 체크</title>
<script type="text/javascript">
	var account = "${account}";
	if(account == ''){
		alert("로그인이 필요한 서비스입니다.");
		location.href='login_form.do';
	}else{
		history.back();
	}
</script>
</head>
<body>

</body>
</html>