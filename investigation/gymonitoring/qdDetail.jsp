<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String sampleAreaId = request.getParameter("sampleAreaId");
	String type = (String)request.getParameter("type");
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
var sampleAreaId = '<%=sampleAreaId%>';
var type = '<%=type%>';
function getGreenYellowQuadratById(){
	if(type=="g"){
		$("#percentageTitle").text("返青率");
	}else{
		$("#percentageTitle").text("枯黄率");
	}
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsGreenYellowQuadratController/getGreenYellowQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
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
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;" onload="getGreenYellowQuadratById();">
	<table id="auditRecords" class="TableBlock" style='width:90%;margin:0 auto;margin-bottom:10px;'>
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
	<form id="form1" name="form1">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
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
				<td class='TableData'><span id="percentageTitle"></span>：</td>
				<td class='TableData' colspan="3"><span id='percentage'
					name='percentage'></span>%</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor" >
						<div class="attachContainorDiv" style="margin-left:20px;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
						    <!-- <input type="file" id="sa_np_landscape_photo" name="sa_np_landscape_photo" onchange="change(this)" style="display: none;" /> -->
					    </div>
					</div>
				</td>
			</tr>

		</table>
	</form>
</body>
</html>