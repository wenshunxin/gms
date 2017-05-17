<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String year = request.getParameter("year");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script src="<%=contextPath %>/indicators_records/indicatorsRecords.js"></script>
</head>
<script>
var year = '<%=year%>';
$(function(){
	 
	  $('#year').combobox('textbox').bind('click',function(){
			 $('#year').combobox('showPanel');
	  });
	  $('#year').combobox({
		  onSelect:function(){
			  $(".easyui-validatebox").val("");
			  getAnnualMonitoringPlanByYear();
		  }
	  });
	  
	  var url = contextPath + "/gmsCityController/getProvinceList.act";
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			var prcList = json.rtData;
			if(prcList.length){
				$.each(prcList,function(i,prc){
					var template="<tr style='text-align: center;'><td class='TableData'>"
							+"<input type=\"hidden\" class='SmallInput '  name=\"cityCode\" value=\""+prc.cityCode+"\" id=\"cityCode"+prc.cityCode+"\" />"
							+"<span>"+prc.cityFullName+"</span>"
							+"</td>"
							+"<td class=\'TableData\'>"
							+"<input type=\"text\" class=\"SmallInput easyui-validatebox\" validType='integeZero[]' name=\"phenologicalNums"+prc.cityCode+"\" id=\"phenologicalNums"+prc.cityCode+"\"/>"
							+"</td>"
							+"<td class=\'TableData\'>"
							+"<input type=\"text\" class='SmallInput easyui-validatebox'  validType='integeZero[]' name=\"sampleAreaNums"+prc.cityCode+"\" id=\"sampleAreaNums"+prc.cityCode+"\" />"
							+"</td>"
							+"<td class=\'TableData\'>"
							+"<input type=\"text\" class='SmallInput easyui-validatebox' validType='integeZero[]' name=\"feedingHouseNums"+prc.cityCode+"\" id=\"feedingHouseNums"+prc.cityCode+"\" />"
							+"</td>"
							+"<td class=\'TableData\'>"
							+"<input type=\"text\" class='SmallInput easyui-validatebox'  validType='integeZero[]' name=\"monitoringStationsNums"+prc.cityCode+"\" id=\"monitoringStationsNums"+prc.cityCode+"\" />"
							+"</td>"
							+"</tr>";
					$("#table").append(template);
				});
			}
			$(".easyui-validatebox").validatebox();
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
})

function saveAnnualMonitoringPlan(){
	if($("#form1").form("validate") && check()){
		var url = contextPath+"/annualMonitoringPlanController/saveAnnualMonitoringPlan.act";
		if(year!="null" && year!=null){
			url = contextPath+"/annualMonitoringPlanController/updateAnnualMonitoringPlan.act";
		}
		var param=tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			top.$.jBox.tip(json.rtMsg,"success");
			top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
			top.$(".jbox-body").remove();
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	} 
}

function getAnnualMonitoringPlanByYear(){
		var years= $("input[name=year]").val();
		var url = contextPath+"/annualMonitoringPlanController/getAnnualMonitoringPlanByYear.act?year="+year;
		if(year=="null" || year==null){
			url = contextPath+"/annualMonitoringPlanController/getAnnualMonitoringPlanByYear.act?year="+years;
			$('#year').combobox('setValue', years);
		}else{
			$('#year').combobox("disable");
			$('#year').combobox('setValue', year);
		}
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var data = json.rtData;
			for(var i=0;i<data.length;i++){
				bindJsonObj2Cntrl(data[i],null,data[i].cityCode);
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
		
}

function copy(){
	var years = parseInt($("input[name=year]").val())-1;
	var url = contextPath+"/annualMonitoringPlanController/getAnnualMonitoringPlanByYear.act?year="+years;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		//基本信息
		var data = json.rtData;
		if(data.length>0){
			$(".easyui-validatebox").val("");
			for(var i=0;i<data.length;i++){
				bindJsonObj2Cntrl(data[i],null,data[i].cityCode);
			}
		}else{
			top.$.jBox.tip("没有上一年的监测计划数据","info");
		}
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}


function check(){
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
/* 	if(province=="" && city=="" && county==""){
		$.jBox.tip("请选择省/市/县","error");
		return false;
	} */
	return true;
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getAnnualMonitoringPlanByYear()" >
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' id="table" style='width: 95%; margin: 0 auto;'>
			<tr style="text-align: center;">
				<td class='TableData'>设置年份：</td>
				<td class='TableData'>
					<select id="year" class="BigSelect easyui-combobox" name="year" style="width:80px;height:28px;line-height: 28px;">
					<%
						Calendar cl = Calendar.getInstance();
						int ye = cl.get(Calendar.YEAR);
						for(int i=0;i<50;i++){
					 %>
					 <option value="<%=ye-i %>"><%=ye-i %></option>
					<%
						}
					%>
					</select>
				</td>
				<td class='TableData' colspan="3"><input type="button" class="btn btn-success" style="background: #41a675;" value="复制上年度监测计划" onclick="copy()" /></td>
			</tr>
			<tr  style="text-align: center;">
				<td class='TableData' >省份</td>
 				<td class='TableData'>物侯监测县数(个)</td>
 				<td class='TableData'>盛期样地数量(个)</td>
 				<td class='TableData'>计划入户调查数(户)</td>
 				<td class='TableData'>固定监测点个数(个)</td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=year %>' />
	</form>
</body>
</html>