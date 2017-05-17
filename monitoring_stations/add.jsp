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
<script type="text/javascript" src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<style>
	i{
		color:red;
		font-weight: 900;
	}

</style>
</head>
<script>
var id = '<%=id%>';
var phone="";
$(function(){
	getProvince();
	 $("#stationsBuildingDate,#reportDate").datetimepicker({
		 language:"zh-CN",   
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 })
	 $("#stationsBuildingDate,#reportDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
	 $('#grassCategory').combobox({
		 onSelect: function(param){
			 var categoryNo = param.categoryNo;
			 getChildListByTypeCode("GRASSLAND_TYPE_"+categoryNo,"grassType");
			
		 }
	});
	$('#grassCategory').combobox('textbox').bind('click',function(){
		 $('#grassCategory').combobox('showPanel');
	});
	$('#grassType').combobox('textbox').bind('click',function(){
		 $('#grassType').combobox('showPanel');
	});

	$("#grassLandscape").change(function(){
 		if($(this).val()=="山地" || $(this).val()=="丘陵"){
 			$("#grassSlope").removeClass("readonly").removeAttr("disabled");
 			$("#grassSlopePosition").removeClass("readonly").removeAttr("disabled");			
 		}else{
 			$("#grassSlope").addClass("readonly").attr("disabled","true");
 			$("#grassSlopePosition").addClass("readonly").attr("disabled","true");
 		};
 	});
})
function saveMonitoringStations(){
	if($("#form1").form("validate") && check()){
		var province = $("#province").val();
		var city = $("#city").val();
		var county = $("#county").val();
		var cityCode="";
		if(county!=""){
			cityCode = county;
		}else if(city!=""){
			cityCode = city;
		}else if(province!=""){
			cityCode = province;
		}else{
			cityCode = "000000";
		}
		$("#cityCode").val(cityCode);
		var url = contextPath+"/monitoringStationsController/saveMonitoringStations.act";
		if(id!="null" && id!=null){
			url = contextPath+"/monitoringStationsController/updateMonitoringStations.act";
		}
		top.$.jBox.tip("数据保存中", 'loading');
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			dataType:"text/html",  
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					top.$.jBox.tip(json.rtMsg,"success");
					top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
					top.$(".jbox-body").remove();
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	} 
}

function getMonitoringById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/monitoringStationsController/getMonitoringStationsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var basicInfo = json.rtData.basicInfo;
			bindJsonObj2Cntrl(basicInfo);
			$('#grassCategory').combobox('setValue', basicInfo.grassCategory);
			getChildListByTypeCode("GRASSLAND_TYPE_"+basicInfo.grassCategory,"grassType");
			$('#grassType').combobox('setValue', basicInfo.grassType);
			var jsonObj = getCityFullInfo(basicInfo.cityCode);
			if(jsonObj){
				$("#province").val(jsonObj.provinceCode);
				if(jsonObj.provinceCode){
					getCity();
					$("#city").val(jsonObj.cityCode);
				}
				if(jsonObj.cityCode){
					getCounty();
					$("#county").val(jsonObj.countyCode);
				}
			}
			var sampleArea = json.rtData.basicInfo.grassLandscape;
			if(sampleArea=="丘陵" || sampleArea=="山地"){
				$("#grassSlope").removeClass("readonly").removeAttr("disabled");
				$("#grassSlopePosition").removeClass("readonly").removeAttr("disabled");
			};
			//照片
			var mspattachList = json.rtData.mspAttachList;
			for(var i = 0 ;i<mspattachList.length;i++){
				var attach = mspattachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainor .preview").attr("src",encodeURI(attachUrl));
			}
			var msfAttachList = json.rtData.msfAttachList;
			//附件？
			for(var i = 0 ;i<msfAttachList.length;i++){
				(function(i){
					var attach = msfAttachList[i];
					var attachUrl = encodeURI(contextPath+"/attachController/download.act?attachPath="+attach.attachPath);
					var div = $("<div>");
					var file = $("<a>").attr("href",encodeURI(attachUrl)).text(attach.attachName);
					var span = $("<span>").attr("title","删除").css({"font-size":16,"font-weight":"bolder","color":"red","margin-left":"15px","cursor":"pointer"}).text("×").click(function(){
						var param={};
						param["sid"]=attach.id;
						if(deleteAttach(param)){
							$(this).parents("div:first").remove();
						}
					});
					div.append(file);
					div.append(span);
					$("#fileAttachContainor").append(div);
				})(i);
			} 
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}


function check(){
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
 	if(county==""){
		$.jBox.tip("请选择县","error");
		return false;
	} 
	return true;
}


function deleteAttach(param){
	var url= contextPath+"/attachController/deleteAttach.act";
	var json = tools.requestJsonRs(url,param);
	if(json.rtState){
		return true;
	}
}

/**
 * 数据校验	
 * 
 */
$.extend($.fn.validatebox.defaults.rules, {   
	stationsNumIsExist: {   //监测点编码是否已存在
		validator: function(value, param){
			var url = contextPath+"/monitoringStationsController/stationsNumIsExist.act";
			var param={};
			var stationsNum = $("#stationsNum").val();
			param["stationsNum"] = stationsNum;
			if(id!="null" && id!=null){
				param["sid"]=id;
			}
			var json = tools.requestJsonRs(url,param);
			if(json.rtState){
				if(json.rtData){
					return false;
				}
			}
			return true;
			
		},  
	   message: '当前监测点编号已存在，请重新输入！'
	} 
});

</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getMonitoringById()">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr >
				<td class="TableHeader" colspan="4" style="text-align: left;">详细信息</td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>省： <select name="province" id="province"
					onchange="getCity();" class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select> 市： <select name="city" id="city" onchange="getCounty();"
					class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select> 县： <select name="county" id="county"
					class="BigSelect easyui-validatebox">
						<option value="">所有</option>
				</select><i>*</i>
				<input type="hidden" id='cityCode' name='cityCode' class='BigInput easyui-validatebox' />
				</td>
				<td class='TableData'>乡镇：</td>
				<td class='TableData'>
					<input id="cityShortName" name="cityShortName" class='BigInput easyui-validatebox' maxlength="20" required="true" /><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>监测点编号：</td>
				<td class='TableData' colspan='3'><input type="text" class="BigInput easyui-validatebox" required="true" validType='identifier[] & stationsNumIsExist[]' id='stationsNum' name='stationsNum' /><i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">地理信息</td>
			</tr>
			<tr>
				<td class='TableData'>检测点中心经度：</td>
				<td class='TableData'><input type="text" id='longitude'
					name='longitude' class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[60,150] &addMethode[]"/>(度)<i>*</i> </td>
				<td class='TableData'>监测点中心纬度：</td>
				<td class='TableData'><input type="text" id='latitude'
					name='latitude' class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[10,60] &addMethode[]"/>(度)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>地貌：</td>
				<td class='TableData'>
					<select id='grassLandscape' name='grassLandscape' class="BigSelect" style="width:92px;padding-left: 5px;">
						<option value="平原">平原</option>
						<option value="高原">高原</option>
						<option value="盆地">盆地</option>
						<option value="丘陵">丘陵</option>
						<option value="山地">山地</option>
					</select><i>*</i></td>
					<td class='TableData'>坡向：</td>
				<td class='TableData'>
					<!-- <input type="text" class="SmallInput" id='grassSlope' name='grassSlope'/> -->
					<select id="grassSlope" name="grassSlope" class="BigSelect readonly" disabled="true" style="width:92px;">
						<option value="阳坡">阳坡</option>
						<option value="半阳坡">半阳坡</option>
						<option value="半阴坡">半阴坡</option>
						<option value="阴坡">阴坡</option>
					</select><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>坡位：</td>
				<td class='TableData'>
					<!-- <input type="text" class="SmallInput" id='grassSlopePosition' name='grassSlopePosition'/>  -->
					<select id="grassSlopePosition" name="grassSlopePosition" class="BigSelect readonly" disabled="true" style="width:92px;">
							<option value="坡脚">坡脚</option>
							<option value="坡顶">坡顶</option>
							<option value="坡下部">坡下部</option>
							<option value="坡中部">坡中部</option>
							<option value="坡上部">坡上部</option>
					</select><i>*</i>
				</td>
				<td class='TableData'>地表有无季节性积水：</td>
				<td class='TableData'>
					<select name="hasSeasonalWater" id="hasSeasonalWater" class="BigInput easyui-combobox" style="width:92px; height:28px;line-height: 28px;">
						<option value="有">有</option>
						<option value="无">无</option>
					</select><i>*</i></td>
			</tr>
			<tr>
					<td class='TableData'>年平均降雨量：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethodf[]" id='averageAnnualRainfall'
					name='averageAnnualRainfall'/>(毫米)<i>*</i></td>
					<td class='TableData'>土壤质地：</td>
				<td class='TableData'>
					<select id="cc" class="easyui-combobox" name="soilTexture" id='soilTexture' style="width:92px; height:28px;line-height: 28px;">
					    <option value="沙土">沙土</option>
					    <option value="壤土">壤土</option>
					    <option value="砾石质">砾石质</option>
					    <option value="粘土">粘土</option>
					    <option value="沙土壤土">沙土壤土</option>
					    <option value="栗钙土">栗钙土 </option>
					    <option value="栗钙土">栗钙土 </option>
					    <option value="浮沙 ">浮沙 </option>
					</select><i>*</i>
				 </td>
			</tr>
			<tr>
				<td class='TableData'>海拔：</td>
				<td class='TableData' colspan="3"><input type="text" class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[-160,8849] &addMethod[]" id='altitude'
					name='altitude' />(米)<i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">专业信息</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassCategory'
					name='grassCategory' style='height:28px;line-height: 28px;'/><i>*</i></td>
					<td class='TableData'>草地型：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassType'
					name='grassType' style='height:28px;line-height: 28px;'/><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>是否具有灌木和高大草本：</td>
				<td class='TableData'>
					<select name="hasShrubs" id="hasShrubs" class="BigSelect" style="width:92px;height:28px;line-height: 28px;">
						<option value="1">有</option>
						<option value="0">无</option>
					</select><i>*</i>
				</td>
				<td class='TableData'>主管测场地面积：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethodf[]" id='mainStationsSize' name='mainStationsSize'/>(亩)<i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>常规检测区面积：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethodf[]" id='conventionalStationsSize' name='conventionalStationsSize'/>(亩)<i>*</i>
				</td>
				<td class='TableData'>永久观测区面积：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethodf[]" id='permanentStationsSize'
					name='permanentStationsSize'/>(亩) <i>*</i>	</td>
			</tr>
			<tr>
				<td class='TableData'>刈割检测区面积：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethodf[]"  id='mowingStationsSize' name='mowingStationsSize'/>(亩)<i>*</i>
				</td>
				<td class='TableData'>火烧管理区面积：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethodf[]" id='fireStationsSize'
					name='fireStationsSize'/>(亩)<i>*</i> </td>
			</tr>
			<tr>
				<td class='TableData'>科研实验区面积：</td>
				<td class='TableData'  colspan="3"><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethodf[]" id='researchStationsSize' name='researchStationsSize'/>(亩)<i>*</i>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">其他信息</td>
			</tr>
			<tr>
				<td class='TableData'>建成时间：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly" id='stationsBuildingDate' name='stationsBuildingDate'/><i>*</i>
				</td>
				<td class='TableData'>填报时间：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly"  id='reportDate' name='reportDate'/><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>单位名称：</td>
				<td class='TableData'><input type="text" class="BigInput easyui-validatebox" required="true" id='companyName'
					name='companyName'/> <i>*</i></td>
				<td class='TableData'>联系人：</td>
				<td class='TableData'><input type="text" class="BigInput easyui-validatebox" required="true" id='contactUserName'
					name='contactUserName'/><i>*</i> </td>
			</tr>
			<tr>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><input type="text" class="BigInput easyui-validatebox" required="true" validType="" id='contactPhone'
					name='contactPhone' maxlength="13" /> <i>*</i></td>
				<td class='TableData'>传真：</td>
				<td class='TableData'><input type="text" class="BigInput easyui-validatebox" required="true" validType="facsimile[]" id='contactFax'
					name='contactFax'/><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>电子邮件：</td>
				<td class='TableData'  colspan="3"><input type="text" class="BigInput easyui-validatebox" required="true" validType="email[]" id='contactEmail'
					name='contactEmail'/> <i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>代表性景观照：</td>
				<td class='TableData' colspan="3">
					<div id="attachContainor">
						<div class="attachContainorDiv" style="float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="ms_photo" name="ms_photo" onchange="change(this)"/>
					        请选择景观照片文件</p>
							
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
				<td class='TableData'  colspan="3">
					<img onclick="add('ms_file')" src="<%=contextPath %>/resource/images/sys/fileAdd.png" title="点击添加文件"/>
					<div id="fileAttachContainor"></div>
					
				</td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
</body>
</html>