<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
%>

<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/category/category.js"></script>
<script src="<%=contextPath %>/monitoringinfo/monitoring.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/download/download.js"></script>
<script>
	var datagrid;
	var userLevel = '<%= userLevel%>';
	var userCityCode = '<%= userCityCode %>';
	function doInit(){
		 getProvince();
		 cityPrivSettingForQuery();
		 $("#beginInvestigateDate,#endInvestigateDate").datetimepicker({
			 language:"zh-CN",
			 minView:"month",
			 format:"yyyy-mm-dd",
			 startDate:"",
			 todayBtn: true,
			 todayHighlight : true,  
			 endDate : new Date(),
		     autoclose: true
		 })
		 
		 getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
		 $('#grassCategory').combobox({
			 onSelect: function(param){
				 var categoryNo = param.categoryNo;
				 getChildListByTypeCode("GRASSLAND_TYPE_"+categoryNo,"grassType");
				
			 }
		});
		$('#grassCategory').combobox('textbox').bind('click',function(){
			 $('#grassCategory').combobox('showPanel');
		});
		$('#grassType').combobox('textbox').bind('click',function(){
			 $('#grassType').combobox('showPanel');
		});
		
		var stationsType = returnStationType();
		 $("#stationsType").val(stationsType);
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
		 var queryParams=tools.formToJson($("#form1"));
		 queryParams["cityCode"] = cityCode;
		
		var url = contextPath+"/gsoaController/getGsoaDatagrid.act";
		datagrid = $('#datagrid').datagrid({
			url:url,
			pagination:true,
			singleSelect:false,
			toolbar:'#toolbar',//工具条对象
			checkbox:true,
			border:false,
			idField:'sid',//主键列
			fitColumns:true,//列是否进行自动宽度适应
			queryParams:queryParams,
			columns:[[
				{field:'sid',checkbox:true,title:'ID',rowspan:2,width:10},
				{field:'index',title:'序号',width:30,align:"center",rowspan:2,formatter:function(value,rowData,index){
					return index+1;
				}},
				{field:'cityCode',title:'监测点所在地',width:100,align:'center',rowspan:2,formatter:function(e,rowData,index){
					var jsonObj = getCityFullInfo(rowData.cityCode);
					if(jsonObj!=null){
						return jsonObj.provinceFullName+"  "+jsonObj.cityFullName+"  "+jsonObj.countyFullName;
						}
					}
				},
				{field:'investigateDate',title:'调查日期',align:'center',rowspan:2,width:80},
				{field:'grassCategory',title:'草地类',align:'center',rowspan:2,width:100,formatter:function(value,rowData,index){
					return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
				}},
				{field:'grassType',title:'草地型',align:'center',width:110,rowspan:2,formatter:function(value,rowData,index){
					return returnCategoryName("GRASSLAND_TYPE_"+rowData.grassCategory,rowData.grassType);
				}},
				{field:'monitoringPeriod',title:'物候期',rowspan:2,width:60,rowspan:2,align:"center",formatter:function(value,rowData,index){
					if(rowData.monitoringPeriod==0){
						return '返青期';
					}else if(rowData.monitoringPeriod==1){
						return '盛期';
					}else if(rowData.monitoringPeriod==2){
						return '枯黄期';
					}
				}},
				{field:'coverage',title:'总盖度(%)',width:60,rowspan:2,rowspan:2,align:"center"},
				{title:'总产草量折算(千克/公顷)',colspan:2},
				{field:'f2',title:'操作',width:100,align:"center",rowspan:2,formatter:function(value,rowData,index){
					if(userLevel=="3"){
						return "<a href='javascript:void(0);' onclick='eidtGsoa("+rowData.sid+")'>编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='findGsoaBySID("+rowData.sid+")'>详细</a>";
					}else{
						return "<a href='javascript:void(0);' onclick='findGsoaBySID("+rowData.sid+")'>详细</a>";
						
					}
				}}
			],[
				{field:'freshAmount',title:'鲜重',width:80,align:"center"},
				{field:'dryAmount',title:'干重',width:80,align:"center"}
			]
			]
		});
		
		if(userLevel=="3"){
			$("#delBtn").show();
		}else{
			$("#delBtn").hide();
		}
		
		$("#cityCode").val(cityCode);
		var cityCode = $("#cityCode").val();
	}
	
	
	
	function eidtGsoa(id){
		top.$.jBox("iframe:../monitoringinfo/shrubs_observation_area.jsp?id="+id, {
			title:"修改常规观测区信息",
		    width: 1000,
		    height: 600,
		    top:10,
		    buttons:{"确定":1,'关闭': 2},
		    submit: function (v, h, f) {
	            if (v == 1) {
	            	top.document.getElementById("jbox-iframe").contentWindow.saveGsoa();
	            	return false;
	            }
	            else if(v==2){
	            	return true;
	            }
	        }
		  });
	}
	
	function findGsoaBySID(id){
		top.$.jBox("iframe:../monitoringinfo/shrubs_observation_area_details.jsp?id="+id, {
			title:"详细信息",
			top:10,
		    width: 1000,
		    height: 600,
		    buttons:{"关闭":1},
		    submit: function (v, h, f) {
	            if (v == 1) {
	            	return true;
	            }
	        }
		  });
	}
	
	
	function deleteGsoa(){
		var ids = getSelectItem();
		if(ids.length>0){
			$.jBox.confirm("确定删除信息吗","确认",function(v){
				if(v=="ok"){
					var url = contextPath+"/gsoaController/deleteGsoaById.act?sids="+ids;
					var json = tools.requestJsonRs(url);
					if(json.rtState){
						top.$.jBox.tip(json.rtMsg,"success");
						datagrid.datagrid("reload");
						datagrid.datagrid("unselectAll");
					}else{
						$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
					}
				}
			});
		}else{
			$.jBox.tip("至少选中一条信息","info");
		}
	}
	
	/**
	 * 获取选中值
	 */
	function getSelectItem(){
		var selections = datagrid.datagrid('getSelections');
		var ids = "";
		for(var i=0;i<selections.length;i++){
			ids+=selections[i].sid;
			if(i!=selections.length-1){
				ids+=",";
			}
		}
		return ids;
	}
	
	/**
	*重置
	*/
	function doReset(){
		document.getElementById("form1").reset(); 
		getProvince();
		cityPrivSettingForQuery();
		$("#grassCategory").combobox("clear");
		$("#grassType").combobox("clear");
	}
	
	/**
	 * 
	 *通用查询方法
	 * @returns
	 */
	function doSearch(){
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
			cityCode = "";
		 }
		 var queryParams=tools.formToJson($("#form1"));
		 queryParams["cityCode"] = cityCode;
		 datagrid.datagrid('options').queryParams=queryParams; 
		 datagrid.datagrid("reload");
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
<body onload="doInit();">
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
		<form id="form1" name="form1" method="post" enctype="multipart/form-data" style="display: none;">
			<table class='TableBlock' style='width:100%; margin: 0 auto;'>
				<tr>
					<td class='TableData' align="right">监测点所在地：</td>
						<td class='TableData'>省： <select id="province" name="province"  class="BigSelect"
						onchange="getCity();">
							<option value="">请选择</option>
					</select> 市： <select name="city" id="city" onchange="getCounty();" class="BigSelect easyui-validatebox" >
							<option value="">请选择</option>
					</select> 县： <select name="county" id="county"
						class="BigSelect easyui-validatebox">
							<option value="">请选择</option>
					</select>
					<input type="hidden" id='cityCode' name='cityCode' class='SmallInput easyui-validatebox' />
					</td>
					<td class='TableData' align="right">草地类：</td>
					<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassCategory'
						name='grassCategory' style="height:28px;line-height: 28px;width:174px;"/></td>
						<td class='TableData' align="right">草地型：</td>
					<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassType'
						name='grassType' style="height:28px;line-height: 28px;width:174px;"/></td>
				</tr>
				<tr>
					<td class='TableData' align="right">调查日期：</td>
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
					<select id="month" name="month" class="BigSelect" style="width:60px;">
					<option value="">所有</option>
					<%
						for(int i = 1 ;i<=12;i++){
					%>
					<option value="<%=i %>"><%=i %></option>
					<%} %>
					</select>月
				</td>
					<td class='TableData' align="right">土壤含水量测定：</td>
					<td class='TableData'>
						<input type="text" class="SmallInput easyui-validatebox" validtype='numberBetweenLength[0,100] &addMethod[]' id='beginSoilMoisture' name='beginSoilMoisture'/>至<input type="text" class="SmallInput easyui-validatebox" validtype='numberBetweenLength[0,100] &addMethod[]' id='endSoilMoisture' name='endSoilMoisture'/>(%)
					</td>
					<td class='TableData' align="right">总盖度：</td>
					<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validtype='numberBetweenLength[0,100] &addMethod[]' id='beginCoverage'
						name='beginCoverage'/>至<input type="text" class="SmallInput easyui-validatebox" validtype='numberBetweenLength[0,100] &addMethod[]' id='endCoverage'
						name='endCoverage'/>(%)</td>
				</tr>
				<tr>
					<td class='TableData' align="right">总产草量折算：</td>
					<td class='TableData'>鲜重：<input type="text" class='SmallInput easyui-validatebox' validtype="integeZerol[]" id='beginFreshAmount'
						name='beginFreshAmount'/>至<input type="text" class='SmallInput easyui-validatebox' validtype="integeZerol[]" id='endFreshAmount'
						name='endFreshAmount'/>(千克/公顷)</td>
					<td class='TableData' align="right">干重：</td>
					<td class='TableData' colspan="3"><input type="text" class='SmallInput easyui-validatebox' validtype="integeZerol[]" id='beginDryAmount'
						name='beginDryAmount'/>至<input type="text" class='SmallInput easyui-validatebox' validtype="integeZerol[]" id='endDryAmount'
						name='endDryAmount'/>(千克/公顷)</td>
				</tr>
				<tr>
					<td class="TableHeader" style="text-align:center;" colspan="6">
						<input type="button" class="btn btn-success" style="background: #41a675;" value="查询" onclick="doSearch()"/>
						<input type="hidden" id="stationsType" name="stationsType" />
						<input type="hidden" id="observationArea" name="observationArea" value="1"/>
						<input type="button" value="重置" class="btn btn-warning" onclick="doReset()" />
						<input id="delBtn" type='button' class="btn btn-danger" value="批量删除" onclick="deleteGsoa();"/>
						<input type='button' class="btn btn-success" style="background: #41a675;" value="批量下载" onclick="multiExportInfo();"/>
					</td>
				</tr>
			</table>
		</form>
		</div>
</body>