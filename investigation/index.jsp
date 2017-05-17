<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
	int userLevel = (Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
	String investigateType = request.getParameter("investigateType");
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
	getProvince();
	cityPrivSettingForQuery();
	statistics(<%=investigateType%>);
	returnTypeDesc(<%=investigateType%>);
	var url = contextPath+"/gmsInvestigateDataController/queryDataList.act?investigateType=<%=investigateType%>";
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
				var html="<div class='sampleArea'>"+rowData.year+"-"+rowData.investigateNum+"</div>";
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
			{field:'auditStatus',title:'审核状态',width:50,rowspan:2,align:"center",formatter:function(e,rowData,index){
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
			{field:'auditContent',title:'审核意见',width:100,rowspan:2,formatter:function(e,rowData,index){
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
			{field:'completeStatus',title:'数据状态',width:50,rowspan:2,align:'center',formatter:function(e,rowData,index){
				var html="<div class='sampleArea'>"+getCompleteStatusDesc(rowData.completeStatus)+"</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						var completeStatus = quadratList[i].complete?0:1;
						html+="<div class='quadrat'>"+getCompleteStatusDesc(completeStatus)+"</div>";
					}
				}
				return html;
			}},
			{title:'操作',colspan:5,align:"center"}
			],
			[
				{field:'5',title:'审核',width:20,align:"center",formatter:function(e,rowData,index){
					var html="<div class='sampleArea'>";
					if(userLevel=="1" && rowData.recordsType==0){
						html+="<a class='approveCtrl' href='javascript:void(0);' onclick='auditSampleArea("+index+")'></a>";
					}
					if(userLevel=="2" && (rowData.recordsType==null || rowData.recordsType==1 ||rowData.recordsType==3)){
						html+="<a class='approveCtrl' href='javascript:void(0);' onclick='auditSampleArea("+index+")'></a>";
					}
					html+="</div>";
				var quadratList=rowData.quadratList;
				if(quadratList){
					for(var i=0;i<quadratList.length;i++){
						html+="<div class='quadrat'>";
						if(userLevel=="1" && quadratList[i].recordsType==0){
							html+="<a class='approveCtrl' href='javascript:void(0);' onclick=\"auditSampleArea("+index+",'"+quadratList[i].quadratNumber+"',"+quadratList[i].sid+")\"></a>";
						}
						if(userLevel=="2" && (quadratList[i].recordsType==null || quadratList[i].recordsType==1 || quadratList[i].recordsType==3)){
							html+="<a class='approveCtrl' href='javascript:void(0);' onclick=\"auditSampleArea("+index+",'"+quadratList[i].quadratNumber+"',"+quadratList[i].sid+")\"></a>";
						}
						html+="</div>";
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
 * 审核样地
 */
function auditSampleArea(index,qTitle,qId){
	var data = datagrid.datagrid('getData').rows[index];
	var type = data.investigateType;
	var dataId = data.dataId;
	var saId = data.sampleAreaId;
	var title = data.investigateNum;
	if(qTitle){
		title = qTitle;
	}
	var inOrOut = data.inOrOut;
	var url="";
	var topTitle="";
	if(type==0){
		url = encodeURI("../investigation/height/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title+"&inOrOut="+inOrOut+"&type="+type+"&index="+index);
		topTitle="盛期工程审核";
	}
	if(type==1){
		url = encodeURI("../investigation/height/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title+"&inOrOut="+inOrOut+"&type="+type+"&index="+index);
		topTitle="盛期非工程审核";
	}
	if(type==2){
		url="../investigation/feeding/detail.jsp?id="+data.sampleAreaId+"&type="+type;
		topTitle="分县补饲审核";
	}
	if(type==3){
		url="../investigation/feeding/detail.jsp?id="+data.sampleAreaId+"&type="+type;
		topTitle="入户补饲审核";
	}
	if(type==4){
		url="../investigation/ecological/detail.jsp?id="+data.sampleAreaId+"&type="+type;
		topTitle="生态调查审核";
	}
	if(type==5){
		url = encodeURI("../investigation/gymonitoring/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title+"&type="+type+"&index="+index);
		topTitle="返青期调查审核";
	}
	if(type==6){
		url = encodeURI("../investigation/gymonitoring/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title+"&type="+type+"&index="+index);
		topTitle="枯黄期调查审核";
	}
	if(type==7){
		url="../investigation/vegetation/detail.jsp?id="+data.sampleAreaId+"&type="+type;
		topTitle="植被长势调查审核";
	}
	var param = {};
	param["investigateDataId"]=data.dataId;
	param["sampleAreaId"]=data.sampleAreaId;
	param["quadratId"]=0;
	if(qId){
		param["quadratId"]=qId;
	}
	param["investigateType"] = type;
	top.$.jBox("iframe:"+encodeURI(url), {
		title: topTitle,
	    width: 1000,
	    height: 550,
	    buttons:{'通过':1,'驳回':2,'关闭': 3},
	    submit: function (v, h, f) {
	    	if(v==1){
	    		approved(param,index);
	    		return false;
	    	}else if(v==2){
	    		rejected(param,index);
	    		return false;
	    	}else if(v==3){
            	return true;
            }
        }
	 });
}


/**
 * 审核通过
 */
function approved(param,index){
	param["recordsType"]=0;
	//param["auditContent"]="审核通过";
	top.$.jBox.confirm("确定通过吗？","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsAuditRecordsController/saveAuditRecords.act";
			var json = tools.requestJsonRs(url,param);
			if(json.rtState){
				if(json.rtData){
					$.jBox.tip("审核成功");
					top.$(".jbox-body").remove();
					datagrid.datagrid('reload');
					statistics(<%=investigateType%>);
					return;
				}else {
					datagrid.datagrid('reload');
					statistics(<%=investigateType%>);
					setTimeout(function(){
						var tips = "审核成功！是否审核关联样方";
						var data = datagrid.datagrid('getData').rows[index];
						if(userLevel=="1" && data.recordsType==0){
							tips="审核成功！是否审核关联样地";
						}
						if(userLevel=="2"  && (data.recordsType==null || data.recordsType==3 || (data.recordsType==1 && data.isHistory==1))){
							tips="审核成功！是否审核关联样地";
						}
						var submit = function (v, h, f) {
						    if (v == 'ok') {
									if(userLevel=="1" && data.recordsType==0){
										top.$(".jbox-body").remove();
										auditSampleArea(index);
										return;
									}
									if(userLevel=="2" && (data.recordsType==null || data.recordsType==3 || (data.recordsType==1 && data.isHistory==1))){
										top.$(".jbox-body").remove();
										auditSampleArea(index);
										return;
									}
									//审核关联样方
									var quadratList = data.quadratList;
									if(quadratList){
										for(var i =0;i<quadratList.length;i++){
											var quadrat = quadratList[i];
											if(userLevel=="2" && (quadrat.recordsType==null || quadrat.recordsType==3 ||(quadrat.recordsType==1 && quadrat.isHistory==1))){
												top.$(".jbox-body").remove();
												auditSampleArea(index,quadrat.quadratNumber,quadrat.sid);
												break;
											}
											if(userLevel=="1" && quadrat.recordsType==0){
												top.$(".jbox-body").remove();
												auditSampleArea(index,quadrat.quadratNumber,quadrat.sid);
												break;
											}
										}
									}
						    }
						    else if (v == 'cancel') {
						    	top.$(".jbox-body").remove();
						    }
						    return true; 
						};
						top.$.jBox.confirm(tips, "提示", submit);
						
					},100);
				}
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
	
}

/**
 * 驳回
 */
function rejected(param,index){
	var html = "<div style='padding:10px;'>审核意见：<textarea id='auditContent' name='auditContent' class='BigTextarea'></textarea></div>";
	var submit = function (v, h, f) {
	    if (f.auditContent == '') {
	        // f.auditContent 或 h.find('#auditContent').val() 等于 top.$('#auditContent').val()
	        top.$.jBox.tip("请输入审核意见", 'error', { focusId: "auditContent" }); // 关闭设置 auditContent 为焦点
	        return false;
	    }
	    param["recordsType"]=1;
	  	param["auditContent"]=f.auditContent;
	  	var url = contextPath+"/gmsAuditRecordsController/saveAuditRecords.act";
		var json = tools.requestJsonRs(url,param);
		if(json.rtState){
			if(json.rtData){
				$.jBox.tip("审核成功");
				top.$(".jbox-body").remove();
				datagrid.datagrid('reload');
				statistics(<%=investigateType%>);
				return;
			}else {
				datagrid.datagrid('reload');
				statistics(<%=investigateType%>);
				setTimeout(function(){
					var tips = "审核成功！是否审核关联样方";
					var data = datagrid.datagrid('getData').rows[index];
					if(userLevel=="1" && data.recordsType==0){
						tips="审核成功！是否审核关联样地";
					}
					if(userLevel=="2" && data.recordsType==null){
						tips="审核成功！是否审核关联样地";
					}
					var submit = function (v, h, f) {
					    if (v == 'ok') {
								if(userLevel=="1" && data.recordsType==0){
									top.$(".jbox-body").remove();
									auditSampleArea(index);
									return;
								}
								if(userLevel=="2" && (data.recordsType==null || data.recordsType==3)){
									top.$(".jbox-body").remove();
									auditSampleArea(index);
									return;
								}
								//审核关联样方
								var quadratList = data.quadratList;
								if(quadratList){
									for(var i =0;i<quadratList.length;i++){
										var quadrat = quadratList[i];
										if(userLevel=="2" && (quadrat.recordsType==null || quadrat.recordsType==3)){
											top.$(".jbox-body").remove();
											auditSampleArea(index,quadrat.quadratNumber,quadrat.sid);
											break;
										}
										if(userLevel=="1" && quadrat.recordsType==0){
											top.$(".jbox-body").remove();
											auditSampleArea(index,quadrat.quadratNumber,quadrat.sid);
											break;
										}
									}
								}
					    }
					    else if (v == 'cancel') {
					    	top.$(".jbox-body").remove();
					    }
					    return true; 
					};
					top.$.jBox.confirm(tips, "提示", submit);
					
				},100);
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	};
	top.$.jBox(html, { title: "驳回原因", submit: submit });
	
}

function returnTypeDesc(type){
	var typeDesc="";
	switch(type)
	{
	case 0:
		typeDesc="盛期地面调查";
		break;
	case 1:
		typeDesc =  "盛期地面调查";
		break;
	case 2:
		typeDesc =  "补饲调查";
		$("#saTitle").text("数据");
		break;
	case 3:
		typeDesc =  "补饲调查";
		$("#saTitle").text("数据");
		break;
	case 4:
		typeDesc =  "生态环境调查";
		$("#saTitle").text("数据");
		break;
	case 5:
		typeDesc =  "返青期调查";
		break;
	case 6:
		typeDesc =  "枯黄期调查";
		break;
	case 7:
		typeDesc =  "植被长势调查";
		break;
	}
	$("#investigateTypeDesc").text(typeDesc);
}

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
	 $("#cityCode").val(cityCode);
	 statistics(<%=investigateType%>,cityCode);
	 var queryParams=tools.formToJson($("#form1"));
	 queryParams["queryCityCode"]=cityCode;
	 datagrid.datagrid('options').queryParams=queryParams; 
	 datagrid.datagrid("reload");
}
</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<form id="form1" name="form1" method="post">
			<div class="moduleHeader">
				<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：常规监测审核》<b class="second" id="investigateTypeDesc"></b></b>
				<div style="float: right;padding-right:100px;color:#000;">
					<span style="display:none;">省： <select name="province" id="province" onchange="getCity();" class="BigSelect">
							<option value="">全国</option>
						</select>
					</span>
					 市级： <select name="city" id="city" onchange="getCounty();" class="BigSelect">
							<option value="">所有</option>
						</select> 
					县级： <select name="county" id="county" class="BigSelect">
							<option value="">所有</option>
						</select>
					<input type="button" class="btn btn-success" style="background: #41a675;" value="查询" onclick="doSearch();"/>
				</div>
				<div style="height:24px;line-height:24px;margin-top:10px;color:#000;margin-left: 10px;">
						<!-- 今年生成样地 <span id="saTotal" style='color:green;'>20</span>， -->
						今年上报<span id="saTitle">样地</span><span id="submitNums" style='color:green;'></span>，
						<!-- 未上报 <span id="noSubmitNums" style='color:red;'></span>， -->
						审核通过 <span id="auditYesNums" style='color:green;'></span>，
						省驳回 <span id="auditProvinceNoNums" style='color:red;cursor:pointer;'></span>，
						市驳回 <span id="auditCityNoNums" style='color:red;cursor:pointer;'></span>，
						待市审核 <span id="waitCityAudit" style='color:red;'></span>，
						待省审核 <span id="waitProvinceAudit" style='color:red;'></span>
				</div>
			</div>
		</form>
	</div>
</body>
</html>