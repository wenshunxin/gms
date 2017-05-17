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
<script type="text/javascript" src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/check.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script src="<%=contextPath %>/monitoringinfo/monitoring.js"></script>
<script>
var id = '<%= id %>';
var datagrid;
function doInit(){
	 $("#investigateDate").datetimepicker({
		 language:"zh-CN",   
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 })
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 if(parent.document.getElementById("monitoringStationsId")){
		 var stationId = parent.document.getElementById("monitoringStationsId").value;
		 if(stationId==""){
			 return;
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
		 var stationsType = returnStationType();
		 $("#stationsType").val(stationsType);
		 if(stationsType>0){
			 $("#permanentInfo").remove();
		 }
	 }
	 findById();
}


function saveGhoa(){
	if($("#form1").form("validate")&&check()){
		var url = contextPath+"/ghoaController/saveGhoaInfo.act";
		if(id!="null" && id!=null){
			url = contextPath+"/ghoaController/updateGhoa.act";
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
						var content = top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow;
						content.$("#tabss").tabs("getSelected").find("iframe")[0].contentWindow.datagrid.datagrid('reload');
						top.$(".jbox-body").remove();
					}else{
						$("#form1").resetForm();
					}
					
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}


function findById(){
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
					$("#attachContainor .preview").attr("src",encodeURI(attachUrl));
				}
				// var attachList2 = json.rtData.attachList2;
				// for(var i = 0 ;i<attachList2.length;i++){
				// 	var attach = attachList2[i];
				// 	var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				// 	//$("#attachContainor .preview").attr("src",encodeURI(attachUrl));
				// }
			}
		}
}

function check(){
	var  src=contextPath+"/resource/images/sys/fileImg.png";
	var attachContainor=$("#attachContainor").find("img.preview").attr("src");
	var stationsType=$("#stationsType").val();
	if( stationsType==0 &&attachContainor==src){
		top.$.jBox.tip("永久观测区景观照片不能为空！","error");
		$("#ghoa_perpetual_photo").focus();
		return false;
	}
	return true;

}
</script>
</head>
<body onload="doInit();" style="overflow-y:scroll; font-size: 12px; margin-top:10px;">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData' colspan="1">监测点编号：</td>
				<td class='TableData' colspan="3"><span id="stationsNum"></span></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>
 					<span id="stationAddress"></span>
				</td>
				<td class='TableData'>调查日期：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly" id='investigateDate' name='investigateDate'/>
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
					<td class='TableData'>植物盖度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validType="numberBetweenLength[0,100] & addMethod[]" required="true" id='coverage'
					name='coverage'/>(%)</td>
					<td class='TableData'>草群平均高度：</td>
				<td class='TableData'>
					<input type="text" class="SmallInput easyui-validatebox" required="true"  validType="numberBetweenLength[0,80] & addMethod[]" id='grassAvgHeight'
					name='grassAvgHeight'/>(厘米)
				 </td>
			</tr>
			<tr>
				<td class='TableData'>选择景观照照片：</td>
				<td class='TableData' colspan="3">
					<div id="attachContainor">
						<div class="attachContainorDiv" style="margin-left:0px;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="ghoa_landscape_photo" name="ghoa_landscape_photo" onchange="change(this)"/>
					        请选择景观照片文件</p>
					    </div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align:center;" colspan="4">
					<input type="hidden" id="monitoringStationsId" name="monitoringStationsId" />
					<input type="hidden" id="stationsType" name="stationsType" />
					<input type="hidden" id="sid" name="sid" value="<%= id %>"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>