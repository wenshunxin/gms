<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/header/header.jsp"%>
<title>草原监测信息报送系统</title>
<link href="<%=contextPath %>/resource/css/login.css" rel="stylesheet"
	type="text/css" />
<script type="text/javascript">
function delCookie(name) { //删除cookie
	 setCookie(name, "", -1);  
}
/**
 * 设置cookie
 * @param name  名称
 * @param value 值
 * @param Days  时间
 */
function setCookie(name, value, Days) {
	var exp = new Date();
	exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);//天数
	document.cookie = name + "=" + escape(value) + ";path=/;expires="
			+ exp.toGMTString();
}
function login(){
	var userId=$("#userId").val();
	var password=$("#password").val();
	var url =contextPath+"/userController/doLogin.act";
	var json = tools.requestJsonRs(url,"userId="+userId+"&password="+password);
	if(json.rtState){
		if ($('#checkboxId').is(':checked') == true){
		    setCookie('userId',userId, 15);
		    setCookie("password", password, 15);
		}else {
		    var name=getCookie("userId");
            var password=getCookie("password");
            if(name!=null||password!=null){
            	delCookie("userId");
            	delCookie("password");
            }
	    }
		window.location=("<%=contextPath %>/frame/index.jsp");
	}else{
		$("#tips").html("用户名密码错误！");	
		$("#password").val();
		$("#password").focus();		
	}
}
$(function() {
	var userName=getCookie("userId");
    var password=getCookie("password");
    if (userName!=null && password!=null) {
		$("#userId").val(userName);
		$("#password").val(password);
    }
    $("#userId,#password").keyup(function(){
    	$("#tips").text("");
    });
});
</script>
</head>
<body>
	<img src="<%=contextPath %>/resource/images/login/bgg.jpg" alt="全国草原监测信息报送管理系统" title="全国草原监测信息报送管理系统">
	<div id="containor">
		<form id="form1" name="form1" method="post">
			<div class="inputDiv">
				<div>
					<div class="sysTitle">用户登录</div>
					<div class="item item1">
						<span class="user"></span><b></b> 
						<input type="text"
							onkeydown='if(event.keyCode==13){login();}' class="BigInput"
							id="userId" name="userId" placeholder="请输入用户名" />
					</div>
					<div class="item item2">
						<span class="password"></span><b></b><input type="password"
							placeholder="请输入密码" class="BigInput" id="password"
							onkeydown='if(event.keyCode==13){login();}' name="password" />
					</div>
					<!--请记住密码-->
					<div class="item" style='line-height:36px;color:#fff'>
						<span style="margin-left: 50px;"><input style="vertical-align: middle;" type="checkbox" id="checkboxId" checked="checked"/><label for="checkboxId">记住密码</label></span>
					</div>
					<div class="item" style='height: 36px;line-height: 36px;'>
						<lable id='tips' style="color:red;margin-left: 40px;font-size: 16px;"></lable>
					</div>
					<div class="item">
						<input class="loginBtn" id="loginBtn" type="button" value="登录"
							onclick="login();" onkeydown='if(event.keyCode==13){login();}' />
					</div>
				</div>
			</div>
		</form>
	</div>
	<div class="footer">
		软件开发：北京天创金农科技有限公司 &nbsp;&nbsp;联系电话：010-65001547
	</div>
</body>
</html>
