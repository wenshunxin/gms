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
<script src="<%=contextPath %>/user/user.js"></script>
<script>
var datagrid;

function doInit(){
	var url = contextPath+"/messageController/getPersonalMessages.act";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:true,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'id',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			{field:'id',checkbox:true,title:'ID',width:10},
			{field:'title',title:'标题',width:50},
			{field:'readStatus',title:'状态',width:50,align:"center",formatter:function(e,rowData,index){
				if(rowData.readStatus==1){
					return "已读";
				}else if(rowData.readStatus==0){
					return "未读";
				}
			}},
			{field:'sendTimeDesc',title:'发送时间',width:100},
			{field:'content',title:'内容',width:500},
			{field:'1',title:'操作',width:50,align:"center",formatter:function(e,rowData,index){
				return "<a <a href='javascript:void(0);' onclick='deleteMessage("+rowData.id+")'>删除</a>";
			}}
		]]
	});
}


function deleteMessage(id){
	top.$.jBox.confirm("确定删除该信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/messageController/deleteMessageById.act?id="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				top.$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<b style="color:#41a675;">消息管理</b>
		</div>
	</div>
</body>
</html>