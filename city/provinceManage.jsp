<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>省管理</title>
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<script type="text/javascript">

function doInit(){
	getInfoList();
}

var datagrid;
function getInfoList(){
	datagrid = $('#datagrid').datagrid({
		url:contextPath+"/gmsCityController/getProvinceDatagrid.act",
		pagination:true,
		singleSelect:false,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		pageSize : 10,
		pageList : [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100 ],
		columns:[[
			{field:'sid',checkbox:true,title:'ID',width:100,formatter:function(){
				
			}},
			{field:'cityCode',title:'省编号',width:50/*, formatter:function(value,rowData,rowIndex){
				var str="<div style='line-height:32px;'>2016-北京-密云县-盛-1</div>"
						+"<div style='margin-left:30px;line-height:32px;'>2016-北京-密云县-盛-1-1</div>"
						+"<div style='margin-left:30px;line-height:32px;'>2016-北京-密云县-盛-1-2</div>";
				return str;
			} */},
			{field:'cityFullName',title:'省名称',width:100,formatter:function(value,rowData,rowIndex){
				return "<a href='#;' onclick='cityManageFunc("+rowData.cityCode+")' >" + value + "</a>";
			}},
			{field:'createTime',title:'创建时间',width:50,formatter:function(value,rowData,rowIndex){
				return getFormatDateTimeStr(rowData.createTime,"yyyy-MM-dd HH:ss:mm");
			}},
			{field:'2',title:'操作',width:50,formatter:function(value, rowData, rowIndex){
				var str = "<a href='#' onclick='cityManageFunc("+rowData.cityCode+")'>市管理 </a>";
				str += "&nbsp;&nbsp;<a href='#' onclick='addOrUpdateInfo("+rowData.sid+")'>修改</a>";
				str += "&nbsp;&nbsp;<a href='#' onclick='deleteSingleFunc("+rowData.sid+")'>删除</a>";
				return str;
			}}
		]]
	});
}


/**
 * 市管理
 */
function cityManageFunc(sid){
  var url = contextPath + "/city/cityManage.jsp?provinceCode=" + sid;
  location.href = url;
}



/**
 * 新建信息
 */
 function addOrUpdateInfo(sid){
   var title = "新建省信息";
   if(sid>0){
	  title = "编辑省份信息";
   }
   $.jBox("iframe:addOrUpdateProvince.jsp?sid=" + sid, {
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
 * 单个删除维护信息
 */
function deleteSingleFunc(sid){
	deleteObjFunc(sid);
}
/**
 * 删除维护信息
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
 * 省(城市)级联效果
 */
 function showCityresult(){
   var title = "省(城市)级联效果";
   $.jBox("iframe:chinaCityResult.jsp", {
		title:title,
		top:0,
	    width: 500,
	    height: 300,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
          if(v==2){
          	   return true;
          }
      }
 	});
}


</script>
</head>
<body onload="doInit()" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div style="text-align: left; margin: 10px 10px;">
			<button class="btn btn-success" style="background: #41a675;" onclick="addOrUpdateInfo(0)">添加省</button>
			&nbsp;&nbsp;
			<button class="btn btn-success" style="background: #41a675;" onclick="showCityresult()">省(城市)级联效果</button>
			&nbsp;&nbsp;
		</div>
	</div>
</body>
</html>