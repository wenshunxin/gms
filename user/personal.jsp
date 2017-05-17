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
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
</head>
<script>
function doInit(){
	getUserById();
}
function getUserById(){
	var url = contextPath+"/userController/getUserById.act?id=<%=userId%>";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		bindJsonObj2Cntrl(json.rtData);
		if(json.rtData.sex==0){
			$("#sex").html("男");
		}else if(json.rtData.sex==1){
			$("#sex").html("女");
		}
		if(json.rtData.userLevel==0){
			$("#userLevel").text("部级");
		}else if(json.rtData.userLevel==1){
			$("#userLevel").text("省级");
		}else if(json.rtData.userLevel==2){
			$("#userLevel").text("市级");
		}else if(json.rtData.userLevel==3){
			$("#userLevel").text("县级");
		}
		getRoleName(json.rtData.roleId);
		var jsonObj = getCityFullInfo(json.rtData.cityCode);
		if(jsonObj!=null){
			var cityFullName="";
			if(jsonObj.provinceFullName){
				cityFullName +=jsonObj.provinceFullName;
			}
			if(jsonObj.cityFullName){
				cityFullName +="  "+jsonObj.cityFullName;
			}
			if(jsonObj.countyFullName){
				cityFullName +="  "+jsonObj.countyFullName;
			}
			$("#cityFullName").text(cityFullName);
		}
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}
function getRoleName(id){
	var url = contextPath+"/roleController/getRoleById.act?id="+id;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		$("#roleName").html(json.rtData.name);
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}
</script>
<body style="overflow: hidden; font-size: 12px;" onload="doInit()">
	<div class="moduleHeader">
		<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：个人中心》<b class="second">我的资料</b></b>
	</div>
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class='TableData' style="width: 20%;">用户账号：</td>
				<td class='TableData'><span id='userId' name='userId'></span></td>
			</tr>
			<tr>
				<td class='TableData'>用户名：</td>
				<td class='TableData'><span id='userName' name='userName'></span></td>
			</tr>
			<tr>
				<td class='TableData'>用户级别：</td>
				<td class='TableData'><span id="userLevel" name="userLevel">
				</span></td>
			</tr>
			<tr>
				<td class='TableData'>所属城市：</td>
				<td class='TableData'><span id="cityFullName"></span></td>
			</tr>
			<tr>
				<td class='TableData'>性别：</td>
				<td class='TableData'><span id='sex' name='sex'></span></td>
			</tr>
			<tr>
				<td class='TableData'>手机号：</td>
				<td class='TableData'><span id='userPhone' name='userPhone'></span></td>
			</tr>
			<tr>
				<td class='TableData'>座机号：</td>
				<td class='TableData'><span id='userTelephone'
					name='userTelephone'></span></td>
			</tr>
			<tr>
				<td class='TableData'>单位名称：</td>
				<td class='TableData'><span id='companyName' name='companyName'></span></td>
			</tr>
			<tr>
				<td class='TableData'>用户邮箱：</td>
				<td class='TableData'><span id='userEmail' name='userEmail'></span></td>
			</tr>
			<tr>
				<td class='TableData'>所属角色：</td>
				<td class='TableData' colspan='2'><span id="roleName"
					name="roleName"></span></td>
			</tr>

		</table>
	</form>
</body>
</html>