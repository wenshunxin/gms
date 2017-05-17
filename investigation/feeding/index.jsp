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
<link href="<%=contextPath %>/resource/css/ctrl.css" rel="stylesheet" />
<script src="<%=contextPath%>/investigation/investigate.js"></script>
<script src="<%=contextPath%>/investigation/common/total.js"></script>
<script>
var datagrid;

function doInit(){
	statistics(2);
	var url = contextPath+"/gmsInvestigateDataController/queryDataList.act?investigateType=2";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:false,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'dataId',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			{field:'dataId',checkbox:true,title:'ID',width:10,rowspan:2},
			{field:'investigateNum',title:'数据名称',rowspan:2,width:250,formatter:function(e,rowData,index){
				return "<div class='sampleArea sampleAreaWeight'>"+rowData.year+"-"+rowData.investigateNum+"</div>";
			}},
			{field:'investigateType',title:'数据类型',width:80,rowspan:2,formatter:function(e,rowData,index){
				return "<div class='sampleArea'>"+getInvestigateTypeDesc(rowData.investigateType)+"</div>";
			}},
			{field:'auditStatus',title:'审核状态',width:50,rowspan:2,align:'center',formatter:function(e,rowData,index){
				return "<div class='sampleArea'>"+getAuditStatusDesc(rowData.auditStatus)+"</div>";
			}},
	 		{field:'auditContent',title:'审核意见',width:100,rowspan:2,formatter:function(e,rowData,index){
	 			if(rowData.auditContent){
		 			return "<div class='sampleArea'>"+rowData.auditContent+"</div>";
	 			}
	 			return "";
	 		}},
			{field:'completeStatus',title:'数据状态',width:50,rowspan:2,align:'center',formatter:function(e,rowData,index){
				return "<div class='sampleArea'>"+getCompleteStatusDesc(rowData.completeStatus)+"</div>";
			}},
			{title:'操作',colspan:5,align:"center"}
			],
			[
				{field:'2',title:'上报',width:20,align:"center",formatter:function(e,rowData,index){
					var html="<div class='sampleArea'>"
						 	+"<a class='submitCtrl' href='javascript:void(0);' title='上报' onclick=singleSubmit("+index+")></a></div>";
					return html;
				}},
				{field:'4',title:'修改',width:20,align:"center",formatter:function(e,rowData,index){
					var auditContent = rowData.auditContent==undefined?"":rowData.auditContent;
					var html ="<div class='sampleArea'>"
							+"<a class='editCtrl' href='javascript:void(0);' title='修改'  onclick=\"editFeeding("+rowData.sampleAreaId+","+rowData.investigateType+",'"+auditContent+"')\"></a>"
							+"</div>";
					return html;
				}},
				{field:'5',title:'删除',width:20,align:"center",formatter:function(e,rowData,index){
					var html ="<div class='sampleArea'><a class='deleteCtrl' title='删除' href='javascript:void(0);' onclick='deleteFeeding("+rowData.sampleAreaId+")'></a>"
							+"</div>";
					return html;
				}},
				{field:'6',title:'详情',width:20,align:"center",formatter:function(e,rowData,index){
					var auditContent = rowData.auditContent==undefined?"":rowData.auditContent;
					var html ="<div class='sampleArea'>"
							+"<a class='detailCtrl' href='javascript:void(0);' title='详情' "
							+"onclick=\"detail("+rowData.dataId+","+rowData.inOrOut+","+rowData.sampleAreaId+","
							+"'"+rowData.investigateNum+"',"+rowData.investigateType+",'"+auditContent+"')\"></a>"
							+"</div>";
					return html;
				}}
			]]
	});
}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader" style='height: 60px; padding-top: 20px;'>
			<img src='<%=contextPath%>/resource/images/sys/home.png' style='top:20px;'/><b class="first">当前位置：常规监测报送》<b class="second">补饲调查</b></b>
			<div style="float: right;">
				<input type="button" class="btn btn-success" style="background: #42a576;" value="添加分县补饲调查"
					onclick="addFeeding(2)" /> <input type="button"
					class="btn btn-success" style="background: #42a576;" value="添加入户补饲调查" onclick="addFeeding(3)" />
				<input type="button" class="btn btn-success" style="background: #42a576;" value="批量上报"
					onclick="mulitiSubmit(2)" />
			</div>
			<div style="height:24px;line-height:24px;margin-top:10px;color:#000;margin-left: 10px;">
					今年生成样地 <span id="saTotal" style='color:green;'></span>，
					已上报<span id="submitNums" style='color:green;'></span>，
					未上报 <span id="noSubmitNums" style='color:red;'></span>，
					审核通过 <span id="auditYesNums" style='color:green;'></span>，
					省驳回 <span id="auditProvinceNoNums" style='color:red;cursor:pointer;'></span>，
					市驳回 <span id="auditCityNoNums" style='color:red;cursor:pointer;'></span>，
					待市审核 <span id="waitCityAudit" style='color:red;'></span>，
					待省审核 <span id="waitProvinceAudit" style='color:red;'></span>
			</div>
		</div>
	</div>
</body>
</html>