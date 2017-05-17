<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
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
<script src="<%=contextPath %>/indicators_records/indicatorsRecords.js"></script>
</head>
<script>
var id = '<%=id%>';
var phone="";
$(function(){
	 $("#investigateDate").datetimepicker({
		 language:"zh-CN",   
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 })
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
})

function getIndicatorsRecordsById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/indicatorsRecordsController/getGmsIndicatorsRecordsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var data = json.rtData;
			bindJsonObj2Cntrl(data);
			var jsonObj = getCityFullInfo(data.cityCode);
			if(jsonObj){
				$("#province").text(jsonObj.provinceFullName);
				$("#city").text(jsonObj.cityFullName);
				$("#county").text(jsonObj.countyFullName);
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}


</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getIndicatorsRecordsById()">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left; font-weight:100" colspan="4">详细信息</td>
			</tr>
			<tr>
				<td class='TableData'>监测点编号：</td>
				<td class='TableData' colspan="3"><span id="stationsNum"></span> </td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>
 					<span id='province'></span>省 <span id='city'></span><span id='county'></span></td>
				<td class='TableData'>调查日期：</td>
				<td class='TableData'><span id='investigateDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>指标名：</td>
				<td class='TableData'><span id='indicatorsName'></span> </td>
				<td class='TableData'>指标值：</td>
				<td class='TableData'><span id='indicatorsValue'></span> </td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData' colspan="3"><span id='investigateUserNames'></span> </td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
</body>
</html>