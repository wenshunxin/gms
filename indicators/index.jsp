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
	var url = contextPath+"/indicatorsController/getProvinceByUid.act";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		//省
		$("#province").val(json.rtData.basicInfo.cityCode.substring(0,2)+'0000');
		getCity();
	}
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
	var cityCode="";
	if(county!=""){
		cityCode = county;
	}else if(city!=""){
		cityCode = city.substring(0,4)+"__";
	}else if(province!=""){
		cityCode = province.substring(0,2)+"____";
	}else{
		cityCode = "";
	}
	var queryParams=tools.formToJson($("#form1"));
	queryParams["cityCode"] = cityCode;
	var url = contextPath+"/indicatorsController/getIndicatorsDatagrid.act";
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
			{field:'cityCode',title:'监测点所在地',width:100,align:'center',formatter:function(e,rowData,index){
				var jsonObj = getCityFullInfo(rowData.cityCode);
				if(jsonObj!=null){
					return jsonObj.provinceFullName+"  "+jsonObj.cityFullName+"  "+jsonObj.countyFullName;
					}
				}
			},
			{field:'indicatorsName',title:'指标名',width:100,align:'center'},
			{field:'indicatorsUnit',title:'单位',width:100,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				return "<a href='javascript:void(0);' onclick='eidtIndicators("+rowData.sid+")'>编辑</a>";
			}}
		]]
	});
}

function addIndicators(){
	top.$.jBox("iframe:../indicators/add.jsp", {
		title:"其他指标调查录入",
	    width: 650,
	    height: 250,
	    top:100,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveIndicators();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }
	  });
}


function eidtIndicators(id){
	top.$.jBox("iframe:../indicators/add.jsp?id="+id, {
		title:"修改指标信息",
		width: 650,
		height: 250,
		top:100,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveIndicators();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function deleteIndicators(){
	var ids = getSelectItem();
	if(ids.length>0){
		$.jBox.confirm("确定删除指标信息吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/indicatorsController/deleteIndicatorsById.act?sids="+ids;
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
		cityCode = city.substring(0,4)+"__";
	 }else if(province!=""){
		cityCode = province.substring(0,2)+"____";
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
	getProvince();
	cityPrivSettingForQuery();
}

</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">其他指标管理</b>
		</div>
		<form id="form1" name="form1" method="post">
		<div>
			<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class='TableData'>市：</td>
 				<td class='TableData'>
				 <select name="city" id="city" onchange="getCounty();"
					class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select> 
				<input type="hidden" id='province' name='province' />
				<input type="hidden" id='cityCode' name='cityCode' />
				</td>
				<td class='TableData'>县：</td>
				<td class='TableData'>
				<select name="county" id="county"
					class="BigSelect easyui-validatebox">
						<option value="">请选择</option>
				</select>
				</td>
			</tr>
			<tr>
				<td class='TableData'>指标名：</td>
				<td class='TableData'>
					<input type="text" class='BigInput' id='indicatorsName' name='indicatorsName'/>
				</td>
				<td class='TableData'>单位：</td>
				<td class='TableData'>
					<input type="text" class="BigInput" id='indicatorsUnit' name='indicatorsUnit'/>
				</td>
			</tr>
			</table>
		</div>
		
			<div style="margin: 10px 10px;" id="searchDiv" align="center" >
				<input type="button" class="btn btn-success" style="background: #41a675;" onclick="addIndicators();"
					value="新增" /> <input type="button" class="btn btn-success" style="background: #41a675;" 
					onclick="doSearch();" value="查询" />
					<input type="button" class="btn btn-warning"
					onclick="doReset();" value="重置" />
					<input type="button" class="btn btn-danger"
					onclick="deleteIndicators();" value="删除" />
			</div>
		</form>
	</div>
</body>
</html>