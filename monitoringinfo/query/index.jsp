<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String cityCode = (String)request.getSession().getAttribute("cityCode");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/ctrl.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script src="<%=contextPath%>/monitoringinfo/query/query.js"></script>
<script>
var cityCode = '<%=cityCode%>';
$(function(){
	$("#dataType").change(function(){
		var value = $("input[name=observationArea]:checked").val();
		addQueryConditon($(this).val(),value);
		if($(this).val()=="照片查询对比"){
			$("#observationType").hide();
		}else{
			$("#observationType").show();
		}
	});
});
function doInit(){
	var height = (document.documentElement.clientHeight-80)+"px";
	$("#queryCondition").css("height",height);
	var dataType = $("#dataType").val();
	addQueryConditon(dataType,0);
	
	$("input[name=observationArea]").each(function(){
		$(this).click(function(){
			var value = $(this).val();
			var dataType = $("#dataType").val();
			addQueryConditon(dataType,value);
		});
			
	})
}


</script>
</head>

<body onload="doInit();" style="overflow: hidden; font-size: 12px">
		<div class="moduleHeader" style="margin-bottom: 0px;">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：数据查询》<b class="second">固定监测点数据</b></b>
		</div>
		<div style="width:100%;height:36px;line-height:36px;background:#f7f7f7;font-weight:bolder;padding-left:10px;" fit="true">
			数据类型：
			<select id="dataType" name="dataType" class="BigSelect" style="width:180px;">
				<option value="植物群落特征及生产力">植物群落特征及生产力</option>
				<option value="生态状况调查">生态状况调查</option>
				<option value="物候期及降雪观测">物候期及降雪观测</option>
				<option value="经济社会指标调查">经济社会指标调查</option>
				<option value="照片查询对比">照片查询对比</option>
				<option value="其他指标调查">其他指标调查</option>
			</select>
			<span id="observationType" >
				<input type="radio" name="observationArea" checked="checked" id="observationArea1" value="0" />
				<label for="observationArea1">草本调查</label>
				<input type="radio" name="observationArea"  id="observationArea2" value="1" />
				<label for="observationArea2">灌木调查</label>
			</span>
		</div>
		<div id="queryCondition" style="width:100%;" fit="true">
		</div>
</body>
</html>