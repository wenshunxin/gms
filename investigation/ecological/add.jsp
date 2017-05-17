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
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<style>
	i{color: red;font-size: 16px;font-weight: bold;}
</style>
</head>
<script>
var id = '<%=id%>';
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
	 }).on('changeDate',function(){
		 autoNumber();
	 });
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 autoNumber();
	 getCityInfo("cityInfo");
	 getProvinceAndCounty("investigateCompanyName");
	 //草原退化自动计算
	$(".frist").on('keyup', function() { 
		var num=$("#degradationMildSize").val();
		num=parseFloat(num==""?0:num);
		var num1=$("#degradationModerateSize").val();
		num1=parseFloat(num1==""?0:num1);
		var num2=$("#degradationSevereSize").val();
		num2=parseFloat(num2==""?0:num2);
		$("#degradationSize").val(parseFloat(parseFloat(num+num1+num2).toFixed(8)));
	});
	//草原盐泽化自动计算
	$(".secend").on('keyup', function() { 
		var num=$("#salinizationMildSize").val();
		num=parseFloat(num==""?0:num);
		var num1=$("#salinizationModerateSize").val();
		num1=parseFloat(num1==""?0:num1);
		var num2=$("#salinizationSevereSize").val();
		num2=parseFloat(num2==""?0:num2);
		$("#salinizationSize").val(parseFloat(parseFloat(num+num1+num2).toFixed(8)));
	});
	//草原沙化自动计算
	$(".third").on('keyup', function() { 
		var num=$("#desertificationMildSize").val();
		num=parseFloat(num==""?0:num);
		var num1=$("#desertificationModerateSize").val();
		num1=parseFloat(num1==""?0:num1);
		var num2=$("#desertificationSevereSize").val();
		num2=parseFloat(num2==""?0:num2);
		$("#desertificationSize").val(parseFloat(parseFloat(num+num1+num2).toFixed(8)));
	});
	//草原石漠化自动计算
	$(".fourth").on('keyup', function() { 
		var num=$("#rockyDesertificationMildSize").val();
		num=parseFloat(num==""?0:num);
		var num1=$("#rockyDesertificationModerateSize").val();
		num1=parseFloat(num1==""?0:num1);
		var num2=$("#rockyDesertificationSevereSize").val();
		num2=parseFloat(num2==""?0:num2);
		$("#rockyDesertificationSize").val(parseFloat(parseFloat(num+num1+num2).toFixed(8)));
	});
});
function saveEcological(){
	$("#investigateArea").val($("#cityInfo").text());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsEcologicalController/saveEcological.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsEcologicalController/updateEcological.act";
		}
		var param=tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			if(id!="null" && id!=null){
				top.$.jBox.tip(json.rtMsg, 'success');
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(4);
				top.$(".jbox-body").remove();
			 }else{
				top.$.jBox.closeTip();
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(4);
				var that = top;
		    	top.$(".jbox-body").remove();
				var submit = function (v, h, f) {
				    if(v==2){
				    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addEcological();
				    	 return true;
				    }else{
				    	return true;
				    }
				    return true;
				};
				// 自定义按钮
				that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {"继续添加生态环境调查": 2,'关闭':3} });
			 }
			
			
			
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
function getEcologicalById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsEcologicalController/getEcologicalById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			/* var area = json.rtData.basicInfo.investigateArea;
			var index = area.indexOf("-");
			if(index>-1){
				var countyName= area.substring(index+1,area.length);
				$("#countyName").val(countyName);
			} */
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
function autoNumber(){
	var investigateDate = $("#investigateDate").val();
	var url = contextPath+"/gmsInvestigateDataController/autoSampleAreaNumber.act?investigateType=4&investigateDate="+investigateDate;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		$("#sampleAreaNumber").val(json.rtData.preNumber+json.rtData.curNumber);
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getEcologicalById();">
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData' ><input type="text" id='investigateDate'
					name='investigateDate' autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly"  /><i>*</i>
				</td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text"
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox' validType="" maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>所在区域：</td>
				<td class='TableData' colspan='3'>
					<span id="cityInfo"></span>
					<input type="hidden" id='investigateArea' name='investigateArea' class='BigInput easyui-validatebox' /></td>
				<!-- <td class='TableData'>乡镇：</td>
				<td class='TableData'><input id="countyName" name="countyName" class="BigInput easyui-validatebox" maxlength="20" /><i>*</i></td> -->
			</tr>
			<tr>
				<td class='TableData'>填表单位：</td>
				<td class='TableData' colspan="3">
					<input type="text" id='investigateCompanyName' name='investigateCompanyName' class='BigInput easyui-validatebox'/><i>*</i>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原退化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='degradationArea' name='degradationArea'
					class='BigInput easyui-validatebox'  /></td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='degradationSize' name='degradationSize'
					class='SmallInput easyui-validatebox readonly ' readonly="readonly" validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>轻度退化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='degradationMildSize' name='degradationMildSize'
					class='SmallInput easyui-validatebox frist' validType="integeZerol[] & addMethode[]" />(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>中度退化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='degradationModerateSize' name='degradationModerateSize'
					class='SmallInput easyui-validatebox frist' validType="integeZerol[] & addMethode[]" />(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>重度退化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='degradationSevereSize' name='degradationSevereSize'
					class='SmallInput easyui-validatebox frist' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原盐渍化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='salinizationArea' name='salinizationArea'
					class='BigInput easyui-validatebox' /></td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='salinizationSize' name='salinizationSize'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>轻度盐渍化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='salinizationMildSize' name='salinizationMildSize'
					class='SmallInput easyui-validatebox secend' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>中度盐渍化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='salinizationModerateSize' name='salinizationModerateSize'
					class='SmallInput easyui-validatebox secend' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>重度盐渍化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='salinizationSevereSize' name='salinizationSevereSize'
					class='SmallInput easyui-validatebox secend' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原沙化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='desertificationArea' name='desertificationArea'
					class='BigInput easyui-validatebox' /></td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='desertificationSize' name='desertificationSize'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>轻度沙化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='desertificationMildSize' name='desertificationMildSize'
					class='SmallInput easyui-validatebox third' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>中度沙化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='desertificationModerateSize' name='desertificationModerateSize'
					class='SmallInput easyui-validatebox third' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>重度沙化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='desertificationSevereSize' name='desertificationSevereSize'
					class='SmallInput easyui-validatebox third' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原石漠化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='rockyDesertificationArea' name='rockyDesertificationArea'
					class='BigInput easyui-validatebox' validType="invalidType="integeZerol[] & addMethode[]" /></td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='rockyDesertificationSize' name='rockyDesertificationSize'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>轻度石漠化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='rockyDesertificationMildSize'
					name='rockyDesertificationMildSize'
					class='SmallInput easyui-validatebox fourth' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>中度石漠化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='rockyDesertificationModerateSize'
					name='rockyDesertificationModerateSize'
					class='SmallInput easyui-validatebox fourth' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>重度石漠化面积：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='rockyDesertificationSevereSize'
					name='rockyDesertificationSevereSize'
					class='SmallInput easyui-validatebox fourth' validType="integeZerol[] & addMethode[]"/>(公顷)</td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> 
		<input type='hidden' id='investigateDataId' name='investigateDataId' />
		<input type="hidden" id='sampleAreaNumber'name='sampleAreaNumber'/>
	</form>
</body>
</html>