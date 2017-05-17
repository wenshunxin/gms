<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script>
var datagrid;
var userLevel = '<%=userLevel%>';
var userCityCode = '<%=userCityCode%>';
function doInit(){
	getProvince();
	 $("#beginStationsBuildingDate,#endStationsBuildingDate").datetimepicker({
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
	cityPrivSettingForQuery();
	if(userLevel==0){
		$("#addBtn").show();
		$("#delBtn").show();
	}else{
		$("#addBtn").hide();
		$("#delBtn").hide();
	}
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
	var url = contextPath+"/monitoringStationsController/getMonitoringStationsDatagrid.act";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:false,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		queryParams:queryParams,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			{field:'sid',checkbox:true,title:'ID',width:30,align:'center'},
			{field:'index',title:'序号',width:30,align:'center',formatter:function(e,rowData,index){
				return index+1;
			}},
			{field:'cityCode',title:'监测点所在地',width:100,formatter:function(e,rowData,index){
				var jsonObj = getCityFullInfo(rowData.cityCode);
				if(jsonObj!=null){
					return jsonObj.provinceFullName+"  "+jsonObj.cityFullName+"  "+jsonObj.countyFullName;
					}
				}
			},
			{field:'altitude',title:'海拔（米）',width:100,align:'center'},
			{field:'grassCategory',title:'草地类',width:100,formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
			}},
			{field:'grassType',title:'草地型',width:100,formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE_"+rowData.grassCategory,rowData.grassType);
			}},
			{field:'grassLandscape',title:'地貌',width:100,align:'center'},
			{field:'averageAnnualRainfall',title:'年平均降雨量（毫米）',width:100,align:'center'},
			{field:'stationsBuildingDate',title:'建成时间',width:150,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				if(userLevel==0){
					return "<a href='javascript:void(0);' onclick='eidtMonitoring("+rowData.sid+")'>编辑</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='findByMonitoringId("+rowData.sid+")'>详情</a>";
				}else{
					return "<a href='javascript:void(0);' onclick='findByMonitoringId("+rowData.sid+")'>详情</a>";
				}
			}}
		]]
	});
	doSearch();
}

function addMonitoringStations(){
	top.$.jBox("iframe:../monitoring_stations/add.jsp", {
		title:"添加监测站点",
		top:10,
	    width: 1000,
	    height: 600,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveMonitoringStations();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }
	  });
}


 function findByMonitoringId(id){
	top.$.jBox("iframe:../monitoring_stations/details.jsp?id="+id, {
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
function eidtMonitoring(id){
	top.$.jBox("iframe:../monitoring_stations/add.jsp?id="+id, {
		title:"修改监测点信息",
		top:10,
	    width: 1000,
	    height: 600,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveMonitoringStations();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function deleteMonitoring(){
	var ids = getSelectItem();
	if(ids.length>0){
		$.jBox.confirm("确定删除站点吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/monitoringStationsController/deleteMonitoringStationsById.act?sids="+ids;
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
		$.jBox.tip("至少选中一个用户","info");
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


function doReset(){
	document.getElementById("form1").reset(); 
	$('#grassCategory').combobox('clear');
	$('#grassType').combobox('clear');
	getProvince();
	cityPrivSettingForQuery();
}

function returnCategoryName(typeCode,codeValue){
	if(typeCode==null || typeCode==""){
		return "";
	}
	if(codeValue==null || codeValue==""){
		return "";
	}
	var url = contextPath+"/gmsSysCategoryController/getCategoryName.act?typeCode="+typeCode+"&codeValue="+codeValue;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		if(data){
			return data.categoryName;
		}
	}
}


$.extend($.fn.validatebox.defaults.rules, {   
	beginAltitude: {  
		validator: function(value,param){
			var beginAltitude = $("#beginAltitude").val();
			if(value!="" && beginAltitude!="" && parseFloat(value)<parseFloat(beginAltitude)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginAverageAnnualRainfall: {  
		validator: function(value,param){
			var beginAverageAnnualRainfall = $("#beginAverageAnnualRainfall").val();
			if(value!="" && beginAverageAnnualRainfall!="" && parseFloat(value)<parseFloat(beginAverageAnnualRainfall)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	}
});
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">监测点管理</b></b>
		</div>
		<form id="form1" name="form1" method="post">
		<div>
			<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>监测点所在地：</td>
 				<td class='TableData'>省： <select name="province" id="province"
					onchange="getCity();" class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select> 市： <select name="city" id="city" onchange="getCounty();"
					class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select> 县： <select name="county" id="county"
					class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select>
				<input type="hidden" id='cityCode' name='cityCode' class='BigInput easyui-validatebox' />
				</td>
				<td class='TableData'>样地海拔：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validType="numberBetweenLength[-160,8849] &addMethod[]" id='beginAltitude'
					name='beginAltitude'/>至<input type="text" class="SmallInput easyui-validatebox" validType="numberBetweenLength[-160,8849] &addMethod[] &beginAltitude[]" id='endAltitude'
					name='endAltitude'/>(米)</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-combobox' id='grassCategory'
					name='grassCategory' style="height:28px;line-height: 28px;width:195px;" /></td>
					<td class='TableData'>草地型：</td>
				<td class='TableData'><input type="text" class='BigInput easyui-combobox' style="height:28px;line-height: 28px;width:195px;" id='grassType'
					name='grassType'/></td>
			</tr>
			<tr>
				<td class='TableData'>地貌：</td>
				<td class='TableData'>
				<select id='grassLandscape' name='grassLandscape' class="BigSelect">
						<option value="">全部</option>
						<option value="平原">平原</option>
						<option value="高原">高原</option>
						<option value="盆地">盆地</option>
						<option value="丘陵">丘陵</option>
						<option value="山地">山地</option>
					</select>
				</td>
				<td class='TableData'>年平均降雨量：</td>
				<td class='TableData'><input type="text" class="SmallInput easyui-validatebox" validType="integeZerol[] &addMethodf[]" id='beginAverageAnnualRainfall'
					name='beginAverageAnnualRainfall'/>至<input type="text" class="SmallInput easyui-validatebox" validType="integeZerol[] &addMethodf[] &beginAverageAnnualRainfall[]" id='endAverageAnnualRainfall'
					name='endAverageAnnualRainfall'/>(毫米)</td>
			</tr>
			<tr>
				<td class='TableData'>建成时间：</td>
				<td class='TableData' colspan="3"><input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly" id='beginStationsBuildingDate' name='beginStationsBuildingDate'/>至<input type="text" autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly" id='endStationsBuildingDate' name='endStationsBuildingDate'/>
				</td>
			</tr>
			</table>
		</div>
		
			<div style="margin: 10px 10px;" id="searchDiv" align="center" >
				<input id="addBtn" type="button" class="btn btn-success" style="background: #41a675;" onclick="addMonitoringStations();" value="新增" /> 
				<input type="button" class="btn btn-success" style="background: #41a675;"onclick="doSearch();" value="查询" />
				<input type="button" class="btn btn-warning" onclick="doReset();" value="重置" />
				<input id="delBtn" type="button" class="btn btn-danger"onclick="deleteMonitoring();" value="批量删除" />
			</div>
		</form>
	</div>
</body>
</html>