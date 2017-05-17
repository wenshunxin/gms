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
	statistics(1);
	var url = contextPath+"/gmsInvestigateDataController/queryDataList.act?investigateType=1";
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
			{field:'investigateNum',title:'数据名称',width:250,rowspan:2,formatter:function(e,rowData,index){
				var html="<div class='sampleArea sampleAreaWeight'>"+rowData.year+"-"+rowData.investigateNum+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						html+="<div class='quadrat'><span></span><b></b>"+rowData.year+"-"+quadratList[i].quadratNumber+"</div>";
					}
				}
				return html;
			}},
			{field:'investigate_type',title:'数据类型',width:80,sortable:true,rowspan:2,formatter:function(e,rowData,index){
				var html="<div class='sampleArea'>"+getInvestigateTypeDesc(rowData.investigateType)+"</div>";
				var quadratList=rowData.quadratList;
				var quadratType="";
				if(rowData.hasShrubs=="无" && rowData.investigateType==0){
					quadratType="工程草本样方";
				}else if(rowData.hasShrubs=="有" && rowData.investigateType==0){
					quadratType="工程灌木样方";
				}else if(rowData.hasShrubs=="无" && rowData.investigateType==1){
					quadratType="非工程草本样方";
				}else if(rowData.hasShrubs=="有" && rowData.investigateType==1){
					quadratType="非工程灌木样方";
				}
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						html+="<div class='quadrat'>"+quadratType+"</div>";
					}
				}
				return html;
			}},
			{field:'auditStatus',title:'审核状态',width:50,rowspan:2,align:'center',formatter:function(e,rowData,index){
				var html="";
				var auditStatusDesc=getAuditStatusDesc(rowData.auditStatus);
				if(rowData.auditStatus==0){
					html="<div class='sampleArea'>"+auditStatusDesc+"</div>";
					var quadratList=rowData.quadratList;
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							html+="<div class='quadrat '>"+auditStatusDesc+"</div>";
						}
					}
				}else{
					html="<div class='sampleArea'>"+getRecordsTypeDesc(rowData.recordsType)+"</div>";
					var quadratList=rowData.quadratList;
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							var recordsType = quadratList[i].recordsType==null?-1:quadratList[i].recordsType;
							html+="<div class='quadrat '>"+getRecordsTypeDesc(recordsType)+"</div>";
						}
					}
				}
				return html;
			}},
			{field:'auditContent',title:'审核意见',width:100,rowspan:2,formatter:function(e,rowData,index){
				var auditContents=rowData.auditContent==null?"":rowData.auditContent;
				var html="<div class='sampleArea'>"+auditContents+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						var auditContent = quadratList[i].auditContent==null?"":quadratList[i].auditContent;
						html+="<div class='quadrat quadratCenter'>"+auditContent+"</div>";
					}
				}
				return html;
			}},
			{field:'completeStatus',title:'数据状态',width:50,rowspan:2,align:'center',formatter:function(e,rowData,index){
				var html="<div class='sampleArea'>"+getCompleteStatusDesc(rowData.completeStatus)+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						var completeStatus = quadratList[i].complete?0:1;
						html+="<div class='quadrat '>"+getCompleteStatusDesc(completeStatus)+"</div>";
					}
				}
				return html;
			}},
			{title:'操作',colspan:5,align:"center"}
			],
			[
				{field:'2',title:'上报',width:20,align:"center",formatter:function(e,rowData,index){
					var html="<div class='sampleArea'>"
						 	+"<a class='submitCtrl ' href='javascript:void(0);' title='上报' onclick=singleSubmit("+index+")></a></div>";
					var quadratList=rowData.quadratList;
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							html+="<div class='quadrat'>"
								+"</div>";
						}
					}
					return html;
				}},
				{field:'3',title:'添加样方',width:30,align:"center",formatter:function(e,rowData,index){
					var html ="<div class='sampleArea'><a class='addCtrl' title='添加样方' href='javascript:void(0);' onclick=addQuadrat("+rowData.sampleAreaId+","+rowData.inOrOut+",'"+rowData.hasShrubs+"')></a></div>";
					var quadratList=rowData.quadratList;
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							html+="<div class='quadrat'>"
								+"</div>";
						}
					}
					return html;
				}},
				{field:'4',title:'修改',width:20,align:"center",formatter:function(e,rowData,index){
					var quadratList=rowData.quadratList;
					var auditContent = rowData.auditContent==undefined?"":rowData.auditContent;
					var html ="<div class='sampleArea'>"
							+"<a class='editCtrl' href='javascript:void(0);' title='修改' onclick=\"editSampleArea("+rowData.sampleAreaId+","+rowData.investigateType+","+rowData.dataId+","+rowData.recordsType+",'"+auditContent+"',"+quadratList.length+")\"></a>"
							+"</div>";
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							var content = quadratList[i].auditContent==undefined?"":quadratList[i].auditContent;
							html+="<div class='quadrat'>"
								+"<a class='editCtrl' href='javascript:void(0);' title='修改' onclick=editQuadrat("+quadratList[i].sid+","+quadratList[i].inOrOut+",'"+rowData.hasShrubs+"',"+quadratList[i].recordsType+",'"+content+"')></a>"
								+"</div>";
						}
					}
					return html;
				}},
				{field:'5',title:'删除',width:20,align:"center",formatter:function(e,rowData,index){
					var quadratList=rowData.quadratList;
					var isDel=true;
					for(var i=0;i<quadratList.length;i++){
						if(quadratList[i].recordsType==0 || quadratList[i].recordsType==2){
							isDel = false;
						}
					}
					if(rowData.recordsType==0 || rowData.recordsType==2){
						isDel=false;
					}
					var html ="<div class='sampleArea'><a class='deleteCtrl' title='删除' href='javascript:void(0);' onclick='deleteSampleArea("+rowData.sampleAreaId+","+isDel+")'></a>"
							+"</div>";
					if(quadratList){
						for(var i=0;i<quadratList.length;i++){
							html+="<div class='quadrat'>"
								+"<a class='deleteCtrl' href='javascript:void(0);' title='删除' onclick=deleteQuadrat("+quadratList[i].sid+",'"+rowData.hasShrubs+"',"+quadratList[i].recordsType+")></a>"
								+"</div>";
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

/**
 * 样方删除
 */
function deleteQuadrat(id,hasShrubs,recordsType){
	if(recordsType==0 || recordsType==2){
		$.jBox.tip("该样方数据已审核通过，不可删除！");
		return;
	}
	var url = "";
	if(hasShrubs=="有"){
		url=contextPath+"/gmsShrubsQuadratController/deleteShrubsQuadratById.act?sid="+id;
	}else{
		url=contextPath+"/gmsHerbQuadratController/deleteHerbQuadratById.act?sid="+id;
	}
	top.$.jBox.confirm("确定删除该条样方数据？","确认",function(v){
		if(v=="ok"){
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
}

function addQuadrat(sampleAreaId,inOrOut,hasShrubs){
	var url="";
	var title = "";
	if(hasShrubs=="有" && inOrOut==0){//非工程灌木样方
		url="../investigation/height/shrubs_no_project_quadrat.jsp?sampleAreaId="+sampleAreaId;
		title = "添加非工程灌木样方";
	}else if(hasShrubs=="无" && inOrOut==0){//非工程草本样方
		url="../investigation/height/herb_no_project_quadrat.jsp?sampleAreaId="+sampleAreaId;
		title="添加非工程草本样方";
	}else if(hasShrubs=="有" && inOrOut>0){//工程灌木样方
		url="../investigation/height/shrubs_project_quadrat.jsp?sampleAreaId="+sampleAreaId;
		title="添加工程灌木样方";
	}else if(hasShrubs=="无" && inOrOut>0){//工程草本样方
		url="../investigation/height/herb_project_quadrat.jsp?sampleAreaId="+sampleAreaId;
		title="添加工程草本样方";
	}
	top.$.jBox("iframe:"+url, {
		top:30,
		title:title,
	    width: 1000,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveQuadrat();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });

}

function editQuadrat(id,projectId,hasShrubs,recordsType,auditContent){
	if(recordsType==0 || recordsType==2){
		$.jBox.tip("该样方数据已审核通过，不可修改！");
		return;
	}
	var bottomText="";
	if(auditContent!=undefined && auditContent!="" && auditContent!=null && auditContent!="null"){
		bottomText = "审核意见:"+auditContent;
	}
	var bText=bottomText;
	if(bottomText.length>50){
		bottomText = bottomText.substring(0,50)+"...";
	}
	var url="";
	var title="";
	if(hasShrubs=="有" && projectId==0){//非工程灌木样方
		url="../investigation/height/shrubs_no_project_quadrat.jsp?id="+id;
		title = "修改非工程灌木样方";
	}else if(hasShrubs=="无" && projectId==0){//非工程草本样方
		url="../investigation/height/herb_no_project_quadrat.jsp?id="+id;
		title = "修改非工程草本样方";
	}else if(hasShrubs=="有" && projectId>0){//工程灌木样方
		url="../investigation/height/shrubs_project_quadrat.jsp?id="+id;
		title = "修改工程灌木样方";
	}else if(hasShrubs=="无" && projectId>0){//工程草本样方
		url="../investigation/height/herb_project_quadrat.jsp?id="+id;
		title = "修改工程草本样方";
	}
	top.$.jBox("iframe:"+url, {
		bottomText:"<span style='max-width:800px;display:block;text-overflow:ellipsis;overflow:hidden;' title='"+bText+"'>"+bottomText+"<span>",
		top:30,
		title:title,
	    width: 1000,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveQuadrat();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader" style='height: 60px; padding-top: 20px;'>
			<img src='<%=contextPath%>/resource/images/sys/home.png' style="top:20px;"/><b class="first">当前位置：常规监测报送》<b class="second">盛期地面调查</b></b>
			<div style="float: right;">
				<input type="button" class="btn btn-success" style="background: #41a675;" value="添加非工程样地" onclick="addSampleArea(1)" />
				<input type="button" class="btn btn-success" style="background: #41a675;"  value="添加工程样地" onclick="addSampleArea(0)" /> 
				<input type="button" class="btn btn-success" style="background: #41a675;"  value="批量上报"
					onclick="mulitiSubmit(1)" />
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