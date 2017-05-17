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
<script>
var datagrid;
var id = '<%=id%>';
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
	 var stationId="";
	 if(id!="null" && id!=null){
		 stationId =  getSocialById(id);
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


function saveGms(){
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsController/saveGmsInfo.act";
	    if(id!="null" && id!=null){
			url = contextPath+"/gmsController/updateGms.act";
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

function getSocialById(id){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsController/getGmsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			$("#submitBtn").hide();
			return json.rtData.basicInfo.monitoringStationsId;
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

</script>
</head>
<body onload="doInit();" style="overflow:hidden;margin-bottom: 100px; font-size: 12px; margin-top:10px;">
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
					class='SmallInput easyui-validatebox  easyui-validatebox' required="true" readonly="readonly" id='investigateDate' name='investigateDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text" id='investigateUserNames'
					name='investigateUserNames' class="BigInput" maxlength="20" /> </td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><input type="text" id='mobilePhone'
					name='mobilePhone' class="BigInput easyui-validatebox" validType="" maxlength="13" /> </td>
			</tr>
			<tr>
				<td class='TableData'>所在县国土总面积：</td>
				<td class='TableData'><input type="text" id='landArea'
					name='landArea' class="SmallInput easyui-validatebox" required="true"  validType="integeZerol[] & addMethod[]"/>(公顷)
				</td>
				<td class='TableData'>所在县草原面积：</td>
				<td class='TableData'><input type="text" id='prairieArea'
					name='prairieArea' class="SmallInput easyui-validatebox" required="true"  validType="integeZerol[] & addMethod[]"/>(公顷)
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县天然草原面积：</td>
				<td class='TableData'><input type="text" id='naturalPrairieArea'
					name='naturalPrairieArea' class="SmallInput easyui-validatebox" required="true"  validType="integeZerol[] & addMethod[]"/>(公顷)
				</td>
				<td class='TableData'>所在县天然草原可利用面积：</td>
				<td class='TableData'><input type="text" id='availableNaturalPrairieArea'
					name='availableNaturalPrairieArea' class="SmallInput easyui-validatebox" required="true"  validType="integeZerol[] & addMethod[]"/>(公顷)
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县退化草原面积：</td>
				<td class='TableData'><input type="text" id='degradationPrairieArea'
					name='degradationPrairieArea' class="SmallInput easyui-validatebox" required="true"  validType="integeZerol[] & addMethod[]"/>(公顷)
				</td>
				<td class='TableData'>所在县牧户数：</td>
				<td class='TableData'><input type="text" id='herdingNums'
					name='herdingNums' class="SmallInput easyui-validatebox" required="true"  validType="integeZero[]"/>(户)
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县草食牲畜年末存栏量：</td>
				<td class='TableData'><input type="text" id='animalAmount'
					name='animalAmount' class="SmallInput easyui-validatebox" required="true"  validType="integeZero[]"/>(头)
				</td>
				<td class='TableData'>所在县职工年平均工资：</td>
				<td class='TableData'><input type="text" id='workerAvgSalary'
					name='workerAvgSalary' class="SmallInput easyui-validatebox" required="true"  validType="integeZerol[] & addMethod[]"/>(元)
				</td>
			</tr>
			<tr>
				<td class='TableData'>所在县农牧民年人均纯收入：</td>
				<td class='TableData' colspan="3"><input type="text" class="SmallInput easyui-validatebox" required="true"  validType="integeZerol[] & addMethod[]" id='herdingNetIncome'
					name='herdingNetIncome' />(元)</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align:center;" colspan="4">
					<input type="hidden" id="sid" name="sid" value="<%=id %>"/>
					<input type="hidden" id="monitoringStationsId" name="monitoringStationsId" />
					<input id="submitBtn" type="button" value="提交" class="btn btn-success" style="background: #41a675;" onclick="saveGms()"/>
				</td>
			</tr>
		</table>
	</form>
	
</body>
</html>