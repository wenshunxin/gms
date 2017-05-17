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
<script>
var id = '<%=id%>';
function getHerbQuadratById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsHerbQuadratController/getHerbQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			var itemList= json.rtData.herbQuadratItem;
			getItemList(itemList);
			var dataId = json.rtData.basicInfo.investigateDataId;
			var saId = json.rtData.basicInfo.sampleAreaId;
			queryAuditRecords(dataId,saId,id);
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

function getItemList(itemList){
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
		$("#grassAvgAmount").before(template);
	}
	var avgFreshAmount = parseFloat($("#freshAmount").text()/10).toFixed(2);
	var avgEdibleFreshAmount = parseFloat($("#edibleFreshAmount").text()/10).toFixed(2);
	var avgDryAmount = parseFloat($("#dryAmount").text()/10).toFixed(2);
	var avgEdibleDryAmount = parseFloat($("#edibleDryAmount").text()/10).toFixed(2);
	$("#avgFreshAmount").text(avgFreshAmount);
	$("#avgEdibleFreshAmount").text(avgEdibleFreshAmount);
	$("#avgDryAmount").text(avgDryAmount);
	$("#avgEdibleDryAmount").text(avgEdibleDryAmount);
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
				<td class='TableData'>东经：</td>
				<td class='TableData'><span id='longitude' name='longitude'></span>度</td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><span id='latitude' name='latitude'></span>度</td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData'><span id='quadratNumber'
					name='quadratNumber'></span></td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><span id='altitude' name='altitude'></span>米</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'>样方面积：</td>
				<td class='TableData'><span id='quadratSize' name='quadratSize'>m²</span></td>
				<td class='TableData'>植被盖度：</td>
				<td class='TableData'><span id='coverage' name='coverage'></span>%</td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'><span id='grassAvgHeight'
					name='grassAvgHeight'></span>厘米</td>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><span id='litters' name='litters'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>植物种数：</td>
				<td class='TableData'><span id='plantNums' name='plantNums'></span>种</td>
				<td class='TableData'>主要植物：</td>
				<td class='TableData'><span id='mainPlant' name='mainPlant'></span></td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><span id='badGrassNums'
					name='badGrassNums'></span>种</td>
				<td class='TableData'>主要毒害草名称：</td>
				<td class='TableData'><span id='mainBadGrass'
					name='mainBadGrass'></span></td>
			</tr>
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">产草量测定</td>
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
						<tr id="grassAvgAmount">
							<td class="TableData" align='center'>平均</td>
							<td class="TableData"><span id='avgFreshAmount'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmount'></span></td>
							<td class="TableData"><span id='avgDryAmount'></span></td>
							<td class="TableData"><span id='avgEdibleDryAmount'></span></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class='TableData'>总产草量鲜重：</td>
				<td class='TableData'><span id='freshAmount' name='freshAmount'></span>千克/公顷</td>
				<td class='TableData'>总产草量风干重：</td>
				<td class='TableData'><span id='dryAmount' name='dryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData'><span id='edibleFreshAmount'
					name='edibleFreshAmount'></span>千克/公顷</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData'><span id='edibleDryAmount'
					name='edibleDryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><span id="remark"
					name="remark"></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor">
						<div class="attachContainorDiv" style="margin-left:20px;">
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