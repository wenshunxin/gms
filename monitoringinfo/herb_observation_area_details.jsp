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
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var id = '<%= id %>';
function findGhoaBySID(){
	if(id!="null" && id!=null){
		var url = contextPath+"/ghoaController/getGhoaById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var basicInfo = json.rtData.basicInfo;
			bindJsonObj2Cntrl(basicInfo);
			var cityJson = getCityFullInfo(basicInfo.cityCode);
			if(cityJson){
				var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
				$("#cityCode").text(cityDesc);
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
}
</script>
</head>
<body onload="findGhoaBySID();" style="overflow-y:scroll; font-size: 12px;margin: 10px auto 20px;">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">详细信息</td>
			</tr>
			<tr>
				<td class='TableData' colspan="1" style="width:15%;">监测点编号：</td>
				<td class='TableData' colspan="3"><span id="stationsNum"></span></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>
				<span id='cityCode'></span>
				</td>
				<td class='TableData'>调查日期：</td>
				<td class='TableData'><span id='investigateDate' ></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span  id='investigateUserNames'></span></td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><span  id='contactPhone'></span></td>
			</tr>
			<tr>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><span id="hasLitter"></span></td>
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
				<span id="erosionReason"></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>盐碱斑：</td>
				<td class='TableData'>
				<span id="hasSalineSpot"></span>
				</td>
					<td class='TableData'>裸地面积比例：</td>
				<td class='TableData'><span id='bareLandAreaRatio'></span>% </td>
			</tr>
			<tr>
					<td class='TableData'>土壤含水量测定：</td>
				<td class='TableData'><span id='soilMoisture'></span>%</td>
					<td class='TableData'>物候期：</td>
				<td class='TableData'>
				<span id='monitoringPeriod'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物盖度：</td>
				<td class='TableData'><span id='coverage'></span>%</td>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'>
					<span id='grassAvgHeight'></span>厘米
				 </td>
			</tr>
			<tr>
				<td class='TableData'>植被种数：</td>
				<td class='TableData'><span id='plantNums'></span>种 </td>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><span id='badGrassNums'></span>种</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物种名称：</td>
				<td class='TableData' colspan="3"><span id='mainPlant'></span> </td>
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
				<td class="TableHeader" style="text-align: left;" colspan="4">总产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='freshAmount'></span>千克/公顷</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><span id='dryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">可食产草量折算</td>
			</tr>
			<tr>
				<td class='TableData'>鲜重：</td>
				<td class='TableData'><span id='edibleFreshAmount'></span>千克/公顷</td>
					<td class='TableData'>干重：</td>
				<td class='TableData'><span id='edibleDryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">景观照</td>
			</tr>
			<tr>
				<td class='TableData'>景观照照片：</td>
				<td class='TableData' colspan="3">
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
				<td class='TableData'>样方照照片：</td>
				<td class='TableData' colspan="3">
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
		</table>
</body>
</html>