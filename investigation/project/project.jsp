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
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
</head>
<script>
var id = '<%=id%>';
$(function(){
	 $("input[name=projectMeasures]").each(function(e,i){
		$(this).click(function(){
			if($(this).attr("checked")){
				$(this).removeAttr("checked");
			}else{
				$(this).attr("checked","checked");
			}
		});
	 });
	 $("#projectBuildingDate").datetimepicker({
		 language:"zh-CN",   
		 startView: 'decade',
		 minView: 'decade',
		 format:"yyyy",
		 endDate : new Date(),
	     autoclose: true
	 });
	 $("#projectBuildingDate").val(new Date().getFullYear());
	 getCityInfo("cityInfo");
});
function saveProject(){
	$("#projectAddress").val($("#cityInfo").text()+"-"+$("#countyName").val());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsProjectController/saveProject.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsProjectController/updateProject.act";
		}
		var param=tools.formToJson($("#form1"));
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			top.$.jBox.tip(json.rtMsg,"success");
			parent.datagrid.datagrid("reload");
			parent.$(".jbox-body").remove();
		}else{
			top.$.jBox.tip("系统异常！","error");
		}
	}
}
function getProjectById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsProjectController/getProjectById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			bindJsonObj2Cntrl(json.rtData);
			var area = json.rtData.projectAddress;
			var index = area.indexOf("-");
			if(index>-1){
				var countyName= area.substring(index+1,area.length);
				$("#countyName").val(countyName);
			}
		}
	}
}
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getProjectById();">
	<form id="form1" name="form1" method="post">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>工程名称：</td>
				<td class='TableData'>
					<select id='projectName'name='projectName'  class='BigSelect' >
						<option value="京津风沙源治理工程">京津风沙源治理工程</option>
						<option value="退牧还草工程">退牧还草工程</option>
						<option value="西南岩溶地区草地治理试点工程">西南岩溶地区草地治理试点工程</option>
						<option value="岩溶地区石漠化综合治理">岩溶地区石漠化综合治理</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class='TableData'>工程建设时间：</td>
				<td class='TableData'><input type="text"
					id='projectBuildingDate' name='projectBuildingDate'
					class='SmallInput easyui-validatebox ' readonly="readonly"
					required="true" />(年)</td>
			</tr>
			<tr>
				<td class='TableData'>工程面积：</td>
				<td class='TableData'><input type="text" id='projectSize'
					name='projectSize' class='BigInput easyui-validatebox'
					required="true" />(公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>工程措施：</td>
				<td class='TableData'><input type="checkbox" id="measure1"
					name='projectMeasures' class='' value="人工种草" /><label
					for="measure1">人工种草</label> <input type="checkbox" id="measure2"
					name='projectMeasures' class='' value="飞播牧草" /><label
					for="measure2">飞播牧草</label> <input type="checkbox" id="measure3"
					name='projectMeasures' class='' value="围栏封育" /><label
					for="measure3">围栏封育</label><br /> <input type="checkbox"
					id="measure4" name='projectMeasures' class='' value="基本牧草" /><label
					for="measure4">基本牧草</label> <input type="checkbox" id="measure5"
					name='projectMeasures' class='' value="草种基地" /><label
					for="measure5">草种基地</label> <input type="checkbox" id="measure6"
					name='projectMeasures' class='' value="禁牧" /><label for="measure6">禁牧</label>
				</td>
			</tr>
			<tr>
				<td class='TableData'>工程投资：</td>
				<td class='TableData'><input type="text" id='projectInvestment'
					name='projectInvestment' class='BigInput easyui-validatebox'
					required="true" />(万元)</td>
			</tr>
			<tr>
				<td class='TableData'>中央投资：</td>
				<td class='TableData'><input type="text"
					id='projectNationalInvestment' name='projectNationalInvestment'
					class='BigInput easyui-validatebox' required="true" />(万元)</td>
			</tr>
	<!-- 		<tr>
				<td class='TableData'>工程所在区域：</td>
				<td class='TableData'>
					<input type="text" id='projectArea'name='projectArea' class='BigInput easyui-validatebox'required="true" />
				</td>
			</tr> -->
			<tr>
				<td class='TableData'>工程地点：</td>
				<td class='TableData'>
					<span id="cityInfo"></span>
					乡镇：<input id='countyName' name='countyName' class='SmallInput easyui-validatebox' maxlength="20" />
					<input type="hidden" id='projectAddress' name='projectAddress'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>描述：</td>
				<td class='TableData'><textarea id='remark' name='remark' autocomplete="off" cols="30" class='BigTextarea'></textarea></td>
			</tr>
		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' />
	</form>
</body>
</html>