<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String dataId = request.getParameter("dataId");
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
var dataId = '<%=dataId%>';

function getSampleAreaById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsSampleAreaController/getSampleAreaById.act?sid="+id+"&dataId="+dataId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//工程信息
			getProjectById(json.rtData.sampleAreaIn.projectId);
			//基本信息
			bindJsonObj2Cntrl(json.rtData.sampleAreaIn);
			bindJsonObj2Cntrl(json.rtData.sampleAreaIn,null,"In");
			bindJsonObj2Cntrl(json.rtData.sampleAreaOut,null,"Out");
			getCategoryName("GRASSLAND_TYPE",json.rtData.sampleAreaIn.grassCategory,"grassCategoryIn");
			getCategoryName("GRASSLAND_TYPE_"+json.rtData.sampleAreaIn.grassCategory,json.rtData.sampleAreaIn.grassType,"grassTypeIn");
			getCategoryName("GRASSLAND_TYPE",json.rtData.sampleAreaOut.grassCategory,"grassCategoryOut");
			getCategoryName("GRASSLAND_TYPE_"+json.rtData.sampleAreaOut.grassCategory,json.rtData.sampleAreaOut.grassType,"grassTypeOut");
			
			var dataId = json.rtData.sampleAreaIn.investigateDataId;
			queryAuditRecords(dataId,id,0);
			
			//$("#year").text(json.rtData.year);
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

function getProjectById(projectId){
	if(projectId!="null" && projectId!=null){
		var url = contextPath+"/gmsProjectController/getProjectById.act?sid="+projectId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData);
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
		<table class='TableBlock' style='width: 95%; margin: 0 auto;margin-bottom:80px;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<!-- <td class='TableData' style="width: 135px;">调查年份：</td>
				<td class='TableData'><span id='year' name='year'> </span></td> -->
				<td class='TableData' style="width: 135px;">调查时间：</td>
				<td class='TableData' colspan="3"><span id='investigateDate'
					name='investigateDate'></span></td>
			</tr>
			<tr>
				<td class='TableData'>具有灌木和高大草木：</td>
				<td class='TableData'><span id='hasShrubs' name='hasShrubs'></span>
				</td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span id='investigateUserNames'
					name='investigateUserNames'></span></td>
			</tr>

			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">工程信息
				</td>
			</tr>
			<tbody id="projectDetail">
				<tr>
					<td class='TableData'>工程名称：</td>
					<td class='TableData'><span id='projectName'></span></td>
					<td class='TableData'>工程面积：</td>
					<td class='TableData'><span id='projectSize'></span>公顷</td>
				</tr>
				<tr>
					<td class='TableData'>工程投资：</td>
					<td class='TableData'><span id='projectInvestment'></span>万元</td>
					<td class='TableData'>中央投资：</td>
					<td class='TableData'><span id='projectNationalInvestment'></span>万元</td>
				</tr>
				<tr>
					<td class='TableData'>工程所在区域：</td>
					<td class='TableData'><span id='projectArea'> </span></td>
					<td class='TableData'>工程建设时间：</td>
					<td class='TableData'><span id='projectBuildingDate'></span></td>
				</tr>
				<tr>
					<td class='TableData'>工程措施：</td>
					<td class='TableData' colspan='3'><span id="projectMeasures"></span>
					</td>
				</tr>
				<tr>
					<td class='TableData'>工程地点：</td>
					<td class='TableData' colspan='3'><span id='projectAddress'></span>
					</td>
				</tr>
			</tbody>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="2">工程区域内样地</td>
				<td class="TableHeader" style="text-align: left;" colspan="2">工程区域外样地</td>
			</tr>

			<tr>
				<td class='TableData'>样地编号：</td>
				<td class='TableData'><span id='sampleAreaNumberIn'
					name='sampleAreaNumberIn'></span></td>
				<td class='TableData'>样地编号：</td>
				<td class='TableData'><span id='sampleAreaNumberOut'
					name='sampleAreaNumberOut'></span></td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><span id='grassCategoryIn'></span></td>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><span id='grassCategoryOut'></span></td>
			</tr>
			<tr>
				<td class='TableData'>草地型：</td>
				<td class='TableData'><span id='grassTypeIn'></span></td>
				<td class='TableData'>草地型：</td>
				<td class='TableData'><span id='grassTypeOut'></span></td>
			</tr>
			<tr>
				<td colspan="2" class="TableData" style="padding: 0 0; border-bottom: 0;">
					<table class="TableBlock" style="border-left: 0; width: 100%; border-top:0;border-right:0;">
						<tr>
							<td class='TableData' style="width: 135px;">地形地貌：</td>
							<td class='TableData'><span id="grassLandscapeIn"
								name="grassLandscapeIn"> </span></td>
							<td class='TableData'>土壤质地：</td>
							<td class='TableData' style="border-right:0;"><span id="soilTextureIn" name="soilTextureIn"> </span></td>
						</tr>
						<tr>
							<td class='TableData'>坡向：</td>
							<td class='TableData'><span id="grasSlopeIn"
								name="grasSlopeIn"> </span></td>
							<td class='TableData'>坡位：</td>
							<td class='TableData'><span id="grassSlopePositionIn"
								name="grassSlopePositionIn"> </span></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">地表特征</td>
						</tr>
						<tr>
							<td class='TableData'>枯落物情况：</td>
							<td class='TableData'><span id='hasLitterIn'
								name='hasLitterIn'></span></td>
							<td class='TableData'>覆沙情况：</td>
							<td class='TableData'><span id='hasSandIn' name='hasSandIn'></span>
							</td>
						</tr>
						<tr>
							<td class='TableData'>地表侵蚀：</td>
							<td class='TableData'><span id='hasSurfaceErosionIn'
								name='hasSurfaceErosionIn'></span></td>
							<td class='TableData'>侵蚀原因：</td>
							<td class='TableData'><span id="erosionReasonIn"
								name="erosionReasonIn"> </span></td>
						</tr>
						<tr>
							<td class='TableData'>盐碱斑：</td>
							<td class='TableData'><span id='hasSalineSpotIn'
								name='hasSalineSpotIn'></span></td>
							<td class='TableData'>裸地面积比例：</td>
							<td class='TableData'><span id='bareLandAreaRatioIn'
								name='bareLandAreaRatioIn'></span>%</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">积水和降水</td>
						</tr>
						<tr>
							<td class='TableData'>地表有无季节性积水：</td>
							<td class='TableData'><span id='hasSeasonalWaterIn'
								name='hasSeasonalWaterIn'></span></td>
							<td class='TableData'>年平均降水量：</td>
							<td class='TableData'><span id='averageAnnualRainfallIn'
								name='averageAnnualRainfallIn'></span>毫米</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">利用</td>
						</tr>
						<tr>
							<td class='TableData'>利用方式：</td>
							<td class='TableData' colspan='3'><span id="usingTypeIn"
								name="usingTypeIn"> </span></td>
						</tr>
						<tr>
							<td class='TableData'>利用状况：</td>
							<td class='TableData' colspan='3'><span id="usingStatusIn"
								name="usingStatusIn"> </span></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">评价</td>
						</tr>
						<tr>
							<td class='TableData'>综合评价：</td>
							<td class='TableData' colspan='3'><span id="evaluationIn"
								name="evaluationIn"> </span></td>
						</tr>
					</table>
				</td>
				<td colspan="2" class="TableData" style="padding: 0 0;border-bottom:0;">
					<table class="TableBlock" style="border-left: 0; width: 100%;border-top:0;border-right:0;">
						<tr>
							<td class='TableData' style="width: 132px;">地形地貌：</td>
							<td class='TableData'><span id="grassLandscapeOut"
								name="grassLandscapeOut"> </span></td>
							<td class='TableData'>土壤质地：</td>
							<td class='TableData' style="border-right:0;"><span id="soilTextureOut" name="soilTextureOut"></span></td>
						</tr>
						<tr>
							<td class='TableData'>坡向：</td>
							<td class='TableData'><span id="grasSlopeOut"
								name="grasSlopeOut"> </span></td>
							<td class='TableData'>坡位：</td>
							<td class='TableData'><span id="grassSlopePositionOut"
								name="grassSlopePositionOut"> </span></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">地表特征</td>
						</tr>
						<tr>
							<td class='TableData'>枯落物情况：</td>
							<td class='TableData'><span id='hasLitterOut'
								name='hasLitterOut'></span></td>
							<td class='TableData'>覆沙情况：</td>
							<td class='TableData'><span id='hasSandOut'
								name='hasSandOut'></span></td>
						</tr>
						<tr>
							<td class='TableData'>地表侵蚀：</td>
							<td class='TableData'><span id='hasSurfaceErosionOut'
								name='hasSurfaceErosionOut'></span></td>
							<td class='TableData'>侵蚀原因：</td>
							<td class='TableData'><span id="erosionReasonOut"
								name="erosionReasonOut"> </span></td>
						</tr>
						<tr>
							<td class='TableData'>盐碱斑：</td>
							<td class='TableData'><span id='hasSalineSpotOut'
								name='hasSalineSpotOut'></span></td>
							<td class='TableData'>裸地面积比例：</td>
							<td class='TableData'><span id='bareLandAreaRatioOut'
								name='bareLandAreaRatioOut'></span>%</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">积水和降水</td>
						</tr>
						<tr>
							<td class='TableData'>地表有无季节性积水：</td>
							<td class='TableData'><span id='hasSeasonalWaterOut'
								name='hasSeasonalWaterOut'></span></td>
							<td class='TableData'>年平均降水量：</td>
							<td class='TableData'><span id='averageAnnualRainfallOut'
								name='averageAnnualRainfallOut'></span>毫米</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">利用</td>
						</tr>
						<tr>
							<td class='TableData'>利用方式：</td>
							<td class='TableData' colspan='3'><span id="usingTypeOut"
								name="usingTypeOut"> </span></td>
						</tr>
						<tr>
							<td class='TableData'>利用状况：</td>
							<td class='TableData' colspan='3'><span id="usingStatusOut"
								name="usingStatusOut"> </span></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">评价</td>
						</tr>
						<tr>
							<td class='TableData'>综合评价：</td>
							<td class='TableData' colspan='3'><span id="evaluationOut"
								name="evaluationOut"> </span></td>
						</tr>
					</table>
				</td>

			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;border-top:0;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4" >
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