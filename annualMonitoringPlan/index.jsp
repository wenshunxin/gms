<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var datagrid;

function doInit(){
	var url = contextPath+"/annualMonitoringPlanController/getAnnualMonitoringPlanDatagrid.act";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:false,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			{field:'sid',checkbox:true,title:'年份',width:30,align:'center'},
			{field:'index',title:'序号',width:30,align:'center',formatter:function(e,rowData,index){
				return index+1;
			}},
			{field:'year',title:'数据名称',width:100,align:'center',formatter:function(e,rowData,index){
				return e+"年年度监测计划";
			}},
			{field:'createUserName',title:'创建人',width:100,align:'center'},
			{field:'provinceCount',title:'计划省份',width:100,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				return "<a href='javascript:void(0);' onclick='eidtAnnualMonitoringPlan("+rowData.year+")'>编辑</a>";
			}}
		]]
	});
}

function addAnnualMonitoringPlan(){
	top.$.jBox("iframe:../annualMonitoringPlan/add.jsp", {
		title:"添加年度监测计划",
		top:0,
	    width: 800,
	    height: 600,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveAnnualMonitoringPlan();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }
	  });
}


function eidtAnnualMonitoringPlan(year){
	top.$.jBox("iframe:../annualMonitoringPlan/add.jsp?year="+year, {
		title:"修改年度计划",
		top:0,
		width: 800,
	    height: 600,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveAnnualMonitoringPlan();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function deleteAnnualMonitoringPlan(){
	var years = getSelectItem();
	if(years.length>0){
		$.jBox.confirm("确定删除吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/annualMonitoringPlanController/deleteAnnualMonitoringPlanByYear.act?years="+years;
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
	var years = "";
	for(var i=0;i<selections.length;i++){
		years+=selections[i].year;
		if(i!=selections.length-1){
			years+=",";
		}
	}
	return years;
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
		cityCode = "000000";
	 }
	 var queryParams=tools.formToJson($("#form1"));
	 queryParams["cityCode"] = cityCode;
	 datagrid.datagrid('options').queryParams=queryParams; 
	 datagrid.datagrid("reload");
}


function doReset(){
	document.getElementById("form1").reset(); 
	getProvince();
	cityPrivSettingForQuery();
}

</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader" >
			<img src='<%=contextPath%>/resource/images/sys/home.png'/><b class="first">当前位置：年度监测计划》<b class="second">监测计划管理</b>
		</div>
		<form id="form1" name="form1" method="post">
			<div style="margin: 10px 10px;" id="searchDiv" >
				<input type="button" class="btn btn-success" style="background: #41a675;" onclick="addAnnualMonitoringPlan();"value="新增" /> 
				<input type="button" class="btn btn-danger" onclick="deleteAnnualMonitoringPlan();" value="删除" />
			</div>
		</form>
	</div>
</body>
</html>