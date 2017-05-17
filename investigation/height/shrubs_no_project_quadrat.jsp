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
<script type="text/javascript" src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/height/shrubs.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
</head>
<style>
.dividingLine {
	border-right: 1px solid red;
}
i{font-size: 16px;color:red;font-weight: bold;}
</style>
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
	 total("");
	 autoCalculate("");
	 getQuadratNumber(1);

});
function saveQuadrat(){
	$("#quadratNumber").val($("#preNumber").text()+$("#curNumber").val());
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
						that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加非工程灌木样方': 2,'关闭':3}});
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function getShrubsQuadratById(){
	getSampleAreaById();
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsShrubsQuadratController/getShrubsQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			var itemList= json.rtData.herbItemList;
			var shrubsItemList = json.rtData.shrubsItemList;
			getItemList(itemList,"");
			getShrubsItemList(shrubsItemList,"");
			
			var quadratNumber = json.rtData.basicInfo.quadratNumber;
			var strs = quadratNumber.split("-");
			var preNumber = "";
			var curNumber = strs[strs.length-1];
			for(var i = 0 ;i<strs.length-1;i++){
				preNumber +=strs[i]+"-";
			}
			$("#preNumber").text(preNumber);
			$("#curNumber").val(curNumber);
			$("#quadratNumber").val(quadratNumber);
			//附件信息
			var attachList = json.rtData.attachList;
			for(var i = 0 ;i<attachList.length;i++){
				var attach = attachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainor .preview").attr("src",encodeURI(attachUrl));
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

function getSampleAreaById(){
	if(sampleAreaId!="null" && sampleAreaId!=null){
		var url = contextPath+"/gmsSampleAreaController/getSampleAreaById.act?sid="+sampleAreaId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			var data = json.rtData.basicInfo;
			if(data.hasLitter=="有"){
				$("#litters").removeAttr("disabled");
			}else{
				$("#litters").attr("disabled","disabled");
			}
			$("#investigateUserNames").val(data.investigateUserNames);
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
			var quadratNumber = $("#preNumber").text()+$("#curNumber").val();
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
	} 
});
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getShrubsQuadratById();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
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
				<td class='TableData'>东经：</td>
				<td class='TableData'><input type="text" id='longitude'
					name='longitude' class='SmallInput easyui-validatebox' validType="numberBetweenLength[60,150] & addMethodbbb[]"/>(度)<i>*</i></td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><input type="text" id='latitude'
					name='latitude' class='SmallInput easyui-validatebox' validType="numberBetweenLength[10,60] & addMethodbbb[]"/>(度)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData'>
					<span id='preNumber'></span>
					<input id='curNumber' name='curNumber' class='SmallInput easyui-validatebox' required="true" validType="integeZero[] & qaNumberIsExist[0]"/><i>*</i>
					<input type="hidden" id='quadratNumber' name='quadratNumber'/>
				</td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><input type="text" id='altitude'
					name='altitude' class='SmallInput easyui-validatebox' validType="numberBetweenLength[-160,8849] & addMethod[]"/>(米)<i>*</i></td>
			</tr>
			
			
			
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内草本及矮小灌木测定</td>
			</tr>
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">1平方米草本及矮小灌木小样方</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<table class="TableBlock" width="100%" id="itemTableHerb">
						<tr>
							<td class="TableData" align='center'>编号</td>
							<td class="TableData" align='center'>植物种数<i>*</i></td>
							<td class="TableData" align='center'>平均高度(cm)<i>*</i></td>
							<td class="TableData" align='center'>鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>可食鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>干重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'>可食干重(g/㎡)<i>*</i></td>
							<td class="TableData" align='center'><input type='button' value='+' class='btn btn-success' style="background: #41a675;" onclick="addGrassAmount(this,'');"/></td>
						</tr>
						<tr>
							<td class="TableData" align='center'>样方1</td>
							<td class="TableData" align='center'><input type='text' name='itemPlantNums' class='SmallInput easyui-validatebox' validType='positivIntege[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemAvgHeightly' class='SmallInput easyui-validatebox' validType=' numberBetweenLength[0,80] & integeZeroln[] & addMethod[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemFreshAmount' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleFreshAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleFreshValid[1,'']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemDryAmount' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[] & dryFreshValid[1,'']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleDryAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleDryValid[1,''] & edible[1,'']"/></td>
							<td class="TableData" align='center'>
							</td>
						</tr>
						<tr id="grassAvgAmount">
							<td class="TableHeader">平均</td>
							<td class="TableData"><span id='avgPlantNums'></span></td>
							<td class="TableData"><span id='avgHeightly'></span></td>
							<td class="TableData"><span id='avgFreshAmount'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmount'></span></td>
							<td class="TableData"><span id='avgDryAmount'></span></td>
							<td class="TableData" colspan='2'><span id='avgEdibleDryAmount'></span></td>
						</tr>
					</table>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData dividingLine'><input type="text" id='herbPlantNums' name='herbPlantNums'
					class='SmallInput easyui-validatebox' validType="positivIntege[]"/><i>*</i></td>
				<td class='TableData'>平均高度：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbGrassAvgHeight' name='herbGrassAvgHeight'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" validType="numberBetweenLength[0,80] & addMethod[]"/>(厘米)</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData dividingLine' colspan='3'><input type="text"
					id='herbMainPlant' name='herbMainPlant'
					class='BigInput easyui-validatebox' style="width:500px;" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>平均草产量折算鲜重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgFreshAmount' name='herbAvgFreshAmount'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgEdibleFreshAmount' name='herbAvgEdibleFreshAmount'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>平均草产量折算干重：：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgDryAmount' name='herbAvgDryAmount'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData dividingLine'><input type="text"
					id='herbAvgEdibleDryAmount' name='herbAvgEdibleDryAmount'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
			</tr>
			
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内灌木及高大草本测定</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<div style='width:840px;overflow-x:scroll;'>
						<table class="TableBlock" width="100%" id="itemTableShrubs">
							<tr>
								<td class="TableData" align='center' rowspan='2'>灌木及高大草本名称<i>*</i></td>
								<td class="TableData" align='center' colspan='4'>大株丛(cm,g)</td>
								<td class="TableData" align='center'  colspan='4'>中株丛(cm,g)</td>
								<td class="TableData" align='center' colspan='4'>小株丛(cm,g)</td>
								<td class="TableData" align='center' rowspan='2'>覆盖<br/>面积(㎡)</td>
								<td class="TableData" align='center' colspan='2'>产草量折算<br/>(kg/h㎡)</td>
								<td class="TableData" align='center' rowspan='2'>灌丛<br/>高度<br/>(cm)<i>*</i></td>
								<td class="TableData" align='center' rowspan='2'><input type='button' value='+'  class='btn btn-success' style='background:#41a675;'  onclick="addShrubsItem(this,'');"/></td>
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
								<td class='TableData ' ><input type='text' name='plantName' class='BigInput'/></td>
								<td class='TableData '><input type='text' name='largeRadius' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='largeFreshAmount' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='largeDryAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidLarge[1,'']"/></td>
								<td class='TableData '><input type='text' name='largeNums' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='middleRadius' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='middleFreshAmount' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='middleDryAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidMid[1,'']"/></td>
								<td class='TableData '><input type='text' name='middleNums' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='smallRadius' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='smallFreshAmount' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='smallDryAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] &addMethod[] & edibleFreshValidSmall[1,'']"/></td>
								<td class='TableData '><input type='text' name='smallNums' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
								<td class='TableData '><input type='text' name='coverSize' class='SmallInput readonly' readonly="readonly"/></td>
								<td class='TableData '><input type='text' name='convertFreshAmount' class='SmallInput readonly' readonly="readonly"/></td>
								<td class='TableData '><input type='text' name='convertDryAmount' class='SmallInput readonly' readonly="readonly"/></td>
								<td class='TableData '><input type='text' name='heightly' class='SmallInput' validType="integeZerollf[] & addMethod[]"/></td>
								<td class='TableData'></td>
							</tr>
							<tr id='shrubsItemAmount'>
								<td class='TableHeader'>合计</td>
								<td class='TableData'><span id='largeRadiusTotal'/></td>
								<td class='TableData'><span id='largeFreshAmountTotal' /></td>
								<td class='TableData'><span id='largeDryAmountTotal'/></td>
								<td class='TableData'><span id='largeNumsTotal'></span></td>
								<td class='TableData'><span id='middleRadiusTotal' ></span></td>
								<td class='TableData'><span id='middleFreshAmountTotal' ></span></td>
								<td class='TableData'><span id='middleDryAmountTotal' ></span></td>
								<td class='TableData'><span id='middleNumsTotal'></span></td>
								<td class='TableData'><span id='smallRadiusTotal'></span></td>
								<td class='TableData'><span id='smallFreshAmountTotal'></span></td>
								<td class='TableData'><span id='smallDryAmountTotal'></span></td>
								<td class='TableData'><span id='smallNumsTotal'></span></td>
								<td class='TableData'><span id='coverSizeTotal'></span></td>
								<td class='TableData'><span id='convertFreshAmountTotal'></span></td>
								<td class='TableData'><span id='convertDryAmountTotal'></span></td>
								<td class='TableData' colspan='2'><span id='avgShrubsHeightly'></span></td>
							</tr>
						</table>
					
					</div>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData'><input type="text" id='shrubsPlantNums'
					name='shrubsPlantNums' class='SmallInput easyui-validatebox' validType="positivIntege[]"/><i>*</i></td>
				<td class='TableData'>总覆盖面积：</td>
				<td class='TableData'><input type="text" id='totalCoverSize'
					name='totalCoverSize' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(m²)</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData'><input type="text" id='shrubsMainPlant'
					name='shrubsMainPlant' class='BigInput easyui-validatebox' /><i>*</i></td>
				<td class='TableData'>灌丛平均高度：</td>
				<td class='TableData'><input type="text"
					id='shrubsGrassAvgHeight' name='shrubsGrassAvgHeight'
					class='SmallInput easyui-validatebox readonly' readonly="readonly"/>(厘米)</td>
			</tr>
			<tr>
				<td class='TableData'>草产量折算鲜重：</td>
				<td class='TableData'><input type="text"
					id='shrubsAvgFreshAmount' name='shrubsAvgFreshAmount'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>草产量折算干重：</td>
				<td class='TableData'><input type="text"
					id='shrubsAvgDryAmount' name='shrubsAvgDryAmount'
					class='SmallInput easyui-validatebox readonly' readonly="readonly"/>(千克/公顷)</td>
			</tr>

			<tr>
				<td class='TableHeader' style="text-align: left;" colspan="4">概况：</td>
			</tr>
			<tr>
				<td class='TableData'>枯落物：</td>
				<td class='TableData'><input type="text" id='litters'
					name='litters' class='SmallInput easyui-validatebox' validType="addMethod[] & integeZeroln[]"/>(千克/公顷)<i>*</i></td>
				<td class='TableData'>总盖度：</td>
				<td class='TableData'><input type="text" id='coverage'
					name='coverage' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethod[]"/>(%)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>总产草量折算鲜重：</td>
				<td class='TableData'><input type="text" id='freshAmount'
					name='freshAmount' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>总产草量折算干重：</td>
				<td class='TableData'><input type="text" id='dryAmount'
					name='dryAmount' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><textarea id="remark"
						name="remark" rows="3" cols="60" class="BigTextarea"></textarea></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor">
						<div class="attachContainorDiv" style="margin-left:20px; float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
							<input type="file" id="qd_np_sh_overlooking_photo" name="qd_np_sh_overlooking_photo" onchange="change(this)" />
					        请选择景观照片文件</p>
					    </div>
					    <i style="float:left;">*</i>
					</div>
				</td>
			</tr>

		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='sampleAreaId' name='sampleAreaId'
			value='<%=sampleAreaId %>' /> <input type='hidden'
			id='investigateDataId' name='investigateDataId' /> <input
			type='hidden' id='inOrOut' name='inOrOut' value="0" />
	</form>
</body>
</html>