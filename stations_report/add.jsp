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
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
</head>
<script>
var id = '<%=id%>';
$(function(){
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
	 var url = contextPath+"/indicatorsRecordsController/getMonitoringStationsByUid.act";
		var json = tools.requestJsonRs(url);
		if(json && json.total>0){
			$('#monitoringStationsId').combobox({
				data:json.rows,
				valueField:'sid',
				textField:'stationsNum',
				onSelect:function(param){
					var jsonObj = getCityFullInfo(param.cityCode);
					if(jsonObj){
						$("#province").val(jsonObj.provinceFullName);
						$("#city").val(jsonObj.cityFullName);
					}
				 }
			 });
		  $('#monitoringStationsId').combobox('textbox').bind('click',function(){
				 $('#monitoringStationsId').combobox('showPanel');
		  });
		  $('#monitoringStationsId').combobox("setValue",json.rows[0].sid);
		  var jsonObj = getCityFullInfo(json.rows[0].cityCode);
			if(jsonObj){
				$("#province").val(jsonObj.provinceFullName);
				$("#city").val(jsonObj.cityFullName);
			}
		}else{
			$("#form1").empty();
			messageMsg("当前县（旗）下没有固定监测点,不可录入信息！","msg","warning");
		}
	  
})
function saveStationsReport(){
	if($("#form1").form("validate") && check()){
		var url = contextPath+"/stationsReportController/saveStationsReport.act";
		if(id!="null" && id!=null){
			url = contextPath+"/stationsReportController/updateStationsReport.act";
		}
		top.$.jBox.tip("文件上传中...", 'loading');
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			dataType:"text/html",  
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					top.$.jBox.tip(json.rtMsg,"success");
					$("#fileAttachContainor").empty();
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				} 
			}
		});
	} 
}

function getStationsReportById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/stationsReportController/getStationsReportById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var data = json.rtData;
			bindJsonObj2Cntrl(data);
			$("#monitoringStationsId").combobox('setValue',data.gmsSid);
			var jsonObj = getCityFullInfo(data.cityCode);
			if(jsonObj){
				$("#province").val(jsonObj.provinceFullName);
				$("#city").val(jsonObj.cityFullName);
				$("#county").val(jsonObj.countyFullName);
			}
		}
	}
}

function check(){
	var stationId = $("input[name=monitoringStationsId]").val();
	if(stationId==""){
		$.jBox.tip("请选择监测点","info");
		return false;
	}
	var child = $("#fileAttachContainor").children();
	if(child.length<1){
		$.jBox.tip("请选择文件","info");
		return false;
	}
	return true;
}
</script>
<body style="overflow-x: hidden; font-size: 12px;" onload="getStationsReportById()">
	<div class="moduleHeader">
		<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：固定监测点》<b class="second">科研试验区报告录入</b></b>
	</div>
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>选择监测点：</td>
				<td class='TableData' colspan="3"><input type="text" class='BigInput easyui-combobox' id='monitoringStationsId'
				name='monitoringStationsId' style="height:28px;line-height: 28px;"/></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'><input type="text" class='BigInput readonly' readonly="readonly" id='province'
					name='province'/>省 <input type="text" class='BigInput readonly' readonly="readonly" id='city'
					name='city'/>市(旗)</td>
				<td class='TableData'>年份：</td>
				<td class='TableData'>
					<select id="year" class="BigSelect" name="year">
					<%
						Calendar cl = Calendar.getInstance();
						int year = cl.get(Calendar.YEAR);
						for(int i=0;i<50;i++){
					%>
					    <option value="<%=year-i%>"><%=year-i%></option>
					<%
						}
					%>
					</select>
				</td>
			</tr>
			<tr>
				<td class='TableData'>选择试验区文件/照片：</td>
				<td class='TableData' colspan="3">
					<img onclick="add('stations_report')" src="<%=contextPath %>/resource/images/sys/fileAdd.png" title="点击添加文件"/>
					<div id="fileAttachContainor"></div>
				
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" >
					<input type="button" class='btn btn-success' style="background: #41a675;" value="录入" onclick="saveStationsReport()" />
				</td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
	<div id="msg"></div>
</body>
</html>