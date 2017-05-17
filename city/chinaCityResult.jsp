<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>省（城市）级联显示</title>
<%@ include file="/header/header.jsp"%>
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>

</head>
<body onload="getProvince();">
	省份：
	<select name="province" id="province" onchange="getCity();"
		class="BigSelect easyui-validatebox">
		<option>请选择</option>
	</select> 城市：
	<select name="city" id="city" onchange="getCounty();"
		class="BigSelect easyui-validatebox">
		<option>请选择</option>
	</select> 县：
	<select name="county" id="county" class="BigSelect easyui-validatebox">
		<option>请选择</option>
	</select>


</body>
</html>