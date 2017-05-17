<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<%=contextPath%>/resource/css/upload.css"></link>
<script type="text/javascript"
	src='<%=contextPath %>/resource/js/upload/upload.js'></script>
</head>
<script>
function doInit(){
	getRoleList();
	$(".tempImg").click(function(){
		$(".tempImg").siblings("input").trigger("click");
	})
}
function saveUser(){
	if($("#form1").form("validate") && check()){
		document.form1.action  = contextPath+"/userController/saveUser.act";
		form1.submit();
	} 
}

function getRoleList(){
	var url = contextPath+"/roleController/getRoleDatagrid.act?rows=100&page=1";
	var json = tools.requestJsonRs(url);
	if(json.total>0){
		var html = "";
		for(var i=0;i<json.total;i++){
			var data = json.rows[i];
			html+="<option value='"+data.id+"'>"+data.name+"</option>";
		}
		$("#roleId").html(html);
	}
}

function check(){
	if($("#password").val()!=$("#rePassword").val()){
		top.$.jBox.tip("两次密码不匹配，请重新输入","error");
		$("#password").focus();
		$("#password").val("");
		$("#rePassword").val("");
		return false;
	}
	if($("#avatorFile").val()=="" || $("#avatorFile").val()=="undefined"){
		top.$.jBox.tip("请上传头像！","error");
		return false;
	}
	if($("#area").val()=="" || $("#area").val()=="undefined"){
		top.$.jBox.tip("请选择业务区域！","error");
		$("#area").focus();
		return false;
	}
	
	var url = contextPath+"/userController/isExist.act?phone="+$("#phone").val();
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		if(json.rtData){
			top.$.jBox.tip("手机号已存在，请重新输入！","error");
			$("#phone").val("");
			$("#phone").focus();
			return false;
		}
	}
	return true;
}

</script>
<body style="overflow: hidden; font-size: 12px; padding: 20px 0;"
	onload="doInit()">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>用户名：</td>
				<td class='TableData'><input type='text' id='name' name='name'
					autocomplete="off" class='easyui-validatebox BigInput'
					required="true" /></td>
				<td class="TableData" rowspan='5' width="30%">
					<div class="fileUpload">
						<input size="180" type="file" name="avatorFile" id="avatorFile"
							onchange="upload(this)" />
						<div class="tempImg" title='点击上传图片'>
							<img src="<%=contextPath %>/resource/images/upload/tage.jpg">
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td class='TableData'>性别：</td>
				<td class='TableData'><select id='sex' name='sex'
					class='easyui-validatebox BigSelect' required="true">
						<option value='0'>男</option>
						<option value='1'>女</option>
				</select></td>
			</tr>
			<tr>
				<td class='TableData'>手机号：</td>
				<td class='TableData'><input type='text' id='phone'
					name='phone' autocomplete="off" class='easyui-validatebox BigInput'
					required="true" validType='mobile' /></td>
			</tr>
			<tr>
				<td class='TableData'>业务区域：</td>
				<td class='TableData'><input type='text' id='area' name='area'
					autocomplete="off" class='BigInput' /></td>
			</tr>
			<tr>
				<td class='TableData'>公司名称：</td>
				<td class='TableData'><input type='text' id='companyName'
					name='companyName' autocomplete="off"
					class='easyui-validatebox BigInput' required="true" /></td>
			</tr>
			<tr>
				<td class='TableData'>密码：</td>
				<td class='TableData' colspan='2'><span style='display: none;'><input
						type='password' /></span> <input type='password' id='password'
					name='password' class='easyui-validatebox BigInput' required="true" />
				</td>
			</tr>
			<tr>
				<td class='TableData'>确认密码：</td>
				<td class='TableData' colspan='2'><input type='password'
					id='rePassword' name='rePassword'
					class='easyui-validatebox BigInput' required="true" /></td>
			</tr>
			<tr>
				<td class='TableData'>所属角色：</td>
				<td class='TableData' colspan='2'><select id='roleId'
					name='roleId' class='easyui-validatebox BigSelect'>
				</select></td>
			</tr>

		</table>
	</form>
</body>
</html>