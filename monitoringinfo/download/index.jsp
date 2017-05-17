<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
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
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/download/download.js"></script>
</head>
<script>
var userLevel = '<%=userLevel%>';
var userCityCode = '<%=userCityCode%>';
function doInit(){
	getProvince();
	cityPrivSettingForQuery();
}
function doReset(){
	document.getElementById("form1").reset(); 
	getProvince();
	cityPrivSettingForQuery();
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;" onload="doInit();">
	<form id="form1" name="form1" method="post" enctype="multipart/form-data">
		<table class='TableBlock' style='width: 60%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" colspan="2">固定监测点信息下载</td>
			</tr>
			<tr>
				<td class="TableData">监测点所在地：</td>
				<td class="TableData">
					省： <select name="province" id="province" onchange="getCity();" class="BigSelect">
							<option value="">全国</option>
						</select>
					 市： <select name="city" id="city" onchange="getCounty();" class="BigSelect">
							<option value="">所有</option>
						</select> 
					县： <select name="county" id="county" class="BigSelect">
							<option value="">所有</option>
						</select>
				</td>
			</tr>
			<tr>
				<td class="TableData">调查类型:</td>
				<td class="TableData">
					<input type="radio" name="observationArea" checked="checked" id="observationArea1" value="0" />
					<label for="observationArea1">草本调查</label>
					<input type="radio" name="observationArea"  id="observationArea2" value="1" />
					<label for="observationArea2">灌木调查</label>
				</td>
			</tr>
			<tr>
				<td class="TableData">调查时间:</td>
				<td class="TableData">
					<select id="startYear" name="startYear" class="BigSelect" style="width:80px;">
					<%
						Calendar cl = Calendar.getInstance();
						int year = cl.get(Calendar.YEAR);
						for(int i = 0 ;i<50;i++){
					%>
					<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
					</select>年 - 
					<select id="endYear" name="endYear" class="BigSelect" style="width:80px;">
					<%
						for(int i = 0 ;i<50;i++){
					%>
					<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
					</select>年  
					<select id="month" name="month" class="BigSelect" style="width:60px;">
					<option value="">所有</option>
					<%
						for(int i = 1 ;i<=12;i++){
					%>
					<option value="<%=i %>"><%=i %></option>
					<%} %>
					</select>月
				</td>
			</tr>
			<tr>
				<td class="TableData">数据表:</td>
				<td class="TableData">
					<select id="stationsType" name="stationsType" class="BigSelect">
						<option value="常规观测区">常规观测区</option>
						<option value="辅助观测区">辅助观测区</option>
						<option value="刈割监测区">刈割监测区</option>
						<option value="火烧管理区">火烧管理区</option>
						<option value="生态状况调查">生态状况调查</option>
						<option value="物候期及降雪观测">物候期及降雪观测</option>
						<option value="经济社会指标">经济社会指标</option>
					</select>	
				</td>
			</tr>
			<tr>
				<td class="TableData" colspan="2"  style="text-align:center;">
					<input type="hidden" id="cityCode" name="cityCode"/>
					<input type='button' class="btn btn-success" style="background: #41a675;" value="下载"  onclick='allExportInfo();'/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>