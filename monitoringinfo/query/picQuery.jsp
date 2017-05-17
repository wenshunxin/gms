<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%

	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
%>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script src="<%=contextPath %>/monitoringinfo/query/picQuery.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script type="text/javascript">
	var datagrid;
	var userLevel = '<%=userLevel%>';
	var userCityCode = '<%=userCityCode%>';
	getProvince();
	cityPrivSettingForQuery();
	 var province = $("#province").val();
	 var city = $("#city").val();
	 var county = $("#county").val();
	 var cityCode="";
	 if(county!=""){
		cityCode = county;
	 }else if(city!=""){
		cityCode = city;
	 }else if(province!=""){
		cityCode = province;
	 }else{
		cityCode = "000000";
	 }
	 $("#cityCode").val(cityCode);
	var cityCode = $("#cityCode").val();
	var year = $("#endYear").val();
	var month = $("#month").val();
	var date = new Date(year,month,0);
	var dayNums = date.getDate();
	for(var i = 1 ;i<=dayNums;i++){
		$("#day").append("<option value='"+i+"'>"+i+"</option>");
	}
	$("#endYear,#month").change(function(){
		var year = $("#endYear").val();
		var month = $("#month").val();
		var date = new Date(year,month,0);
		var dayNums = date.getDate();
		for(var i = 1 ;i<=dayNums;i++){
			$("#day").append("<option value='"+i+"'>"+i+"</option>");
		}
	});
	getMonitoringStations();
	queryPic();
	$("input[name=queryType]").each(function(){
		$(this).click(function(){
			if($(this).val()==1){
				$("#typeSpan").hide();
			}else{
				$("#typeSpan").show();
			}
		});
	});
	
	$("#province,#city,#county").change(function(){
		 var province = $("#province").val();
		 var city = $("#city").val();
		 var county = $("#county").val();
		 var cityCode="";
		 if(county!=""){
			cityCode = county;
		 }else if(city!=""){
			cityCode = city;
		 }else if(province!=""){
			cityCode = province;
		 }else{
			cityCode = "000000";
		 }
		$("#cityCode").val(cityCode);
		getMonitoringStations();
	});
</script>
	<form id="form1" name="form1" method="post" >
		<table class="TableBlock" width="100%" style="margin:0 auto;border-left:0;border-right:0;">
			<tr>
				<td class="TableData" style="width:15%;">对比类型：</td>
				<td class="TableData" colspan="3">
					<input type="radio" id="queryType1" name="queryType" value="0" checked="checked"/><label for="queryType1">年纪之间对比</label>
					<input type="radio" id="queryType2" name="queryType" value="1" /><label for="queryType2">同年常规辅助对比</label>
					<span id="typeSpan" style="margin-left:100px;">照片所在观测区：
						<select id="observationType" name="observationType" class="BigSelect">
							<option value="常规观测区">常规观测区</option>
							<option value="辅助观测区">辅助观测区</option>
							<option value="永久观测区">永久观测区</option>
							</select>
					</span>
				</td>
			</tr>
			<tr>
				<td class="TableData">监测点所在地：</td>
				<td class="TableData">
					省： <select name="province" id="province" onchange="getCity();" class="BigSelect">
							<option value="">请选择</option>
						</select>
					 市： <select name="city" id="city" onchange="getCounty();"class="BigSelect">
							<option value="">请选择</option>
						</select> 
					县： <select name="county" id="county" class="BigSelect">
							<option value="">请选择</option>
						</select>
				</td>
				<td class="TableData">监测点：</td>
				<td class="TableData">
					<select class='BigSelect' id='monitoringStationsId' name='monitoringStationsId' style="width:180px;">
					</select>
				</td>
			</tr>
			<tr>
				<td class="TableData">对比时间：</td>
				<td class="TableData" colspan='3'>
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
					<%
						for(int i = 1 ;i<=12;i++){
					%>
					<option value="<%=i %>"><%=i %></option>
					<%} %>
					</select>月
					<select id="day" name="day" class="BigSelect" style="width:60px;">
					</select>日 前后
					<select id="dayRange" name="dayRange" class="BigSelect" style="width:60px;">
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
						<option value="6">6</option>
						<option value="7">7</option>
						<option value="8">8</option>
						<option value="9">9</option>
						<option value="10">10</option>
					</select>天
				</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4' align='center'>
					<input type="hidden" id="cityCode" name="cityCode"/>
					<input type='button' class='btn btn-success' style="background: #41a675;" onclick="queryPic();" value="查询"/>
					<input type='button' class='btn btn-warning' onclick="doReset();" value="重置"/>
				</td>
			</tr>
		</table>
		<div id="queryResult" style="width:100%;margin:20px 0 20px 0;height:360px;overflow-y:auto;overflow-x:hidden;padding-bottom:20px;">
		</div>
	</form>
