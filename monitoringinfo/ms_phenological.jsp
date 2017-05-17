<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
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
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script>
var datagrid;
var id = '<%=id%>';
function doInit(){
	 $(".dateTime").datetimepicker({
		 language:"zh-CN",   
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 })
	 $(".dateTime").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));

	 var stationId="";
	 if(id!="null" && id!=null){
		 stationId =  getPhenologicaById(id);
	 }else{
		 stationId= parent.document.getElementById("monitoringStationsId").value;
		 if(stationId==""){
			 return;
		 }
	 }
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
	 $("#monitoringStationsId").val(stationId);
}


function saveGmp(){
	if($("#form1").form("validate") && check()){
		var url = contextPath+"/gmpController/saveGmpInfo.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmpController/updateGmp.act";
		} 
		top.$.jBox.tip("数据正在保存","loading");
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			dataType:"text/html",  
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					top.$.jBox.tip(json.rtMsg,"success");
					if(id!="null" && id!=null){
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						top.$(".jbox-body").remove();
					}else{
						$("#form1").resetForm();
						$(".delectImg").remove();
						$(".preview").attr("src",contextPath+"/resource/images/sys/fileImg.png");
					}
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}

function getPhenologicaById(id){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmpController/getGmpById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			$("#submitBtn").hide();
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


//照片的验证
function check(){
	var attachContainorGreen=$("#attachContainorGreen").find("img.preview").attr("src");
	var  src=contextPath+"/resource/images/sys/fileImg.png";
	if(attachContainorGreen==src){
		top.$.jBox.tip("返青期照片不能为空！","error");
		$("#gmp_green_photo").focus();
		return false;
	}
	var attachContainorYellow=$("#attachContainorYellow").find("img.preview").attr("src");
	if(attachContainorYellow==src){
		top.$.jBox.tip("凋落期照片不能为空!","error");
		$("#gmp_yellow_photo").focus();
		return false;
	}
	return true;
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
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox  easyui-validatebox dateTime' required="true"  readonly="readonly " id='investigateDate' name='investigateDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text" id='investigateUserNames'
					name='investigateUserNames' class="BigInput" maxlength="20" /> </td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><input type="text" id='contactPhone'
					name='contactPhone' class="BigInput easyui-validatebox" validType="" maxlength="13" /> </td>
			</tr>
			<tr>
				<td class='TableData'>返青时间：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox  easyui-validatebox dateTime' required="true" readonly="readonly" id='greenDate' name='greenDate'/>
				</td>
				<td class='TableData'>刈割时间：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox  easyui-validatebox dateTime' required="true" readonly="readonly" id='mowingDate' name='mowingDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>火烧时间：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox  easyui-validatebox dateTime' required="true" readonly="readonly" id='fireDate' name='fireDate'/>
				</td>
				<td class='TableData'>凋落时间：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox  easyui-validatebox dateTime' required="true" readonly="readonly" id='yellowDate' name='yellowDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>1月降雪厚度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true"
				validType="integeZerol[] &addMethod[]" id='januarySnowThickness'
					name='januarySnowThickness'/>(毫米) </td>
				<td class='TableData'>2月降雪厚度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true"
				validType="integeZerol[] &addMethod[]" id='februarySnowThickness'
					name='februarySnowThickness'/>(毫米) </td>
			</tr>
			<tr>
				<td class='TableData'>12月降雪厚度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true"
				validType="integeZerol[] &addMethod[]" id='decemberSnowThickness'
					name='decemberSnowThickness'/>(毫米) </td>
				<td class='TableData'>初雪时间：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox  easyui-validatebox dateTime' required="true" readonly="readonly" id='firstSnowDate' name='firstSnowDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>全年降雪次数：</td>
				<td class='TableData' colspan="3"><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeBetweenLength[0,100]" id='snowAmount'
					name='snowAmount' /> </td>
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
					        <p id="p">
								<input type="file" id="gmp_green_photo" name="gmp_green_photo" onchange="change(this)"/>
					        请选择返青期照片文件</p>
						    
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
					        <p id="p">
								<input type="file" id="gmp_yellow_photo" name="gmp_yellow_photo" onchange="change(this)"/>
					        请选择凋落期照片文件</p>
						    
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
					        <p id="p">
								<input type="file" id="gmp_january_snow_photo" name="gmp_january_snow_photo" onchange="change(this)" />
					        请选择降雪照片文件</p>
						    
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
					        <p id="p">
								<input type="file" id="gmp_february_snow_photo" name="gmp_february_snow_photo" onchange="change(this)" />
					        请选择凋落期照片文件</p>
						    
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
					        <p id="p">
								<input type="file" id="gmp_december_snow_photo" name="gmp_december_snow_photo" onchange="change(this)"/>
					        请选择凋落期照片文件</p>
						    
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align:center;" colspan="4">
					<input type="hidden" id="sid" name="sid" value="<%=id %>"/>
					<input type="hidden" id="monitoringStationsId" name="monitoringStationsId" />
					<input  id="submitBtn"  type="button" value="提交" class="btn btn-success" style="background: #41a675;" onclick="saveGmp()"/>
				</td>
			</tr>
		</table>
	</form>
	
</body>
</html>