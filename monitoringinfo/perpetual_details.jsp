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
			if(basicInfo.stationsType>0){
				 $("#permanentInfo").remove();
			}
			bindJsonObj2Cntrl(basicInfo);
			var cityJson = getCityFullInfo(basicInfo.cityCode);
			if(cityJson){
				var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
				$("#stationAddress").text(cityDesc);
			}
			$("#monitoringPeriod").val(basicInfo.monitoringPeriod);
			//照片
			var attachList1 = json.rtData.attachList1;
			for(var i = 0 ;i<attachList1.length;i++){
				var attach = attachList1[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#ghoa_landscape_photo .preview").attr("src",encodeURI(attachUrl));
			}
			// var attachList2 = json.rtData.attachList2;
			// for(var i = 0 ;i<attachList2.length;i++){
			// 	var attach = attachList2[i];
			// 	var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
			// 	$("#ghoa_landscape_photo .preview").attr("src",encodeURI(attachUrl));
			// }
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
</script>
</head>
<body onload="findGhoaBySID();" style="overflow-y:scroll; font-size: 12px;margin-top: 20px;">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">详细信息</td>
			</tr>
			<tr>
				<td class='TableData' colspan="1">监测点编号：</td>
				<td class='TableData' colspan="3"><span id="stationsNum"></span></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>
				<span id='stationAddress'></span>
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
				<td class='TableData'>植物盖度：</td>
				<td class='TableData'><span id='coverage'></span>%</td>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'>
					<span id='grassAvgHeight'></span>厘米
				 </td>
			</tr>
			<tr>
				<td class='TableData'>景观照照片：</td>
				<td class='TableData' colspan="3">
					<div id="ghoa_landscape_photo">
						<div class="attachContainorDiv" style="margin-left:0px;">
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