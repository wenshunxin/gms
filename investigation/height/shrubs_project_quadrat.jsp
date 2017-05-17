<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String sampleAreaId = request.getParameter("sampleAreaId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/height/shrubs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<style>
	i{font-size: 16px;font-weight: bold;color:red;}
</style>
</head>
<script>
var id = '<%=id%>';
var sampleAreaId = '<%=sampleAreaId%>';
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
	 total("In");
	 autoCalculate("In");
	 total("Out");
	 autoCalculate("Out");
	 getQuadratNumber(0);

});
function saveQuadrat(){
	$("#quadratNumberIn").val($("#preNumberIn").text()+$("#curNumberIn").val());
	$("#quadratNumberOut").val($("#preNumberOut").text()+$("#curNumberOut").val());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsShrubsQuadratController/saveShrubsQuadrat.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsShrubsQuadratController/updateShrubsQuadrat.act";
		}
		top.$.jBox.tip("数据保存中", 'loading');
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					if(id!="null" && id!=null){
						top.$.jBox.tip(json.rtMsg, 'success');
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						top.$(".jbox-body").remove();
					 }else{
						var data = json.rtData;
						top.$.jBox.closeTip();
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						var that = top;
				    	top.$(".jbox-body").remove();
						var submit = function (v, h, f) {
						    if(v==2){
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addQuadrat(data.sampleAreaId,data.inOrOut,"有");
						    	 return true;
						    }else{
						    	return true;
						    }
						    return true;
						};
						// 自定义按钮
						that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加工程灌木样方': 2,'关闭':3}});
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function getShrubsQuadratById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsShrubsQuadratController/getShrubsQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			bindJsonObj2Cntrl(json.rtData.quadratIn,null,"In");
			bindJsonObj2Cntrl(json.rtData.quadratOut,null,"Out");
			
			var itemListIn= json.rtData.herbItemListIn;
			var shrubsItemListIn = json.rtData.shrubsItemListIn;
			getItemList(itemListIn,"In");
			getShrubsItemList(shrubsItemListIn,"In");
			
			var itemListOut= json.rtData.herbItemListOut;
			var shrubsItemListOut = json.rtData.shrubsItemListOut;
			getItemList(itemListOut,"Out");
			getShrubsItemList(shrubsItemListOut,"Out");
			
			//样方编码处理
			var quadratNumber = json.rtData.quadratIn.quadratNumber;
			var strs = quadratNumber.split("-");
			var preNumber = "";
			var curNumber = strs[strs.length-1];
			for(var i = 0 ;i<strs.length-1;i++){
				preNumber +=strs[i]+"-";
			}
			$("#preNumberIn").text(preNumber);
			$("#curNumberIn").val(curNumber);
			$("#quadratNumberIn").val(quadratNumber);
			$("#preNumberOut").text(preNumber);
			$("#curNumberOut").val(curNumber);
			$("#quadratNumberOut").val(quadratNumber);
			//附件信息
			var attachListIn = json.rtData.attachListIn;
			for(var i = 0 ;i<attachListIn.length;i++){
				var attach = attachListIn[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorIn .preview").attr("src",encodeURI(attachUrl));
			}
			var attachListOut = json.rtData.attachListOut;
			for(var i = 0 ;i<attachListOut.length;i++){
				var attach = attachListOut[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorOut .preview").attr("src",encodeURI(attachUrl));
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
	getSampleAreaById();
}

function getSampleAreaById(){
	var saId = $("#sampleAreaId").val();
	if(saId!="null" && saId!=null){
		var url = contextPath+"/gmsSampleAreaController/getSampleAreaById.act?sid="+saId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			var inInfo = json.rtData.sampleAreaIn;
			var outInfo = json.rtData.sampleAreaOut;
			if(inInfo.hasLitter=="有"){
				$("#littersIn").removeAttr("disabled");
			}else{
				$("#littersIn").attr("disabled","disabled");
			}
			if(outInfo.hasLitter=="有"){
				$("#littersOut").removeAttr("disabled");
			}else{
				$("#littersOut").attr("disabled","disabled");
			}
			if($("#investigateUserNames").val()==""){
				$("#investigateUserNames").val(inInfo.investigateUserNames);
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}


/**
 * 数据校验	
 * 
 */
$.extend($.fn.validatebox.defaults.rules, {   
	qaNumberIsExist: {   //样方编码是否已存在
		validator: function(value, param){
			var url = contextPath+"/gmsShrubsQuadratController/qaNumberIsExist.act";
			var params={};
			var sampleAreaId = $("#sampleAreaId").val();
			var quadratNumber = $("#preNumber"+param[1]).text()+$("#curNumber"+param[1]).val();
			params["sampleAreaId"] = sampleAreaId;
			params["quadratNumber"] = quadratNumber;
			params["inOrOut"] = param[0];
			if(id!="null" && id!=null){
				params["sid"]=id;
			}
			var json = tools.requestJsonRs(url,params);
			if(json.rtState){
				if(json.rtData){
					return false;
				}
			}
			return true;
			
		},  
	   message: '当前样方编码已存在，请重新输入！'
	},
	qaNumberIsEqual: {   //工程内外样方编码一致
		validator: function(value, param){
			var quadratNumberIn = $("#preNumberIn").text()+$("#curNumberIn").val();
			var quadratNumberOut = $("#preNumberOut").text()+$("#curNumberOut").val();
			if(quadratNumberIn!=quadratNumberOut){
				return false;
			}
			return true;
			
		},  
	   message: '工程内外样方编码应该一样！'
	} 
});
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getShrubsQuadratById();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><input type="text" id='investigateDate'
					name='investigateDate' class='SmallInput easyui-validatebox '
					readonly="readonly" /><i>*</i></td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text"
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox' maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">工程区域内</td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><input type="text" id='longitudeIn'
					name='longitudeIn' class='SmallInput easyui-validatebox' validType="numberBetweenLength[60,150] & addMethodbbb[]"/>(度)<i>*</i></td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><input type="text" id='latitudeIn'
					name='latitudeIn' class='SmallInput easyui-validatebox' validType="numberBetweenLength[10,60] & addMethodbbb[]"/>(度)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData'>
					<span id='preNumberIn'></span>
					<input id='curNumberIn' name='curNumberIn' class='SmallInput easyui-validatebox' required="true" validType="integeZero[] & qaNumberIsExist[1,'In'] & qaNumberIsEqual[]"/>
					<span>-内</span><i>*</i>
					<input type="hidden" id='quadratNumberIn' name='quadratNumberIn'/>
				</td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><input type="text" id='altitudeIn'
					name='altitudeIn' class='SmallInput easyui-validatebox' validType="numberBetweenLength[-160,8849] & addMethod[]"/>(米)<i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内草本及矮小灌木测定</td>
			</tr>
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">1平方米草本及矮小灌木小样方</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<table class="TableBlock" width="100%" id="itemTableHerbIn">
						<tr>
							<td class="TableData" align='center'>编号</td>
							<td class="TableData" align='center'>植物种数<i>*</i></td>
							<td class="TableData" align='center'>平均高度(cm)<i>*</i></td>
							<td class="TableData" align='center'>鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>可食鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>干重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>可食干重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'><input type='button' value='+' class='btn btn-success' style="background:#41a675;" onclick="addGrassAmount(this,'In');"/></td>
						</tr>
						<tr>
							<td class="TableData" align='center'>样方1</td>
							<td class="TableData" align='center'><input type='text' name='itemPlantNumsIn' class='SmallInput easyui-validatebox' validType='positivIntege[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemAvgHeightlyIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[] & numberBetweenLength[0,80]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemFreshAmountIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleFreshAmountIn' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleFreshValid[1,'In']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemDryAmountIn' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[] & dryFreshValid[1,'In']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleDryAmountIn' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleDryValid[1,'In'] & edible[1,'In']"/></td>
							<td class="TableData" align='center'>
							</td>
						</tr>
						<tr id="grassAvgAmountIn">
							<td class="TableHeader">平均</td>
							<td class="TableData"><span id='avgPlantNumsIn'></span></td>
							<td class="TableData"><span id='avgHeightlyIn'></span></td>
							<td class="TableData"><span id='avgFreshAmountIn'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmountIn'></span></td>
							<td class="TableData"><span id='avgDryAmountIn'></span></td>
							<td class="TableData" colspan='2'><span id='avgEdibleDryAmountIn'></span></td>
						</tr>
					</table>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbPlantNumsIn' name='herbPlantNumsIn'
					class='SmallInput easyui-validatebox' validType="positivIntege[]"/><i>*</i></td>
						<td class='TableData'>平均高度：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbGrassAvgHeightIn' name='herbGrassAvgHeightIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="numberBetweenLength[0,80] & addMethod[]"/>(厘米)</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData dividingLine' colspan="3"><input type="text"
					id='herbMainPlantIn' name='herbMainPlantIn'
					class='BigInput easyui-validatebox' style="width:500px;" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>平均草产量折算鲜重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgFreshAmountIn' name='herbAvgFreshAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]" />(千克/公顷)</td>
				<td class='TableData'>平均草产量折算干重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgDryAmountIn' name='herbAvgDryAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgEdibleFreshAmountIn'
					name='herbAvgEdibleFreshAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgEdibleDryAmountIn' name='herbAvgEdibleDryAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内灌木及高大草本测定</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<div style='width:910px;overflow-x:scroll;'>
						<table class="TableBlock" width="100%" id="itemTableShrubsIn">
							<tr>
								<td class="TableData" align='center' rowspan='2'>灌木及高大草本名称<i>*</i></td>
								<td class="TableData" align='center' colspan='4'>大株丛(cm,g)</td>
								<td class="TableData" align='center'  colspan='4'>中株丛(cm,g)</td>
								<td class="TableData" align='center' colspan='4'>小株丛(cm,g)</td>
								<td class="TableData" align='center' rowspan='2'>覆盖<br/>面积(㎡)</td>
								<td class="TableData" align='center' colspan='2'>产草量折算<br/>(kg/h㎡)</td>
								<td class="TableData" align='center' rowspan='2'>灌丛<br/>高度<br/>(cm)<i>*</i></td>
								<td class="TableData" align='center' rowspan='2'><input type='button' value='+' class='btn btn-success' style="background: #41a675;" onclick="addShrubsItem(this,'In');"/></td>
							</tr>
							<tr>
								<td class="TableData" align='center'>丛径<i>*</i></td>
								<td class="TableData" align='center'>鲜重<i>*</i></td>
								<td class="TableData" align='center'>风干重<i>*</i></td>
								<td class="TableData" align='center'>株丛数<i>*</i></td>
								<td class="TableData" align='center'>丛径<i>*</i></td>
								<td class="TableData" align='center'>鲜重<i>*</i></td>
								<td class="TableData" align='center'>风干重<i>*</i></td>
								<td class="TableData" align='center'>株丛数<i>*</i></td>
								<td class="TableData" align='center'>丛径<i>*</i></td>
								<td class="TableData" align='center'>鲜重<i>*</i></td>
								<td class="TableData" align='center'>风干重<i>*</i></td>
								<td class="TableData" align='center'>株丛数<i>*</i></td>
								<td class="TableData" align='center'>鲜重</td>
								<td class="TableData" align='center'>风干重</td>
								</td>
							</tr>
							<tr>
								<td class='TableData'><input type='text' name='plantNameIn' class='BigInput'/></td>
								<td class='TableData'><input type='text' name='largeRadiusIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='largeFreshAmountIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='largeDryAmountIn' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidLarge[1,'In']"/></td>
								<td class='TableData'><input type='text' name='largeNumsIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='middleRadiusIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='middleFreshAmountIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='middleDryAmountIn' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidMid[1,'In']"/></td>
								<td class='TableData'><input type='text' name='middleNumsIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='smallRadiusIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='smallFreshAmountIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='smallDryAmountIn' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidSmall[1,'In']"/></td>
								<td class='TableData'><input type='text' name='smallNumsIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='coverSizeIn' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType=''/></td>
								<td class='TableData'><input type='text' name='convertFreshAmountIn' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType=''/></td>
								<td class='TableData'><input type='text' name='convertDryAmountIn' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType=''/></td>
								<td class='TableData'><input type='text' name='heightlyIn' class='SmallInput easyui-validatebox' validType='integeZerollf[] & addMethod[]'/></td>
								<td class='TableData'></td>
							</tr>
							<tr id='shrubsItemAmountIn'>
								<td class='TableHeader'>合计</td>
								<td class='TableData'><span id='largeRadiusInTotal'/></td>
								<td class='TableData'><span id='largeFreshAmountInTotal' /></td>
								<td class='TableData'><span id='largeDryAmountInTotal'/></td>
								<td class='TableData'><span id='largeNumsInTotal'></span></td>
								<td class='TableData'><span id='middleRadiusInTotal' ></span></td>
								<td class='TableData'><span id='middleFreshAmountInTotal' ></span></td>
								<td class='TableData'><span id='middleDryAmountInTotal' ></span></td>
								<td class='TableData'><span id='middleNumsInTotal'></span></td>
								<td class='TableData'><span id='smallRadiusInTotal'></span></td>
								<td class='TableData'><span id='smallFreshAmountInTotal'></span></td>
								<td class='TableData'><span id='smallDryAmountInTotal'></span></td>
								<td class='TableData'><span id='smallNumsInTotal'></span></td>
								<td class='TableData'><span id='coverSizeTotalIn'></span></td>
								<td class='TableData'><span id='convertFreshAmountTotalIn'></span></td>
								<td class='TableData'><span id='convertDryAmountTotalIn'></span></td>
								<td class='TableData' colspan='2'><span id='avgShrubsHeightlyIn'></span></td>
							</tr>
						</table>
					
					</div>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData'><input type="text"
					id='shrubsPlantNumsIn' name='shrubsPlantNumsIn'
					class='SmallInput easyui-validatebox' validType="positivIntege[]"/><i>*</i></td>
				<td class='TableData'>总覆盖面积：</td>
				<td class='TableData'><input type="text"
					id='totalCoverSizeIn' name='totalCoverSizeIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="numberBetweenLength[0,100] & addMethod[]"/>(m²)</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='shrubsMainPlantIn' name='shrubsMainPlantIn'
					class='BigInput easyui-validatebox' style="width:500px;" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>草产量折算鲜重：</td>
				<td class='TableData'><input type="text"
					id='shrubsAvgFreshAmountIn' name='shrubsAvgFreshAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
				<td class='TableData'>草产量折算干重：</td>
				<td class='TableData'><input type="text"
					id='shrubsAvgDryAmountIn' name='shrubsAvgDryAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>灌丛平均高度：</td>
				<td class='TableData' colspan='3'><input type="text"
					id='shrubsGrassAvgHeightIn' name='shrubsGrassAvgHeightIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="addMethod[]"/>(厘米)</td>
			</tr>
			<tr>
				<td class='TableHeader' style="text-align: left;" colspan="4">概况：</td>
			</tr>
			<tr>
				<td class='TableData'>枯落物：</td>
				<td class='TableData'><input type="text" id='littersIn'
					name='littersIn' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[]"/>(千克/公顷)<i>*</i></td>
				<td class='TableData'>总盖度：</td>
				<td class='TableData'><input type="text" id='coverageIn'
					name='coverageIn' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethod[]"/>(%)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>总产草量折算鲜重：</td>
				<td class='TableData'><input type="text" id='freshAmountIn'
					name='freshAmountIn' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
				<td class='TableData'>总产草量折算干重：</td>
				<td class='TableData'><input type="text" id='dryAmountIn'
					name='dryAmountIn' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><textarea id="remarkIn"
						name="remarkIn" rows="3" cols="60" class="BigTextarea"></textarea>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">工程区域外</td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><input type="text" id='longitudeOut'
					name='longitudeOut' class='SmallInput easyui-validatebox' validType="numberBetweenLength[60,150] & addMethodbbb[]"/>(度)<i>*</i></td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><input type="text" id='latitudeOut'
					name='latitudeOut' class='SmallInput easyui-validatebox' validType="numberBetweenLength[10,60] & addMethodbbb[]"/>(度)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData'>
					<span id='preNumberOut'></span>
					<input id='curNumberOut' name='curNumberOut' class='SmallInput easyui-validatebox' required="true" validType="integeZero[] & qaNumberIsExist[2,'Out'] & qaNumberIsEqual[]"/>
					<span>-外</span><i>*</i>
					<input type="hidden" id='quadratNumberOut' name='quadratNumberOut'/>
				</td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><input type="text" id='altitudeOut'
					name='altitudeOut' class='SmallInput easyui-validatebox' validType="numberBetweenLength[-160,8849] & addMethod[]"/>(米)<i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内草本及矮小灌木测定</td>
			</tr>
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">1平方米草本及矮小灌木小样方</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<table class="TableBlock" width="100%" id="itemTableHerbOut">
						<tr>
							<td class="TableData" align='center'>编号</td>
							<td class="TableData" align='center'>植物种数<i>*</i></td>
							<td class="TableData" align='center'>平均高度(cm)<i>*</i></td>
							<td class="TableData" align='center'>鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>可食鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>干重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>可食干重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'><input type='button' value='+' class='btn btn-success' style='background: #41a675;' onclick="addGrassAmount(this,'Out');"/></td>
						</tr>
						<tr>
							<td class="TableData" align='center'>样方1</td>
							<td class="TableData" align='center'><input type='text' name='itemPlantNumsOut' class='SmallInput easyui-validatebox' validType='positivIntege[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemAvgHeightlyOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[] &numberBetweenLength[0,80]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemFreshAmountOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleFreshAmountOut' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleFreshValid[1,'Out']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemDryAmountOut' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[] & dryFreshValid[1,'Out']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleDryAmountOut' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleDryValid[1,'Out'] & edible[1,'Out']"/></td>
							<td class="TableData" align='center'>
							</td>
						</tr>
						<tr id="grassAvgAmountOut">
							<td class="TableHeader">平均</td>
							<td class="TableData"><span id='avgPlantNumsOut'></span></td>
							<td class="TableData"><span id='avgHeightlyOut'></span></td>
							<td class="TableData"><span id='avgFreshAmountOut'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmountOut'></span></td>
							<td class="TableData"><span id='avgDryAmountOut'></span></td>
							<td class="TableData" colspan='2'><span id='avgEdibleDryAmountOut'></span></td>
						</tr>
					</table>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbPlantNumsOut' name='herbPlantNumsOut'
					class='SmallInput easyui-validatebox' validType="positivIntege[]"/><i>*</i></td>
				<td class='TableData'>平均高度：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbGrassAvgHeightOut' name='herbGrassAvgHeightOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="numberBetweenLength[0,80] & addMethod[]"/>(厘米)</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData' colspan='3'><input type="text"
					id='herbMainPlantOut' name='herbMainPlantOut'
					class='BigInput easyui-validatebox' style="width:500px;" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>平均草产量折算鲜重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgFreshAmountOut' name='herbAvgFreshAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
					<td class='TableData'>平均草产量折算干重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgDryAmountOut' name='herbAvgDryAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgEdibleFreshAmountOut'
					name='herbAvgEdibleFreshAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgEdibleDryAmountOut' name='herbAvgEdibleDryAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内灌木及高大草本测定</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<div style='width:910px;overflow-x:scroll;'>
						<table class="TableBlock" width="100%" id="itemTableShrubsOut">
							<tr>
								<td class="TableData" align='center' rowspan='2'>灌木及高大草本名称<i>*</i></td>
								<td class="TableData" align='center' colspan='4'>大株丛(cm,g)</td>
								<td class="TableData" align='center'  colspan='4'>中株丛(cm,g)</td>
								<td class="TableData" align='center' colspan='4'>小株丛(cm,g)</td>
								<td class="TableData" align='center' rowspan='2'>覆盖<br/>面积(㎡)</td>
								<td class="TableData" align='center' colspan='2'>产草量折算<br/>(kg/h㎡)</td>
								<td class="TableData" align='center' rowspan='2'>灌丛<br/>高度<br/>(cm)<i>*</i></td>
								<td class="TableData" align='center' rowspan='2'><input type='button' value='+'  class='btn btn-success' style="background:#41a675;" onclick="addShrubsItem(this,'Out');"/></td>
							</tr>
							<tr>
								<td class="TableData" align='center'>丛径<i>*</i></td>
								<td class="TableData" align='center'>鲜重<i>*</i></td>
								<td class="TableData" align='center'>风干重<i>*</i></td>
								<td class="TableData" align='center'>株丛数<i>*</i></td>
								<td class="TableData" align='center'>丛径<i>*</i></td>
								<td class="TableData" align='center'>鲜重<i>*</i></td>
								<td class="TableData" align='center'>风干重<i>*</i></td>
								<td class="TableData" align='center'>株丛数<i>*</i></td>
								<td class="TableData" align='center'>丛径<i>*</i></td>
								<td class="TableData" align='center'>鲜重<i>*</i></td>
								<td class="TableData" align='center'>风干重<i>*</i></td>
								<td class="TableData" align='center'>株丛数<i>*</i></td>
								<td class="TableData" align='center'>鲜重</td>
								<td class="TableData" align='center'>风干重</td>
								</td>
							</tr>
							<tr>
								<td class='TableData'><input type='text' name='plantNameOut' class='BigInput'/></td>
								<td class='TableData'><input type='text' name='largeRadiusOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='largeFreshAmountOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='largeDryAmountOut' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidLarge[1,'Out']"/></td>
								<td class='TableData'><input type='text' name='largeNumsOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='middleRadiusOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='middleFreshAmountOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='middleDryAmountOut' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidMid[1,'Out']"/></td>
								<td class='TableData'><input type='text' name='middleNumsOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='smallRadiusOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='smallFreshAmountOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='smallDryAmountOut' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidSmall[1,'Out']"/></td>
								<td class='TableData'><input type='text' name='smallNumsOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData'><input type='text' name='coverSizeOut' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType=''/></td>
								<td class='TableData'><input type='text' name='convertFreshAmountOut' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType=''/></td>
								<td class='TableData'><input type='text' name='convertDryAmountOut' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType=''/></td>
								<td class='TableData'><input type='text' name='heightlyOut' class='SmallInput easyui-validatebox' validType='integeZerollf[] & addMethod[]'/></td>
								<td class='TableData'></td>
							</tr>
							<tr id='shrubsItemAmountOut'>
								<td class='TableHeader'>合计</td>
								<td class='TableData'><span id='largeRadiusOutTotal'/></td>
								<td class='TableData'><span id='largeFreshAmountOutTotal' /></td>
								<td class='TableData'><span id='largeDryAmountOutTotal'/></td>
								<td class='TableData'><span id='largeNumsOutTotal'></span></td>
								<td class='TableData'><span id='middleRadiusOutTotal' ></span></td>
								<td class='TableData'><span id='middleFreshAmountOutTotal' ></span></td>
								<td class='TableData'><span id='middleDryAmountOutTotal' ></span></td>
								<td class='TableData'><span id='middleNumsOutTotal'></span></td>
								<td class='TableData'><span id='smallRadiusOutTotal'></span></td>
								<td class='TableData'><span id='smallFreshAmountOutTotal'></span></td>
								<td class='TableData'><span id='smallDryAmountOutTotal'></span></td>
								<td class='TableData'><span id='smallNumsOutTotal'></span></td>
								<td class='TableData'><span id='coverSizeTotalOut'></span></td>
								<td class='TableData'><span id='convertFreshAmountTotalOut'></span></td>
								<td class='TableData'><span id='convertDryAmountTotalOut'></span></td>
								<td class='TableData' colspan='2'><span id='avgShrubsHeightlyOut'></span></td>
							</tr>
						</table>
					
					</div>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData'><input type="text"
					id='shrubsPlantNumsOut' name='shrubsPlantNumsOut'
					class='SmallInput easyui-validatebox' validType="positivIntege[]"/><i>*</i></td>
					<td class='TableData'>总覆盖面积：</td>
				<td class='TableData'><input type="text"
					id='totalCoverSizeOut' name='totalCoverSizeOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="numberBetweenLength[0,100] & addMethod[]"/>(m²)</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData' colspan='3'><input type="text"
					id='shrubsMainPlantOut' name='shrubsMainPlantOut'
					class='BigInput easyui-validatebox' style="width:500px;" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>草产量折算鲜重：</td>
				<td class='TableData'><input type="text"
					id='shrubsAvgFreshAmountOut' name='shrubsAvgFreshAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
				<td class='TableData'>草产量折算干重：</td>
				<td class='TableData'><input type="text"
					id='shrubsAvgDryAmountOut' name='shrubsAvgDryAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>灌丛平均高度：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='shrubsGrassAvgHeightOut' name='shrubsGrassAvgHeightOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="addMethod[]"/>(厘米)</td>
			</tr>
			<tr>
				<td class='TableHeader' style="text-align: left;" colspan="4">概况：</td>
			</tr>
			<tr>
				<td class='TableData'>枯落物：</td>
				<td class='TableData'><input type="text" id='littersOut'
					name='littersOut' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[]"/>(千克/公顷)<i>*</i></td>
				<td class='TableData'>总盖度：</td>
				<td class='TableData'><input type="text" id='coverageOut'
					name='coverageOut' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethod[]"/>(%)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>总产草量折算鲜重：</td>
				<td class='TableData'><input type="text" id='freshAmountOut'
					name='freshAmountOut' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
				<td class='TableData'>总产草量折算干重：</td>
				<td class='TableData'><input type="text" id='dryAmountOut'
					name='dryAmountOut' class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="integeZerol[] & addMethod[]"/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><textarea id="remarkOut"
						name="remarkOut" rows="3" cols="60" class="BigTextarea"></textarea>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainorIn" style="width:40%;display:inline-block;float:left;margin-left: 10%;">
						<div class="attachContainorDiv" style="float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="qd_pi_sh_overlooking_photo" name="qd_pi_sh_overlooking_photo" onchange="change(this)" />
					        请选择工程内景观照片文件</p>
							
					    </div>
					    <i style="float: left;">*</i>
					</div> 
					<div id="attachContainorOut" style="width:40%;display:inline-block;float:left;margin-left: 10%;">
						<div class="attachContainorDiv" style="float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="qd_po_sh_overlooking_photo" name="qd_po_sh_overlooking_photo" onchange="change(this)" />
					        请选择工程外景观照片文件</p>
							
					    </div>
					    <i style="float: left;">*</i>
					</div> 
				</td>
			</tr>

		</table>
		<input type='hidden' id='sidIn' name='sidIn' /> <input type='hidden'
			id='sidOut' name='sidOut' /> <input type='hidden' id='sampleAreaId'
			name='sampleAreaId' value='<%=sampleAreaId %>' /> <input
			type='hidden' id='investigateDataId' name='investigateDataId' /> <input
			type='hidden' id='inOrOut' name='inOrOut' value="1" />
	</form>
</body>
</html>