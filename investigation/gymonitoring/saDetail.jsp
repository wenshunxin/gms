<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String type = (String)request.getParameter("type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script type="text/javascript" src="<%=contextPath%>//investigation/common/detail.js"></script>
</head>
<script>
var id = '<%=id%>';
var type = '<%=type%>';

function getGreenYellowSampleAreaById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsGreenYellowSampleAreaController/getGreenYellowSampleAreaById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var basicInfo = json.rtData.basicInfo;
			bindJsonObj2Cntrl(basicInfo);
			if(basicInfo.sampleAreaType==0){
				$("#dateTitle").text("返青日期：");
			}else {
				$("#dateTitle").text("枯黄日期：");
			}
			getCategoryName("GRASSLAND_TYPE",basicInfo.grassCategory,"grassCategory");
			getCategoryName("GRASSLAND_TYPE_"+basicInfo.grassCategory,basicInfo.grassType,"grassType");
			//$("#year").text(json.rtData.year);
			var dataId = json.rtData.basicInfo.investigateDataId;
			queryAuditRecords(dataId,id,0);
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
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0; width: 100%; height: 100%;" onload="getGreenYellowSampleAreaById();">
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
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;margin-bottom:60px;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<!-- <td class='TableData'>调查年份：</td>
				<td class='TableData'><span id='year' name='year'
					autocomplete="off"> </span></td> -->
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><span id='investigateDate'
					name='investigateDate'></span></td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><span id='altitude' name='altitude'></span>米</td>
			</tr>
			<tr>
				
				
				<td class='TableData'>东经：</td>
				<td class='TableData'><span id='longitude' name='longitude'></span>度</td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><span id='latitude' name='latitude'></span>度</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span id='investigateUserNames'
					name='investigateUserNames'></span></td>
				<td class='TableData'>调查单位：</td>
				<td class='TableData'><span id='investigateCompanyName'
					name='investigateCompanyName'></span></td>
				
			</tr>
			<tr>
				<td class='TableData' >样地编号：</td>
				<td class='TableData' colspan="3"><span id='sampleAreaNumber'
					name='sampleAreaNumber'></span></td>
				
			</tr>
			<tr>
				<td class='TableData'>调查区域：</td>
				<td class='TableData' colspan="3"><span id='investigateArea'
					name='investigateArea'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData' colspan="3"><span id='grassCategory'></span></td>
			</tr>
			<tr>
				<td class='TableData'>草地型：</td>
				<td class='TableData' colspan="3"><span id='grassType'></span></td>
			</tr>
			<tr>
				<td class='TableData'>地形地貌：</td>
				<td class='TableData' colspan="3"><span id='grassLandscape'
					name='grassLandscape'></span></td>
			</tr>
			<tr>
				<td class='TableData'>牧草种类：</td>
				<td class='TableData' colspan="3"><span id='mainGrassTypes'
					name='mainGrassTypes'></span>种</td>
			</tr>
			<tr>
				<td class='TableData' id="dateTitle"></td>
				<td class='TableData' colspan="3"><span id='changeDate'
					name='changeDate'></span></td>
			</tr>
			<tr>
				<td class='TableData'>与常年比较：</td>
				<td class='TableData' colspan="3"><span id="changeDaysType"
					name="changeDaysType"> </span> <span id='changeDaysNum'
					name='changeDaysNum'></span>天</td>
			</tr>
			<tr>
				<td class='TableData'>与上年比较：</td>
				<td class='TableData' colspan="3"><span id="preYearDaysType"
					name="preYearDaysType"> </span> <span id='preYearDaysNum'
					name='preYearDaysNum'></span>天</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">利用</td>
			</tr>
			<tr>
				<td class='TableData'>利用方式：</td>
				<td class='TableData' colspan="3"><span id='usingType'
					name='usingType'></span></td>
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
					<div id="attachContainor" >
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