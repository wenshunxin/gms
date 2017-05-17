<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%

	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
	String type = request.getParameter("type");
%>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script src="<%=contextPath %>/indicators_records/indicatorsRecords.js"></script>
<script type="text/javascript">
	var datagrid;
	var userLevel = '<%=userLevel%>';
	var userCityCode = '<%=userCityCode%>';
	var type = '<%=type%>';
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
	var queryParams=tools.formToJson($("#form1"));
	var url = contextPath+"/indicatorsRecordsController/getIndicatorsRecordsDatagrid.act";
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
			{field:'investigateUserNames',title:'调查人',width:100,align:'center'},
			{field:'indicatorsName',title:'指标名',width:100,align:'center'},
			{field:'indicatorsValue',title:'指标值',width:100,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				if(userLevel=="3"){
					return "<a href='javascript:void(0);' onclick='eidtIndicatorsRecords("+rowData.sid+")'>编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='findIndicatorsRecordsById("+rowData.sid+")'>详情</a>";
				}else{
					return "<a href='javascript:void(0);' onclick='findIndicatorsRecordsById("+rowData.sid+")'>详情</a>";
					
				}
			}}
		]]
	});
	if(userLevel=="3"){
		$("#delBtn").show();
	}else{
		$("#delBtn").hide();
	}
	var cityCode = $("#cityCode").val();
	getIndicatorsByCityCode(cityCode);
	$("#province,#city,#county").change(function(){
		 var curCityCode="";
		 var province = $("#province").val();
		 var city = $("#city").val();
		 var county = $("#county").val();
		 var curCityCode="";
		 if(county!=""){
			 curCityCode = county;
		 }else if(city!=""){
			 curCityCode = city;
		 }else if(province!=""){
			 curCityCode = province;
		 }else{
			 curCityCode = "000000";
		 }
		 $("#cityCode").val(curCityCode);
		var curCityCode = $("#cityCode").val();
		getIndicatorsByCityCode(curCityCode);
	});

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
			<tr class="TableHeader">
				<td class='TableData'  style="text-align: left;border-bottom: 0;">
					查询条件
				</td>
				<img src="<%=contextPath%>/resource/images/sys/down.png" title='展开' alt='展开/收起' style="position:absolute;top:3px;right:0;float:right;cursor: pointer;margin-right: 0px; z-index: 20" onclick='toggll(this)'>
			</tr>
	</table>
	<form id="form1" name="form1" method="post" style="display: none;">
		<table class="TableBlock" width="100%" style="margin:0 auto;border-left:0;border-right:0;">
			<tr>
				<td class="TableData">监测点所在地：</td>
				<td class="TableData">
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
				<td class="TableData">调查日期：</td>
				<td class="TableData">
					<select id="startYear" name="startYear" class="BigSelect" style="width:80px;">
					<option value="请选择">请选择</option>
					<%
						Calendar cl = Calendar.getInstance();
						int year = cl.get(Calendar.YEAR);
						for(int i = 0 ;i<50;i++){
					%>
					<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
					</select>年 - 
					<select id="endYear" name="endYear" class="BigSelect" style="width:80px;">
					<option value="请选择">请选择</option>
					<%
						for(int i = 0 ;i<50;i++){
					%>
					<option value="<%=year-i %>"><%=year-i %></option>
					<%} %>
					</select>年  
					<select id="month" name="month" class="BigSelect" style="width:60px;">
					<option value="">所有</option>
					<%
						for(int i = 1 ;i<=12;i++){
					%>
					<option value="<%=i %>"><%=i %></option>
					<%} %>
					</select>月
				</td>
			</tr>
			<tr>
				<td class="TableData">指标名：</td>
				<td class="TableData">
					<input id="indicatorsId" name="indicatorsId" class="easyui-combobox" style="height:28px;line-height: 28px;"/>
				</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4' align='center'>
					<input type="hidden" id="cityCode" name="cityCode"/>
					<input type="hidden" id="type" name="type" value='<%=type%>'/>
					<input type='button' class='btn btn-success' style="background: #41a675;" onclick="doSearch();" value="查询"/>
					<input type='button' class='btn btn-warning' onclick="doReset();" value="重置"/>
					<input type='button' class="btn btn-success" style="background: #41a675;" value="批量下载" onclick="multiExportInfo();"/>
					<input id="delBtn" type='button' class="btn btn-success" style="background: #41a675;" value="批量删除" onclick="deleteIndicatorsRecords();"/>
				</td>
			</tr>
		</table>
	
	</form>
</div>