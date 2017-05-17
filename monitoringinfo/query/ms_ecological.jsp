<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
String userCityCode =(String)request.getSession().getAttribute("cityCode");
String observationArea = request.getParameter("type");
%>

<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/category/category.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/download/download.js"></script>
<script type="text/javascript" src="<%=contextPath%>/monitoringinfo/query/check.js"></script>
<script>
	var datagrid;
	var userLevel = '<%= userLevel%>';
	var userCityCode = '<%= userCityCode %>';
	var observationArea = '<%= observationArea %>';
	$("#observationArea").val(observationArea);
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
	 });
	 
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
	
	var url = contextPath+"/gmeController/getGmeDatagrid.act";
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
			{field:'auxiliaryUsingType',title:'辅助区利用方式',rowspan:2,width:60,rowspan:2,align:"center"},
			{field:'mainPlants',title:'主要植物种名称',width:60,rowspan:2,rowspan:2,align:"center"},
			{field:'plantAmount',title:'植物种数参考值',width:80,rowspan:2,align:"center"},
			{field:'f2',title:'操作',width:100,align:"center",rowspan:2,formatter:function(value,rowData,index){
				if(userLevel=="3"){
					return "<a href='javascript:void(0);' onclick='eidtGme("+rowData.sid+")'>编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='findGmeBySID("+rowData.sid+")'>详细</a>";
				}else{
					return "<a href='javascript:void(0);' onclick='findGmeBySID("+rowData.sid+")'>详细</a>";
				}
			}}
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
	
	
	
	function eidtGme(id){
		top.$.jBox("iframe:../monitoringinfo/ms_ecological.jsp?id="+id, {
			title:"修改生态观测区信息",
			top:10,
		    width: 1000,
		    height: 600,
		    top:100,
		    buttons:{"确定":1,'关闭': 2},
		    submit: function (v, h, f) {
	            if (v == 1) {
	            	top.document.getElementById("jbox-iframe").contentWindow.saveGme();
	            	return false;
	            }
	            else if(v==2){
	            	return true;
	            }
	        }
		  });
	}
	
	function findGmeBySID(id){
		top.$.jBox("iframe:../monitoringinfo/ms_ecological_details.jsp?id="+id, {
			title:"详细信息",
			top:0,
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
	
	
	function deleteGme(){
		var ids = getSelectItem();
		if(ids.length>0){
			top.$.jBox.confirm("确定删除该信息吗","确认",function(v){
				if(v=="ok"){
					var url = contextPath+"/gmeController/deleteGmeById.act?sids="+ids;
					var json = tools.requestJsonRs(url);
					if(json.rtState){
						$.jBox.tip(json.rtMsg,"success");
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
		<form id="form1" name="form1" method="post" enctype="multipart/form-data" style="display: none;">
			<table class='TableBlock' style='width:100%; margin: 0 auto;border-bottom: 0;'>
				<tr>
					<td class='TableData' align="right">监测点所在地：</td>
						<td class='TableData' colspan="3">省： <select name="province" id="province"
						onchange="getCity();" class="BigSelect easyui-validatebox">
							<option value="">请选择</option>
					</select> 市： <select name="city" id="city" onchange="getCounty();"
						class="BigSelect easyui-validatebox">
							<option value="">请选择</option>
					</select> 县： <select name="county" id="county"
						class="BigSelect easyui-validatebox">
							<option value="">请选择</option>
					</select>
					<input type="hidden" id='cityCode' name='cityCode' class='SmallInput easyui-validatebox' />
					</td>
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
					<%-- <select id="month" name="month" class="BigSelect" style="width:60px;">
					<option value="">所有</option>
					<%
						for(int i = 1 ;i<=12;i++){
					%>
					<option value="<%=i %>"><%=i %></option>
					<%} %>
					</select>月 --%>
				</td>
				</tr>
				<tr>
					<td class='TableData' align="right">草地类：</td>
					<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassCategory'
						name='grassCategory' style="height:28px;line-height: 28px;width:195px;"/></td>
						<td class='TableData' align="right">草地型：</td>
					<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassType'
						name='grassType' style="height:28px;line-height: 28px;width:195px;"/></td>
					<td class='TableData' align="right">枯落物重量：</td>
					<td class='TableData'>
						<input type="text" class="SmallInput easyui-validatebox" validtype='integeZerol[] &addMethodf[]' id='beginLitterAmount' name='beginLitterAmount'/>至<input type="text" class="SmallInput easyui-validatebox" validtype='integeZerol[] &addMethodf[] &beginSoilMoisture[]' id='endLitterAmount' name='endLitterAmount'/>(克/平方米)
					</td>
				</tr>
				<tr>
					
					<td class='TableData' align="right">土壤容重：</td>
					<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validtype='integeZerol[] &addMethodf[]' id='beginSoilWeight'
						name='beginSoilWeight'/>至<input type="text" class="SmallInput easyui-validatebox" validtype='integeZerol[] &addMethodf[] &beginSoilWeight[]' id='endSoilWeight'
						name='endSoilWeight'/>(克/立方厘米)</td>
					<td class='TableData' align="right">土壤含盐量：</td>
					<td class='TableData'>
						<input type="text" class="SmallInput easyui-validatebox" validtype="numberBetweenLength[0,100] &addMethod[]" id='beginSoilSalt' name='beginSoilSalt'/>至<input type="text" class="SmallInput easyui-validatebox" validtype="numberBetweenLength[0,100] &addMethod[] &beginSoilSalt[]" id='endSoilSalt' name='endSoilSalt'/>(%)
					</td>
					<td class='TableData' align="right">土壤PH：</td>
					<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validtype="integeZerol[]" id='beginSoilPh'
						name='beginSoilPh' />至<input type="text" class="SmallInput easyui-validatebox" validtype="integeZerol[] &beginSoilPh[]" id='endSoilPh'
						name='endSoilPh' /> </td>
				</tr>
				<tr>
					<td class='TableData' align="right">土壤有机含量：</td>
					<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validtype="numberBetweenLength[0,100] &addMethod[]" id='beginSoilOrganic'
						name='beginSoilOrganic' />至<input type="text" class="SmallInput easyui-validatebox" validtype="numberBetweenLength[0,100] &addMethod[] &beginSoilOrganic[]" id='endSoilOrganic'
						name='endSoilOrganic' />(%) </td>
					<td class='TableData' align="right">土壤全氮含量：</td>
					<td class='TableData'><input type="text" class='SmallInput easyui-validatebox' validtype="integeZerol[] &addMethodf[]" id='beginSoilNitrogen'
						name='beginSoilNitrogen'/>至<input type="text" class='SmallInput easyui-validatebox' validtype='integeZerol[] &addMethodf[] &beginSoilNitrogen[]' id='endSoilNitrogen'
						name='endSoilNitrogen'/>(克/公顷)</td>
					<td class='TableData' align="right">植物种数参考值：</td>
					<td class='TableData' colspan="3"><input type="text" class='SmallInput easyui-validatebox' validtype="number[]" id='beginPlantAmount'
						name='beginPlantAmount'/>至<input type="text" class='SmallInput easyui-validatebox' validtype="number[] &beginPlantAmount[]" id='endPlantAmount'
						name='endPlantAmount'/></td>
				</tr>
				<tr>
					<td class="TableHeader" style="text-align:center;" colspan="6">
						<input type="hidden" id="observationArea" name="observationArea">
						<input type="button" class="btn btn-success" style="background: #41a675;" value="查询" onclick="doSearch()"/>
						<input type="button" value="重置" class="btn btn-warning" onclick="doReset()" />
						<input id="delBtn" type='button' class="btn btn-danger" value="批量删除" onclick="deleteGme();"/>
						<input type='button' class="btn btn-success" style="background: #41a675;" value="下载"  onclick='multiExportInfo(0);'/>
					</td>
				</tr>
			</table>
		</form>
		</div>
