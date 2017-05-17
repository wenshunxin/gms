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
function saveRole(){
	if($("#form1").form("validate")){
		var url = contextPath+"/roleController/saveRole.act";
		if(id!="null" && id!=null){
			url = contextPath+"/roleController/updateRole.act";
		}
		var param=tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			top.$.jBox.tip(json.rtMsg,"success");
			parent.datagrid.datagrid("reload");
			parent.$(".jbox-body").remove();
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
function getRoleById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/roleController/getRoleById.act?id="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData);
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
</script>
<body style="overflow: hidden; font-size: 12px; padding: 20px 0;"
	onload="getRoleById();">
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>角色名称：</td>
				<td class='TableData'><input type="text" id='name' name='name'
					autocomplete="off" class='easyui-validatebox BigInput'
					required="true" validType="isBlank[]"/></td>
			</tr>
			<tr>
				<td class='TableData'>父级角色：</td>
				<td class='TableData'><input type="text" id='parent'
					name='parent' class='BigInput readonly' value='0'
					readonly="readonly" /></td>
			</tr>
			<tr>
				<td class='TableData'>描述：</td>
				<td class='TableData'><textarea id='remark' name='remark'
						autocomplete="off" class='BigTextarea'></textarea></td>
			</tr>
		</table>
		<input type='hidden' id='id' name='id' value='<%=id %>' />
	</form>
</body>
</html>