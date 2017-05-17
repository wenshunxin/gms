<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String id = request.getParameter("id");
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" ></span>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" ></span>
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var id = '<%=id%>';
function doInit(){
	 var stationId = getSocialById();
	 var url = contextPath+"/monitoringStationsController/getMonitoringStationsById.act?sid="+stationId;
	 var json = tools.requestJsonRs(url);
	 if(json.rtState){
		var basicInfo = json.rtData.basicInfo;
		$("#stationsNum").text(basicInfo.stationsNum);
		var cityJson = getCityFullInfo(basicInfo.cityCode);
		
		if(cityJson){
			var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
			$("#stationAddress").text(cityDesc);
		}
	 }else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
}

function getSocialById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsController/getGmsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			return json.rtData.basicInfo.monitoringStationsId;
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

</script>
</head>
<body onload="doInit();" style="overflow:hidden;margin-bottom: 100px; font-size: 12px; margin-top:10px;">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>监测点编号：</td>
				<td class='TableData' colspan="3"><span id="stationsNum"></span></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>
 					<span id="stationAddress"></span>
				</td>
				<td class='TableData'>调查日期：</td>
				<td class='TableData'><span id='investigateDate' name='investigateDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span  id='investigateUserNames'
					name='investigateUserNames' class="BigInput"></span> </td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><span id='mobilePhone'
					name='mobilePhone'></span> </td>
			</tr>
			<tr>
				<td class='TableData'>所在县国土总面积：</td>
				<td class='TableData'><span id='landArea'
					name='landArea' ></span>公顷
				</td>
				<td class='TableData'>所在县草原面积：</td>
				<td class='TableData'><span id='prairieArea'
					name='prairieArea'></span>公顷
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县天然草原面积：</td>
				<td class='TableData'><span id='naturalPrairieArea'
					name='naturalPrairieArea' ></span>公顷
				</td>
				<td class='TableData'>所在县天然草原可利用面积：</td>
				<td class='TableData'><span id='availableNaturalPrairieArea'
					name='availableNaturalPrairieArea' ></span>公顷
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县退化草原面积：</td>
				<td class='TableData'><span id='degradationPrairieArea'
					name='degradationPrairieArea' ></span>公顷
				</td>
				<td class='TableData'>所在县牧户数：</td>
				<td class='TableData'><span id='herdingNums'
					name='herdingNums'></span>户
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县草食牲畜年末存栏量：</td>
				<td class='TableData'><span id='animalAmount'
					name='animalAmount' ></span>头
				</td>
				<td class='TableData'>所在县职工年平均工资：</td>
				<td class='TableData'><span id='workerAvgSalary'
					name='workerAvgSalary' ></span>元
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县农牧民年人均纯收入：</td>
				<td class='TableData' colspan="3"><span id='herdingNetIncome'
					name='herdingNetIncome' ></span>元</td>
			</tr>
		</table>
	</form>
	
</body>
</html>