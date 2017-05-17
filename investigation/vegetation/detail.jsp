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
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script type="text/javascript" src="<%=contextPath%>//investigation/common/detail.js"></script>
</head>
<script>
var id = '<%=id%>';
function getVegetationGrewById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsVegetationGrewController/getVegetationGrewById.act?sid="+id;
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
			var ldAttachList = json.rtData.ldAttachList;
			for(var i = 0 ;i<ldAttachList.length;i++){
				var attach = ldAttachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorIn .preview").attr("src",encodeURI(attachUrl));
			}
			var olAttachList = json.rtData.olAttachList;
			for(var i = 0 ;i<olAttachList.length;i++){
				var attach = olAttachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorOut .preview").attr("src",encodeURI(attachUrl));
			}
			
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;" onload="getVegetationGrewById();">
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
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr><!-- 
				<td class='TableData'>调查年份：</td>
				<td class='TableData'><span id='year' name='year'> </span></td> -->
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
				<td class='TableData'>样地编号：</td>
				<td class='TableData' colspan="3"><span id='sampleAreaNumber'
					name='sampleAreaNumber'></span>月长势</td>
				
			</tr>
			<tr>
				<td class='TableData'>调查区域：</td>
				<td class='TableData' colspan="3"><span id='investigateArea'
					name='investigateArea'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">类型</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><span id='grassCategory'></span></td>
				<td class='TableData'>草地型：</td>
				<td class='TableData'><span id='grassType'></span></td>
			</tr>
			<tr>
				<td class='TableData'>地形地貌：</td>
				<td class='TableData' colspan="3"><span id='grassLandscape'
					name='grassLandscape'></span></td>
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
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'>平均盖度：</td>
				<td class='TableData'><span id='avgCoverage' name='avgCoverage'></span>%
				</td>
				<td class='TableData'>平均高度：</td>
				<td class='TableData'><span id='avgHighly' name='avgHighly'></span>厘米
				</td>
			</tr>
			<tr>
				<td class='TableData'>平均鲜草产量：</td>
				<td class='TableData'><span id='avgFreshGrassAmount'
					name='avgFreshGrassAmount'></span>千克/公顷</td>
				<td class='TableData'>平均干草产量：</td>
				<td class='TableData'><span id='avgGrassAmount'
					name='avgGrassAmount'></span>千克/公顷</td>
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
				<td class='TableData'>土壤墒情：</td>
				<td class='TableData' colspan="3"><span id='soilMoisture'
					name='soilMoisture'></span> <span id='soilMoistureOther'
					name='soilMoistureOther'></span></td>
			</tr>
			<tr>
				<td class='TableData'>综合评价：</td>
				<td class='TableData' colspan="3"><span id='evaluation'
					name='evaluation'></span></td>
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
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='investigateDataId' name='investigateDataId' />
	</form>
</body>
</html>