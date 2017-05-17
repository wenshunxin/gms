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
<script src="<%=contextPath %>/log/log.js"></script>
<script>
var datagrid;

function doInit(){
	var url = contextPath+"/syslogController/getSyslogDatagrid.act";
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
			{field:'operateUserName',title:'操作人',width:200},
			{field:'operateTime',title:'操作时间',width:200,formatter:function(e,rowData,index){
				return getFormatDateTimeStr(rowData.operateTime,"yyyy-MM-dd HH:ss:mm");
			}},
			{field:'logType',title:'操作类型',width:200,formatter:function(e,rowData,index){
				return parse2SysLogTypeDesc(rowData.logType);
			}},
			{field:'ip',title:'ip地址',width:100},
			{field:'remark',title:'描述',width:200},
			{field:'1',title:'操作',width:300,formatter:function(e,rowData,index){
					return "<a href='javascript:void(0);' onclick='deleteLog("+rowData.id+")'>删除</a>";
			}}
		]]
	});
}
//根据条件查询
function doSearch(){
	  var queryParams=tools.formToJson($("#form1"));
	  datagrid.datagrid('options').queryParams=queryParams; 
	  datagrid.datagrid("reload");
}


function deleteLog(id){
	top.$.jBox.confirm("确定删除该日志信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/syslogController/deleteSyslogById.act?id="+id;
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
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">系统日志</b>
		</div>
		<form id="form1" name="form1" method="post">
			<div style="margin: 10px 0px;" id="searchDiv">
				<!-- <input type="button" class="btn btn-success" onclick="doSearch();" value="查询"/> -->
			</div>
		</form>
	</div>
</body>
</html>