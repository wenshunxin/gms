<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String headId = request.getParameter("investigatorId");
	Integer userLevel = (Integer)request.getSession().getAttribute("userLevel");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="<%=contextPath %>/investigator/investigator.js"></script>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var datagrid;

function doInit(){
	var url = contextPath+"/gmsInvestigatorController/getInvestigatorDatagrid.act?parentId=<%=headId%>";
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
			{field:'xuhao',title:'序号',align:"center",width:30,formatter:function(e,rowData,index){
				return index+1;
			}},
			{field:'investigatorCityFullName',title:'所在省市县',width:200,formatter:function(e,rowData,index){
				var cityJson = getCityFullInfo(rowData.investigatorCityCode);
				var cityDesc ="";
				if(cityJson){
					var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName;
				}
				return cityDesc;
			}},
			{field:'investigatorName',title:'姓名',width:100,align:'center'},
			{field:'investigatorDegree',title:'学历',width:100,align:'center'},
			{field:'investigatorMajor',title:'专业',width:100,align:'center'},
			{field:'investigatorAge',title:'年龄',width:150,align:'center'},
			{field:'1',title:'操作',width:300,align:'center',formatter:function(e,rowData,index){
				if(<%=userLevel%>==1 || <%=userLevel%>==3){
					return "<a href='javascript:void(0);' onclick='editInvestigator("+rowData.sid+")'>修改</a>"
					+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='detailInfo("+rowData.sid+")'>详情</a>"
					+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='deleteInvestigator("+rowData.sid+")'>删除</a>";
				}else{
					return "<a href='javascript:void(0);' onclick='detailInfo("+rowData.sid+")'>详情</a>";
				}
			}}
		]]
	});
}

function addInvestigator(){
	top.$.jBox("iframe:../investigator/investigator.jsp?parentId=<%=headId%>", {
		title:"添加负责人",
		top:10,
	    width: 800,
	    height: 600,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveInvestigator();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editInvestigator(id){
	top.$.jBox("iframe:../investigator/investigator.jsp?id="+id, {
		title:"修改调查人信息",
		top:10,
	    width: 800,
	    height: 600,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveInvestigator();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function detailInfo(id){
	top.$.jBox("iframe:../investigator/detailInfo.jsp?id="+id, {
		title:"查看调查人信息",
		top:10,
	    width: 800,
	    height: 600,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
             if(v==2){
            	return true;
            }
        }

	  });
}

function deleteInvestigator(id){
	top.$.jBox.confirm("确定删除该信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsInvestigatorController/deleteInvestigatorById.act?sid="+id;
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

function goBack(){
	location.href="index.jsp";
}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<b style="color:#41a675;">调查人信息管理</b>
		</div>
		<form id="form1" name="form1" method="post">
			<div style="margin: 10px 10px;" id="searchDiv">
				<input type="button" class="btn btn-success" style="background: #41a675;" onclick="goBack()" value="返回" /> 
				<%if(userLevel==1 || userLevel==3){ %>
				<input type="button" class="btn btn-success" style="background: #41a675;" onclick="addInvestigator();" value="添加调查人" />
				<%} %>
			</div>
		</form>
	</div>
</body>
</html>