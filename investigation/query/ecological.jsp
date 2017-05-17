<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<form id="form1" name="form1" method="post">
	<table class="TableBlock" width="100%" style="margin:0 auto;border-left:0;border-right:0;">
		<tr>
			<td class="TableData">年份：</td>
			<td class="TableData">
				<select id="year" name="year" class="BigSelect">
					<option value="">全部</option>
					<%
						Calendar cl = Calendar.getInstance();
						int year = cl.get(Calendar.YEAR);
						for(int i = 0 ;i<50;i++){
					%>
					<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
				</select>
			</td>
			<td class="TableData">城市：</td>
			<td class="TableData" colspan="3">
				省： <select name="province" id="province" onchange="getCity();" class="BigSelect">
						<option value="">全国</option>
					</select>
				 市： <select name="city" id="city" onchange="getCounty();"class="BigSelect">
						<option value="">所有</option>
					</select> 
				县： <select name="county" id="county" class="BigSelect">
						<option value="">所有</option>
					</select>
			</td>
		</tr>
		<tr>
			<td class="TableData">草原退化：</td>
			<td class="TableData">
				<select id="degradation" name="degradation" class="BigSelect">
					<option value="">无</option>
					<option value="degradation_size">分布面积</option>
					<option value="degradation_mild_size">分级面积（轻度）</option>
					<option value="degradation_moderate_size">分级面积（中度）</option>
					<option value="degradation_severe_size">分级面积（重度）</option>
				</select>
			</td>
			<td class="TableData">
				<select id="degradationCondition" name="degradationCondition" class="BigSelect">
					<option value="">请选择查询规则</option>
					<option value="0">等于</option>
					<option value="1">大于</option>
					<option value="2">小于</option>
					<option value="3">在区间内</option>
					<option value="4">在区间外</option>
				</select>
			</td>
			<td class="TableData" colspan="3">
				<input type='text' id="degradationValue" name="degradationValue" class="BigInput easyui-validatebox" validType="number[]"/>
				<div id="degradationValueDiv" style='display:none'>
					<input type='text' id="startDegradationValue" name="startDegradationValue" class="SmallInput easyui-validatebox" validType="number[]"/>&nbsp;到&nbsp;
					<input type='text' id="endDegradationValue" name="endDegradationValue" class="SmallInput easyui-validatebox" validType="number[]"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="TableData">草原盐渍化：</td>
			<td class="TableData">
				<select id="salinization" name="salinization" class="BigSelect">
					<option value="">无</option>
					<option value="salinization_size">分布面积</option>
					<option value="salinization_mild_size">分级面积（轻度）</option>
					<option value="salinization_moderate_size">分级面积（中度）</option>
					<option value="salinization_severe_size">分级面积（重度）</option>
				</select>
			</td>
			<td class="TableData">
				<select id="salinizationCondition" name="salinizationCondition" class="BigSelect">
					<option value="">请选择查询规则</option>
					<option value="0">等于</option>
					<option value="1">大于</option>
					<option value="2">小于</option>
					<option value="3">在区间内</option>
					<option value="4">在区间外</option>
				</select>
			</td>
			<td class="TableData" colspan="3">
				<input type='text' id="salinizationValue" name="salinizationValue" class="BigInput easyui-validatebox" validType="number[]"/>
				<div id="salinizationValueDiv" style='display:none'>
					<input type='text' id="startSalinizationValue" name="startSalinizationValue" class="SmallInput easyui-validatebox" validType="number[]"/>&nbsp;到&nbsp;
					<input type='text' id="endSalinizationValue" name="endSalinizationValue" class="SmallInput easyui-validatebox" validType="number[]"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="TableData">草原沙化：</td>
			<td class="TableData">
				<select id="desertification" name="desertification" class="BigSelect">
					<option value="">无</option>
					<option value="desertification_size">分布面积</option>
					<option value="desertification_mild_size">分级面积（轻度）</option>
					<option value="desertification_moderate_size">分级面积（中度）</option>
					<option value="desertification_severe_size">分级面积（重度）</option>
				</select>
			</td>
			<td class="TableData">
				<select id="desertificationCondition" name="desertificationCondition" class="BigSelect">
					<option value="">请选择查询规则</option>
					<option value="0">等于</option>
					<option value="1">大于</option>
					<option value="2">小于</option>
					<option value="3">在区间内</option>
					<option value="4">在区间外</option>
				</select>
			</td>
			<td class="TableData" colspan="3">
				<input type='text' id="desertificationValue" name="desertificationValue" class="BigInput easyui-validatebox" validType="number[]"/>
				<div id="desertificationValueDiv" style='display:none'>
					<input type='text' id="startDesertificationValue" name="startDesertificationValue" class="SmallInput easyui-validatebox" validType="number[]"/>&nbsp;到&nbsp;
					<input type='text' id="endDesertificationValue" name="endDesertificationValue" class="SmallInput easyui-validatebox" validType="number[]"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="TableData">草原石漠化：</td>
			<td class="TableData">
				<select id="rockyDesertification" name="rockyDesertification" class="BigSelect">
					<option value="">无</option>
					<option value="rocky_desertification_size">分布面积</option>
					<option value="rocky_desertification_mild_size">分级面积（轻度）</option>
					<option value="rocky_desertification_moderate_size">分级面积（中度）</option>
					<option value="rocky_desertification_severe_size">分级面积（重度）</option>
				</select>
			</td>
			<td class="TableData">
				<select id="rockyDesertificationCondition" name="rockyDesertificationCondition" class="BigSelect">
					<option value="">请选择查询规则</option>
					<option value="0">等于</option>
					<option value="1">大于</option>
					<option value="2">小于</option>
					<option value="3">在区间内</option>
					<option value="4">在区间外</option>
				</select>
			</td>
			<td class="TableData" colspan="3">
				<input type='text' id="rockyDesertificationValue" name="rockyDesertificationValue" class="BigInput easyui-validatebox" validType="number[]"/>
				<div id="rockyDesertificationValueDiv" style='display:none'>
					<input type='text' id="startRockyDesertificationValue" name="startRockyDesertificationValue" class="SmallInput easyui-validatebox" validType="number[]"/>&nbsp;到&nbsp;
					<input type='text' id="endRockyDesertificationValue" name="endRockyDesertificationValue" class="SmallInput easyui-validatebox" validType="number[]"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="TableData" colspan='6' align='center'>
				<input type="hidden" id="cityCode" name="cityCode"/>
				<input type='button' class='btn btn-success' style="background: #41a675;" onclick="doSearch();" value="查询"/>
				<input type='button' class='btn btn-warning' onclick="doReset();" value="重置"/>
				<input type='button' class="btn btn-success" style="background: #41a675;" value="批量下载" onclick="multiExportInfo();"/>
				<input type='button' class="btn btn-success" style="background: #41a675;" value="全部下载" onclick="allExportInfo();"/>
			</td>
		</tr>
	</table>

</form>