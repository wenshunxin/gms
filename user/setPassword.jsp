<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript"
	src='<%=contextPath %>/resource/js/jquery/jquery.md5.js'></script>
<script>
var oldPassword='';
function doInit(){
	getUserById();
}
function getUserById(){
	var url = contextPath+"/userController/getUserById.act?id=<%=userId%>";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		bindJsonObj2Cntrl(json.rtData);
		$("#password").val("");
		oldPassword = json.rtData.password;
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}
/**
 * 修改密码
 */
function resetPassword(){
	if($("#form1").form("validate") && check()){
		top.$.jBox.confirm("确定修改密码吗","确认",function(v){
			if(v=="ok"){
				var param=tools.formToJson($("#form1"));
				var url = contextPath+"/userController/resetPassword.act";
				var json = tools.requestJsonRs(url,param);
				if(json.rtState){
					top.$.jBox.tip(json.rtMsg,"success");
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function check(){
	if($.md5($("#oldPassword").val()).toUpperCase()!=oldPassword){
		top.$.jBox.tip("原密码输入错误,请重新输入","error");
		$("#oldPassword").focus();
		$("#oldPassword").val("");
		return false;
	}
	if($("#password").val()!=$("#rePassword").val()){
		top.$.jBox.tip("两次密码不匹配，请重新输入","error");
		$("#password").focus();
		$("#password").val("");
		$("#rePassword").val("");
		return false;
	}
	return true;
}
</script>
</head>
<body style="overflow: hidden; font-size: 12px;" onload="doInit()">
	<div class="moduleHeader">
		<img src='<%=contextPath%>/resource/images/sys/home.png'/><b class="first">当前位置：个人中心》<b class="second">修改密码</b></b>
	</div>
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>用户账号：</td>
				<td class='TableData'><span id='userId' name='userId'></span></td>
			</tr>
			<tr>
				<td class='TableData'>用户名：</td>
				<td class='TableData'><span id='userName' name='userName'></span></td>
			</tr>
			<tr>
				<td class='TableData'>手机号：</td>
				<td class='TableData'><span id='userPhone' name='userPhone'></span></td>
			</tr>
			<tr>
				<td class='TableData'>原密码：</td>
				<td class='TableData'><input type='password' id='oldPassword'
					name='oldPassword' class='BigInput easyui-validatebox'  /></td>
			</tr>
			<tr>
				<td class='TableData'>新密码：</td>
				<td class='TableData'><input type='password' id='password'
					name='password' class='easyui-validatebox BigInput' required='true' /></td>
			</tr>
			<tr>
				<td class='TableData'>确认密码：</td>
				<td class='TableData'><input type='password' id='rePassword'
					name='rePassword' class='easyui-validatebox BigInput'
					required='true' /></td>
			</tr>
			<tr>
				<td class='TableData' colspan='2' align='center'><input
					type='hidden' id='id' name='id' value='<%=userId %>' /> <input
					type='button' class='btn btn-success' style="background: #41a675;" onclick='resetPassword();'
					value='确定' /></td>
			</tr>
		</table>
	</form>
</body>
</html>