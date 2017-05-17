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
<script src="<%=contextPath%>/investigation/query/query.js"></script>
</head>
<script>
var userLevel = '<%=userLevel%>';
var userCityCode = '<%=userCityCode%>';
function doInit(){
	getProvince();
	cityPrivSettingForQuery();
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;" onload="doInit();">
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 60%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" colspan="2">常规监测数据下载</td>
			</tr>
			<tr>
				<td class="TableData">年份</td>
				<td class="TableData">
					<select id="year" name="year" class="BigSelect" style='width: 65px;'>
						<option value="">全部</option>
					<%
						Calendar cl = Calendar.getInstance();
						int year = cl.get(Calendar.YEAR);
						for(int i = 0 ;i<50;i++){
					%>
						<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
				</td>
			</tr>
			<tr>
				<td class="TableData">省区</td>
				<td class="TableData">
					<select name="province" id="province" onchange="getCity();" class="BigSelect">
						<option value="">所有</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="TableData">市级</td>
				<td class="TableData">
					 <select name="city" id="city" onchange="getCounty();"class="BigSelect">
						<option value="">所有</option>
					</select> 
				</td>
			</tr>
			<tr>
				<td class="TableData">县(旗)</td>
				<td class="TableData">
					 <select name="county" id="county" class="BigSelect">
						<option value="">所有</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="TableData">数据表</td>
				<td class="TableData">
					<select id="dataType" name="dataType" class="BigSelect">
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
					</select>	
				</td>
			</tr>
			<tr>
				<td class="TableData" colspan="2"  style="text-align:center;">
					<input type="hidden" id="cityCode" name="cityCode"/>
					<input type='button' class="btn btn-success" style="background: #41a675;" value="下载"  onclick='allExportInfo();'/>
					<input type='button' class='btn btn-warning' onclick="doReset();" value="重置"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>