<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String cityCode = (String)request.getSession().getAttribute("cityCode");
	Integer userLevel = (Integer)request.getSession().getAttribute("userLevel");
	if(userLevel==0){
		cityCode="000000";
	}
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
	var url = contextPath+"/gmsInvestigatorController/getInvestigatorDatagrid.act?parentId=0&cityCode=<%=cityCode%>";
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
			{field:'investigatorName',title:'负责人姓名',width:100,align:'center'},
			{field:'investigatorDegree',title:'负责人学历',width:100,align:'center'},
			{field:'investigatorMajor',title:'负责人专业',width:100,align:'center'},
			{field:'investigatorAge',title:'负责人年龄',width:150,align:'center'},
			{field:'1',title:'操作',width:200,align:'center',formatter:function(e,rowData,index){
				if(<%=userLevel%>==1 || <%=userLevel%>==3){
					return "<a href='javascript:void(0);' onclick='showInvestigatorInfo("+rowData.sid+")'>查看调查人</a>"
					+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='editInvestigator("+rowData.sid+")'>修改</a>"
					+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='detailInfo("+rowData.sid+")'>详情</a>"
					+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='deleteInvestigator("+rowData.sid+")'>删除</a>";
				}else{
					return "<a href='javascript:void(0);' onclick='showInvestigatorInfo("+rowData.sid+")'>查看调查人</a>"
					+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='detailInfo("+rowData.sid+")'>详情</a>";
				}
			}}
		]]
	});
}

function addInvestigator(){
	top.$.jBox("iframe:../investigator/head.jsp", {
		title:"添加负责人",
		top:10,
	    width: 800,
	    height: 550,
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
	top.$.jBox("iframe:../investigator/head.jsp?id="+id, {
		title:"修改负责人信息",
		top:10,
	    width: 800,
	    height: 550,
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
	top.$.jBox("iframe:../investigator/headInfo.jsp?id="+id, {
		title:"查看负责人信息",
		top:10,
	    width: 600,
	    height: 500,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
             if(v==2){
            	return true;
            }
        }

	  });
}

function deleteInvestigator(id){
	top.$.jBox.confirm("删除负责人的同时会删除该负责人下面的调查人，确定删除吗？","确认",function(v){
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

function showInvestigatorInfo(investigatorId){
	var url = contextPath + "/investigator/investigatorList.jsp?investigatorId=" + investigatorId;
	location.href = url;
}

</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">调查人管理</b>
		</div>
		<form id="form1" name="form1" method="post">
		<% if(userLevel==1 || userLevel == 3){ %>
			<div style="margin: 10px 10px;" id="searchDiv">
				<input type="button" class="btn btn-success" style="background: #41a675;" 
					onclick="addInvestigator();" value="添加负责人" />
			</div>
			<%} %>
		</form>
	</div>
</body>
</html>