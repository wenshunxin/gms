<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String cityCode = (String)request.getSession().getAttribute("cityCode");
	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/ctrl.css" rel="stylesheet" />
<script src="<%=contextPath%>/investigation/investigate.js"></script>
<script src="<%=contextPath%>/investigation/query/query.js"></script>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script>
	var datagrid;
	var cityCode = '<%=cityCode%>';
	var userLevel = '<%=userLevel%>';
	var userCityCode = '<%=userCityCode%>';
	function doInit(){
		var dataType = $("#dataType").val();
		datagrid = $('#datagrid').datagrid();
		addQueryConditon(dataType);
	}

	function exportInfo(){
		var url = contextPath+"/gmsInvestigateDataController/exportData.act";
		document.form2.action= url;
		document.form2.submit();
	}
	
	$(function(){
		$("#imgZhe").click(function(){
			var indexArray = [];
			var selections = $('#datagrid').datagrid('getSelections');
			for(var i=0;i<selections.length;i++){
				var index = $('#datagrid').datagrid('getRowIndex',selections[i]);
				indexArray[i]=index;
			}
			toggle(this);
			setTimeout(function(){
				setValue(indexArray);
			},100);
		});
	});
	function setValue(indexArray){
		for(var i=0;i<indexArray.length;i++){
			$('#datagrid').datagrid('checkRow',indexArray[i]);
		}
	}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：数据查询》<b class="second">常规监测数据</b></b>
		</div>
		<div style="width:100%;height:36px;line-height:36px;background:#f7f7f7;font-weight:bolder;padding-left:10px;">
			筛选条件：
			<select id="dataType" name="dataType" class="BigSelect" onchange="addQueryConditon(this.value)">
				<option value="非工程样地">非工程样地</option>
				<option value="非工程草本样方">非工程草本样方</option>
				<option value="非工程灌木样方">非工程灌木样方</option>
				<option value="工程样地">工程样地</option>
				<option value="工程草本样方">工程草本样方</option>
				<option value="工程灌木样方">工程灌木样方</option>
				<option value="分县补饲调查">分县补饲调查</option>
				<option value="入户补饲调查">入户补饲调查</option>
				<option value="生态环境调查">生态环境调查</option>
				<option value="返青期调查">返青期调查</option>
				<option value="枯黄期调查">枯黄期调查</option>
				<option value="植被长势调查">植被长势调查</option>
				<option value="调查人员">调查人员</option>
			</select>
			<img id="imgZhe" src="<%=contextPath%>/resource/images/sys/down.png" title='展开' alt='展开/收起' style="float:right;cursor: pointer;margin-right: 20px;">
		</div>
		<div id="queryCondition" style="display: none;">
		</div>
		<div style="height:46px;line-height:46px;font-size:18px;">查询结果列表</div>
	</div>
</body>
</html>