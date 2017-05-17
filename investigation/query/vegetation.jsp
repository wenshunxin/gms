<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<form id="form1" name="form1" method="post">
	<table class="TableBlock" width="100%" style="margin:0 auto;border-left: 0;border-right:0;">
		<tr>
			<td class="TableData">年份：</td>
			<td class="TableData">
				<select id="year" name="year" class="BigSelect" style="width:78px;">
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
						<option value="">请选择</option>
					</select>
				 市： <select name="city" id="city" onchange="getCounty();"class="BigSelect">
						<option value="">请选择</option>
					</select> 
				县： <select name="county" id="county" class="BigSelect">
						<option value="">请选择</option>
					</select>
			</td>
		</tr>
		<tr>
			
			<td class="TableData">坡位：</td>
			<td class="TableData">
				<select id="grassSlopePosition" name="grassSlopePosition" class="BigSelect" style="width:78px;">
					<option value="">全部</option>
					<option value="坡脚">坡脚</option>
					<option value="坡顶">坡顶</option>
					<option value="坡下部">坡下部</option>
					<option value="坡中部">坡中部</option>
					<option value="坡上部">坡上部</option>
				</select>
			</td>
			<td class="TableData">坡向：</td>
			<td class="TableData">
				<select id="grassSlope" name="grassSlope" class="BigSelect" style="width:78px;">
					<option value="">全部</option>
					<option value="阳坡">阳坡</option>
					<option value="半阳坡">半阳坡</option>
					<option value="半阴坡">半阴坡</option>
					<option value="阴坡">阴坡</option>
				</select>
			</td>
			<td class="TableData">草地类型：</td>
			<td class="TableData">
				<input id='grassCategory' name='grassCategory' class='BigInput easyui-combobox' style='height:28px;line-height: 28px;'/>
			</td>
		</tr>
		<tr>
			<td class="TableData">土壤墒情：</td>
			<td class="TableData">
				<select id="soilMoisture" name="soilMoisture" class="BigSelect" style="width:78px;">
					<option value="">全部</option>
					<option value="干旱">干旱</option>
					<option value="中等">中等</option>
					<option value="湿润">湿润</option>
					<option value="其他">其他</option>
				</select>
			</td>
			<td class="TableData">地形地貌：</td>
			<td class="TableData">
				<select id="grassLandscape" name="grassLandscape" class="BigSelect" style="width:78px;">
					<option value="">全部</option>
					<option value="平原">平原</option>
					<option value="丘陵">丘陵</option>
					<option value="山地">山地</option>
					<option value="高原">高原</option>
					<option value="盆地">盆地</option>
				</select>
			</td>
			<td class="TableData">植被长势综合评价：</td>
			<td class="TableData">
				<select id="evaluation" name="evaluation" class="BigSelect" style="width:78px;">
					<option value="">全部</option>
					<option value="好">好</option>
					<option value="中">中</option>
					<option value="差">差</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="TableData">利用方式：</td>
			<td class="TableData">
				<select id="usingType" name="usingType" class="BigSelect">
					<option value="">全部</option>
					<option value="打草场">打草场</option>
					<option value="冷季放牧">冷季放牧</option>
					<option value="暖季放牧">暖季放牧</option>
					<option value="春季放牧">春季放牧</option>
					<option value="全年放牧">全年放牧</option>
					<option value="禁牧">禁牧</option>
					<option value="其他">其他</option>
				</select>
			</td>
			<td class="TableData">利用状况：</td>
			<td class="TableData">
				<select id="usingStatus" name="usingStatus" class="BigSelect">
					<option value="">全部</option>
					<option value="未利用">未利用</option>
					<option value="轻度利用">轻度利用</option>
					<option value="合理利用">合理利用</option>
					<option value="超载">超载</option>
					<option value="严重超载">严重超载</option>
				</select>
			</td>
			<td class="TableData">审核情况：</td>
			<td class="TableData">
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