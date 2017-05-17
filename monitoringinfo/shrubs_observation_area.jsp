<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String id = request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/check.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script src="<%=contextPath %>/monitoringinfo/monitoring.js"></script>
<script>

var datagrid;
var id = '<%= id %>';
$(function(){
	//灌木调查里面的数据自动填充
	$(".fresh").on('keyup',function(){
	 	var totial=null;
	 	var num=$("#firstFreshAmount").val();
	 	num=parseFloat(num==""?0:num);
	 	var num1=$("#secondFreshAmount").val();
	 	num1=parseFloat(num1==""?0:num1);
	 	var num2=$("#thirdFreshAmount").val();
	 	num2=parseFloat(num2==""?0:num2); 
	 	totial=parseFloat((num+num1+num2)*10/3)
	 	$("#herbAvgFreshAmount").val(totial.toFixed(2));
	 })
	$(".dry").on('keyup',function(){
	 	var totial=null;
	 	var num=$("#firstDryAmount").val();
	 	num=parseFloat(num==""?0:num);
	 	var num1=$("#secondDryAmount").val();
	 	num1=parseFloat(num1==""?0:num1);
	 	var num2=$("#thirdDryAmount").val();
	 	num2=parseFloat(num2==""?0:num2); 
	 	totial=parseFloat((num+num1+num2)*10/3)
	 	$("#herbAvgDryAmount").val(totial.toFixed(2));
	})
	$(".edibleFresh").on('keyup',function(){
	 	var totial=null;
	 	var num=$("#firstEdibleFreshAmount").val();
	 	num=parseFloat(num==""?0:num);
	 	var num1=$("#secondEdibleFreshAmount").val();
	 	num1=parseFloat(num1==""?0:num1);
	 	var num2=$("#thirdEdibleFreshAmount").val();
	 	num2=parseFloat(num2==""?0:num2); 
	 	totial=parseFloat((num+num1+num2)*10/3)
	 	$("#herbAvgEdibleFreshAmount").val(totial.toFixed(2));
	})
	$(".edibleDry").on('keyup',function(){
	 	var totial=null;
	 	var num=$("#firstEdibleDryAmount").val();
	 	num=parseFloat(num==""?0:num);
	 	var num1=$("#secondEdibleDryAmount").val();
	 	num1=parseFloat(num1==""?0:num1);
	 	var num2=$("#thirdEdibleDryAmount").val();
	 	num2=parseFloat(num2==""?0:num2); 
	 	totial=parseFloat((num+num1+num2)*10/3)
	 	$("#herbAvgEdibleDryAmount").val(totial.toFixed(2));
	})
	$(".total , .fresh").on('keyup',function(){
		var num=$("#shrubsCoverageSize").val();
		num=parseFloat(num==""?0:num);
		var num1=$("#shrubsFreshAmount").val();
		num1=parseFloat(num1==""?0:num1);
		var num2=$("#herbAvgFreshAmount").val();
		num2=parseFloat(num2==""?0:num2);
		$("#freshAmount").val(parseFloat(num2*(100-num)/100+num1).toFixed(2))
	})
	$(".totalDry , .dry").on('keyup',function(){
		var num=$("#shrubsCoverageSize").val();
		num=parseFloat(num==""?0:num);
		var num1=$("#shrubsDryAmount").val();
		num1=parseFloat(num1==""?0:num1);
		var num2=$("#herbAvgDryAmount").val();
		num2=parseFloat(num2==""?0:num2);
		$("#dryAmount").val(parseFloat(num2*(100-num)/100+num1).toFixed(2))
	});
	
	$("#hasSurfaceErosion").change(function(){
		if($(this).val()=="有"){
			$("#erosionReason").removeAttr("disabled");
			$("#erosionReason").removeClass("readonly");
			$("#erosionReason").val("风蚀");
		}else{
			$("#erosionReason").attr("disabled","disabled");
			$("#erosionReason").addClass("readonly");
			$("#erosionReason").val("");
		}
	});
})
function doInit(){
	 $("#investigateDate").datetimepicker({
		 language:"zh-CN",   
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 })
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 var stationId="";
	 if(parent.document.getElementById("monitoringStationsId")){
		 stationId = parent.document.getElementById("monitoringStationsId").value;
	 }else{
		 stationId = findById();
	 }
	 var url = contextPath+"/monitoringStationsController/getMonitoringStationsById.act?sid="+stationId;
	 var json = tools.requestJsonRs(url);
	 if(json.rtState){
		var basicInfo = json.rtData.basicInfo;
		$("#stationsNum").text(basicInfo.stationsNum);
		var cityJson = getCityFullInfo(basicInfo.cityCode);
		
		if(cityJson){
			var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
			$("#stationAddress").text(cityDesc);
		}
	 }else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	 $("#monitoringStationsId").val(stationId);
	 var stationsType = returnStationType();
	 $("#stationsType").val(stationsType);
	 if(stationsType>0){
		 $("#permanentInfo").remove();
	 }
	 
	 if($("#hasSurfaceErosion").val()=="有"){
		$("#erosionReason").removeAttr("disabled");
		$("#erosionReason").removeClass("readonly");
	 }else{
		$("#erosionReason").attr("disabled","disabled");
		$("#erosionReason").addClass("readonly");
		$("#erosionReason").val("");
	 }
	
}


function saveGsoa(){
	if($("#form1").form("validate") && check()){
		var url = contextPath+"/gsoaController/saveGsoaInfo.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gsoaController/updateGsoa.act";
		}
		if($("#hasSurfaceErosion").val()=="无"){
			url+="?erosionReason=";
		}
		top.$.jBox.tip("数据正在保存","loading");
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			dataType:"text/html",  
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					top.$.jBox.tip(json.rtMsg,"success");
					if(id!="null" && id!=null){
						var content = top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow;
						content.$("#tabss").tabs("getSelected").find("iframe")[0].contentWindow.datagrid.datagrid('reload');
						top.$(".jbox-body").remove();
					}else{
						$("#form1").resetForm();
						$(".delectImg").remove();
						$(".preview").attr("src",contextPath+"/resource/images/sys/fileImg.png");
					}
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}

function findById(){
	 var stationId="";
	 if(id!="null" && id!=null){
			$("input[type='button']").remove();
		 	$("#permanentInfo").remove();
			var url = contextPath+"/gsoaController/getGsoaById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				//基本信息
				var basicInfo = json.rtData.basicInfo;
				bindJsonObj2Cntrl(basicInfo);
				stationId = basicInfo.monitoringStationsId;
				var cityJson = getCityFullInfo(basicInfo.cityCode);
				if(cityJson){
					var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
					$("#stationAddress").text(cityDesc);
				}
				$("#monitoringPeriod").val(basicInfo.monitoringPeriod);
				//照片
				var attachList1 = json.rtData.attachList1;
				for(var i = 0 ;i<attachList1.length;i++){
					var attach = attachList1[i];
					var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
					$("#attachContainorLand .preview").attr("src",encodeURI(attachUrl));
				}
				var quadratAttach1 = json.rtData.quadratAttach1;
				for(var i = 0 ;i<quadratAttach1.length;i++){
					var attach = quadratAttach1[i];
					var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
					$("#attachContainorQuadrat1 .preview").attr("src",encodeURI(attachUrl));
				}
				var quadratAttach2 = json.rtData.quadratAttach2;
				for(var i = 0 ;i<quadratAttach2.length;i++){
					var attach = quadratAttach2[i];
					var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
					$("#attachContainorQuadrat2 .preview").attr("src",encodeURI(attachUrl));
				}
				var quadratAttach3 = json.rtData.quadratAttach3;
				for(var i = 0 ;i<quadratAttach3.length;i++){
					var attach = quadratAttach3[i];
					var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
					$("#attachContainorQuadrat3 .preview").attr("src",encodeURI(attachUrl));
				}
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	 return stationId;
}

function check(){
	var attachContainorLand=$("#attachContainorLand").find("img.preview").attr("src");
	var  src=contextPath+"/resource/images/sys/fileImg.png";
	if(attachContainorLand==src){	
		top.$.jBox.tip("景观照片不能为空！","error");
		$("#gsoa_landscape_photo").focus();
		return false;
	}
	var attachContainorQuadrat1=$("#attachContainorQuadrat1").find("img.preview").attr("src");
	var attachContainorQuadrat2=$("#attachContainorQuadrat2").find("img.preview").attr("src");
	var attachContainorQuadrat3=$("#attachContainorQuadrat3").find("img.preview").attr("src");
	if((attachContainorQuadrat1==src) && (attachContainorQuadrat2==src) &&(attachContainorQuadrat3==src)){
		top.$.jBox.tip("必须选择一张样方照片！","error");
		$("#gsoa_quadrat_photo_first").focus();
		return false;
	}
	var attachContainor=$("#attachContainor").find("img.preview").attr("src");
	var stationsType=$("#stationsType").val();
	if( stationsType==0 &&attachContainor==src){
		top.$.jBox.tip("永久观测区景观照片不能为空！","error");
		$("#gsoa_perpetual_photo").focus();
		return false;
	}
	return true;
}
</script>
</head>
<body onload="doInit();" style="overflow-y:scroll;margin-bottom:30px ; font-size: 12px; margin-top:10px;">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data" >
		<table class='TableBlock' style='width: 95%; margin: 0px auto;height:auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData' style="width:15%;">监测点编号：</td>
				<td class='TableData' colspan="3"><span id="stationsNum"></span></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>
 					<span id="stationAddress"></span>
				</td>
				<td class='TableData'>调查日期：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly" id='investigateDate' name='investigateDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text" id='investigateUserNames'
					name='investigateUserNames' class="BigInput" maxlength="20" /> </td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><input type="text" id='contactPhone'
					name='contactPhone' class="BigInput easyui-validatebox" validType="" maxlength="13" /> </td>
			</tr>
			<tr>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'>
					<select name="hasLitter" id="hasLitter" class="SmallSelect easyui-combobox easyui-validatebox" required="true" style="width:92px;height:26px;line-height: 26px;">
						<option value="有">有</option>
						<option value="无">无</option>
					</select>
				</td>
				<td class='TableData'>覆沙情况：</td>
				<td class='TableData'>
					<select name="hasSand" id="hasSand" class="SmallInput easyui-combobox easyui-validatebox" required="true" style="width:92px;height:26px;line-height: 26px;">
						<option value="有">有</option>
						<option value="无">无</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class='TableData'>侵蚀情况：</td>
				<td class='TableData'>
					<select name="hasSurfaceErosion" id="hasSurfaceErosion" class="SmallInput easyui-combobox easyui-validatebox" required="true" style="width:92px;height:26px;line-height: 26px;">
						<option value="有">有</option>
						<option value="无">无</option>
					</select>
				</td>
				<td class='TableData'>侵蚀原因：</td>
				<td class='TableData'>
					<select name="erosionReason" id="erosionReason" class="SmallInput easyui-combobox easyui-validatebox" required="true" style="width:92px;height:26px;line-height: 26px;">
						<option value="风蚀">风蚀</option>
						<option value="水蚀">水蚀</option>
						<option value="冻蚀">冻蚀</option>
						<option value="超载">超载</option>
						<option value="其他">其他</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class='TableData'>盐碱斑：</td>
				<td class='TableData'>
					<select name="hasSalineSpot" id="hasSalineSpot" class="SmallInput easyui-combobox easyui-validatebox"  required="true" style="width:92px; height:26px;line-height: 26px;">
						<option value="有">有</option>
						<option value="无">无</option>
					</select>
				</td>
					<td class='TableData'>裸地面积比例：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validType="numberBetweenLength[0,100] & addMethodf[]" required="true" id='bareLandAreaRatio'
					name='bareLandAreaRatio'/>(%) </td>
			</tr>
			<tr>
					<td class='TableData'>土壤含水量测定：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validType="numberBetweenLength[0,100] & addMethod[]" required="true" id='soilMoisture'
					name='soilMoisture'/>(%) </td>
					<td class='TableData'>物候期：</td>
				<td class='TableData'>
					<select name="monitoringPeriod" id="monitoringPeriod" class="BigSelect easyui-validatebox" required="true" style="width:92px; height:26px;line-height: 26px;">
						<option value="">请选择物候期</option>
						<option value="0">返青期</option>
						<option value="1">盛期</option>
						<option value="2">枯黄期</option>
					</select> 
				</td>
			</tr>
			<tr>
					<td class='TableData'>总盖度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validType="numberBetweenLength[0,100] & addMethod[]" required="true" id='coverage'
					name='coverage'/>(%)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内草本及矮小灌木</td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'>
					<input type="text" class="SmallInput easyui-validatebox" validType="numberBetweenLength[0,80] & addMethod[]" required="true" id='herbGrassAvgHeight'
					name='herbGrassAvgHeight'/>(厘米)
				 </td>
				 <td class='TableData'>植被种数：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="positivIntege[]" id='herbPlantNums'
					name='herbPlantNums' />(种)</td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZero[]" id='herbBadGrassNums'
					name='herbBadGrassNums' /> (种)</td>
					<td class='TableData'>主要植物种名称：</td>
				<td class='TableData' colspan="3"><input type="text" class="BigInput easyui-validatebox" required="true" validType="isBlank[]"  id='herbMainPlant'
					name='herbMainPlant' /> </td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">测产样方1</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox fresh' required="true" validType="integeZerol[] &addMethod[]" id='firstFreshAmount'
					name='firstFreshAmount'/>(克/平方米)</td>
					<td class='TableData'>可食鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox edibleFresh' required="true" validType="integeZerol[] &addMethod[] &edibleFreshValid[]" id='firstEdibleFreshAmount'
					name='firstEdibleFreshAmount'/>(克/平方米)</td>
			</tr>
			<tr>
				<td class='TableData'>干重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox dry' required="true" validType="integeZerol[] &addMethod[] & dryFreshValid[]" id='firstDryAmount'
					name='firstDryAmount'/>(克/平方米)</td>
					<td class='TableData'>可食干重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox edibleDry' required="true" validType="integeZerol[] &addMethod[] & edibleDryValid[] & edible[]" id='firstEdibleDryAmount'
					name='firstEdibleDryAmount'/>(克/平方米)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">测产样方2</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox fresh' required="true" validType="integeZerol[] &addMethod[]" id='secondFreshAmount'
					name='secondFreshAmount'/>(克/平方米)</td>
					<td class='TableData'>可食鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox edibleFresh' required="true" validType="integeZerol[] & addMethod[] & edibleFreshValids[]" id='secondEdibleFreshAmount'
					name='secondEdibleFreshAmount'/>(克/平方米)</td>
			</tr>
			<tr>
				<td class='TableData'>干重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox dry' required="true" validType="integeZerol[] &addMethod[] & dryFreshValids[]" id='secondDryAmount'
					name='secondDryAmount'/>(克/平方米)</td>
					<td class='TableData'>可食干重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox edibleDry' required="true" validType="integeZerol[] &addMethod[] & edibleDryValids[] & edibles[]" id='secondEdibleDryAmount'
					name='secondEdibleDryAmount'/>(克/平方米)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">测产样方3</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox fresh' required="true" validType="integeZerol[] &addMethod[]" id='thirdFreshAmount'
					name='thirdFreshAmount'/>(克/平方米)</td>
					<td class='TableData'>可食鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox edibleFresh' required="true" validType="integeZerol[] &addMethod[] &edibleFreshValidt[]" id='thirdEdibleFreshAmount'
					name='thirdEdibleFreshAmount'/>(克/平方米)</td>
			</tr>
			<tr>
				<td class='TableData'>干重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox dry' required="true" validType="integeZerol[] &addMethod[] & dryFreshValidt[]" id='thirdDryAmount'
					name='thirdDryAmount'/>(克/平方米)</td>
					<td class='TableData'>可食干重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox edibleDry' required="true" validType="integeZerol[] &addMethod[] & edibleDryValidt[] & ediblet[]" id='thirdEdibleDryAmount'
					name='thirdEdibleDryAmount'/>(克/平方米)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">平均产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput readonly' readonly="readonly" id='herbAvgFreshAmount'
					name='herbAvgFreshAmount'/>(千克/公顷)</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><input type="text" class='SmallInput readonly' readonly="readonly" id='herbAvgDryAmount'
					name='herbAvgDryAmount'/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">可食产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput readonly' readonly="readonly" id='herbAvgEdibleFreshAmount'
					name='herbAvgEdibleFreshAmount'/>(千克/公顷)</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><input type="text" class='SmallInput readonly' readonly="readonly" id='herbAvgEdibleDryAmount'
					name='herbAvgEdibleDryAmount'/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">总产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput readonly' readonly="readonly" id='freshAmount'
					name='freshAmount'/>(千克/公顷)</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><input type="text" class='SmallInput readonly' readonly="readonly" id='dryAmount'
					name='dryAmount'/>(千克/公顷)</td>
			</tr>
			
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内高大草本及灌木</td>
			</tr>
			<tr>
				<td class='TableData'>灌丛平均高度：</td>
				<td class='TableData'>
					<input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerollf[] &addMethod[]" id='shrubsAvgHeight'
					name='shrubsAvgHeight'/>(厘米)
				 </td>
				 <td class='TableData'>植被种数：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="positivIntege[]" id='shrubsNums'
					name='shrubsNums' />(种)</td>
			</tr>
			<tr>
				<td class='TableData'>100平方米内灌木覆盖面积：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox total totalDry" required="true" validType="numberBetweenLength[0,100] & addMethod[]" id='shrubsCoverageSize'
					name='shrubsCoverageSize' />(平方米) </td>
					<td class='TableData'>主要植物种名称：</td>
				<td class='TableData' colspan="3"><input type="text" class="BigInput easyui-validatebox" required="true" validType="isBlank[]" id='shrubsMainNames'
					name='shrubsMainNames' /> </td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">灌木产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox total' required="true" validType="integeZeroln[] & addMethod[]" id='shrubsFreshAmount'
					name='shrubsFreshAmount'/>(千克/公顷)</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><input type="text" class='SmallInput easyui-validatebox totalDry' required="true" validType="integeZerol[] &addMethod[] &shrubsFreshAmount[]" id='shrubsDryAmount'
					name='shrubsDryAmount'/>(千克/公顷)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">景观照</td>
			</tr>
			<tr>
				<td class='TableData'>选择景观照照片：</td>
				<td class='TableData' colspan="4">
					<div id="attachContainorLand">
						<div class="attachContainorDiv" style="margin-left:0px;">
							
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="gsoa_landscape_photo" name="gsoa_landscape_photo" onchange="change(this)" />
					        请选择景观照片文件</p>
					    </div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">样方照</td>
			</tr>
			<tr>
				<td class='TableData'>选择样方照照片：</td>
				<td class='TableData' colspan="4">
					<div id="attachContainorQuadrat1">
						<div class="attachContainorDiv" style="margin-right:30px;float: left;">
							
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="gsoa_quadrat_photo_first" name="gsoa_quadrat_photo_first" onchange="change(this)"/>
					        请选择样方一照片文件</p>
					    </div>
					  </div>
					 <div id="attachContainorQuadrat2">
					    <div class="attachContainorDiv" style="margin-right:30px;float: left;">
							
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="gsoa_quadrat_photo_second" name="gsoa_quadrat_photo_second" onchange="change(this)" />
					        请选择样方二照片文件</p>
					    </div>
					 </div>
					 <div id="attachContainorQuadrat3">
					    <div class="attachContainorDiv" style="float: left;">
							
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="gsoa_quadrat_photo_third" name="gsoa_quadrat_photo_third" onchange="change(this)"/>
					        请选择样方三照片文件</p>
					    </div>
					</div>
				</td>
			</tr>
			<tbody id="permanentInfo">
				<tr>
					<td class="TableHeader" style="text-align: left;" colspan="4">永久观测区监测值</td>
				</tr>
				<tr>
					<td class='TableData'>植物盖度：</td>
					<td class='TableData'><input type="text" class='SmallInput easyui-validatebox' required="true" validType="numberBetweenLength[0,100] &addMethod[]" id='permanentCoverage'
						name='permanentCoverage'/>(%)</td>
						<td class='TableData'>草群平均高度：</td>
					<td class='TableData'><input type="text" class='SmallInput easyui-validatebox' required="true" validType="numberBetweenLength[0,80] &addMethod[]" id='permanentGrassAvgHeight'
						name='permanentGrassAvgHeight'/>(厘米)</td>
				</tr>
				<tr>
					<td class='TableData'>灌丛平均高度：</td>
					<td class='TableData'><input type="text" class='SmallInput easyui-validatebox' required="true" validType="integeZerollf[] &addMethod[]" id='permanentShrubsAvgHeight'
						name='permanentShrubsAvgHeight'/>(厘米)</td>
				</tr>
				<tr>
					<td class="TableHeader" style="text-align: left;" colspan="4">永久观测区照片</td>
				</tr>
				<tr>
					<td class='TableData'>选择景观照照片：</td>
					<td class='TableData' colspan="3">
						<div id="attachContainor">
							<div class="attachContainorDiv" style="margin-right:30px;float: left;">
								<div class="temImg" onclick="getImg_W_H.call(this)">
									<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
								</div>
						        <p id="p">
									<input type="file" id="gsoa_perpetual_photo" name="gsoa_perpetual_photo" onchange="change(this)" />
						        请选择景观照片文件</p>
						    </div>
						</div>
					</td>
				</tr>
			</tbody>
			<tr>
				<td class="TableHeader" style="text-align:center;" colspan="4">
					<input type="hidden" id="monitoringStationsId" name="monitoringStationsId" />
					<input type="hidden" id="stationsType" name="stationsType" />
					<input type="button" value="提交" class="btn btn-success" style="background:#41a675;" onclick="saveGsoa()" />
					<input type="hidden" id="sid" name="sid" value="<%= id %>"/>
				</td>
			</tr>
		</table>
	</form>	
</body>
</html>