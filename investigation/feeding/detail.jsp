<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String type = request.getParameter("type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/detail.js"></script>
</head>
<style>
.BigInput {
	width: 75px;
}
</style>
<script>
var id = '<%=id%>';
var type = '<%=type%>';
function getFeedingById(){
	if(type=="2"){
		$("#householdTr").hide();
	}else if(type=="3"){
		$("#householdTr").show();
		$("span[class=unit]").each(function(){
			if($(this).text().indexOf("万")>-1){
				var value = $(this).text().replace("万","");
				$(this).text(value);
			}
			if($(this).text().indexOf("吨")>-1){
				var value = $(this).text().replace("吨","公斤");
				$(this).text(value);
			}
		});
	}
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsFeedingController/getFeedingById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			$("#year").text(json.rtData.year);
			var dataId = json.rtData.basicInfo.investigateDataId;
			queryAuditRecords(dataId,id,0);
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;" onload="getFeedingById();">
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
				<td class='TableData' width="20%">调查年份：</td>
				<td class='TableData'><span id='year' name='year'> </span></td>
				<td class='TableData' width="20%">调查时间：</td>
				<td class='TableData'><span id='investigateDate'
					name='investigateDate'></span></td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span id='investigateUserNames'
					name='investigateUserNames'></span></td>
				<td class='TableData'>调查单位：</td>
				<td class='TableData'><span id='investigateCompanyName'
					name='investigateCompanyName'></span></td>
			</tr>
			<tr id="householdTr">
				<td class='TableData'>户主姓名：</td>
				<td class='TableData' colspan="3"><span id='householdUserName'
					name='householdUserName'></span></td>
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
				<td class='TableData'>家庭承包面积：</td>
				<td class='TableData'><span id='houseContractedSize'
					name='houseContractedSize'></span>公顷</td>
				<td class='TableData'>绵羊数量：</td>
				<td class='TableData'><span id='sheepAmount' name='sheepAmount'></span><span class='unit'>万只</span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>人工草地面积：</td>
				<td class='TableData'><span id='artificialGrassSize'
					name='artificialGrassSize'></span>公顷</td>
				<td class='TableData'>山羊数量：</td>
				<td class='TableData'><span id='goatAmount' name='goatAmount'></span><span class='unit'>万只</span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>人工草地产草总量：</td>
				<td class='TableData'><span id='artificialGrassAmount'
					name='artificialGrassAmount'></span><span class='unit'>吨</span></td>
				<td class='TableData'>牛数量：</td>
				<td class='TableData'><span id='cowAmount' name='cowAmount'></span><span class='unit'>万头</span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>补饲秸秆等总量：</td>
				<td class='TableData'><span id='strawAmount' name='strawAmount'></span><span class='unit'>吨</span>
				</td>
				<td class='TableData'>马数量：</td>
				<td class='TableData'><span id='horseAmount' name='horseAmount'></span><span class='unit'>万匹</span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>青贮饲料总量：</td>
				<td class='TableData'><span id='silageAmount'
					name='silageAmount'></span><span class='unit'>吨</span></td>
				<td class='TableData'>骆驼数量：</td>
				<td class='TableData'><span id='camelAmount' name='camelAmount'></span><span class='unit'>万峰</span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>粮食补饲量：</td>
				<td class='TableData'><span id='foodAmount' name='foodAmount'></span><span class='unit'>吨</span>
				</td>
				<td class='TableData'>骡数量：</td>
				<td class='TableData'><span id='muleAmount' name='muleAmount'></span><span class='unit'>万头</span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>补饲总天数：</td>
				<td class='TableData'><span id='supplementDays'
					name='supplementDays'></span>天</td>
				<td class='TableData'>驴数量：</td>
				<td class='TableData'><span id='donkeyAmount'
					name='donkeyAmount'></span><span class='unit'>万头</span></td>
			</tr>
			<tr id="grazingDaysTr">
				<td class='TableData'>放牧总天数：</td>
				<td class='TableData'><span id='grazingDays' name='grazingDays'></span>天
				</td>
				<td class='TableData'>其他草食家禽数量：</td>
				<td class='TableData'><span id='otherHerbivorousAmount'
					name='otherHerbivorousAmount'></span><span class='unit'>万头/只</span></td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='feedingType' name='feedingType' /> <input
			type='hidden' id='investigateDataId' name='investigateDataId' />
	</form>
</body>
</html>