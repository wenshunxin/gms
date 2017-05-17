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
<script type="text/javascript" src="<%=contextPath%>/investigation/height/herb.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
</head>
<style>
#inOutTr input[type=text] {
	width: 75px;
}
i{font-size: 16px;font-weight: bold;color:red;}
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
	 total("In");
	 total("Out");
	 getQuadratNumber(0);

});
function saveQuadrat(){
	$("#quadratNumberIn").val($("#preNumberIn").text()+$("#curNumberIn").val());
	$("#quadratNumberOut").val($("#preNumberOut").text()+$("#curNumberOut").val());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsHerbQuadratController/saveHerbQuadrat.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsHerbQuadratController/updateHerbQuadrat.act";
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
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addQuadrat(data.sampleAreaId,data.inOrOut,"无");
						    	 return true;
						    }else{
						    	return true;
						    }
						    return true;
						};
						// 自定义按钮
						that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加工程草本样方': 2,'关闭':3}});
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function getHerbQuadratById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsHerbQuadratController/getHerbQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			bindJsonObj2Cntrl(json.rtData.quadratIn,null,"In");
			bindJsonObj2Cntrl(json.rtData.quadratOut,null,"Out");
			
			var itemListIn= json.rtData.herbQuadratItemIn;
			getItemList(itemListIn,"In");
			var itemListOut= json.rtData.herbQuadratItemOut;
			getItemList(itemListOut,"Out");
			
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
			var url = contextPath+"/gmsHerbQuadratController/qaNumberIsExist.act";
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
	},
	badGrassNumsIn:{
		validator:function(value,params){
			var badGrassNumsIn=$("#badGrassNumsIn").val();
			if(badGrassNumsIn=="0"){
				return false;
			}
			return true;
		},
		message:'检查到毒害草种数和主要毒害草不对应!'
	},
	badGrassNumsOut:{
		validator:function(value,params){
			var badGrassNumsOut=$("#badGrassNumsOut").val();
			if(badGrassNumsOut=="0"){
				return false;
			}
			return true;
		},
		message:'检查到毒害草种数和主要毒害草不对应!'
	}
});
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getHerbQuadratById();">
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
					class='BigInput easyui-validatebox' maxlength='20'/><i>*</i></td>
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
				<td class='TableData'>样方面积：</td>
				<td class='TableData'><input type="text" id='quadratSizeIn'
					name='quadratSizeIn' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100]"/>(m²)<i>*</i></td>
				<td class='TableData'>植被盖度：</td>
				<td class='TableData'><input type="text" id='coverageIn'
					name='coverageIn' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethod[]"/>(%)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'><input type="text"
					id='grassAvgHeightIn' name='grassAvgHeightIn'
					class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,80] & addMethod[]"/>(厘米)<i>*</i></td>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><input type="text" id='littersIn'
					name='littersIn' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[]"/>(千克/公顷)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>植物种数：</td>
				<td class='TableData'><input type="text" id='plantNumsIn'
					name='plantNumsIn' class='SmallInput easyui-validatebox' validType="positivIntege[]"/>(种)<i>*</i></td>
				<td class='TableData'>主要植物种名称：</td>
				<td class='TableData'><input type="text" id='mainPlantIn'
					name='mainPlantIn' class='BigInput easyui-validatebox' /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><input type="text" id='badGrassNumsIn'
					name='badGrassNumsIn' class='SmallInput easyui-validatebox' validType="integeZero[]"/>(种)<i>*</i></td>
				<td class='TableData'>主要毒害草名称：</td>
				<td class='TableData'><input type="text" id='mainBadGrassIn'
					name='mainBadGrassIn' class='BigInput easyui-validatebox' validType="badGrassNumsIn[]"/><i>*</i></td>
			</tr>
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">产草量测定</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<table class="TableBlock" width="100%" id="itemTableIn">
						<tr>
							<td class="TableData" align="center">编号</td>
							<td class="TableData" align="center">鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">可食鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">干重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">可食干重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center"><input type='button' value='+' class='btn btn-success' style="background: #41a675;" onclick="addGrassAmount(this,'In');"/></td>
						</tr>
						<tr>
							<td class="TableData" align='center'>1</td>
							<td class="TableData" align='center'><input type='text' name='itemFreshAmountIn' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleFreshAmountIn' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleFreshValid[1,'In']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemDryAmountIn' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[] & dryFreshValid[1,'In']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleDryAmountIn' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleDryValid[1,'In'] & edible[1,'In']"/></td>
							<td class="TableData" align='center'>
							</td>
						</tr>
						<tr id="grassAvgAmountIn">
							<td class="TableHeader">平均</td>
							<td class="TableData"><span id='avgFreshAmountIn'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmountIn'></span></td>
							<td class="TableData"><span id='avgDryAmountIn'></span></td>
							<td class="TableData" colspan='2'><span id='avgEdibleDryAmountIn'></span></td>
						</tr>
					</table>					
				</td>			
			</tr>
			<tr>
				<td class='TableData'>总产草量鲜重：</td>
				<td class='TableData'><input type="text" id='freshAmountIn'
					name='freshAmountIn' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>总产草量风干重：</td>
				<td class='TableData'><input type="text" id='dryAmountIn'
					name='dryAmountIn' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData'><input type="text"
					id='edibleFreshAmountIn' name='edibleFreshAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData'><input type="text"
					id='edibleDryAmountIn' name='edibleDryAmountIn'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
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
				<td class='TableData'>样方面积：</td>
				<td class='TableData'><input type="text" id='quadratSizeOut'
					name='quadratSizeOut' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100]"/>(m²)<i>*</i></td>
				<td class='TableData'>植被盖度：</td>
				<td class='TableData'><input type="text" id='coverageOut'
					name='coverageOut' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethod[]"/>(%)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'><input type="text"
					id='grassAvgHeightOut' name='grassAvgHeightOut'
					class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,80] & addMethod[]"/>(厘米)<i>*</i></td>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><input type="text" id='littersOut'
					name='littersOut' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[]"/>(千克/公顷)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>植物种数：</td>
				<td class='TableData'><input type="text" id='plantNumsOut'
					name='plantNumsOut' class='SmallInput easyui-validatebox' validType="positivIntege[]"/>(种)<i>*</i></td>
				<td class='TableData'>主要植物种名称：</td>
				<td class='TableData'><input type="text" id='mainPlantOut'
					name='mainPlantOut' class='BigInput easyui-validatebox' /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><input type="text"
					id='badGrassNumsOut' name='badGrassNumsOut'
					class='SmallInput easyui-validatebox' validType="integeZero[]"/>(种)<i>*</i></td>
				<td class='TableData'>主要毒害草名称：</td>
				<td class='TableData'><input type="text"
					id='mainBadGrassOut' name='mainBadGrassOut'
					class='BigInput easyui-validatebox' validType="badGrassNumsOut[]"/><i>*</i></td>
			</tr>
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">产草量测定</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<table class="TableBlock" width="100%" id="itemTableOut">
						<tr>
							<td class="TableData" align="center">编号</td>
							<td class="TableData" align="center">鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">可食鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">干重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">可食干重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center"><input type='button' value='+' class='btn btn-success' style="background: #41a675;" onclick="addGrassAmount(this,'Out');"/></td>
						</tr>
						<tr>
							<td class="TableData" align='center'>1</td>
							<td class="TableData" align='center'><input type='text' name='itemFreshAmountOut' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleFreshAmountOut' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleFreshValid[1,'Out']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemDryAmountOut' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[] & dryFreshValid[1,'Out']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleDryAmountOut' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleDryValid[1,'Out'] & edible[1,'Out']"/></td>
							<td class="TableData" align='center'>
							</td>
						</tr>
						<tr id="grassAvgAmountOut">
							<td class="TableHeader">平均</td>
							<td class="TableData"><span id='avgFreshAmountOut'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmountOut'></span></td>
							<td class="TableData"><span id='avgDryAmountOut'></span></td>
							<td class="TableData" colspan='2'><span id='avgEdibleDryAmountOut'></span></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class='TableData'>总产草量鲜重：</td>
				<td class='TableData'><input type="text" id='freshAmountOut'
					name='freshAmountOut' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>总产草量风干重：</td>
				<td class='TableData'><input type="text" id='dryAmountOut'
					name='dryAmountOut' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData'><input type="text"
					id='edibleFreshAmountOut' name='edibleFreshAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData'><input type="text"
					id='edibleDryAmountOut' name='edibleDryAmountOut'
					class='SmallInput easyui-validatebox readonly' readonly="readonly"/>(千克/公顷)</td>
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
					<div id="attachContainorIn" style="width:40%;display:inline-block;float:left;margin-left: 10%">
						<div class="attachContainorDiv" style="display: inline-block;float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)" >
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
							<input type="file" id="qd_pi_hb_overlooking_photo" name="qd_pi_hb_overlooking_photo" onchange="change(this)" />
					        请选择工程内景观照片文件</p>
							
					    </div>
					    <i style="float: left;">*</i>
					</div> 
					
					<div id="attachContainorOut" style="width:40%;display:inline-block;float:left;margin-left: 10%"">
						<div class="attachContainorDiv" style="display: inline-block;float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)" >
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="qd_po_hb_overlooking_photo" name="qd_po_hb_overlooking_photo" onchange="change(this)"/>
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