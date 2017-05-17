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
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
</head>
<script>
var id = '<%=id%>';
$(function(){
	 var url = contextPath+"/indicatorsController/getProvinceByUid.act";
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//省
			$("#province").val(json.rtData.basicInfo.cityCode.substring(0,2)+'0000');
			getCity();
		}
})
function saveIndicators(){
	if($("#form1").form("validate") && check()){
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
		var url = contextPath+"/indicatorsController/saveIndicators.act";
		if(id!="null" && id!=null){
			url = contextPath+"/indicatorsController/updateIndicators.act";
		}
		var param=tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			top.$.jBox.tip(json.rtMsg,"success");
			top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
			top.$(".jbox-body").remove();
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	} 
}

function getIndicatorsById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/indicatorsController/getGmsIndicatorsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var basicInfo = json.rtData.basicInfo;
			bindJsonObj2Cntrl(basicInfo);
			var jsonObj = getCityFullInfo(basicInfo.cityCode);
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
		}
	}
}


function check(){
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
/* 	if(province=="" && city=="" && county==""){
		$.jBox.tip("请选择省/市/县","error");
		return false;
	} */
	return true;
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getIndicatorsById()">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" colspan="4" style="text-align: left;">详细信息</td>
			</tr>
			<tr>
				<td class='TableData'>市级：</td>
 				<td class='TableData'>
					 <select name="city" id="city" onchange="getCounty();"
					class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select>
				</td> 
				<td class='TableData'>县级:</td> 
				<td class='TableData'><select name="county" id="county"
					class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select>
				<input type="hidden" id='province' name='province' />
				<input type="hidden" id='cityCode' name='cityCode' />
				</td>
			</tr>
			<tr>
				<td class='TableData'>指标名：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-validatebox' validType="maxLength[25]" required="true" id='indicatorsName'
					name='indicatorsName'/> </td>
				<td class='TableData'>单位：</td>
				<td class='TableData'><input type="text" class="BigInput easyui-validatebox" id='indicatorsUnit' name='indicatorsUnit' required="true"/> </td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
</body>
</html>