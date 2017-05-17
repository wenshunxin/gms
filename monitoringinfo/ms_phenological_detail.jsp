<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String id = request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" ></span>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" ></span>
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" ></span>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script>
var datagrid;
var id = '<%=id%>';
function doInit(){
	 var stationId=getPhenologicaById(id);
	 var url = contextPath+"/monitoringStationsController/getMonitoringStationsById.act?sid="+stationId;
	 var json = tools.requestJsonRs(url);
	 if(json.rtState){
		var basicInfo = json.rtData.basicInfo;
		$("#stationsNum").text(basicInfo.stationsNum);
		var cityJson = getCityFullInfo(basicInfo.cityCode);
		
		if(cityJson){
			var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
			$("#stationAddress").text(cityDesc);
		}
	 }else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
}

function getPhenologicaById(id){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmpController/getGmpById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			var greenPhoto = json.rtData.greenPhoto;
			var yellowPhoto = json.rtData.yellowPhoto;
			var januarySnowPhoto = json.rtData.januarySnowPhoto;
			var februarySnowPhoto = json.rtData.februarySnowPhoto;
			var decemberSnowPhoto = json.rtData.decemberSnowPhoto;
			for(var i=0;i<greenPhoto.length;i++){
				var attach = greenPhoto[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorGreen .preview").attr("src",encodeURI(attachUrl));
			}
			for(var i=0;i<yellowPhoto.length;i++){
				var attach = yellowPhoto[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorYellow .preview").attr("src",encodeURI(attachUrl));
			}
			for(var i=0;i<januarySnowPhoto.length;i++){
				var attach = januarySnowPhoto[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorJanuarySnow .preview").attr("src",encodeURI(attachUrl));
			}
			for(var i=0;i<februarySnowPhoto.length;i++){
				var attach = februarySnowPhoto[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorFebruarySnow .preview").attr("src",encodeURI(attachUrl));
			}
			for(var i=0;i<decemberSnowPhoto.length;i++){
				var attach = decemberSnowPhoto[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorDecemberSnow .preview").attr("src",encodeURI(attachUrl));
			}
			return json.rtData.basicInfo.monitoringStationsId;
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

</script>
</head>
<body onload="doInit();" style="overflow-y:scroll;margin-bottom: 100px; font-size: 12px; margin-top:10px;">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>监测点编号：</td>
				<td class='TableData' colspan="3"><span id="stationsNum"></span></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>
 					<span id="stationAddress"></span>
				</td>
				<td class='TableData'>调查日期：</td>
				<td class='TableData'><span
					 id='investigateDate' name='investigateDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span id='investigateUserNames'
					name='investigateUserNames'></span> </td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><span id='contactPhone'
					name='contactPhone'></span> </td>
			</tr>
			<tr>
				<td class='TableData'>返青时间：</td>
				<td class='TableData'><span id='greenDate' name='greenDate'></span>
				</td>
				<td class='TableData'>刈割时间：</td>
				<td class='TableData'><span id='mowingDate' name='mowingDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>火烧时间：</td>
				<td class='TableData'><span id='fireDate' name='fireDate'></span>
				</td>
				<td class='TableData'>凋落时间：</td>
				<td class='TableData'><span id='yellowDate' name='yellowDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>1月降雪厚度：</td>
				<td class='TableData'><span  id='januarySnowThickness'
					name='januarySnowThickness'></span>(毫米) </td>
				<td class='TableData'>2月降雪厚度：</td>
				<td class='TableData'><span id='februarySnowThickness'
					name='februarySnowThickness'></span>(毫米) </td>
			</tr>
			<tr>
				<td class='TableData'>12月降雪厚度：</td>
				<td class='TableData'><span id='decemberSnowThickness'
					name='decemberSnowThickness'></span>(毫米) </td>
				<td class='TableData'>初雪时间：</td>
				<td class='TableData'><span  id='firstSnowDate' name='firstSnowDate'></span>
				</td>
			</tr>
			<tr>
				<td class='TableData'>全年降雪次数：</td>
				<td class='TableData' colspan="3"><span id='snowAmount'
					name='snowAmount' ></span> </td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData'>返青期照片：</td>
				<td class='TableData'>
					<div id="attachContainorGreen" style="position: relative;">
						<div class="attachContainorDiv" style="margin-left:20px;display: inline-block;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					    </div>
					    <i style="color:red;font-weight: 900;font-size:20px;position: absolute;top:45%;left:260px;">*</i>
					</div>
				</td>
				<td class='TableData'>凋落期照片：</td>
				<td class='TableData'>
					<div id="attachContainorYellow" style="position: relative;">
						<div class="attachContainorDiv" style="margin-left:20px;display: inline-block;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
						</div>
					<i style="color:red;font-weight: 900;font-size:20px;position: absolute;top:45%;left:260px;">*</i>
					</div>
				</td>
			</tr>
			<tr>
				<td class='TableData'>1月降雪照片：</td>
				<td class='TableData'>
					<div id="attachContainorJanuarySnow">
						<div class="attachContainorDiv" style="margin-left:20px;display: inline-block;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
						</div>
					</div>
				</td>
				<td class='TableData'>2月降雪照片：</td>
				<td class='TableData'>
					<div id="attachContainorFebruarySnow">
						<div class="attachContainorDiv" style="margin-left:20px;display: inline-block;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td class='TableData'>12月降雪照片：</td>
				<td class='TableData' colspan="3">
					<div id="attachContainorDecemberSnow">
						<div class="attachContainorDiv" style="margin-left:20px;display: inline-block;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align:center;" colspan="4">
				</td>
			</tr>
		</table>
	</form>
	
</body>
</html>