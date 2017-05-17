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
<script src="<%=contextPath %>/role/role.js"></script>
<script>
var datagrid;

function doInit(){
	var url = contextPath+"/roleController/getRoleDatagrid.act";
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
			{field:'name',title:'角色名称',width:200},
			{field:'remark',title:'职责描述',width:200},
			{field:'1',title:'操作',width:300,formatter:function(e,rowData,index){
					return "<a href='javascript:void(0);' onclick='setPriv("+rowData.id+")'>权限设置</a>";
			/* 	if(rowData.name=="系统管理员"){
				}else{
					return "<a href='javascript:void(0);' onclick='editRole("+rowData.id+")'>修改</a>"
						+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='deleteRole("+rowData.id+")'>删除</a>"
						+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='setPriv("+rowData.id+")'>权限设置</a>";
					
				} */
			}}
		]]
	});
}

function addRole(){
	$.jBox("iframe:role.jsp", {
		title:"添加角色",
		top:0,
	    width: 500,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveRole();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editRole(id){
	$.jBox("iframe:role.jsp?id="+id, {
		title:"修改角色",
		top:0,
	    width: 500,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveRole();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function setPriv(id){
	$.jBox("iframe:setPriv.jsp?roleId="+id, {
		title:"设置角色权限",
		top:0,
	    width: 400,
	    height: 500,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	setRolePriv();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function deleteRole(id){
	top.$.jBox.confirm("确定删除该角色信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/roleController/deleteRoleById.act?id="+id;
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
function setRolePriv(){
	document.getElementById("jbox-iframe").contentWindow.setPriv();
}

</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">角色管理</b>
		</div>
		<form id="form1" name="form1" method="post">
			<div style="margin: 10px 10px;" id="searchDiv">
				<input type="button" class="btn btn-success" style="background: #41a675;" onclick="addRole();"
					value="新建角色" />
			</div>
		</form>
	</div>
</body>
</html>