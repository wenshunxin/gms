<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String roleId = request.getParameter("roleId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<%@ include file="/header/ztree.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<script>
var roleId = '<%=roleId%>';
var setting = {
		check: {
			enable: true,
			chkboxType:{ "Y" : "ps", "N" : "ps" }
		},
		data: {
			simpleData: {
				enable: true
			}
		}
	};
 		
function getMenu(){
	var url = contextPath + "/menuController/getMenuZtree.act";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		return json.rtData;
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}

$(document).ready(function(){
	$.fn.zTree.init($("#menuTree"), setting, getMenu());
	getPriv();
});


function setPriv(){
	var checkedIds="";
    var treeObj=$.fn.zTree.getZTreeObj("menuTree");
    nodes=treeObj.getCheckedNodes(true);
    for(var i=0;i<nodes.length;i++){
    	checkedIds+=nodes[i].id + ",";
    }
    var url = contextPath+"/roleController/setRolePriv.act?roleId="+roleId+"&menuIds="+checkedIds;
    var json = tools.requestJsonRs(url);
	if(json.rtState){
		top.$.jBox.tip(json.rtMsg,"success");
		parent.datagrid.datagrid("reload");
		parent.$(".jbox-body").remove();
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}    
}

function getPriv(){
	if(roleId!="null" && roleId!=null){
		var url = contextPath+"/roleController/getRoleById.act?id="+roleId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			 var menuIds = json.rtData.menuIds.split(",")
			 var treeObj=$.fn.zTree.getZTreeObj("menuTree");
			 for(var i=0;i<menuIds.length;i++){
				 treeObj.checkNode(treeObj.getNodeByParam("id",menuIds[i]),true);
			 }
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
</script>
<body style="font-size: 12px; padding: 20px 0;">
	<div class="zTreeDemoBackground left">
		<ul id="menuTree" class="ztree"></ul>
	</div>
</body>
</html>