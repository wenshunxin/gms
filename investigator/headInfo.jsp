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
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
</head>
<script>
var id = '<%=id%>';
function getInvestigatorById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsInvestigatorController/getInvestigatorById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData);
			var jsonObj = getCityFullInfo(json.rtData.investigatorCityCode);
			if(jsonObj!=null){
				$("#cityFullName").text(jsonObj.provinceFullName+"  "+jsonObj.cityFullName+"  "+jsonObj.countyFullName);
				if(json.rtData.isReport==0){
					$("#isReport").text("是");
				}else{
					$("#isReport").text("否");
					
				}
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
</script>
<body style="overflow-xs: hidden; font-size: 12px; padding: 20px 0;"
	onload="getInvestigatorById();">
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
					<td class="TableHeader" colspan='2' style='text-align:left;'>
						基本信息
					</td>
			</tr>
			<tr>
				<td class='TableData'>年份：</td>
				<td class='TableData'>
					<span id="year"></span>年
				</td>
			</tr>
			<tr>
				<td class='TableData' width="30%">负责人姓名：</td>
				<td class='TableData'><span id='investigatorName'
					name='investigatorName'></span></td>
			</tr>
			<tr>
				<td class='TableData'>民族：</td>
				<td class='TableData'><span id='investigatorNational'
					name='investigatorNational'> </span></td>
			</tr>
			<tr>
				<td class='TableData'>所属城市：</td>
				<td class='TableData'><span id="cityFullName"></span></td>
			</tr>
			<tr>
				<td class='TableData'>年龄：</td>
				<td class='TableData'><span id="investigatorAge"></span></td>
			</tr>
			<tr>
				<td class='TableData'>专业：</td>
				<td class='TableData'><span id="investigatorMajor"
					name="investigatorMajor"></span></td>
			</tr>
			<tr>
				<td class='TableData'>学历：</td>
				<td class='TableData'><span id="investigatorDegree"
					name="investigatorDegree"></span></td>
			</tr>
			<tr>
				<td class='TableData'>单位：</td>
				<td class='TableData'><span id="investigatorCompanyName"
					name="investigatorCompanyName"></span></td>
			</tr>
			<tr>
				<td class='TableData'>手机号：</td>
				<td class='TableData'><span id="investigatorPhone"
					name="investigatorPhone"></span></td>
			</tr>
			<tr>
				<td class='TableData'>座机号：</td>
				<td class='TableData'><span id="investigatorTelphone"
					name="investigatorTelphone"></span></td>
			</tr>
			<tr>
				<td class='TableData'>邮箱：</td>
				<td class='TableData'><span id="investigatorEmail"
					name="investigatorEmail"></span></td>
			</tr>
			<tr>
				<td class="TableHeader" colspan='2' style='text-align:left;'>
					补助信息
				</td>
			</tr>
			<tr>
				<td class='TableData'>农业部补助经费（万）：</td>
				<td class='TableData'><span id="subsidyAmount"></span></td>
			</tr>
			<tr>
				<td class='TableData'>地方配套资金（万）：</td>
				<td class='TableData'><span id="localAssortAmount"></span></td>
			</tr>
			<tr>
				<td class='TableData'>行程（公里）：</td>
				<td class='TableData'><span id="tripAmount"></span></td>
			</tr>
			<tr>
				<td class='TableData'>培训（人次）：</td>
				<td class='TableData'><span id="trainingNums"/></td>
			</tr>
			<tr>
				<td class='TableData'>发布监测报告：</td>
				<td class='TableData'>
					<span id="isReport"></span>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>