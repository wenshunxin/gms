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
			<td class="TableData" colspan="2">
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
			<td class="TableData">户主姓名：</td>
			<td class="TableData" colspan="1">
				<input type="text" id='householdUserName' name='householdUserName' class='BigInput easyui-validatebox' maxlength="20"  validType=""/>
			</td>
			<td class="TableData">限定项：</td>
			<td class="TableData" colspan="1">
				<select id="queryItem" name="queryItem" class="BigSelect">
					<option value="">无</option>
					<option value="house_contracted_size">家庭承包面积</option>
					<option value="artificial_grass_size">人工草地面积</option>
					<option value="artificial_grass_amount">人工草地产草总量</option>
					<option value="straw_amount">补饲秸秆等总量</option>
					<option value="silage_amount">青稞饲料总量</option>
					<option value="food_amount">粮食补饲量</option>
					<option value="supplement_days">补饲总天数</option>
					<option value="grazing_days">放牧总天数</option>
					<option value="sheep_amount">绵羊</option>
					<option value="goat_amount">山羊</option>
					<option value="cow_amount">牛</option>
					<option value="horse_amount">马</option>
					<option value="camel_amount">骆驼</option>
					<option value="mule_amount">骡</option>
					<option value="donkey_amount">驴</option>
					<option value="other_herbivorous_amount">其他草食家畜数量</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class="TableData">限定条件：</td>
			<td class="TableData" colspan="1">
				<input type="radio" id='itemCondition1'name='itemCondition' class='' value="0" /><label for="itemCondition1">等于</label>
			    <input type="radio" id='itemCondition2'name='itemCondition' class='' value="1" /><label for="itemCondition2">大于</label>
			    <input type="radio" id='itemCondition3'name='itemCondition' class='' value="2" /><label for="itemCondition3">小于</label>
			    <input type="radio" id='itemCondition4'name='itemCondition' class='' value="3" /><label for="itemCondition4">在区间内</label>
			    <input type="radio" id='itemCondition5'name='itemCondition' class='' value="4" /><label for="itemCondition5">在区间外</label>
			</td>
			<td class="TableData">限定值：</td>
			<td class="TableData" colspan="1">
				<input type='text' id="itemValue" name="itemValue" class="SmallInput easyui-validatebox" validType="number[]" style="width:118px;"/>
					<div id="itemValueDiv" style='display:none'>
						<input type='text' id="startValue" name="startValue" class="SmallInput easyui-validatebox" validType="number[]"/>到<input type='text' id="endValue" name="endValue" class="SmallInput easyui-validatebox" validType="number[]"/>
					</div>
			</td>
		</tr>
		<tr>
			
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