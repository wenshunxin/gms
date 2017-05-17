<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath%>/resource/css/category.css" rel="stylesheet" />
<script src="<%=contextPath %>/category/category.js"></script>
<script>
var datagrid;
function doInit(){
	var url = contextPath+"/gmsSysCategoryController/getParentCategoryList.act";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:true,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'categoryName',title:'分类名称',width:100},
			{field:'categoryNo',title:'分类编号',width:100,},
			{field:'1',title:'操作',width:200,align:'center',formatter:function(e,rowData,index){
				
				return "<a href='javascript:void(0)' onclick='editParentCategory("+rowData.sid+")'>修改</a>" 
				+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='getChildCategory("+rowData.sid+")'>下一级</a>" 
				+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='deleteCategory("+rowData.sid+")'>删除</a>" 
			}}
		]]
	});
	getParentCategory();
}
</script>
</head>
<body onload="doInit();">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader" >
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">编码管理</b>
		</div>
		<form id="form1" name="form1" method="post">
			<div style="margin: 10px 10px;" id="searchDiv">
				<input type="button" class='btn btn-success' style="background: #41a675;" value="添加主分类"
					onclick="addParentCategory();" />
			</div>
		</form>
	</div>
</body>
</html>