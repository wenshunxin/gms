<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<%@ include file="/header/header.jsp"%>
<title></title>
<script>
function doInit(){
	top.$.jBox.tip("保存成功！","success");
	parent.datagrid.datagrid("reload");
	parent.$(".jbox-body").remove();
}

</script>
</head>

<body onload="doInit()">

	<center>
	<div id="content" style="padding-top: 30px;"></div>
	</center>
</body>
</html>
