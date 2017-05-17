<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<form id="form1" name="form1" method="post">
	<table class="TableBlock" width="100%" style="margin:0 auto;border-left:0;border-right:0;">
		<tr>
			<td class="TableData">城市：</td>
			<td class="TableData">
				省： <select name="province" id="province" onchange="getCity();" class="BigSelect">
						<option value="">请选择</option>
					</select>
				 市： <select name="city" id="city" onchange="getCounty();" class="BigSelect">
						<option value="">请选择</option>
					</select> 
				县： <select name="county" id="county" class="BigSelect">
						<option value="">请选择</option>
					</select>
			</td>
			<td class="TableData">学历：</td>
			<td class="TableData">
				<select id="investigatorDegree" name="investigatorDegree" class="BigSelect">
					<option value="">全部</option>
					<option value="博士">博士</option>
					<option value="硕士">硕士</option>
					<option value="本科">本科</option>
					<option value="大专">大专</option>
					<option value="大专以下">大专以下</option>
				</select>
			</td>
		</tr>
		<tr>
			
		</tr>
		<tr>
			<td class="TableData">专业：</td>
			<td class="TableData">
				<select id="investigatorMajor" name="investigatorMajor" class="BigSelect">
					<option value="">全部</option>
					<option value="草业科学">草业科学</option>
					<option value="畜牧兽医">畜牧兽医</option>
					<option value="农学">农学</option>
					<option value="生态学">生态学</option>
					<option value="地理学">地理学</option>
					<option value="环境科学">环境科学</option>
					<option value="遥感科学与技术">遥感科学与技术</option>
					<option value="地理信息系统">地理信息系统</option>
					<option value="其他">其他</option>
				</select>
			</td>
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
		</tr>
			<td class="TableData">年龄：</td>
			<td class="TableData" colspan="3">
				<input type='text' id="ageStart" name="ageStart" class="SmallInput easyui-validatebox" validType="number[]"/>到<input type ='text' id="ageEnd" name="ageEnd" class="SmallInput easyui-validatebox" validType="number[]" />
			</td>
		<tr>
			<td class="TableData" colspan='4' align='center'>
				<input type="hidden" id="cityCode" name="cityCode"/>
				<input type='button' class='btn btn-success' style="background: #41a675;" onclick="doSearch();" value="查询"/>
				<input type='button' class='btn btn-warning' onclick="doReset();" value="重置"/>
				<input type='button' class="btn btn-success" style="background: #41a675;" value="批量下载" onclick="multiExportInfo();"/>
				<input type='button' class="btn btn-success" style="background: #41a675;" value="全部下载" onclick="allExportInfo();"/>
			</td>
		</tr>
	</table>

</form>