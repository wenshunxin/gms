<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
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
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<style>
	i{
		color:red;
		font-weight: 900;
	}
</style>
</head>
<script>
var id = '<%=id%>';
var userLevel = '<%=userLevel%>';
var userCityCode = '<%=userCityCode%>';
function saveInvestigator(){
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsInvestigatorController/saveInvestigator.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsInvestigatorController/updateInvestigator.act";
		}
		var param=tools.formToJson($("#form1"));
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
		param["investigatorCityCode"] = cityCode;
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			top.$.jBox.tip(json.rtMsg,"success");
			top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
			top.$(".jbox-body").remove();
		}else{
			top.$.jBox.tip("系统异常！","error");
		}
	}
}
function getInvestigatorById(){
	getProvince();
	cityPrivSettingForQuery();
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsInvestigatorController/getInvestigatorById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData);
			var jsonObj = getCityFullInfo(json.rtData.investigatorCityCode);
			if(jsonObj){
				$("#province").val(jsonObj.provinceCode);
				if(jsonObj.provinceCode){
					getCity();
					$("#city").val(jsonObj.cityCode);
				}
				if(jsonObj.cityCode){
					getCounty();
					$("#county").val(jsonObj.countyCode);
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
					<select id="year" name="year" class="BigSelect">
						<% 
							Calendar cl = Calendar.getInstance();
							int year = cl.get(Calendar.YEAR);
							for(int i=0;i<20;i++){
						%>
						<option value="<%=year-i %>"><%=year-i %></option>
						<%
							}
						%>
					</select><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>负责人姓名：</td>
				<td class='TableData'><input type="text" id='investigatorName'
					name='investigatorName' autocomplete="off"
					class='easyui-validatebox BigInput' required="true" validType="isBlank[]" maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>民族：</td>
				<td class='TableData'><input type="text" id='investigatorNational' class="BigInput easyui-validatebox" 
					name='investigatorNational' required="true" validType="isBlank[]"/><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>所属城市：</td>
				<td class='TableData'>省： <select name="province" id="province"
					onchange="getCity();" class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select> 市： <select name="city" id="city" onchange="getCounty();"
					class="BigSelect easyui-validatebox" required="true">
						<option value="">请选择</option>
				</select> 县： <select name="county" id="county"
					class="BigSelect easyui-validatebox" required="true">
						<option value="">请选择</option>
				</select>
				</td>
			</tr>
			<tr>
				<td class='TableData'>年龄：</td>
				<td class='TableData'>
					<input type="text" id="investigatorAge" name="investigatorAge" class="SmallInput easyui-validatebox" required="true" validType="number[]" /><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>专业：</td>
				<td class='TableData'>
					<select id="investigatorMajor" name="investigatorMajor" class="BigSelect easyui-validatebox" required="true">
						<option value="">请选择</option>
						<option value="草业科学">草业科学</option>
						<option value="畜牧兽医">畜牧兽医</option>
						<option value="农学">农学</option>
						<option value="生态学">生态学</option>
						<option value="地理学">地理学</option>
						<option value="环境科学">环境科学</option>
						<option value="遥感科学与技术">遥感科学与技术</option>
						<option value="地理信息系统">地理信息系统</option>
						<option value="其他">其他</option>
					</select><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>学历：</td>
				<td class='TableData'>
					<select id="investigatorDegree" name="investigatorDegree" class="BigSelect easyui-validatebox" required="true">
						<option value="">请选择</option>
						<option value="博士">博士</option>
						<option value="硕士">硕士</option>
						<option value="本科">本科</option>
						<option value="大专">大专</option>
						<option value="大专以下">大专以下</option>
					</select><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>单位：</td>
				<td class='TableData'><input type="text"
					id="investigatorCompanyName" name="investigatorCompanyName"
					class="BigInput easyui-validatebox" required="true" validType="isBlank[]"/><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>手机号：</td>
				<td class='TableData'><input type="text" id="investigatorPhone"
					name="investigatorPhone" class="BigInput easyui-validatebox"
					required="true" validType='mobile[]' maxlength="11" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>座机号：</td>
				<td class='TableData'><input type="text"
					id="investigatorTelphone" name="investigatorTelphone"
					class="BigInput easyui-validatebox" required="true" validType="landlineNum[]" maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>邮箱：</td>
				<td class='TableData'><input type="text" id="investigatorEmail"
					name="investigatorEmail" class="BigInput easyui-validatebox"
					required="true" validType="email[]" /><i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" colspan='2' style='text-align:left;'>
					补助信息
				</td>
			</tr>
			<tr>
				<td class='TableData'>农业部补助经费（万）：</td>
				<td class='TableData'><input type="text" id="subsidyAmount"
					name="subsidyAmount" class="BigInput easyui-validatebox" required="true" validType="number[]" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>地方配套资金（万）：</td>
				<td class='TableData'><input type="text" id="localAssortAmount"
					name="localAssortAmount" class="BigInput easyui-validatebox" required="true" validType="number[]"/><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>行程（公里）：</td>
				<td class='TableData'><input type="text" id="tripAmount"
					name="tripAmount" class="BigInput easyui-validatebox" required="true" validType="number[]"/><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>培训（人次）：</td>
				<td class='TableData'><input type="text" id="trainingNums"
					name="trainingNums" class="BigInput easyui-validatebox" required="true" validType="number[]"/><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>发布监测报告：</td>
				<td class='TableData'><input type="radio" name="isReport"
					id="isReport1" value="0" checked="checked" /><label for="isReport1">是&nbsp;&nbsp;</label>
					<input type="radio" name="isReport" id="isReport2" value="1" /><label
					for="isReport2">否</label></td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
</body>
</html>