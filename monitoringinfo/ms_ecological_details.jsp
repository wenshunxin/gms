<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String id = request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var id = '<%= id %>';
function doInit(){
	 if(parent.document.getElementById("monitoringStationsId")){
		 var stationId = parent.document.getElementById("monitoringStationsId").value;
		 if(stationId==""){
			 return;
		 }
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
	 findById();
}

function findById(){
	 if(id!="null" && id!=null){
			var url = contextPath+"/gmeController/getGmeById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				//基本信息
				var basicInfo = json.rtData.basicInfo;
				bindJsonObj2Cntrl(basicInfo);
				var cityJson = getCityFullInfo(basicInfo.cityCode);
				if(cityJson){
					var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
					$("#stationAddress").text(cityDesc);
				}
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
}


</script>
</head>
<body onload="doInit();" style="overflow-y:scroll;margin-bottom:100px; margin-top:10px;font-size: 12px">
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
				<td class='TableData'>
				<span id="investigateDate"></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'>
				<span id="investigateUserNames"></span>
				</td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><span id="contactPhone"></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>枯落物重量：</td>
				<td class='TableData'><span id="litterAmount"></span>(克/平方米)
				</td>
				<td class='TableData'>辅助区利用方式：</td>
				<td class='TableData'><span id="auxiliaryUsingType"></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>辅助区利用状况：</td>
				<td class='TableData'><span id="auxiliaryUsingStatus"></span>
				</td>
				<td class='TableData'>土壤容重：</td>
				<td class='TableData'><span id="soilWeight"></span>(克/立方厘米)
				</td>
			</tr>
			<tr>
				<td class='TableData'>土壤含盐量：</td>
				<td class='TableData'><span id="soilSalt"></span>(%)
				</td>
					<td class='TableData'>土壤PH：</td>
				<td class='TableData'><span id="soilPh"></span></td>
			</tr>
			<tr>
					<td class='TableData'>土壤有机质含量：</td>
				<td class='TableData'><span id="soilOrganic"></span>(%) </td>
					<td class='TableData'>土壤全氮含量：</td>
				<td class='TableData'><span id="soilNitrogen"></span>(克)
				</td>
			</tr>
			<tr>
					<td class='TableData'>植物种数参考值：</td>
				<td class='TableData'><span id="plantAmount"></span></td>
					<td class='TableData'>主要植物种名称：</td>
				<td class='TableData'><span id="mainPlants"></span>
				 </td>
			</tr>
			<tr>
				<td class="TableHeader" style='text-align:left;' colspan="4">物种一</td>
			</tr>
			<tr>
				<td class='TableData'>盖度百分比：</td>
				<td class='TableData'><span id="firstPlantCoverage"></span>(%) </td>
				<td class='TableData'>重量百分比：</td>
				<td class='TableData'><span id="firstPlantWeight"></span>(%) </td>
			</tr>
			<tr>
				<td class='TableData'>算数优势度：</td>
				<td class='TableData'><span id="firstPlantAdvantage"></span>(%) </td>
					<td class='TableData'>物种名称：</td>
				<td class='TableData'><span id="firstPlantName"></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style='text-align:left;' colspan="4">物种二</td>
			</tr>
			<tr>
				<td class='TableData'>盖度百分比：</td>
				<td class='TableData'><span id="secondPlantCoverage"></span>(%) </td>
				<td class='TableData'>重量百分比：</td>
				<td class='TableData'><span id="secondPlantWeight"></span>(%) </td>
			</tr>
			<tr>
				<td class='TableData'>算数优势度：</td>
				<td class='TableData'><span id="secondPlantAdvantage"></span>(%) </td>
					<td class='TableData'>物种名称：</td>
				<td class='TableData'><span id="secondPlantName"></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style='text-align:left;' colspan="4">物种三</td>
			</tr>
			<tr>
				<td class='TableData'>盖度百分比：</td>
				<td class='TableData'><span id="thirdPlantCoverage"></span>(%) </td>
				<td class='TableData'>重量百分比：</td>
				<td class='TableData'><span id="thirdPlantWeight"></span>(%) </td>
			</tr>
			<tr>
				<td class='TableData'>算数优势度：</td>
				<td class='TableData'><span id="thirdPlantAdvantage"></span>(%) </td>
					<td class='TableData'>物种名称：</td>
				<td class='TableData'><span id="thirdPlantName"></span></td>
			</tr>
		</table>
	
</body>
</html>