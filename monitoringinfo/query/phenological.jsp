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
<script type="text/javascript" src="<%=contextPath%>/category/category.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath %>/monitoringinfo/monitoring.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/download/download.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/query/check.js"></script>
<script type="text/javascript">
	var datagrid;
	var userLevel = '<%=userLevel%>';
	var userCityCode = '<%=userCityCode%>';
	var observationArea = '<%= observationArea %>';
	getProvince();
	cityPrivSettingForQuery();
	getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
	$('#grassCategory').combobox({
		 onSelect: function(param){
			 var categoryNo = param.categoryNo;
			 getChildListByTypeCode("GRASSLAND_TYPE_"+categoryNo,"grassType");
			 $('#grassType').combobox('textbox').bind('click',function(){
				 $('#grassType').combobox('showPanel');
			 });
		 }
	});
	$('#grassCategory').combobox('textbox').bind('click',function(){
		 $('#grassCategory').combobox('showPanel');
	});
	 $("#greenDateStart,#greenDateEnd,#yellowDateStart,#yellowDateEnd").datetimepicker({
		 language:"zh-CN",
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 });
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
	var url = contextPath+"/gmpController/getGmpDatagrid.act";
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
			{field:'grassCategory',title:'草地类',align:'center',rowspan:2,width:100,formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
			}},
			{field:'grassType',title:'草地型',align:'center',width:110,rowspan:2,formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE_"+rowData.grassCategory,rowData.grassType);
			}},
			{field:'yellowDate',title:'凋落时间',width:100,align:'center'},
			{field:'januarySnowThickness',title:'1月积雪厚度<br/>（毫米）',width:100,align:'center'},
			{field:'februarySnowThickness',title:'2月积雪厚度<br/>（毫米）',width:100,align:'center'},
			{field:'decemberSnowThickness',title:'12月积雪厚度<br/>（毫米）',width:100,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				if(userLevel=="3"){
					return "<a href='javascript:void(0);' onclick='eidtPhenological("+rowData.sid+")'>编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='phenologicalDetail("+rowData.sid+")'>详情</a>";
				}else{
					return "<a href='javascript:void(0);' onclick='phenologicalDetail("+rowData.sid+")'>详情</a>";
					
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
		<tr class="TableHeader">
			<td class='TableData'  style="text-align: left;border-bottom: 0;">
				查询条件
			</td>
			<img src="<%=contextPath%>/resource/images/sys/down.png" title='展开' alt='展开/收起' style="position:absolute;top:3px;right:0;float:right;cursor: pointer;margin-right: 0px; z-index: 20" onclick='toggll(this)'>
		</tr>
	 </table>
	<form id="form1" name="form1" method="post" style="display: none;">
		<table class="TableBlock" width="100%" style="margin:0 auto;">
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

				</td>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassCategory'
					name='grassCategory' style="height:28px;line-height: 28px;width:196px;"/></td>
			</tr>
			<tr>
				<td class="TableData">返青时间：</td>
				<td class="TableData">
					<input type="text" id="greenDateStart" name="greenDateStart" class="SmallInput " readonly="readonly"/>至<input type="text" id="greenDateEnd" name="greenDateEnd" class="SmallInput " readonly="readonly"/>
				</td>
				<td class="TableData">凋落时间：</td>
				<td class="TableData">
					<input type="text" id="yellowDateStart" name="yellowDateStart" class="SmallInput" readonly="readonly"/>至<input type="text" id="yellowDateEnd" name="yellowDateEnd" class="SmallInput" readonly="readonly"/>
				</td>
					<td class='TableData'>草地型：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassType'
					name='grassType' style="height:28px;line-height: 28px;width:196px;"/></td>
			</tr>
			<tr>
				
			</tr>
			<tr>
				<td class="TableData">一月积雪厚度：</td>
				<td class="TableData">
					<input type="text" id="januarySnowThicknessStart" name="januarySnowThicknessStart" class="SmallInput easyui-validatebox" validtype="integeZerol[]"/>至<input type="text" id="januarySnowThicknessEnd" name="januarySnowThicknessEnd" class="SmallInput easyui-validatebox" validtype="integeZerol[] &januarySnowThicknessStart[]"/>(毫米)
				</td>
				<td class="TableData">二月积雪厚度：</td>
				<td class="TableData">
					<input type="text" id="februarySnowThicknessStart" name="februarySnowThicknessStart" class="SmallInput easyui-validatebox" validtype="integeZerol[]"/>至<input type="text" id="februarySnowThicknessEnd" name="februarySnowThicknessEnd" class="SmallInput easyui-validatebox" validtype="integeZerol[] &februarySnowThicknessStart[]"/>(毫米)
				</td> 
				<td class="TableData">十二月积雪厚度：</td>
				<td class="TableData" colspan="3">
					<input type="text" id="decemberSnowThicknessStart" name="decemberSnowThicknessStart" class="SmallInput easyui-validatebox" validtype="integeZerol[]"/>至<input type="text" id="decemberSnowThicknessEnd" name="decemberSnowThicknessEnd" class="SmallInput easyui-validatebox" validtype="integeZerol[] &decemberSnowThicknessStart[]"/>(毫米)
				</td>
			</tr>
			<tr>
				<td class="TableHeader" colspan='6' align='center'>
					<input type="hidden" id="cityCode" name="cityCode"/>
					<input type="hidden" id="observationArea" name="observationArea">
					<input type='button' class='btn btn-success' style="background: #41a675;" onclick="doSearch();" value="查询"/>
					<input type='button' class='btn btn-warning' onclick="doReset();" value="重置"/>
					<input type='button' class="btn btn-success" style="background: #41a675;" value="批量下载" onclick="multiExportInfo(1);"/>
					<input id="delBtn" type='button' class="btn btn-success" style="background: #41a675;" value="批量删除" onclick="deletePhenological();"/>
				</td>
			</tr>
		</table>
	
	</form>
</div>