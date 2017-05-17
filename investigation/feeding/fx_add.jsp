<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String type = request.getParameter("type");
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
	i{color: red;font-size:16px;font-weight: bold;}
</style>
</head>
<script>
var id = '<%=id%>';
var type = '<%=type%>';
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
	 });
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 getCityInfo("cityInfo");
	 getProvinceAndCounty("investigateCompanyName");
});
function saveFeeding(){
	$("#investigateArea").val($("#cityInfo").text());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsFeedingController/saveFeeding.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsFeedingController/updateFeeding.act";
		}
		var param=tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			if(id!="null" && id!=null){
				top.$.jBox.tip(json.rtMsg,"success");
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(2);
				top.$(".jbox-body").remove();
			 }else{
				top.$.jBox.closeTip();
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
				top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(2);
				var that = top;
		    	top.$(".jbox-body").remove();
				var submit = function (v, h, f) {
				    if(v==2){
				    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addFeeding(2);
				    	 return true;
				    }else{
				    	return true;
				    }
				    return true;
				};
				// 自定义按钮
				that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {"继续添加分县补饲调查": 2,'关闭':3} });
			 }
			
			
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
function getFeedingById(){
	if(type=="2"){
		$("#feedingType").val(0);
	}else if(type=="3"){
		$("#feedingType").val(1);
	}
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsFeedingController/getFeedingById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			var area = json.rtData.basicInfo.investigateArea;
			var index = area.indexOf("-");
			if(index>-1){
				var countyName= area.substring(index+1,area.length);
				$("#countyName").val(countyName);
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

$.extend($.fn.validatebox.defaults.rules, {   
	totalDay: {  
		validator: function(value){
			var supplementDays = $("#supplementDays").val();
			supplementDays=parseFloat(supplementDays==""? 0:supplementDays);
			var grazingDays =$("#grazingDays").val();
			grazingDays=parseFloat(grazingDays==""? 0:grazingDays);
			if(grazingDays + supplementDays !=365){
				return false;
			}else{
				return true;
			}
		},
	   message: '补饲天数+放牧天数=365！'
	}

});

</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getFeedingById();">
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><input type="text" id='investigateDate'
					name='investigateDate' autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly"   /><i>*</i>
				</td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text"
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox' maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>所在区域：</td>
				<td class='TableData' colspan='3'>
						<span id="cityInfo"></span>
						<input type="hidden" id='investigateArea' name='investigateArea' class='BigInput easyui-validatebox' />
					</td>
			</tr>
			<tr>
				<td class='TableData'>调查单位：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='investigateCompanyName' name='investigateCompanyName'
					class='BigInput easyui-validatebox'  validType=""/><i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'>家庭承包面积：</td>
				<td class='TableData'><input type="text"
					id='houseContractedSize' name='houseContractedSize'
					class='SmallInput easyui-validatebox'   validType="integeZerol[] & addMethodf[] "/>(公顷)</td>
				<td class='TableData'>绵羊数量：</td>
				<td class='TableData'><input type="text" id='sheepAmount'
					name='sheepAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]" /><span class="wan">(万只)</span></td>
			</tr>
			<tr>
				<td class='TableData'>人工草地面积：</td>
				<td class='TableData'><input type="text"
					id='artificialGrassSize' name='artificialGrassSize'
					class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/>(公顷)</td>
				<td class='TableData'>山羊数量：</td>
				<td class='TableData'><input type="text" id='goatAmount'
					name='goatAmount' class='SmallInput easyui-validatebox'  validType="integeZerol[] & addMethodf[]"/><span class="wan">(万只)</span></td>
			</tr>
			<tr>
				<td class='TableData'>人工草地产草总量：</td>
				<td class='TableData'><input type="text"
					id='artificialGrassAmount' name='artificialGrassAmount'
					class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="dun">(吨)</span></td>
				<td class='TableData'>牛数量：</td>
				<td class='TableData'><input type="text" id='cowAmount'
					name='cowAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="tou">(万头)</span></td>
			</tr>
			<tr>
				<td class='TableData'>补饲秸秆等总量：</td>
				<td class='TableData'><input type="text" id='strawAmount'
					name='strawAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="dun">(吨)</span></td>
				<td class='TableData'>马数量：</td>
				<td class='TableData'><input type="text" id='horseAmount'
					name='horseAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="pi">(万匹)</span></td>
			</tr>
			<tr>
				<td class='TableData'>青贮饲料总量：</td>
				<td class='TableData'><input type="text" id='silageAmount'
					name='silageAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="dun">(吨)</span></td>
				<td class='TableData'>骆驼数量：</td>
				<td class='TableData'><input type="text" id='camelAmount'
					name='camelAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="tou">(万峰)</span></td>
			</tr>
			<tr>
				<td class='TableData'>粮食补饲量：</td>
				<td class='TableData'><input type="text" id='foodAmount'
					name='foodAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="dun">(吨)</span></td>
				<td class='TableData'>骡数量：</td>
				<td class='TableData'><input type="text" id='muleAmount'
					name='muleAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="tou">(万头)</span></td>
			</tr>
			<tr>
				<td class='TableData'>补饲总天数：</td>
				<td class='TableData'><input type="text" id='supplementDays'
					name='supplementDays' class='SmallInput easyui-validatebox' validType="integeZero[] & integeZeroll[] &totalDay[]"/>(天)<i>*</i></td>
				<td class='TableData'>驴数量：</td>
				<td class='TableData'><input type="text" id='donkeyAmount'
					name='donkeyAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="tou">(万头)</span></td>
			</tr>
			<tr>
				<td class='TableData'>放牧总天数：</td>
				<td class='TableData'><input type="text" id='grazingDays'
					name='grazingDays' class='SmallInput easyui-validatebox' validType="integeZero[] & integeZeroll[] &totalDay[]" />(天)<i>*</i></td>
				<td class='TableData'>其他草食家禽数量：</td>
				<td class='TableData'><input type="text"
					id='otherHerbivorousAmount' name='otherHerbivorousAmount'
					class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/><span class="wanT">(万头/只)</span></td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='feedingType' name='feedingType' /> <input
			type='hidden' id='investigateDataId' name='investigateDataId' />
	</form>
</body>
</html>