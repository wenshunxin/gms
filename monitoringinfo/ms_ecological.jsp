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
var id = '<%= id %>';
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
	 }
	 if(id!="null" && id!=null){
		 $("input[type='button']").remove();
	 }
	 findById();
}


function saveGme(){
	if($("#form1").form("validate")){
		var url = contextPath+"/gmeController/saveGmeInfo.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmeController/updateGme.act";
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


function findById(){
	 if(id!="null" && id!=null){
			var url = contextPath+"/gmeController/getGmeById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				//基本信息
				var basicInfo = json.rtData.basicInfo;
				console.log(basicInfo);
				bindJsonObj2Cntrl(basicInfo);
				var cityJson = getCityFullInfo(basicInfo.cityCode);
				if(cityJson){
					var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName+" "+basicInfo.cityShortName;
					$("#stationAddress").text(cityDesc);
				}
			}
		}
}


</script>
</head>
<body onload="doInit();" style="overflow-y:scroll;margin-bottom:100px; margin-top:10px;font-size: 12px">
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
					class='SmallInput easyui-validatebox ' required="true" readonly="readonly" id='investigateDate' name='investigateDate'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text" id='investigateUserNames'
					name='investigateUserNames' class="BigInput" maxlength="20" /> </td>
				<td class='TableData'>联系电话：</td>
				<td class='TableData'><input type="text" id='contactPhone'
					name='contactPhone' class="BigInput  easyui-validatebox" validType="" maxlength="13" /> </td>
			</tr>
			<tr>
				<td class='TableData'>枯落物重量：</td>
				<td class='TableData'>
					<input type="text" id='litterAmount'
					name='litterAmount' class="SmallInput easyui-validatebox" required="true" validType="integeZerol[] &addMethod[]"/>(克/平方米)
				</td>
				<td class='TableData'>辅助区利用方式：</td>
				<td class='TableData'>
					<select id="auxiliaryUsingType" name="auxiliaryUsingType" class="BigSelect easyui-validatebox" required="true" >
							<option value="">请选择利用方式</option>
							<option value="打草场">打草场</option>
							<option value="冷季放牧">冷季放牧</option>
							<option value="暖季放牧">暖季放牧</option>
							<option value="春季放牧">春季放牧</option>
							<option value="全年放牧">全年放牧</option>
							<option value="禁牧">禁牧</option>
							<option value="其他">其他</option>
					</select>
					
				</td>
			</tr>
			<tr>
				<td class='TableData'>辅助区利用状况：</td>
				<td class='TableData'>
					<select id="auxiliaryUsingStatus" name="auxiliaryUsingStatus" class="BigSelect easyui-validatebox" required="true">
							<option value="">请选择利用状况</option>
							<option value="未利用">未利用</option>
							<option value="轻度利用">轻度利用</option>
							<option value="合理利用">合理利用</option>
							<option value="超载">超载</option>
							<option value="严重超载">严重超载</option>
					</select>
				</td>
				<td class='TableData'>土壤容重：</td>
				<td class='TableData'>
					<input type="text" id='soilWeight'
					name='soilWeight' class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[0,2] &addMethod[]" />(克/立方厘米)
				</td>
			</tr>
			<tr>
				<td class='TableData'>土壤含盐量：</td>
				<td class='TableData'>
					<input type="text" id='soilSalt'
					name='soilSalt' class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[0,100] &addMethod[]" />(%)
				</td>
					<td class='TableData'>土壤PH：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[0,14] &addMethod[]" id='soilPh'
					name='soilPh'/></td>
			</tr>
			<tr>
					<td class='TableData'>土壤有机质含量：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[0,100] &addMethod[]" id='soilOrganic'
					name='soilOrganic'/>(%) </td>
					<td class='TableData'>土壤全氮含量：</td>
				<td class='TableData'>
				<input type="text" class="SmallInput easyui-validatebox" required="true" validType="numberBetweenLength[0,100] &addMethod[]" id='soilNitrogen'
					name='soilNitrogen'/>(克)
				</td>
			</tr>
			<tr>
					<td class='TableData'>植物种数参考值：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" required="true" validType="integeBetweenLength[0,1000]"  id='plantAmount'
					name='plantAmount'/></td>
					<td class='TableData'>主要植物种名称：</td>
				<td class='TableData'>
					<input type="text" class="BigInput easyui-validatebox" required="true" validType="isBlank[]" id='mainPlants'
					name='mainPlants'/>
				 </td>
			</tr>
			<tr>
				<td class="TableHeader" style='text-align:left;' colspan="4">物种一</td>
			</tr>
			<tr>
				<td class='TableData'>盖度百分比：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='firstPlantCoverage'
					name='firstPlantCoverage' />(%) </td>
				<td class='TableData'>重量百分比：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='firstPlantWeight'
					name='firstPlantWeight' />(%) </td>
			</tr>
			<tr>
				<td class='TableData'>算数优势度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='firstPlantAdvantage'
					name='firstPlantAdvantage' />(%) </td>
					<td class='TableData'>物种名称：</td>
				<td class='TableData'><input type="text" class="BigInput" id='secondPlantName'
					name='firstPlantName' /> </td>
			</tr>
			<tr>
				<td class="TableHeader" style='text-align:left;' colspan="4">物种二</td>
			</tr>
			<tr>
				<td class='TableData'>盖度百分比：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='secondPlantCoverage'
					name='secondPlantCoverage' />(%) </td>
				<td class='TableData'>重量百分比：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='secondPlantWeight'
					name='secondPlantWeight' />(%) </td>
			</tr>
			<tr>
				<td class='TableData'>算数优势度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='secondPlantAdvantage'
					name='secondPlantAdvantage' />(%) </td>
					<td class='TableData'>物种名称：</td>
				<td class='TableData'><input type="text" class="BigInput" id='secondPlantName'
					name='secondPlantName' /> </td>
			</tr>
			<tr>
				<td class="TableHeader" style='text-align:left;' colspan="4">物种三</td>
			</tr>
			<tr>
				<td class='TableData'>盖度百分比：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]"  id='thirdPlantCoverage'
					name='thirdPlantCoverage' />(%) </td>
				<td class='TableData'>重量百分比：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='thirdPlantWeight'
					name='thirdPlantWeight' />(%) </td>
			</tr>
			<tr>
				<td class='TableData'>算数优势度：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox"  validType="numberBetweenLength[0,100] &addMethod[]" id='thirdPlantAdvantage'
					name='thirdPlantAdvantage' />(%) </td>
					<td class='TableData'>物种名称：</td>
				<td class='TableData'><input type="text" class="BigInput" id='thirdPlantName'
					name='thirdPlantName' /> </td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align:center;" colspan="4">
					<input type="hidden" id="monitoringStationsId" name="monitoringStationsId" />
					<input type="button" value="提交" class="btn btn-success" style="background:#41a675;" onclick="saveGme()"/>
				</td>
			</tr>
		</table>
	</form>
	
</body>
</html>