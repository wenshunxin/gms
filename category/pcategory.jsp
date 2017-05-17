<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<script>
var id = '<%=id%>';
function doInit(){
	getCategoryById();
	$("#categoryNo").blur(function(){
		checkCategoryNo();
	});
}
function saveCategory(){
	if($("#form1").form("validate") && checkCategoryNo()){
		var url = contextPath+"/gmsSysCategoryController/saveCategory.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsSysCategoryController/updateCategory.act";
		}
		var param=tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			$.jBox.tip(json.rtMsg,"success");
			parent.datagrid.datagrid("reload");
			parent.$(".jbox-body").remove();
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
function getCategoryById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsSysCategoryController/getCategoryById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData);
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
function checkCategoryNo(){
	var parentId = $("#parentId").val();
	var categoryNo = $("#categoryNo").val();
	var sid = $("#sid").val();
	var param = {"parentId":parentId,"categoryNo":categoryNo,"sid":sid};
	var url = contextPath+"/gmsSysCategoryController/checkCategoryNo.act";
	var json = tools.requestJsonRs(url,param);
	if(json.rtState){
		if(json.rtData){
			$.jBox.tip("该编号已存在，请重新输入","info");
			$("#categoryNo").val("");
			$("#categoryNo").focus();
			return false;
		}
	}
	return true;
}
</script>
<body style="overflow: hidden; font-size: 12px; padding: 20px 0;"
	onload="doInit();">
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>分类名称：</td>
				<td class='TableData'><input type='text' id='categoryName'
					name='categoryName' autocomplete="off"
					class='easyui-validatebox BigInput' required="true" /></td>
			</tr>
			<tr>
				<td class='TableData'>分类编码：</td>
				<td class='TableData'><input type='text' id='categoryNo'
					name='categoryNo' autocomplete="off"
					class='easyui-validatebox BigInput' required="true" /></td>
			</tr>
			<tr>
				<td class='TableData'>描述：</td>
				<td class='TableData'><textarea id='remark' name='remark'
						autocomplete="off" class='BigTextarea'></textarea></td>
			</tr>
		</table>
		<input type='hidden' id='parentId' name='parentId' value='0' /> <input
			type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
</body>
</html>