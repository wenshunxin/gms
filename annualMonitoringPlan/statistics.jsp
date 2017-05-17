<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var datagrid;

function doInit(){
	getProvince();
	var province = $("#province").val();
	var queryParams=tools.formToJson($("#form1"));
	queryParams["cityCode"] = province;
	var url = contextPath+"/annualMonitoringPlanController/getAnnualMonitoringStatistics.act";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:false,
		singleSelect:true,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		queryParams:queryParams,
		pageSize:50,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			{field:'provinceName',title:'省份',width:50,align:'center',rowspan:2},
			{title:'盛期地面调查样地（个）',width:80,align:'center',colspan:2},
			{title:'物候调查县(个)',width:100,align:'center',colspan:2},
			{title:'入户调查（户）',width:80,align:'center',colspan:2},
			{title:'固定监测点（个）',width:100,align:'center',colspan:2},
		],
		[
			{field:'sampleAreaNums',title:'计划',width:80,align:'center'},
			{field:'sampleAreaNumsReal',title:'实际',width:100,align:'center'},
			{field:'phenologicalNums',title:'计划',width:80,align:'center'},
			{field:'phenologicalNumsReal',title:'实际',width:100,align:'center'},
			{field:'feedingHouseNums',title:'计划',width:80,align:'center'},
			{field:'feedingHouseNumsReal',title:'实际',width:80,align:'center'},
			{field:'monitoringStationsNums',title:'计划',width:80,align:'center'},
			{field:'monitoringStationsNumsReal',title:'实际',width:100,align:'center'}
		]
		
		]
	});
}

/**
 * 
 *通用查询方法
 * @returns
 */
function doSearch(){
	 var province = $("#province").val();
	 var queryParams=tools.formToJson($("#form1"));
	 queryParams["cityCode"] = province;
	 datagrid.datagrid('options').queryParams=queryParams; 
	 datagrid.datagrid("reload");
}


function exportPlan(){
	 var province = $("#province").val();
	 $("#cityCode").val(province);
	var url = contextPath+"/annualMonitoringPlanController/exportAnnualPlanInfo.act";
	document.form1.action = url;
	document.form1.submit();
	
}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：年度监测计划》<b class="second">监测计划统计</b>
		</div>
		<form id="form1" name="form1" method="post">
			<table class="TableBlock" style="width:100%;margin-bottom:10px;">
				<tr>
					<td class="TableData">年份：</td>
					<td class="TableData">
						<select id="year" name="year" class="BigSelect" style="width:78px;">
							<%
								Calendar cl = Calendar.getInstance();
								int year = cl.get(Calendar.YEAR);
								for(int i = 0 ;i<50;i++){
							%>
							<option value="<%=year-i %>"><%=year-i %></option>
							<%} %>
						</select>
					</td>
					<td class="TableData">省份：</td>
					<td class="TableData">
						<select name="province" id="province"  class="BigSelect">
							<option value="">全部</option>
						</select>
					</td>
					<td class="TableData" style="width:40%;">
						<input type="hidden" id="cityCode" name="cityCode"/>
						<input type='button' class='btn btn-success' style="background: #41a675;" value="查询" onclick='doSearch();'/>
						<input type='button' class='btn btn-success' style="background: #41a675;" value="导出" onclick='exportPlan();'/>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>