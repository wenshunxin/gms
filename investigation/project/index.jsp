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
<script>
var datagrid;

function doInit(){
	var url = contextPath+"/gmsProjectController/getProjectDatagrid.act";
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
			{field:'projectName',title:'工程名称',width:100},
			{field:'projectSize',title:'工程面积(公顷)',width:50,align:'center'},
			{field:'projectMeasures',title:'工程措施',width:150,align:'center'},
			{field:'projectInvestment',title:'工程投资(万元)',width:50,align:'center'},
			{field:'projectBuildingDate',title:'工程建设年份(年)',width:50,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				return "<a href='javascript:void(0);' onclick='editProject("+rowData.sid+")'>修改</a>"
						+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='deleteProject("+rowData.sid+")'>删除</a>"
			}}
		]]
	});
}
function addProject(){
	$.jBox("iframe:project.jsp", {
		title:"添加工程",
		top:0,
	    width: 600,
	    height: 500,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	document.getElementById("jbox-iframe").contentWindow.saveProject();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editProject(id){
	$.jBox("iframe:project.jsp?id="+id, {
		title:"修改工程信息",
		top:0,
	    width: 500,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	document.getElementById("jbox-iframe").contentWindow.saveProject();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function deleteProject(id){
	top.$.jBox.confirm("确定删除该信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsProjectController/deleteProjectById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
			}
		}
	});
}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader" style='height: 36px; padding-top: 20px;'>
			<b style="color:#41a675;">当前位置：工程管理</b>
			<div style="float: right;">
				<input type="button" class="btn btn-success" style="background: #41a675;" value="添加工程"
					onclick="addProject()" />
			</div>
		</div>
	</div>
</body>
</html>