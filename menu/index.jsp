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
<script src="<%=contextPath %>/menu/menu.js"></script>
<script>
var datagrid;

function doInit(){
	var url = contextPath+"/menuController/getMenuDatagrid.act";
	datagrid = $('#datagrid').treegrid({
		url:url,
		pagination:true,
		singleSelect:true,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		pageSize:100,
		pageList:[20,30,50,100],
		idField:'id',//主键列
		treeField:"name",
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			//{field:'id',checkbox:true,title:'ID',width:10},
			{field:'name',title:'菜单名称',width:200},
			{field:'url',title:'菜单链接',width:200},
			{field:'1',title:'操作',width:300,formatter:function(e,rowData,index){
				return "<a href='javascript:void(0);' onclick='editMenu("+rowData.id+")'>修改</a>&nbsp;&nbsp;&nbsp;&nbsp;<a <a href='javascript:void(0);' onclick='deleteMenu("+rowData.id+")'>删除</a>";
			}}
		]],
		onLoadSuccess:function(){
			var data = datagrid.treegrid("getData");
			if(data.length){
				$(".MessageBox").hide();
			}
		}
	});
}

function addMenu(){
	$.jBox("iframe:menu.jsp", {
		title:"添加菜单",
		top:0,
	    width: 500,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveMenu();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editMenu(id){
	$.jBox("iframe:menu.jsp?id="+id, {
		title:"修改菜单",
		top:0,
	    width: 500,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveMenu();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function deleteMenu(id){
	top.$.jBox.confirm("确定删除该菜单信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/menuController/deleteMenuById.act?id="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				top.$.jBox.tip(json.rtMsg,"success");
				datagrid.treegrid("reload");
				datagrid.treegrid("unselectAll");
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
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">菜单管理</b>
		</div>
		<form id="form1" name="form1" method="post">
			<div style="margin: 10px 10px;" id="searchDiv">
				<input type="button" class="btn btn-success" style="background: #41a675;" onclick="addMenu();"
					value="新建菜单" />
			</div>
		</form>
	</div>
</body>
</html>