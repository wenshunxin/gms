<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String cityCode = (String)request.getSession().getAttribute("cityCode");
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
<script src="<%=contextPath %>/indicators_records/indicatorsRecords.js"></script>
</head>
<script>
var id = '<%=id%>';
var phone="";
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
	 var url = contextPath+"/indicatorsRecordsController/getMonitoringStationsByUid.act?cityCode=<%=cityCode%>";
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
					getIndicatorsByCityCode(param.cityCode);
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
			getIndicatorsByCityCode(json.rows[0].cityCode);
		}
	 }else{
			$("#form1").empty();
			messageMsg("当前县（旗）下没有固定监测点,不可录入信息！","msg","warning");
		}
});

function saveIndicatorsRecords(){
	if($("#form1").form("validate") && check()){
		var url = contextPath+"/indicatorsRecordsController/saveIndicatorsRecords.act";
		if(id!="null" && id!=null){
			url = contextPath+"/indicatorsRecordsController/updateIndicatorsRecords.act";
		}
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
					}
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	} 
}

function getIndicatorsRecordsById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/indicatorsRecordsController/getGmsIndicatorsRecordsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var data = json.rtData;
			bindJsonObj2Cntrl(data);
			$("#monitoringStationsId").combobox('setValue',data.gmsSid);
			getIndicatorsByCityCode(data.cityCode);
			$("#indicatorsId").combobox('setValue',data.indicatorsId);
			var jsonObj = getCityFullInfo(data.cityCode);
			if(jsonObj){
				$("#province").val(jsonObj.provinceFullName);
				$("#city").val(jsonObj.cityFullName);
				$("#county").val(jsonObj.countyFullName);
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

function check(){
	var monitoringStationsId = $("input[name=monitoringStationsId]").val();
	if(monitoringStationsId==""){
		top.$.jBox.tip("监测站点不能为空","error");
		return false;
	}
	var indicatorsId = $("input[name=indicatorsId]").val();
	if(indicatorsId==""){
	top.$.jBox.tip("指标名称不能为空！" ,"error");
		return false;
	}
	return true;
}
</script>
<body style="overflow: hidden; font-size: 12px; onload="getIndicatorsRecordsById()">
	<div class="moduleHeader">
		<img src='<%=contextPath%>/resource/images/sys/home.png'/><b class="first">当前位置：固定监测点》<b class="second">其他指标调查录入</b></b>
	</div>
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" colspan="4" style="text-align:left;">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>选择监测点：</td>
				<td class='TableData' colspan="3">
				<input type="text" class='BigInput easyui-combobox empty' id='monitoringStationsId' name='monitoringStationsId' style='height:28px;line-height: 28px;'/></td>
			</tr>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData' colspan="3"><input type="text" class='SmallInput readonly' readonly="readonly" id='province'
					name='province'/>省 <input type="text" class='BigInput readonly' readonly="readonly" id='city'
					name='city'/>市(旗)</td>			
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData' ><input type="text" class="BigInput empty" id='investigateUserNames' name='investigateUserNames' maxlength="20"/> </td>
				<td class='TableData'>调查日期：</td>
				<td class='TableData'><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly " id='investigateDate' name='investigateDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>指标名：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-combobox empty'   id='indicatorsId' name='indicatorsId' style='height:28px;line-height: 28px;'/> </td>
				<td class='TableData'>指标值：</td>
				<td class='TableData'>
					<input type="text" class="BigInput easyui-validatebox empty" id='indicatorsValue' name='indicatorsValue' validType="number[] &addMethodf[]" required="true"/> 
				</td>
			</tr>
			<tr>
				<td class="TableData" colspan="4" align="center">
					<input type="button" class="btn btn-success" style="background: #42a576;" value="录入" onclick="saveIndicatorsRecords();"/>
				
				</td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
	<div id="msg"></div>
</body>
</html>