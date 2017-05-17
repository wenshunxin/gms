<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String quadratSize = request.getParameter("quadratSize");
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
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<style>
	i{font-weight: bold;font-size: 16px;color:red;margin-left:3px;}
</style>
</head>
<script>
var id = '<%=id%>';
var quadratSize = '<%=quadratSize%>';
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
 	 getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
	 $('#grassCategory').combobox({
		 onSelect: function(param){
			 var categoryNo = param.categoryNo;
			 getChildListByTypeCode("GRASSLAND_TYPE_"+categoryNo,"grassType");
			
		 }
	});
	$('#grassCategory').combobox('textbox').bind('click',function(){
		 $('#grassCategory').combobox('showPanel');
	});
	$('#grassType').combobox('textbox').bind('click',function(){
		 $('#grassType').combobox('showPanel');
	});
	getCityInfo("cityInfo");

 	//地形地貌选择丘陵、山地是否单选框被选中	
 	$("input[name=grassLandscape]").change(function(){
 		var id=$(this).attr("id");
 		if(id=="grassLandscape2" || id=="grassLandscape3"){
 			$("input[name=grassSlope]").removeAttr("disabled");
 			$("input[name=grassSlopePosition]").removeAttr("disabled");
 			$("#grassSlopePosition1").prop("checked","checked");
 			$("#grassSlope1").prop("checked","checked");
 		}else{
 			$("input[name=grassSlope]").attr("disabled","disabled");
 			$("input[name=grassSlopePosition]").attr("disabled","disabled");
 		};
 	});
 	
 	$("input[name=hasSurfaceErosion]").change(function(){
 		if( $(this).val()=="无"){
 			$("input[name=erosionReason]").attr("disabled","disabled");
 		}else{
 			$("input[name=erosionReason]").removeAttr("disabled");
 			$("#erosionReason1").prop("checked","checked");
 		}
 	});
 	if(quadratSize!="0" && quadratSize!="null"){
 		$("#curNumber").attr("disabled","disabled");
 	}
});

function saveSampleArea(){
	$("#investigateArea").val($("#cityInfo").text()+"-"+$("#countyName").val());
	$("#sampleAreaNumber").val($("#preNumber").text()+$("#curNumber").val());
	if($("#form1").form("validate") && checkHasShrubs()){
		var url = contextPath+"/gmsSampleAreaController/saveSampleArea.act?type=1";//type=0代表工程样地，1-非工程样地
		if(id!="null" && id!=null){
			url = contextPath+"/gmsSampleAreaController/updateSampleArea.act?type=1";//type=0代表工程样地 1-非工程样地
		}
		top.$.jBox.tip("数据保存中", 'loading');
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			dataType:"text/html",  
			complete:function(data){
				var json =eval("("+data.responseText+")");
				 if(json.rtState){
					 if(id!="null" && id!=null){
						top.$.jBox.tip(json.rtMsg, 'success');
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(1);
						top.$(".jbox-body").remove();
					 }else{
						var data = json.rtData;
						top.$.jBox.closeTip();
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(1);
						var that = top;
				    	top.$(".jbox-body").remove();
						var submit = function (v, h, f) {
						    if (v == 1){
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addSampleArea(1);
						        return true;
						    } else if(v==2){
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addQuadrat(data.sid,data.inOrOut,data.hasShrubs);
						    	 return true;
						    }else{
						    	return true;
						    }
						    return true;
						};
						// 自定义按钮
						var btnTitle ="";
						if(data.hasShrubs=="无"){
							that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加样地': 1,"添加非工程草本样方": 2,'关闭':3}});
						}else{
							that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加样地': 1,"添加非工程灌木样方": 2,'关闭':3}});
						}
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			},
            error: function(XmlHttpRequest, textStatus, errorThrown){  
            	$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
            }  
		});
		return false;
	}
}

function getSampleAreaById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsSampleAreaController/getSampleAreaById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			$('#grassCategory').combobox('setValue', json.rtData.basicInfo.grassCategory);
			getChildListByTypeCode("GRASSLAND_TYPE_"+json.rtData.basicInfo.grassCategory,"grassType");
			$('#grassType').combobox('setValue', json.rtData.basicInfo.grassType);
			var area = json.rtData.basicInfo.investigateArea;
			var index = area.indexOf("-");
			if(index>-1){
				var countyName= area.substring(index+1,area.length);
				$("#countyName").val(countyName);
			}
			var sampleAreaNumber = json.rtData.basicInfo.sampleAreaNumber;
			if(sampleAreaNumber){
				var strs = sampleAreaNumber.split("-");
				$("#curNumber").val(strs[strs.length-1]);
			}
			if(json.rtData.hasQuadrat){
				$("input[name=hasShrubs]").each(function(){
					$(this).attr("disabled","disabled");
				});
			}

			var hasSurfaceErosion1=json.rtData.basicInfo.hasSurfaceErosion;
			if(hasSurfaceErosion1=="无"){
				$("input[name=erosionReason]").attr("disabled","disabled");
			}
			var grassLandscape = json.rtData.basicInfo.grassLandscape;
			if(grassLandscape=="丘陵" || grassLandscape=='山地'){
				$("input[name=grassSlope]").removeAttr("disabled");
 				$("input[name=grassSlopePosition]").removeAttr("disabled");
			}
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
function autoNumber(){
	var investigateDate = $("#investigateDate").val();
	var url = contextPath+"/gmsInvestigateDataController/autoSampleAreaNumber.act?investigateType=1&investigateDate="+investigateDate;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		$("#preNumber").text(json.rtData.preNumber);
		$("#curNumber").val(json.rtData.curNumber);
		$("#sampleAreaNumber").val(json.rtData.preNumber+$("#curNumber").val());
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}

$.extend($.fn.validatebox.defaults.rules, {   
	saNumberIsExist: {   //样地编码是否已存在
		validator: function(value, param){
			var url = contextPath+"/gmsSampleAreaController/saNumberIsExist.act";
			var params={};
			var investigateDate = $("#investigateDate").val();
			var sampleAreaNumber = $("#preNumber").text()+$("#curNumber").val();
			params["investigateDate"] = investigateDate;
			params["sampleAreaNumber"] = sampleAreaNumber;
			params["inOrOut"]=param[0];//非工程样地
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
	   message: '当前样地编码已存在，请重新输入！'
	} 
});

/**
 * 判断是否选择了有无灌木
 */
function checkHasShrubs(){
	 var val=$('input:radio[name="hasShrubs"]:checked').val();
	 if(val==null){
		 $("#hasShrubs1").focus();
		 $.jBox.tip("请选择是否具有灌木和高大草本");
		 return false;
	 }
	 return true;
}

</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getSampleAreaById();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><input type="text" id='investigateDate'
					name='investigateDate' autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly" required="true" /><i>*</i>
				</td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text"
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox' maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>所在区域：</td>
				<td class='TableData'>
					<span id="cityInfo"></span>
					<input type="hidden" id='investigateArea' name='investigateArea' class='BigInput easyui-validatebox' /></td>
				<td class='TableData'>乡镇：</td>
				<td class='TableData'><input id="countyName" name="countyName" class="BigInput" maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>样地编号：</td>
				<td class='TableData' colspan="3">
					<span id='preNumber'></span><input id='curNumber' name='curNumber' class='SmallInput easyui-validatebox' required="true" validType="integeZero[] & saNumberIsExist[0]"/><i>*</i>
					<input type="hidden" id='sampleAreaNumber' name='sampleAreaNumber' class='BigInput' /></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">类型</td>
			</tr>
			<tr>
				<td class='TableData'>具有灌木和高大草木：</td>
				<td class='TableData' colspan="3">
					<input type="radio" id='hasShrubs1' name='hasShrubs' class='' value="无" /><label for="hasShrubs1">无</label> 
					<input type="radio" id='hasShrubs2' name='hasShrubs' class='' value="有" /><label for="hasShrubs2">有</label><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'>
					<input id='grassCategory' name='grassCategory' class='BigInput easyui-combobox' style="height:28px;line-height: 28px;"/><i>*</i>
				</td>
				<td class='TableData'>草地型：</td>
				<td class='TableData'>
					<input id='grassType' name='grassType' class='BigInput easyui-combobox' style="height:28px;line-height: 28px;"/><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>地形地貌：</td>
				<td class='TableData' id="grassLandscape" colspan="3"><input type="radio" id='grassLandscape1'
					name='grassLandscape' class='' value="平原" checked="checked"/><label
					for="grassLandscape1">平原</label>  <input type="radio"
					id='grassLandscape4' name='grassLandscape' class='' value="高原" /><label
					for="grassLandscape4">高原</label> <input type="radio"
					id='grassLandscape5' name='grassLandscape' class='' value="盆地" /><label
					for="grassLandscape5">盆地</label><input type="radio"
					id='grassLandscape2' name='grassLandscape' class='' value="丘陵" /><label
					for="grassLandscape2">丘陵</label> <input type="radio"
					id='grassLandscape3' name='grassLandscape' class='' value="山地" /><label
					for="grassLandscape3">山地</label></td>
			</tr>
			<tr id="grassSlope">
				<td class='TableData'>坡向：</td>
				<td class='TableData' colspan="3"><input type="radio" id='grassSlope1'
					name='grassSlope' class='' value="阳坡" disabled="true" checked="checked"/><label for="grassSlope1">阳坡</label>
					<input type="radio" id='grassSlope2' name='grassSlope' class=''
					value="半阳坡" disabled="true" /><label for="grassSlope2">半阳坡</label> <input
					type="radio" id='grassSlope3' name='grassSlope' class=''
					value="半阴坡" disabled="true" /><label for="grassSlope3">半阴坡</label> <input
					type="radio" id='grassSlope4' name='grassSlope' class=''
					value="阴坡 " disabled="true" /><label for="grassSlope4">阴坡 </label></td>
			</tr>
			<tr>
				<td class='TableData'>坡位：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='grassSlopePosition1' name='grassSlopePosition' class=''
					value="坡脚" disabled="true" checked="checked" /><label for="grassSlopePosition1">坡脚</label> <input
					type="radio" id='grassSlopePosition2' name='grassSlopePosition'
					class='' value="坡顶" disabled="true" /><label for="grassSlopePosition2">坡顶</label>
					<input type="radio" id='grassSlopePosition3'
					name='grassSlopePosition' class='' value="坡下部" disabled="true" /><label
					for="grassSlopePosition3">坡下部</label> <input type="radio"
					id='grassSlopePosition4' name='grassSlopePosition' class=''
					value="坡中部" disabled="true" /><label for="grassSlopePosition4">坡中部</label> <input
					type="radio" id='grassSlopePosition5' name='grassSlopePosition'
					class='' value="坡上部" disabled="true" /><label for="grassSlopePosition5">坡上部</label>
				</td>
			</tr>
			</tr>
				<td class='TableData'>土壤质地：</td>
				<td class='TableData' colspan="3"><input type="radio" id='soilTexture1'
					name='soilTexture' class='' value="沙土" checked="checked"/><label for="soilTexture1">沙土</label>
					<input type="radio" id='soilTexture2' name='soilTexture' class=''
					value="壤土" /><label for="soilTexture2">壤土</label> <input
					type="radio" id='soilTexture3' name='soilTexture' class=''
					value="砾石质" /><label for="soilTexture3">砾石质</label> <input
					type="radio" id='soilTexture4' name='soilTexture' class=''
					value="粘土" /><label for="soilTexture4">粘土</label> <input
					type="radio" id='soilTexture5' name='soilTexture' class=''
					value="沙土壤土" /><label for="soilTexture5">沙土壤土</label> <input
					type="radio" id='soilTexture6' name='soilTexture' class=''
					value="栗钙土" /><label for="soilTexture6">栗钙土</label> <input
					type="radio" id='soilTexture7' name='soilTexture' class=''
					value="浮沙" /><label for="soilTexture7">浮沙</label></td>
			</tr>
			
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">地表特征</td>
			</tr>
			<tr>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><input type="radio" id='hasLitter1'
					name='hasLitter' class='' value="无" /><label for="hasLitter1">无</label>
					<input type="radio" id='hasLitter2' name='hasLitter' class=''
					value="有" checked="checked" /><label for="hasLitter2">有</label></td>
				<td class='TableData'>覆沙情况：</td>
				<td class='TableData'><input type="radio" id='hasSand1'
					name='hasSand' class='' value="无" /><label for="hasSand1">无</label>
					<input type="radio" id='hasSand2' name='hasSand' class='' value="有" checked="checked"/><label
					for="hasSand2">有</label></td>
			</tr>
			<tr>
				<td class='TableData'>地表侵蚀：</td>
				<td class='TableData'><input type="radio"
					id='hasSurfaceErosion1' name='hasSurfaceErosion' class='' value="无" /><label
					for="hasSurfaceErosion1">无</label> <input type="radio"
					id='hasSurfaceErosion2' name='hasSurfaceErosion' class='' value="有" checked="checked" /><label
					for="hasSurfaceErosion2">有</label></td>
				<td class='TableData'>侵蚀原因：</td>
				<td class='TableData'><input type="radio" id='erosionReason1'
					name='erosionReason' class='' value="风蚀" checked="checked" /><label
					for="erosionReason1">风蚀</label> <input type="radio"
					id='erosionReason2' name='erosionReason' class='' value="水蚀" /><label
					for="erosionReason2">水蚀</label> <input type="radio"
					id='erosionReason3' name='erosionReason' class='' value="冻蚀" /><label
					for="erosionReason3">冻蚀</label> <input type="radio"
					id='erosionReason4' name='erosionReason' class='' value="超载" /><label
					for="erosionReason4">超载</label> <input type="radio"
					id='erosionReason5' name='erosionReason' class='' value="其他" /><label
					for="erosionReason5">其他</label></td>
			</tr>
			<tr>
				<td class='TableData'>盐碱斑：</td>
				<td class='TableData'><input type="radio" id='hasSalineSpot1'
					name='hasSalineSpot' class='' value="无" /><label
					for="hasSalineSpot1">无</label> <input type="radio"
					id='hasSalineSpot2' name='hasSalineSpot' class='' value="有" checked="checked"/><label
					for="hasSalineSpot2">有</label></td>
				<td class='TableData'>裸地面积比例：</td>
				<td class='TableData'><input type="text" id='bareLandAreaRatio'
					name='bareLandAreaRatio' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethodf[]"/>(%)<i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">积水和降水</td>
			</tr>
			<tr>
				<td class='TableData'>地表有无季节性积水：</td>
				<td class='TableData'><input type="radio"
					id='hasSeasonalWater1' name='hasSeasonalWater' class='' value="无" /><label
					for="hasSeasonalWater1">无</label> <input type="radio"
					id='hasSeasonalWater2' name='hasSeasonalWater' class='' value="有" checked="checked" /><label
					for="hasSeasonalWater2">有</label></td>
				<td class='TableData'>年平均降水量：</td>
				<td class='TableData'><input type="text"
					id='averageAnnualRainfall' name='averageAnnualRainfall'
					class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethodf[]"/>(毫米)<i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">利用</td>
			</tr>
			<tr>
				<td class='TableData'>利用方式：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='usingType1' name='usingType' class='' value="打草场" checked="checked"/><label
					for="usingType1">打草场</label> <input type="radio" id='usingType2'
					name='usingType' class='' value="冷季放牧" /><label for="usingType2">冷季放牧</label>
					<input type="radio" id='usingType3' name='usingType' class=''
					value="暖季放牧" /><label for="usingType3">暖季放牧</label> <input
					type="radio" id='usingType4' name='usingType' class='' value="春季放牧" /><label
					for="usingType4">春季放牧</label> <input type="radio" id='usingType5'
					name='usingType' class='' value="全年放牧" /><label for="usingType5">全年放牧</label>
					<input type="radio" id='usingType6' name='usingType' class=''
					value="禁牧" /><label for="usingType6">禁牧</label> <input type="radio"
					id='usingType7' name='usingType' class='' value="其他" /><label
					for="usingType7">其他</label></td>
			</tr>
			<tr>
				<td class='TableData'>利用状况：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='usingStatus1' name='usingStatus' class='' value="未利用" checked="checked"/><label
					for="usingStatus1">未利用</label> <input type="radio"
					id='usingStatus2' name='usingStatus' class='' value="轻度利用" /><label
					for="usingStatus2">轻度利用</label> <input type="radio"
					id='usingStatus3' name='usingStatus" class='' value="合理利用" /><label
					for="usingStatus3">合理利用</label> <input type="radio"
					id='usingStatus4' name='usingStatus' class='' value="超载" /><label
					for="usingStatus4">超载</label> <input type="radio" id='usingStatus5'
					name='usingStatus' class='' value="严重超载" /><label
					for="usingStatus5">严重超载</label></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">评价</td>
			</tr>
			<tr>
				<td class='TableData'>综合评价：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='evaluation1' name='evaluation' class='' value="好" checked="checked"/><label
					for="evaluation1">好</label> <input type="radio" id='evaluation2'
					name='evaluation' class='' value="中" /><label for="evaluation2">中</label>
					<input type="radio" id='evaluation3' name='evaluation' class=''
					value="差" /><label for="evaluation3">差</label></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor">
						<div class="attachContainorDiv" style="margin-left:20px;float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
							    <input type="file" id="sa_np_landscape_photo" name="sa_np_landscape_photo" onchange="change(this)"/>
					        	请选择景观照片文件
					        </p>
					        
					    </div>
					    <i style="float: left;">*</i>
					</div>
				</td>
			</tr>

		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='investigateDataId' name='investigateDataId' />
	</form>
</body>
</html>