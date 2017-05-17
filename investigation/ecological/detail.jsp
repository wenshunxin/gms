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
<script type="text/javascript" src="<%=contextPath%>//investigation/common/detail.js"></script>
</head>
<script>
var id = '<%=id%>';

function getEcologicalById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsEcologicalController/getEcologicalById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			var dataId = json.rtData.basicInfo.investigateDataId;
			queryAuditRecords(dataId,id,0);
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;" onload="getEcologicalById();">
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
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
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
				
				<td class='TableData'>填表单位：</td>
				<td class='TableData' colspan="3"><span id='investigateCompanyName'
					name='investigateCompanyName'></span></td>
			</tr>
			<tr>
				<td class='TableData'>所在区域：</td>
				<td class='TableData' colspan="3"><span id='investigateArea'
					name='investigateArea'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原退化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><span id='degradationArea'
					name='degradationArea'></span></td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><span id='degradationSize'
					name='degradationSize'></span>公顷</td>
			</tr>
			<tr>
				<td class='TableData'>轻度退化面积：</td>
				<td class='TableData' colspan="3"><span
					id='degradationMildSize' name='degradationMildSize'></span>公顷</td>
			</tr>
			<tr>
				<td class='TableData'>中度退化面积：</td>
				<td class='TableData' colspan="3"><span
					id='degradationModerateSize' name='degradationModerateSize'></span>公顷
				</td>
			</tr>
			<tr>
				<td class='TableData'>重度退化面积：</td>
				<td class='TableData' colspan="3"><span
					id='degradationSevereSize' name='degradationSevereSize'></span>公顷</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原盐渍化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><span id='salinizationArea'
					name='salinizationArea'></span></td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><span id='salinizationSize'
					name='salinizationSize'></span>公顷</td>
			</tr>
			<tr>
				<td class='TableData'>轻度盐渍化面积：</td>
				<td class='TableData' colspan="3"><span
					id='salinizationMildSize' name='salinizationMildSize'></span>公顷</td>
			</tr>
			<tr>
				<td class='TableData'>中度盐渍化面积：</td>
				<td class='TableData' colspan="3"><span
					id='salinizationModerateSize' name='salinizationModerateSize'></span>公顷
				</td>
			</tr>
			<tr>
				<td class='TableData'>重度盐渍化面积：</td>
				<td class='TableData' colspan="3"><span
					id='salinizationSevereSize' name='salinizationSevereSize'></span>公顷</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原沙化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><span
					id='desertificationArea' name='desertificationArea'></span></td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><span
					id='desertificationSize' name='desertificationSize'></span>公顷</td>
			</tr>
			<tr>
				<td class='TableData'>轻度沙化面积：</td>
				<td class='TableData' colspan="3"><span
					id='desertificationMildSize' name='desertificationMildSize'></span>公顷
				</td>
			</tr>
			<tr>
				<td class='TableData'>中度沙化面积：</td>
				<td class='TableData' colspan="3"><span
					id='desertificationModerateSize' name='desertificationModerateSize'></span>公顷
				</td>
			</tr>
			<tr>
				<td class='TableData'>重度沙化面积：</td>
				<td class='TableData' colspan="3"><span
					id='desertificationSevereSize' name='desertificationSevereSize'></span>公顷
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">草原石漠化</td>
			</tr>
			<tr>
				<td class='TableData'>主要分布区域：</td>
				<td class='TableData' colspan="3"><span
					id='rockyDesertificationArea' name='rockyDesertificationArea'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>分布面积：</td>
				<td class='TableData' colspan="3"><span
					id='rockyDesertificationSize' name='rockyDesertificationSize'></span>公顷
				</td>
			</tr>
			<tr>
				<td class='TableData'>轻度石漠化面积：</td>
				<td class='TableData' colspan="3"><span
					id='rockyDesertificationMildSize'
					name='rockyDesertificationMildSize'></span>公顷</td>
			</tr>
			<tr>
				<td class='TableData'>中度石漠化面积：</td>
				<td class='TableData' colspan="3"><span
					id='rockyDesertificationModerateSize'
					name='rockyDesertificationModerateSize'></span>公顷</td>
			</tr>
			<tr>
				<td class='TableData'>重度石漠化面积：</td>
				<td class='TableData' colspan="3"><span
					id='rockyDesertificationSevereSize'
					name='rockyDesertificationSevereSize'></span>公顷</td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='investigateDataId' name='investigateDataId' />

	</form>
</body>
</html>