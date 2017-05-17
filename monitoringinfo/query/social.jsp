<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%

	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
	String observationArea = request.getParameter("type");
%>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script src="<%=contextPath %>/monitoringinfo/monitoring.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/download/download.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/query/check.js"></script>
<script type="text/javascript">
	var datagrid;
	var userLevel = '<%=userLevel%>';
	var userCityCode = '<%=userCityCode%>';
	var observationArea = '<%= observationArea %>';
	getProvince();
	cityPrivSettingForQuery();
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
	var cityCode="";
	if(county!=""){
		cityCode = county;
	}else if(city!=""){
		cityCode = city;
	}else if(province!=""){
		cityCode = province;
	}else{
		cityCode = "000000";
	}
	$("#cityCode").val(cityCode);
	$("#observationArea").val(observationArea);
	var queryParams=tools.formToJson($("#form1"));
	var url = contextPath+"/gmsController/getGmsDatagrid.act";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:false,
		queryParams:queryParams,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			{field:'sid',checkbox:true,title:'ID',width:30,align:'center'},
			{field:'index',title:'序号',width:30,align:'center',formatter:function(e,rowData,index){
				return index+1;
			}},
			{field:'cityCode',title:'监测点所在地',width:100,align:'center',formatter:function(e,rowData,index){
				var jsonObj = getCityFullInfo(rowData.cityCode);
				if(jsonObj!=null){
					return jsonObj.provinceFullName+"  "+jsonObj.cityFullName+"  "+jsonObj.countyFullName;
					}
				}
			},
			{field:'investigateDate',title:'调查日期',width:100,align:'center'},
			{field:'prairieArea',title:'所在县草原面积',width:100,align:'center'},
			{field:'naturalPrairieArea',title:'所在县天然草<br/>原面积',width:100,align:'center'},
			{field:'availableNaturalPrairieArea',title:'所在县天然草原<br/>可利用面积',width:100,align:'center'},
			{field:'degradationPrairieArea',title:'所在县退化<br/>草原面积',width:100,align:'center'},
			{field:'herdingNums',title:'所在县牧户数',width:100,align:'center'},
			{field:'animalAmount',title:'所在县草食牲<br/>畜年末存栏量',width:100,align:'center'},
			{field:'workerAvgSalary',title:'所在县职工年<br/>平均工资',width:100,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				if(userLevel=="3"){
					return "<a href='javascript:void(0);' onclick='eidtSocial("+rowData.sid+")'>编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='socialDetail("+rowData.sid+")'>详情</a>";
				}else{
					return "<a href='javascript:void(0);' onclick='socialDetail("+rowData.sid+")'>详情</a>";
					
				}
			}}
		]]
	});
	if(userLevel=="3"){
		$("#delBtn").show();
	}else{
		$("#delBtn").hide();
	}

	function toggll(evt){
		var indexArray = [];
		var selections = $('#datagrid').datagrid('getSelections');
		for(var i=0;i<selections.length;i++){
			var index = $('#datagrid').datagrid('getRowIndex',selections[i]);
			indexArray[i]=index;
		}
		$("#form1").toggle();
		datagrid.datagrid("reload");
		setTimeout(function(){
			setValue(indexArray);
		},100);
		var src=$(evt).attr("src");
		if(src=="/gms/resource/images/sys/down.png"){
			src=contextPath+"/resource/images/sys/up.png";
			$(evt).attr("src",src);
			$(evt).attr("title","收起");
		}else{
			src=contextPath+"/resource/images/sys/down.png";
			$(evt).attr("src",src);
			$(evt).attr("title","展开");
		}
	}
	function setValue(indexArray){
		for(var i=0;i<indexArray.length;i++){
			$('#datagrid').datagrid('checkRow',indexArray[i]);
		}
	}
</script>
<table id="datagrid" fit="true"></table>
<div id="toolbar">
<table class='TableBlock' fit="true"  style='width:100%; margin: 0 auto; border-bottom: 0;'>
		<tr class="TableHeader" >
			<td class='TableData'  style="text-align: left;border-bottom: 0;">
				查询条件
			</td>
			<img src="<%=contextPath%>/resource/images/sys/down.png" title='展开' alt='展开/收起' style="position:absolute;top:3px;right:0;float:right;cursor: pointer;margin-right: 0px; z-index: 20" onclick='toggll(this)'>
		</tr>
	 </table>
	<form id="form1" name="form1" method="post" style="display: none;">
		<table class="TableBlock" width="100%" style="margin:0 auto;">
			<tr>
				<td class="TableData">调查日期：</td>
				<td class="TableData" colspan="">
					<select id="startYear" name="startYear" class="BigSelect" style="width:80px;">
					<option value="">请选择</option>
					<%
						Calendar cl = Calendar.getInstance();
						int year = cl.get(Calendar.YEAR);
						for(int i = 0 ;i<50;i++){
					%>
					<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
					</select>年 - 
					<select id="endYear" name="endYear" class="BigSelect" style="width:80px;">
					<option value="">请选择</option>
					<%
						for(int i = 0 ;i<50;i++){
					%>
					<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
					</select>年  
					<%-- <select id="month" name="month" class="BigSelect" style="width:60px;">
					<option value="">所有</option>
					<%
						for(int i = 1 ;i<=12;i++){
					%>
					<option value="<%=i %>"><%=i %></option>
					<%} %>
					</select>月 --%>
				</td>
				<td class="TableData" align:>监测点所在地：</td>
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
				<td class="TableData">所在县草原面积：</td>
				<td class="TableData">
					<input type="text" id="prairieAreaStart" name="prairieAreaStart" class="SmallInput easyui-validatebox" validtype="integeZerol[]"/>至<input type="text" id="prairieAreaEnd" name="prairieAreaEnd" class="SmallInput easyui-validatebox" validtype="integeZerol[] &prairieAreaStart[]" />(平方米)
				</td>
				<td class="TableData">所在县天然草原面积：</td>
				<td class="TableData">
					<input type="text" id="naturalPrairieAreaStart" name="naturalPrairieAreaStart" class="SmallInput easyui-validatebox" validtype="integeZerol[]"/>至<input type="text" id="naturalPrairieAreaEnd" name="naturalPrairieAreaEnd" class="SmallInput easyui-validatebox" validtype='integeZerol[] &naturalPrairieAreaStart[]'/>(平方米)
				</td>
				<td class="TableData">所在县天然草原可利用面积：</td>
				<td class="TableData">
					<input type="text" id="availableNaturalPrairieAreaStart" name="availableNaturalPrairieAreaStart" class="SmallInput easyui-validatebox" validtype="integeZerol[]"/>至<input type="text" id="availableNaturalPrairieAreaEnd" name="availableNaturalPrairieAreaEnd" class="SmallInput easyui-validatebox" validtype="integeZerol[] &availableNaturalPrairieAreaStart[]"/>(公顷)
				</td>
				
			</tr>
			<tr>
				<td class="TableData">所在县退化草原面积：</td>
				<td class="TableData">
					<input type="text" id="degradationPrairieAreaStart" name="degradationPrairieAreaStart" class="SmallInput easyui-validatebox" validtype="integeZerol[]"/>至<input type="text" id="degradationPrairieAreaEnd" name="degradationPrairieAreaEnd" class="SmallInput easyui-validatebox" validtype="integeZerol[] &degradationPrairieAreaStart[]"/>(公顷)
				</td>
				<td class="TableData">所在县牧户数：</td>
				<td class="TableData">
					<input type="text" id="herdingNumsStart" name="herdingNumsStart" class="SmallInput easyui-validatebox" validtype="integeZero[]"/>至<input type="text" id="herdingNumsEnd" name="herdingNumsEnd" class="SmallInput easyui-validatebox" validtype="integeZero[] &herdingNumsStart[]"/>(户)
				</td>
				<td class="TableData">所在县草食牲畜年末存栏量：</td>
				<td class="TableData">
					<input type="text" id="animalAmountStart" name="animalAmountStart" class="SmallInput easyui-validatebox" validtype="integeZero[]"/>至<input type="text" id="animalAmountEnd" name="animalAmountEnd" class="SmallInput easyui-validatebox" validtype="integeZero[] &animalAmountStart[]"/>(羊单位)
				</td>
				
				
			</tr>
			<tr>
				
				<td class="TableData">所在县职工年平均工资：</td>
				<td class="TableData">
					<input type="text" id="workerAvgSalaryStart" name="workerAvgSalaryStart" class="SmallInput easyui-validatebox" validtype="number[]"/>至<input type="text" id="workerAvgSalaryEnd" name="workerAvgSalaryEnd" class="SmallInput easyui-validatebox" validtype="number[] &workerAvgSalaryStart[]"/>(元)
				</td>
				<td class="TableData">所在县农牧民年人均纯收入：</td>
				<td class="TableData">
					<input type="text" id="herdingNetIncomeStart" name="herdingNetIncomeStart" class="SmallInput easyui-validatebox" validtype="number[]"/>至<input type="text" id="herdingNetIncomeEnd" name="herdingNetIncomeEnd" class="SmallInput easyui-validatebox" validtype="number[] &herdingNetIncomeStart[]"/>(元)
				</td>
			</tr>
			<tr>
				<td class="TableHeader" colspan='6' align='center'>
					<input type="hidden" id="cityCode" name="cityCode"/>
					<input type="hidden" id="observationArea" name="observationArea">
					<input type='button' class='btn btn-success' style="background: #41a675;" onclick="doSearch();" value="查询"/>
					<input type='button' class='btn btn-warning' onclick="doReset();" value="重置"/>
					<input type='button' class="btn btn-success" style="background: #41a675;" value="批量下载" onclick="multiExportInfo(2);"/>
					<input id="delBtn" type='button' class="btn btn-success" style="background: #41a675;" value="批量删除" onclick="deleteSocial();"/>
				</td>
			</tr>
		</table>
	
	</form>
</div>