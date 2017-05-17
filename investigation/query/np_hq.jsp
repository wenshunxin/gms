<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<form id="form1" name="form1" method="post">
	<table class="TableBlock" width="100%" style="margin:0 auto;border-left:0;border-right:0;">
		<tr>
			<td class="TableData">年份：</td>
			<td class="TableData">
				<select id="year" name="year" class="BigSelect" style="width:92px;">
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
				 市： <select name="city" id="city" onchange="getCounty();" class="BigSelect">
						<option value="">所有</option>
					</select> 
				县： <select name="county" id="county" class="BigSelect">
						<option value="">所有</option>
					</select>
			</td>
			
		</tr>
		<tr>
			<td class="TableData">植被盖度：</td>
			<td class="TableData">
				<input type="text" id='coverage' name='coverage' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] &addMethod[]"/>(%)
			</td>
			<td class="TableData">草群平均高度：</td>
			<td class="TableData">
				<input type="text" id='grassAvgHeight' name='grassAvgHeight' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,80] &addMethod[]" />(厘米)
			</td>
			<td class="TableData">草地类型：</td>
			<td class="TableData">
				<input id='grassCategory' name='grassCategory' class='BigInput easyui-combobox' style="height:28px;line-height: 28px;"/>
			</td>
		</tr>
		<tr>
			<td class="TableData">主要植物种：</td>
			<td class="TableData">
				<input type="text" id='mainPlant' name='mainPlant' class='BigInput easyui-validatebox' />
			</td>
			<td class="TableData">主要毒害草名称：</td>
			<td class="TableData">
				<input type="text" id='mainBadGrass' name='mainBadGrass' class='BigInput easyui-validatebox' />
			</td>
			<td class="TableData">总产草量鲜重：</td>
			<td class="TableData">
				<input type="text" id='freshAmount' name='freshAmount' class='SmallInput easyui-validatebox' validType='number[]'/>(千克/公顷)
			</td>
		</tr>
		<tr>
			<td class="TableData">总产草量风干重：</td>
			<td class="TableData">
				<input type="text" id='dryAmount' name='dryAmount' class='SmallInput easyui-validatebox' validType='number[]'/>(千克/公顷)
			</td>
			<td class="TableData">可食产草量鲜重：</td>
			<td class="TableData">
				<input type="text" id='edibleFreshAmount' name='edibleFreshAmount' class='SmallInput easyui-validatebox' validType='number[]'/>(千克/公顷)
			</td>
			<td class="TableData">可食产草量风干重：</td>
			<td class="TableData">
				<input type="text" id='edibleDryAmount' name='edibleDryAmount' class='SmallInput easyui-validatebox' validType='number[]'/>(千克/公顷)
			</td>
		</tr>
		<tr>
			<td class="TableData">审核情况：</td>
			<td class="TableData" colspan="5">
				<select id="auditStatus" name="auditStatus" class="BigSelect">
					<option value="">全部</option>
					<option value="0">未上报</option>
					<option value="1">待市级审核</option>
					<option value="2">待省级审核</option>
					<option value="3">市级审核驳回</option>
					<option value="4">省级审核通过</option>
					<option value="5">省级审核驳回</option>
				</select>
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