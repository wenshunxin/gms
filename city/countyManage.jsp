<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String provinceCode = request.getParameter("provinceCode");
String cityCodeStr = request.getParameter("cityCodeStr");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>县管理</title>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<script type="text/javascript"
	src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script type="text/javascript">

function doInit(){
	getCityTitle('<%=provinceCode%>','<%=cityCodeStr%>');
	getInfoList();
}

var datagrid;
function getInfoList(){
	datagrid = $('#datagrid').datagrid({
		url:contextPath+"/gmsCityController/getCountyByCityCode.act?cityCodeStr=<%=cityCodeStr%>",
		pagination:true,
		singleSelect:false,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		pageSize : 20,
		pageList : [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ],
		columns:[[
			{field:'sid',checkbox:true,title:'ID',width:100},
			{field:'cityCode',title:'城市编号',width:50},
			{field:'cityFullName',title:'城市名称',width:100},
			{field:'createTimeStr',title:'创建时间',width:50,formatter:function(value,rowData,rowIndex){
				return value;
			}},
			{field:'2',title:'操作',width:50,formatter:function(value, rowData, rowIndex){
				var str = "&nbsp;&nbsp;<a href='#' onclick='addOrUpdateInfo("+rowData.sid+")'>修改</a>";
				str += "&nbsp;&nbsp;<a href='#' onclick='deleteSingleFunc("+rowData.sid+")'>删除</a>";
				return str;
			}}
		]]
	});
}




/**
 * 新建信息
 */
 function addOrUpdateInfo(sid){
   var title = "新建县信息";
   if(sid>0){
	  title = "编辑县信息";
   }
   $.jBox("iframe:addOrUpdateCounty.jsp?cityCodeStr=<%=cityCodeStr%>&sid=" + sid, {
		title:title,
		top:0,
	    width: 500,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
	         if (v == 1) {
	      	   document.getElementById("jbox-iframe").contentWindow.doSaveOrUpdate();
	         	   return false;
	         }
	         else if(v==2){
	         	   return true;
	         }
    	 }

	});
}


/**
 * 单个信息
 */
function deleteSingleFunc(sid){
	deleteObjFunc(sid);
}
/**
 * 批量删除
 */
function batchDeleteFunc(){
	var ids = getSelectItem();
	if(ids.length==0){
		alert("至少选择一项");
		return ;
	}
	deleteObjFunc(ids);
}
/**
 * 删除信息
 */
 function deleteObjFunc(id){
  $.jBox.confirm("确定要删除所选中记录？","确认",function(v){
		if(v=="ok"){
			var url = contextPath + "/gmsCityController/deleteCityById.act";
			var para = {sid:id};
			var json = tools.requestJsonRs(url,para);
			if(json.rtState){
				$.jBox.tip("删除成功！", "info", {timeout: 1800});
				datagrid.datagrid('reload');
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}
/**
 * 获取选中值
 */
function getSelectItem(){
	var selections = $('#datagrid').datagrid('getSelections');
	var ids = "";
	for(var i=0;i<selections.length;i++){
		ids+=selections[i].sid;
		if(i!=selections.length-1){
			ids+=",";
		}
	}
	return ids;
}

//根据条件查询
function doSearch(){
	  var queryParams=tools.formToJson($("#form1"));
	  datagrid.datagrid('options').queryParams=queryParams; 
	  datagrid.datagrid("reload");
	  $('#searchDiv').modal('hide');
}

function getCityTitle(provinceCode,cityCode){
	var provinceObj = getInfoByCityCode(provinceCode);
	var cityObj = getInfoByCityCode(cityCode);
	
	if(provinceObj&&cityObj){
		var spanStr = "<span class=''></span>";
		var allProvinceStr = "<a href='#;' onclick='backProvinceFunc();'>全省</a>" + spanStr;
		allProvinceStr += "<a href='#;' onclick='backCityFunc(" + provinceObj.cityCode + ");'>" + provinceObj.cityFullName +  "</a>";
		allProvinceStr +=  spanStr + "<span style='color:#000000'>" + cityObj.cityFullName + "</span>";
		$("#cityTitle").html(allProvinceStr);
	}
}
function backProvinceFunc(){
	var url = contextPath + "/city/provinceManage.jsp";
	location.href = url;
}
function backCityFunc(cityCode){
	var url = contextPath + "/city/cityManage.jsp?provinceCode=" + cityCode;
	location.href = url;
}
</script>
</head>
<body onload="doInit()" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<b><i class=""></i>&nbsp;<span id="cityTitle"></span></b>
		</div>
		<div style="text-align: left; margin-bottom: 10px; margin-left: 10px;">
			<button class="btn btn-success" style="background: #41a675;" onclick="addOrUpdateInfo(0)">添加县</button>
			&nbsp;&nbsp;
		</div>
	</div>
</body>
</html>