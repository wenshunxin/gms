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
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>

</head>
<script>
var id = '<%=id%>';
function getMonitoringById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/monitoringStationsController/getMonitoringStationsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var basicInfo = json.rtData.basicInfo;
			bindJsonObj2Cntrl(basicInfo);
			if(basicInfo.hasShrubs==0){
				$("#hasShrubs").text("无");
			}else{
				$("#hasShrubs").text("有");
			}
			
			var category = returnCategoryName("GRASSLAND_TYPE",basicInfo.grassCategory);
			var grassType = returnCategoryName("GRASSLAND_TYPE_"+basicInfo.grassCategory,basicInfo.grassType);
			$("#grassCategory").text(category);
			$("#grassType").text(grassType);
			
			var cityJson = getCityFullInfo(basicInfo.cityCode);
			if(cityJson){
				var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
				$("#cityCodeDesc").text(cityDesc);
			}
			//照片
			var mspattachList = json.rtData.mspAttachList;
			for(var i = 0 ;i<mspattachList.length;i++){
				var attach = mspattachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorPhoto .preview").attr("src",encodeURI(attachUrl));
			}
			var msfAttachList = json.rtData.msfAttachList;
			//附件？
			for(var i = 0 ;i<msfAttachList.length;i++){
				(function(i){
					var attach = msfAttachList[i];
					var attachUrl = encodeURI(contextPath+"/attachController/download.act?attachPath="+attach.attachPath);
					var div = $("<div>");
					var file = $("<a>").attr("href",encodeURI(attachUrl)).text(attach.attachName);
					div.append(file);
					$("#fileAttachContainor").append(div);
				})(i);
			} 
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}


function returnCategoryName(typeCode,codeValue){
	if(typeCode==null || typeCode==""){
		return "";
	}
	if(codeValue==null || codeValue==""){
		return "";
	}
	var url = contextPath+"/gmsSysCategoryController/getCategoryName.act?typeCode="+typeCode+"&codeValue="+codeValue;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		if(data){
			return data.categoryName;
		}
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}
</script>
<body style="overflow-x: hidden; font-size: 12px;"
	onload="getMonitoringById();">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;margin-bottom:50px;margin-top:20px;'>
			<tr>
				<td class="TableHeader" colspan="4" style="text-align: left">详细信息</td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
				<td class='TableData'><span id='cityCodeDesc' name='cityCodeDesc'> </span></td>
				<td class='TableData'>监测点编号：</td>
				<td class='TableData'><span id='stationsNum'
					name='stationsNum'></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">地理信息</td>
			</tr>
			<tr>
				<td class='TableData'>检测点中心经度：</td>
				<td class='TableData'><span id='longitude'
					name='longitude'></span>(度)</td>
				<td class='TableData'>监测点中心纬度：</td>
				<td class='TableData'><span id='latitude'
					name='latitude'></span>(度)</td>
			</tr>
			<tr>
				<td class='TableData'>地貌：</td>
				<td class='TableData'><span id='grassLandscape'
					name='grassLandscape'></span></td>
					<td class='TableData'>坡向：</td>
				<td class='TableData'><span id='grassSlope'
					name='grassSlope'></span></td>
			</tr>
			<tr>
					<td class='TableData'>坡位：</td>
				<td class='TableData'><span id='grassSlopePosition'
					name='grassSlopePosition'></span></td>
					<td class='TableData'>地表有无季节性积水：</td>
				<td class='TableData'><span id='hasSeasonalWater'
					name='hasSeasonalWater'></span></td>
			</tr>
			<tr>
					<td class='TableData'>年平均降雨量：</td>
				<td class='TableData'><span id='averageAnnualRainfall'
					name='averageAnnualRainfall'></span>毫米</td>
					<td class='TableData'>土壤质地：</td>
				<td class='TableData'><span id='soilTexture'
					name='soilTexture'></span></td>
			</tr>
			<tr>
					<td class='TableData'>海拔：</td>
				<td class='TableData'><span id='altitude'
					name='altitude'></span>米</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">专业信息</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><span id='grassCategory'
					name='grassCategory'></span></td>
					<td class='TableData'>草地型：</td>
				<td class='TableData'><span id='grassType'
					name='grassType'></span></td>
			</tr>
			<tr>
				<td class='TableData'>是否具有灌木和高大草本：</td>
				<td class='TableData'><span id='hasShrubs'
					name='hasShrubs'></span></td>
				<td class='TableData'>主管测场地面积：</td>
				<td class='TableData'><span id='mainStationsSize' name='mainStationsSize'></span>亩
				</td>
			</tr>
			<tr>
				<td class='TableData'>常规检测区面积：</td>
				<td class='TableData'><span id='conventionalStationsSize' name='conventionalStationsSize'></span>亩
				</td>
				<td class='TableData'>永久观测区面积：</td>
				<td class='TableData'><span id='permanentStationsSize'
					name='permanentStationsSize'></span>亩</td>
			</tr>
			<tr>
				<td class='TableData'>刈割检测区面积：</td>
				<td class='TableData'><span id='mowingStationsSize' name='mowingStationsSize'></span>亩
				</td>
				<td class='TableData'>火烧管理区面积：</td>
				<td class='TableData'><span id='fireStationsSize'
					name='fireStationsSize'></span>亩</td>
			</tr>
			<tr>
				<td class='TableData'>科研实验区面积：</td>
				<td class='TableData'><span id='researchStationsSize' name='researchStationsSize'></span>亩
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">其他信息</td>
			</tr>
			<tr>
				<td class='TableData'>建成时间：</td>
				<td class='TableData'><span id='stationsBuildingDate' name='stationsBuildingDate'></span>
				</td>
				<td class='TableData'>填报时间：</td>
				<td class='TableData'><span id='reportDate' name='reportDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>单位名称：</td>
				<td class='TableData'><span id='companyName'
					name='companyName'></span></td>
				<td class='TableData'>联系人：</td>
				<td class='TableData'><span id='contactUserName'
					name='contactUserName'></span></td>
			</tr>
			<tr>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><span id='contactPhone'
					name='contactPhone'></span></td>
				<td class='TableData'>传真：</td>
				<td class='TableData'><span id='contactFax'
					name='contactFax'></span></td>
			</tr>
			<tr>
				<td class='TableData'>电子邮件：</td>
				<td class='TableData'><span id='contactEmail'
					name='contactEmail'></span></td>
			</tr>
			<tr>
				<td class='TableData'>代表性景观照：</td>
				<td class='TableData' colspan="3">
					<div id="attachContainorPhoto">
						<div class="attachContainorDiv" style="margin-left:20px;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					    </div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">
				包括小区设计、设备清单、人员名单、电话、联系方式等附件
				</td>
			</tr>
			<tr>
				<td class='TableData'>补充信息：</td>
				<td class='TableData' colspan='3'>
					<div id="fileAttachContainor"></div>
				</td>
			</tr>
		</table>
</body>
</html>