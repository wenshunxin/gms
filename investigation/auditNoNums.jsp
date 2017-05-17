<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
	int userLevel = (Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
	String investigateType = request.getParameter("investigateType");
	String auditNoStatus = request.getParameter("auditNoStatus");
	String queryCityCode = request.getParameter("queryCityCode");
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
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script src="<%=contextPath%>/investigation/common/total.js"></script>
<script>
var datagrid;

var userLevel='<%=userLevel%>';
var userCityCode='<%=userCityCode%>';
function doInit(){
	var url = contextPath+"/gmsInvestigateDataController/queryDataList.act?queryType=all&auditNoStatus=<%=auditNoStatus%>&investigateType=<%=investigateType%>&queryCityCode=<%=queryCityCode%>";
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
			{field:'dataId',checkbox:true,title:'ID',width:10},
			{field:'investigateNum',title:'数据名称',width:250,formatter:function(e,rowData,index){
				var html="<div class='sampleArea'>"+rowData.year+"-"+rowData.investigateNum+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						html+="<div class='quadrat'><span></span><b></b>"+rowData.year+"-"+quadratList[i].quadratNumber+"</div>";
					}
				}
				return html;
			}},
			{field:'investigate_type',title:'数据类型',width:80,sortable:true,formatter:function(e,rowData,index){
				var html="<div class='sampleArea'>"+getInvestigateTypeDesc(rowData.investigateType)+"</div>";
				var quadratList=rowData.quadratList;
				var quadratType="";
				if(rowData.hasShrubs=="无"){
					quadratType="草本样方";
				}else if(rowData.hasShrubs=="有"){
					quadratType="灌木样方";
				}
				
				if(rowData.investigateType==5){
					quadratType="返青期样方";
				}
				if(rowData.investigateType==6){
					quadratType="枯黄期样方";
				}
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						html+="<div class='quadrat'>"+quadratType+"</div>";
					}
				}
				return html;
			}},
			{field:'auditStatus',title:'审核状态',width:50,align:"center",formatter:function(e,rowData,index){
				var html="";
				var auditStatusDesc=getAuditStatusDesc(rowData.auditStatus);
				if(rowData.auditStatus==0){
					html="<div class='sampleArea'>"+auditStatusDesc+"</div>";
					var quadratList=rowData.quadratList;
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							html+="<div class='quadrat'>"+auditStatusDesc+"</div>";
						}
					}
				}else{
					html="<div class='sampleArea'>"+getRecordsTypeDesc(rowData.recordsType)+"</div>";
					var quadratList=rowData.quadratList;
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							var recordsType = quadratList[i].recordsType==null?-1:quadratList[i].recordsType;
							html+="<div class='quadrat'>"+getRecordsTypeDesc(recordsType)+"</div>";
						}
					}
				}
				return html;
			}},
			{field:'auditContent',title:'审核意见',width:100,formatter:function(e,rowData,index){
				var auditContents=rowData.auditContent==null?"":rowData.auditContent;
				var html="<div class='sampleArea'>"+auditContents+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						var auditContent = quadratList[i].auditContent==null?"":quadratList[i].auditContent;
						html+="<div class='quadrat'>"+auditContent+"</div>";
					}
				}
				return html;
			}},
			{field:'completeStatus',title:'数据状态',width:50,align:'center',formatter:function(e,rowData,index){
				var html="<div class='sampleArea'>"+getCompleteStatusDesc(rowData.completeStatus)+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						var completeStatus = quadratList[i].completeStatus==null?0:quadratList[i].completeStatus;
						html+="<div class='quadrat'>"+getCompleteStatusDesc(completeStatus)+"</div>";
					}
				}
				return html;
			}},
			{field:'6',title:'详情',width:20,align:"center",formatter:function(e,rowData,index){
				var auditContent = rowData.auditContent==undefined?"":rowData.auditContent;
				var html ="<div class='sampleArea'>"
						+"<a class='detailCtrl' href='javascript:void(0);' title='详情' "
						+"onclick=\"detail("+rowData.dataId+","+rowData.inOrOut+","+rowData.sampleAreaId+","
						+"'"+rowData.investigateNum+"',"+rowData.investigateType+",'"+auditContent+"')\"></a>"
						+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						var content = quadratList[i].auditContent==undefined?"":quadratList[i].auditContent;
						html+="<div class='quadrat'>"
							+"<a class='detailCtrl'  href='javascript:void(0);' title='详情' "
							+"onclick=\"detail("+rowData.dataId+","+rowData.inOrOut+","+rowData.sampleAreaId+","
							+"'"+quadratList[i].quadratNumber+"',"+rowData.investigateType+",'"+content+"')\"></a>"
							+"</div>";
					}
				}
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
		<form id="form1" name="form1" method="post">
			<div class="moduleHeader">
			</div>
		</form>
	</div>
</body>
</html>