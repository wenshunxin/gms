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
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script type="text/javascript" src="<%=contextPath%>//investigation/common/detail.js"></script>
</head>
<script>
var id = '<%=id%>';
function getSampleAreaById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsSampleAreaController/getSampleAreaById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var basicInfo = json.rtData.basicInfo;
			bindJsonObj2Cntrl(basicInfo);
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
<body style="overflow-x: hidden; font-size: 12px;" onload="getSampleAreaById();">
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
		<table class='TableBlock' style='width: 95%; margin: 0 auto;margin-bottom:60px;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<!-- <td class='TableData'>调查年份：</td>
				<td class='TableData'><span id='year' name='year'> </span></td> -->
				<td class='TableData'>调查时间：</td>
				<td class='TableData' colspan="3"><span id='investigateDate'
					name='investigateDate'></span></td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span id='investigateUserNames'
					name='investigateUserNames'></span></td>
				<td class='TableData'>样地编号：</td>
				<td class='TableData'><span id='sampleAreaNumber'
					name='sampleAreaNumber'></span></td>
			</tr>
			<tr>
				<td class='TableData'>所在区域：</td>
				<td class='TableData' colspan="3"><span id='investigateArea'
					name='investigateArea'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">类型</td>
			</tr>
			<tr>
				<td class='TableData'>具有灌木和高大草木：</td>
				<td class='TableData' colspan="3"><span id='hasShrubs'
					name='hasShrubs'></span></td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><span id='grassCategory'></span></td>
				<td class='TableData'>草地型：</td>
				<td class='TableData'><span id='grassType'></span></td>
			</tr>
			<tr>
				<td class='TableData'>地形地貌：</td>
				<td class='TableData'><span id='grassLandscape'
					name='grassLandscape'></span></td>
				<td class='TableData'>土壤质地：</td>
				<td class='TableData'><span id='soilTexture' name='soilTexture'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>坡向：</td>
				<td class='TableData'><span id='grassSlope' name='grassSlope'></span>
				</td>
				<td class='TableData'>坡位：</td>
				<td class='TableData'><span id='grassSlopePosition'
					name='grassSlopePosition'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">地表特征</td>
			</tr>
			<tr>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><span id='hasLitter' name='hasLitter'></span>
				</td>
				<td class='TableData'>覆沙情况：</td>
				<td class='TableData'><span id='hasSand' name='hasSand'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>地表侵蚀：</td>
				<td class='TableData'><span id='hasSurfaceErosion'
					name='hasSurfaceErosion'></span></td>
				<td class='TableData'>侵蚀原因：</td>
				<td class='TableData'><span id='erosionReason'
					name='erosionReason'></span></td>
			</tr>
			<tr>
				<td class='TableData'>盐碱斑：</td>
				<td class='TableData'><span id='hasSalineSpot'
					name='hasSalineSpot'></span></td>
				<td class='TableData'>裸地面积比例：</td>
				<td class='TableData'><span id='bareLandAreaRatio'
					name='bareLandAreaRatio'></span>%</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">积水和降水</td>
			</tr>
			<tr>
				<td class='TableData'>地表有无季节性积水：</td>
				<td class='TableData'><span id='hasSeasonalWater'
					name='hasSeasonalWater'></span></td>
				<td class='TableData'>年平均降水量：</td>
				<td class='TableData'><span id='averageAnnualRainfall'
					name='averageAnnualRainfall'></span>毫米</td>
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
				<td class='TableData'>利用状况：</td>
				<td class='TableData' colspan="3"><span id='usingStatus'
					name='usingStatus'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">评价</td>
			</tr>
			<tr>
				<td class='TableData'>综合评价：</td>
				<td class='TableData' colspan="3"><span id='evaluation'
					name='evaluation'></span></td>
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