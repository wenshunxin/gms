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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script type="text/javascript" src="<%=contextPath%>//investigation/common/detail.js"></script>
</head>
<style>
#inOutTr input[type=text] {
	width: 75px;
}
</style>
<script>
var id = '<%=id%>';
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
			//审核记录
			var dataId = json.rtData.quadratIn.investigateDataId;
			var saId = json.rtData.quadratIn.sampleAreaId;
			queryAuditRecords(dataId,saId,id);
			
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
}

function getItemList(itemList,type){
	for(var i = 0 ;i<itemList.length;i++){
		var freshAmount = itemList[i].freshAmount==null?'':itemList[i].freshAmount;
		var edibleFreshAmount = itemList[i].edibleFreshAmount==null?'':itemList[i].edibleFreshAmount;
		var dryAmount = itemList[i].dryAmount==null?'':itemList[i].dryAmount;
		var edibleDryAmount = itemList[i].edibleDryAmount==null?'':itemList[i].edibleDryAmount;
		var template="	<tr>"
			+"<td class='TableData' align='center'>"+(i+1)+"</td>"
			+"<td class='TableData' align='center'><span>"+freshAmount+"</span></td>"
			+"<td class='TableData' align='center'><span>"+edibleFreshAmount+"</span></td>"
			+"<td class='TableData' align='center'><span>"+dryAmount+"</span></td>"
			+"<td class='TableData' align='center'><span>"+edibleDryAmount+"</span></td>"
			+"</tr>";
		$("#grassAvgAmount"+type).before(template);
	}
	var avgFreshAmount = parseFloat($("#freshAmount"+type).text()/10).toFixed(2);
	var avgEdibleFreshAmount = parseFloat($("#edibleFreshAmount"+type).text()/10).toFixed(2);
	var avgDryAmount = parseFloat($("#dryAmount"+type).text()/10).toFixed(2);
	var avgEdibleDryAmount = parseFloat($("#edibleDryAmount"+type).text()/10).toFixed(2);
	$("#avgFreshAmount"+type).text(avgFreshAmount);
	$("#avgEdibleFreshAmount"+type).text(avgEdibleFreshAmount);
	$("#avgDryAmount"+type).text(avgDryAmount);
	$("#avgEdibleDryAmount"+type).text(avgEdibleDryAmount);
}
</script>
<body style="overflow-x: hidden; font-size: 12px;" onload="getHerbQuadratById();">
	<table id="auditRecords" class="TableBlock" style='width:95%;margin:0 auto;margin-bottom:10px;'>
		<tr>
			<td class="TableHeader" colspan='5' style="text-align:left;">审核记录</td>
		</tr>
		<tr>
			<td class="TableData" align="center" width="10%">审核人</td>
			<td class="TableData" align="center" width="10%">审核单位</td>
			<td class="TableData" align="center" width="10%">审核结果</td>
			<td class="TableData" align="center">审核意见</td>
			<td class="TableData" align="center" width="15%">审核时间</td>
		</tr>
	</table>
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><span id='investigateDate'
					name='investigateDate'></span></td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span id='investigateUserNames'
					name='investigateUserNames'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">工程区域内</td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><span id='longitudeIn'
					name='longitudeIn'></span>度</td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><span id='latitudeIn'
					name='latitudeIn'></span>度</td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData'><span id='quadratNumberIn'
					name='quadratNumberIn'></span></td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><span id='altitudeIn'
					name='altitudeIn'></span>米</td>
			</tr>
			<tr>
				<td class='TableData'>样方面积：</td>
				<td class='TableData'><span id='quadratSizeIn'
					name='quadratSizeIn'></span>m²</td>
				<td class='TableData'>植被盖度：</td>
				<td class='TableData'><span id='coverageIn'
					name='coverageIn'></span>%</td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'><span id='grassAvgHeightIn'
					name='grassAvgHeightIn'></span>厘米</td>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><span id='littersIn' name='littersIn'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>植物种数：</td>
				<td class='TableData'><span id='plantNumsIn'
					name='plantNumsIn'></span>种</td>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData'><span id='mainPlantIn'
					name='mainPlantIn'></span></td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><span id='badGrassNumsIn'
					name='badGrassNumsIn'></span>中</td>
				<td class='TableData'>主要毒害草名称：</td>
				<td class='TableData'><span id='mainBadGrassIn'
					name='mainBadGrassIn'></span></td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<table class="TableBlock" width="100%">
						<tr>
							<td class="TableData" align='center'>编号</td>
							<td class="TableData" align='center'>鲜重(g/㎡)</td>
							<td class="TableData" align='center'>可食鲜重(g/㎡)</td>
							<td class="TableData" align='center'>干重(g/㎡)</td>
							<td class="TableData" align='center'>可食干重(g/㎡)</td>
						</tr>
						<tr id="grassAvgAmountIn">
							<td class="TableData" align='center'>平均</td>
							<td class="TableData"><span id='avgFreshAmountIn'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmountIn'></span></td>
							<td class="TableData"><span id='avgDryAmountIn'></span></td>
							<td class="TableData"><span id='avgEdibleDryAmountIn'></span></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class='TableData'>总产草量鲜重：</td>
				<td class='TableData'><span id='freshAmountIn'
					name='freshAmountIn'></span>千克/公顷</td>
				<td class='TableData'>总产草量风干重：</td>
				<td class='TableData'><span id='dryAmountIn'
					name='dryAmountIn'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData'><span id='edibleFreshAmountIn'
					name='edibleFreshAmountIn'></span>千克/公顷</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData'><span id='edibleDryAmountIn'
					name='edibleDryAmountIn'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><span id="remarkIn"
					name="remarkIn"></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">工程区域外</td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><span id='longitudeOut'
					name='longitudeOut'></span>度</td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><span id='latitudeOut'
					name='latitudeOut'></span>度</td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData'><span id='quadratNumberOut'
					name='quadratNumberOut'></span></td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><span id='altitudeOut'
					name='altitudeOut'></span>米</td>
			</tr>
			<tr>
				<td class='TableData'>样方面积：</td>
				<td class='TableData'><span id='quadratSizeOut'
					name='quadratSizeOut'></span>m²</td>
				<td class='TableData'>植被盖度：</td>
				<td class='TableData'><span id='coverageOut'
					name='coverageOut'></span>%</td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'><span id='grassAvgHeightOut'
					name='grassAvgHeightOut'></span>厘米</td>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><span id='littersOut'
					name='littersOut'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>植物种数：</td>
				<td class='TableData'><span id='plantNumsOut'
					name='plantNumsOut'></span>种</td>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData'><span id='mainPlantOut'
					name='mainPlantOut'></span></td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><span id='badGrassNumsOut'
					name='badGrassNumsOut'></span>种</td>
				<td class='TableData'>主要毒害草名称：</td>
				<td class='TableData'><span id='mainBadGrassOut'
					name='mainBadGrassOut'></span></td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<table class="TableBlock" width="100%">
						<tr>
							<td class="TableData" align='center'>编号</td>
							<td class="TableData" align='center'>鲜重(g/㎡)</td>
							<td class="TableData" align='center'>可食鲜重(g/㎡)</td>
							<td class="TableData" align='center'>干重(g/㎡)</td>
							<td class="TableData" align='center'>可食干重(g/㎡)</td>
						</tr>
						<tr id="grassAvgAmountOut">
							<td class="TableData" align='center'>平均</td>
							<td class="TableData"><span id='avgFreshAmountOut'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmountOut'></span></td>
							<td class="TableData"><span id='avgDryAmountOut'></span></td>
							<td class="TableData"><span id='avgEdibleDryAmountOut'></span></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class='TableData'>总产草量鲜重：</td>
				<td class='TableData'><span id='freshAmountOut'
					name='freshAmountOut'></span>千克/公顷</td>
				<td class='TableData'>总产草量风干重：</td>
				<td class='TableData'><span id='dryAmountOut'
					name='dryAmountOut'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData'><span id='edibleFreshAmountOut'
					name='edibleFreshAmountOut'></span>千克/公顷</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData'><span id='edibleDryAmountOut'
					name='edibleDryAmountOut'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><span id="remarkOut"
					name="remarkOut"></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainorIn" style="width:50%;display:inline-block;float:left;">
						<div class="attachContainorDiv">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					    </div>
					</div> 
					<div id="attachContainorOut" style="width:50%;display:inline-block;float:left;">
						<div class="attachContainorDiv">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					    </div>
					</div> 
				</td>
			</tr>

		</table>
	</form>
</body>
</html>