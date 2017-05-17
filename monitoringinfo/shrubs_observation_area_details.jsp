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
	 if(parent.document.getElementById("monitoringStationsId")){
		 var stationId = parent.document.getElementById("monitoringStationsId").value;
		 if(stationId==""){
			 return;
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
	 }
	 var stationId = findById();
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
});

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
				var monitoringPeriod = basicInfo.monitoringPeriod;
				if(monitoringPeriod==0){
					$("#monitoringPeriod").text("返青期");
				}else if(monitoringPeriod==1){
					$("#monitoringPeriod").text("盛期");
				}else if(monitoringPeriod==2){
					$("#monitoringPeriod").text("枯黄期");
				}
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
</script>
</head>
<body style="overflow-y:scroll;margin-bottom:30px ; font-size: 12px; margin-top:10px;">
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
				<td class='TableData'><span id='investigateDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span  id='investigateUserNames'></span> </td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><span  id='contactPhone' ></span> </td>
			</tr>
			<tr>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'>
					<span id="hasLitter" ></span>
				</td>
				<td class='TableData'>覆沙情况：</td>
				<td class='TableData'>
					<span id="hasSand"></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>侵蚀情况：</td>
				<td class='TableData'>
				<span id="hasSurfaceErosion"></span>
				</td>
				<td class='TableData'>侵蚀原因：</td>
				<td class='TableData'>
				<span id="erosionReason" ></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>盐碱斑：</td>
				<td class='TableData'>
				<span id="hasSalineSpot" ></span>
				</td>
					<td class='TableData'>裸地面积比例：</td>
				<td class='TableData'><span id='bareLandAreaRatio'></span>%</td>
			</tr>
			<tr>
					<td class='TableData'>土壤含水量测定：</td>
				<td class='TableData'><span id='soilMoisture'></span>%</td>
					<td class='TableData'>物候期：</td>
				<td class='TableData'>
				<span id="monitoringPeriod"></span>
				</td>
			</tr>
			<tr>
					<td class='TableData'>总盖度：</td>
				<td class='TableData'><span id='coverage'></span>%</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内草本及矮小灌木</td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'>
					<span id='herbGrassAvgHeight'></span>厘米
				 </td>
				 <td class='TableData'>植被种数：</td>
				<td class='TableData'><span id='herbPlantNums'></span>种</td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><span id='herbBadGrassNums'></span>种</td>
					<td class='TableData'>主要植物种名称：</td>
				<td class='TableData' colspan="3"><span id='herbMainPlant'></span> </td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">测产样方1</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='firstFreshAmount'></span>克/平方米</td>
					<td class='TableData'>可食鲜重：</td>
				<td class='TableData'><span id='firstEdibleFreshAmount'></span>克/平方米</td>
			</tr>
			<tr>
				<td class='TableData'>干重：</td>
				<td class='TableData'><span id='firstDryAmount'></span>克/平方米</td>
					<td class='TableData'>可食干重：</td>
				<td class='TableData'><span id='firstEdibleDryAmount'></span>克/平方米</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">测产样方2</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='secondFreshAmount'></span>克/平方米</td>
					<td class='TableData'>可食鲜重：</td>
				<td class='TableData'><span id='secondEdibleFreshAmount'></span>克/平方米</td>
			</tr>
			<tr>
				<td class='TableData'>干重：</td>
				<td class='TableData'><span id='secondDryAmount'></span>克/平方米</td>
					<td class='TableData'>可食干重：</td>
				<td class='TableData'><span id='secondEdibleDryAmount'></span>克/平方米</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">测产样方3</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='thirdFreshAmount'></span>克/平方米</td>
					<td class='TableData'>可食鲜重：</td>
				<td class='TableData'><span id='thirdEdibleFreshAmount'></span>克/平方米</td>
			</tr>
			<tr>
				<td class='TableData'>干重：</td>
				<td class='TableData'><span id='thirdDryAmount'></span>克/平方米</td>
					<td class='TableData'>可食干重：</td>
				<td class='TableData'><span id='thirdEdibleDryAmount'></span>克/平方米</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">平均产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='herbAvgFreshAmount'></span>千克/公顷</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><span id='herbAvgDryAmount' name='herbAvgDryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">可食产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='herbAvgEdibleFreshAmount'></span>千克/公顷</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><span id='herbAvgEdibleDryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">总产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='freshAmount'></span>千克/公顷</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><span id='dryAmount'></span>千克/公顷</td>
			</tr>
			
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内高大草本及灌木</td>
			</tr>
			<tr>
				<td class='TableData'>灌丛平均高度：</td>
				<td class='TableData'>
					<span id='shrubsAvgHeight'></span>厘米
				 </td>
				 <td class='TableData'>植被种数：</td>
				<td class='TableData'><span id='shrubsNums'></span>种</td>
			</tr>
			<tr>
				<td class='TableData'>100平方米内灌木覆盖面积：</td>
				<td class='TableData'><span id='shrubsCoverageSize'></span>平方米</td>
					<td class='TableData'>主要植物种名称：</td>
				<td class='TableData' colspan="3"><span id='shrubsMainNames'></span> </td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">灌木产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='shrubsFreshAmount'></span>千克/公顷</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><span id='shrubsDryAmount'></span>千克/公顷</td>
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
					    </div>
					  </div>
					 <div id="attachContainorQuadrat2">
					    <div class="attachContainorDiv" style="margin-right:30px;float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					    </div>
					 </div>
					 <div id="attachContainorQuadrat3">
					    <div class="attachContainorDiv" style="float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
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
					<td class='TableData'><span id='permanentCoverage'></span>(%)</td>
						<td class='TableData'>草群平均高度：</td>
					<td class='TableData'><span id='permanentGrassAvgHeight'></span>(厘米)</td>
				</tr>
				<tr>
					<td class='TableData'>灌丛平均高度：</td>
					<td class='TableData'><span id='permanentShrubsAvgHeight'></span>(厘米)</td>
				</tr>
				<tr>
					<td class="TableHeader" style="text-align: left;" colspan="4">永久观测区照片</td>
				</tr>
				<tr>
					<td class='TableData'>选择景观照照片：</td>
					<td class='TableData' colspan="3">
						<div id="attachContainor">
							<div class="attachContainorDiv" style="margin-right: 30px;float: left;">
								<div class="temImg" onclick="getImg_W_H.call(this)">
									<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
								</div>
						    </div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</form>	
</body>
</html>