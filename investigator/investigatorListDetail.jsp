<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String headId = request.getParameter("investigatorId");
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
		singleSelect:false,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
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
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				return "<a href='javascript:void(0);' onclick='detailInfo("+rowData.sid+")'>详情</a>";
			}}
		]]
	});
}


function detailInfo(id){
	top.$.jBox("iframe:../investigator/detailInfo.jsp?id="+id, {
		title:"查看调查人信息",
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
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<b style="color:#41a675;">调查人信息管理</b>
		</div>
	</div>
</body>
</html>