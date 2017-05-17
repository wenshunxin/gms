<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.tcxt.common.TcxtStringUtil"%>
<%

	int sid = TcxtStringUtil.getInteger(request.getParameter("sid"), 0);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新建或编辑省</title>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript">
var sid = "<%=sid%>";
function doInit(){
	if(sid>0){
		getInfoById(sid);
	}else{
		getAutoNumber('000000','1','cityCodeStart');
	}
	$("#cityFullName").focus();
}



/* 查看详情 */
function getInfoById(id){
	var url =   "<%=contextPath%>/gmsCityController/getCityById.act";
	var para = {sid : id};
	var jsonObj = tools.requestJsonRs(url, para);
	if (jsonObj.rtState) {
		var prc = jsonObj.rtData;
		if (prc && prc.sid) {
			bindJsonObj2Cntrl(prc);
			var cityCode = prc.cityCode;
			if(cityCode){
				var cityCodeStart = cityCode.substring(0,2);
				$("#cityCodeStart").val(cityCodeStart);
			}
		}
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}

/**
 * 新建或编辑
 */
function doSaveOrUpdate(){
	if(checkForm()){
		var url = "<%=contextPath %>/gmsCityController/saveCity.act";
		if(sid>0){
			url="<%=contextPath %>/gmsCityController/updateCity.act";
		}
		var para =  tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,para);
		if(json.rtState){
			top.$.jBox.tip(json.rtMsg,"success");
			parent.datagrid.datagrid("reload");
			parent.$(".jbox-body").remove();
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}


function checkForm(){
	var cityCodeStart = $("#cityCodeStart").val();
	var cityCodeEnd = $("#cityCodeEnd").val();
	var check = $("#form1").form('validate'); 
	if(!check){
		return false; 
	}
	var checkFlag = checkCityCode(cityCodeStart + cityCodeEnd);
	if(checkFlag==1){
		return false;
	}
	$("#cityCode").val(cityCodeStart + cityCodeEnd);
	return true;
}

/**
 * 校验城市代码
 */
function checkCityCode(cityCode){
	var url = "<%=contextPath %>/gmsCityController/checkCityCode.act?sid=<%=sid%>";
	var para = {cityCode:cityCode};
	var jsonRs = tools.requestJsonRs(url,para);
	var checkFlag= 0;
	if(jsonRs.rtState){
		checkFlag = jsonRs.rtData.countFlag;
	}else{
		alert(jsonRs.rtMsrg);
	}
	return checkFlag;
}

function checkCityCodefunc(){
	var cityCodeStart = $("#cityCodeStart").val();
	var cityCodeEnd = $("#cityCodeEnd").val();
	if(cityCodeStart.length<2){
		$.jBox.tip("请输入两位整数！", "info", {timeout: 1800});
		$("#cityCodeStart").focus();
	}
	var cityCode = cityCodeStart + cityCodeEnd;
 	var checkFlag = checkCityCode(cityCode);
	if(checkFlag==1){
		$("#cityCodeSpan").html("<font color='red'>该省编号已经存在！</font>");
		$("#cityCodeStart").focus();
	}else{
		$("#cityCodeSpan").text("");
	} 
}

</script>

</head>
<body onload="doInit();">
	<form action="" method="post" name="form1" id="form1">
		<input type="hidden" name="sid" id="sid" value="<%=sid%>">
		<table align="center" width="80%" class="TableBlock"
			style="margin-top: 10px;">
			<tr>
				<td nowrap class="TableData" width="15%;">省编号：<font
					style='color: red'>*</font></td>
				<td class="TableData" width="35%;"><input type="hidden"
					name="cityCode" id="cityCode" value="" /> <input type="text"
					name="cityCodeStart" id="cityCodeStart" size="2"
					class="BigInput  easyui-validatebox" validType='integeZero[]'
					required="true" value="" maxlength="2"
					onblur="checkCityCodefunc();"> <input type="text"
					name="cityCodeEnd" id="cityCodeEnd"
					class="BigInput  easyui-validatebox" disabled="disabled" size="4"
					value="0000" maxlength="4"> <span id="cityCodeSpan"></span>
				</td>
			</tr>
			<tr>
				<td nowrap class="TableData" width="15%;">省名称：<font
					style='color: red'>*</font></td>
				<td class="TableData" width="60%;"><input type="text"
					name="cityFullName" id="cityFullName" size=""
					class="BigInput  easyui-validatebox" required="true" value=""
					maxlength="150"></td>
			</tr>
			<tr>
				<td nowrap class="TableData" width="15%;">省名称简称：<font
					style='color: red'>*</font></td>
				<td class="TableData" width="60%;"><input type="text"
					name="cityShortName" id="cityShortName" size=""
					class="BigInput  easyui-validatebox" required="true" value=""
					maxlength="150"></td>
			</tr>
		</table>
	</form>
</body>
</html>