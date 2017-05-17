/**
 * 返回数据类型
 *0-工程样地调查
 1-非工程样地
 2-分县补饲调查
 3-入户补饲调查
 4-生态环境调查
 5-返青期调查
 6-枯黄期调查
 7-植被长势调查
 */
function getInvestigateTypeDesc(type){
	var typeDesc="";
	switch(type)
	{
	case 0:
		typeDesc="工程样地";
		break;
	case 1:
		typeDesc =  "非工程样地";
		break;
	case 2:
		typeDesc =  "分县补饲调查";
		break;
	case 3:
		typeDesc =  "入户补饲调查";
		break;
	case 4:
		typeDesc =  "生态环境调查";
		break;
	case 5:
		typeDesc =  "返青期样地";
		break;
	case 6:
		typeDesc =  "枯黄期样地";
		break;
	case 7:
		typeDesc =  "植被长势调查";
		break;
	}
	return typeDesc;
}


/**
 * 返回数据的审核状态
 * @param auditStatus
 * @returns
 */
function getAuditStatusDesc(auditStatus){
	var auditStatusDesc="";
	switch(auditStatus)
	{
	case 0:
		auditStatusDesc="未上报";
		break;
	case 1:
		auditStatusDesc =  "待市级审核";
		break;
	case 2:
		auditStatusDesc =  "待省级审核";
		break;
	case 3:
		auditStatusDesc =  "<font style='color:red;'>市级审核驳回</font>";
		break;
	case 4:
		auditStatusDesc =  "省级审核通过";
		break;
	case 5:
		auditStatusDesc =  "<font style='color:red;'>省审核驳回</font>";
		break;
	default:
		auditStatusDesc="未上报";
	}
	
	return auditStatusDesc;
}
/**
 * 返回数据的审核状态
 * @param auditStatus
 * @returns
 */
function getRecordsTypeDesc(recordsType){
	var recordsTypeDesc="";
	switch(recordsType)
	{
	case 0:
		recordsTypeDesc="待省级审核";
		break;
	case 1:
		recordsTypeDesc =  "<font style='color:red;'>市级审核驳回</font>";
		break;
	case 2:
		recordsTypeDesc =  "省级审核通过";
		break;
	case 3:
		recordsTypeDesc =  "<font style='color:red;'>省级审核驳回</font>";
		break;
	default:
		recordsTypeDesc="待市级审核";
	}
	
	return recordsTypeDesc;
}


function getCompleteStatusDesc(status){
	var statusDesc="";
	if(status==0){
		statusDesc="已完成";
	}else if(status==1){
		statusDesc="<font style='color:red;'>未完成</font>";
	}
	return statusDesc;
}



/**
 * 批量上报
 */
function mulitiSubmit(dataType){
	var selections = $('#datagrid').datagrid('getSelections');
	var dataIds = getSelectItem();
	if(dataIds.length<1){
		$.jBox.tip("至少选择一条数据完整的数据","info");
		return;
	}
	var successNums = dataIds.split(",").length;
	var errorNums = selections.length - successNums;
	$.jBox.confirm("确定上报选中的数据吗？","确认",function(v){
		if(v=="ok"){
			var url = contextPath + "/gmsInvestigateDataController/mulitiSubmit.act";
			var para = {dataIds:dataIds};
			var json = tools.requestJsonRs(url,para);
			if(json.rtState){
				if(errorNums>0){
					$.jBox.tip("上报完毕，共有"+successNums+"条数据上报成功，另有"+errorNums+"条数据因数据不完整而上报失败，请补充完整后再上报！", "info", {timeout: 1800});
				}else{
					$.jBox.tip("上报完毕，共有"+successNums+"条数据上报成功！", "info", {timeout: 1800});
				}
				datagrid.datagrid('reload');
				datagrid.datagrid("unselectAll");
				statistics(dataType);
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}

function singleSubmit(index){
	var data = datagrid.datagrid('getData').rows[index];
	var dataId = data.dataId;
	var dataType = data.investigateType;
	if(data.completeStatus!=0){
		if(dataType==0 || dataType==1 || dataType==5 || dataType==6){
			if(data.quadratList.length==0){
				$.jBox.tip("请添加样方数据后再上报！");
				return;
			}else if(!data.isFinish){
				$.jBox.tip("样地数据不完整，请补充完整后再上报！");
				return;
			}else{
				$.jBox.tip("样方数据不完整，请补充完整后再上报！");
				return;
			}
		}else {
			$.jBox.tip("数据不完整，请补充完整后再上报！");
			return;
		}
	}
	$.jBox.confirm("确定上报选中的数据吗？","确认",function(v){
		if(v=="ok"){
			var url = contextPath + "/gmsInvestigateDataController/mulitiSubmit.act";
			var para = {dataIds:dataId};
			var json = tools.requestJsonRs(url,para);
			if(json.rtState){
				$.jBox.tip(json.rtMsg, "info", {timeout: 1800});
				datagrid.datagrid('reload');
				statistics(dataType);
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
		if(selections[i].completeStatus==0){
			ids+=selections[i].dataId+",";
		}
	}
	if(ids.length>0){
		ids = ids.substring(0,ids.length-1);
	}
	return ids;
}




function addFeeding(type){
	var title="";
	var url="";
	if(type==2){
		title="添加分县补饲调查";
		url="../investigation/feeding/fx_add.jsp?type="+type;
	}else{
		title="添加入户补饲调查";
		url="../investigation/feeding/rh_add.jsp?type="+type;
	}
	top.$.jBox("iframe:"+url, {
		title:title,
		top:30,
	    width: 1000,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveFeeding();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editFeeding(id,type,auditContent){
	var bottomText="";
	if(auditContent!=undefined && auditContent!="" && auditContent!=null && auditContent!="null"){
		bottomText = "审核意见:"+auditContent;
	}
	var bText=bottomText;
	if(bottomText.length>50){
		bottomText = bottomText.substring(0,50)+"...";
	}
	var title="";
	var url="";
	if(type==2){
		title="修改分县补饲调查";
		url="../investigation/feeding/fx_add.jsp?id="+id+"&type="+type
	}else{
		title="修改入户补饲调查";
		url="../investigation/feeding/rh_add.jsp?id="+id+"&type="+type
	}
	top.$.jBox("iframe:"+url, {
		bottomText:"<span style='max-width:800px;display:block;text-overflow:ellipsis;overflow:hidden;' title='"+bText+"'>"+bottomText+"<span>",
		title:title,
		top:30,
	    width: 1000,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveFeeding();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function deleteFeeding(id){
	top.$.jBox.confirm("确定删除该条数据吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsFeedingController/deleteFeedingById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
				statistics(2);
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}


function addEcological(){
	top.$.jBox("iframe:../investigation/ecological/add.jsp", {
		title:"添加生态环境调查",
		top:30,
	    width: 800,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveEcological();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editEcological(id,auditContent){
	var bottomText="";
	if(auditContent!=undefined && auditContent!="" && auditContent!=null && auditContent!="null"){
		bottomText = "审核意见:"+auditContent;
	}
	var bText=bottomText;
	if(bottomText.length>50){
		bottomText = bottomText.substring(0,50)+"...";
	}
	top.$.jBox("iframe:../investigation/ecological/add.jsp?id="+id, {
		bottomText:"<span style='max-width:800px;display:block;text-overflow:ellipsis;overflow:hidden;' title='"+bText+"'>"+bottomText+"<span>",
		title:"修改生态环境调查",
		top:30,
	    width: 800,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveEcological();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function deleteEcological(id){
	top.$.jBox.confirm("确定删除该条数据吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsEcologicalController/deleteEcologicalById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
				statistics(4);
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}

function addGreenYellowSampleArea(){
	var title="";
	if(type=="g"){
		title="添加返青期调查";
	}else{
		title="添加枯黄期调查";
	}
	top.$.jBox("iframe:../investigation/gymonitoring/add.jsp?type="+type, {
		title:title,
		top:30,
	    width: 800,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveGreenYellowSampleArea();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editGreenYellowSampleArea(id,recordsType,auditContent,quadratSize){
	var bottomText="";
	if(auditContent!=undefined && auditContent!="" && auditContent!=null && auditContent!="null"){
		bottomText = "审核意见:"+auditContent;
	}
	var bText=bottomText;
	if(bottomText.length>50){
		bottomText = bottomText.substring(0,50)+"...";
	}
	if(recordsType==0 || recordsType==2){
		$.jBox.tip("该样地数据已审核通过，不可修改！");
		return;
	}
	var title="";
	if(type=="g"){
		title="修改返青期调查";
	}else{
		title="修改枯黄期调查";
	}
	top.$.jBox("iframe:../investigation/gymonitoring/add.jsp?id="+id+"&type="+type+"&quadratSize="+quadratSize, {
		bottomText:"<span style='max-width:800px;display:block;text-overflow:ellipsis;overflow:hidden;' title='"+bText+"'>"+bottomText+"<span>",
		title:title,
		top:30,
	    width: 800,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveGreenYellowSampleArea();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function deleteGreenYellowSampleArea(id,isDel){
	if(!isDel){
		$.jBox.tip("该数据中有审核通过的样地或者样方，不能删除！");
		return;
	}
	top.$.jBox.confirm("删除该条样地数据时，该样地下的样方数据也将被删除，确定删除该条样地数据？","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsGreenYellowSampleAreaController/deleteGreenYellowSampleAreaById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
				if(type=="g"){
					statistics(5);
				}else if(type=="y"){
					statistics(6);
				}
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}


function addSampleArea(type){
	var title = "";
	var url="";
	if(type==0){
		title="添加工程样地";
		url="../investigation/height/p_height.jsp";
	}else{
		title="添加非工程样地";
		url="../investigation/height/np_height.jsp";
	}
	top.$.jBox("iframe:"+url, {
		title:title,
		top:30,
	    width: 1000,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveSampleArea();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editSampleArea(id,type,dataId,recordsType,auditContent,quadratSize){
	var bottomText="";
	if(auditContent!=undefined && auditContent!="" && auditContent!=null && auditContent!="null"){
		bottomText = "审核意见:"+auditContent;
	}
	var bText=bottomText;
	if(bottomText.length>50){
		bottomText = bottomText.substring(0,50)+"...";
	}
	if(recordsType==0 || recordsType==2){
		$.jBox.tip("该样地数据已审核通过，不可修改！");
		return;
	}
	var title = "";
	var url="";
	if(type==0){
		title="修改工程样地";
		url="../investigation/height/p_height.jsp?id="+id+"&dataId="+dataId+"&quadratSize="+quadratSize;
	}else{
		title="修改非工程样地";
		url="../investigation/height/np_height.jsp?id="+id+"&dataId="+dataId+"&quadratSize="+quadratSize;
	}
	top.$.jBox("iframe:"+url, {
		bottomText:"<span style='max-width:800px;display:block;text-overflow:ellipsis;overflow:hidden;' title='"+bText+"'>"+bottomText+"<span>",
		title:title,
		top:30,
	    width: 1000,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveSampleArea();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function deleteSampleArea(id,isDel){
	if(!isDel){
		$.jBox.tip("该数据中有审核通过的样地或者样方，不能删除！");
		return;
	}
	top.$.jBox.confirm("删除该条样地数据时，该样地下的样方数据也将被删除，确定删除该条样地数据？","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsSampleAreaController/deleteSampleAreaById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
				statistics(1);
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}



function addVegetationGrew(){
	top.$.jBox("iframe:../investigation/vegetation/add.jsp", {
		title:"添加植被长势调查",
		top:30,
	    width: 800,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveVegetationGrew();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editVegetationGrew(id,auditContent){
	var bottomText="";
	if(auditContent!=undefined && auditContent!="" && auditContent!=null && auditContent!="null"){
		bottomText = "审核意见:"+auditContent;
	}
	var bText=bottomText;
	if(bottomText.length>50){
		bottomText = bottomText.substring(0,50)+"...";
	}
	top.$.jBox("iframe:../investigation/vegetation/add.jsp?id="+id, {
		bottomText:"<span style='max-width:800px;display:block;text-overflow:ellipsis;overflow:hidden;' title='"+bText+"'>"+bottomText+"<span>",
		title:"修改植被长势调查",
		top:30,
	    width: 800,
	    height: 550,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveVegetationGrew();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function deleteVegetationGrew(id){
	top.$.jBox.confirm("确定删除该条数据吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/gmsVegetationGrewController/deleteVegetationGrewById.act?sid="+id;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
				statistics(7);
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}



/**
 * 显示各调查详情
 0-工程样地调查
 1-非工程样地
 2-分县补饲调查
 3-入户补饲调查
 4-生态环境调查
 5-返青期调查
 6-枯黄期调查
 7-植被长势调查
 */
function detail(dataId,inOrOut,saId,title,type,auditContent){
	var url="";
	var topTitle="";
	if(type==0){
		url = encodeURI("../investigation/height/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title+"&inOrOut="+inOrOut);
		topTitle="盛期工程调查详情";
	}
	if(type==1){
		url = encodeURI("../investigation/height/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title+"&inOrOut="+inOrOut);
		topTitle="盛期非工程调查详情";
	}
	if(type==2){
		url="../investigation/feeding/detail.jsp?id="+saId+"&type="+type;
		topTitle="分县补饲详情";
	}
	if(type==3){
		url="../investigation/feeding/detail.jsp?id="+saId+"&type="+type;
		topTitle="入户补饲详情";
	}
	if(type==4){
		url="../investigation/ecological/detail.jsp?id="+saId+"&type="+type;
		topTitle="生态调查详情";
	}
	if(type==5){
		url = encodeURI("../investigation/gymonitoring/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title);
		topTitle="返青期调查详情";
	}
	if(type==6){
		url = encodeURI("../investigation/gymonitoring/detail.jsp?dataId="+dataId+"&sampleAreaId="+saId+"&title="+title);
		topTitle="枯黄期调查详情";
	}
	if(type==7){
		url="../investigation/vegetation/detail.jsp?id="+saId+"&type="+type;
		topTitle="植被长势调查详情";
	}
	var bottomText="";
	if(auditContent!=undefined && auditContent!="" && auditContent!=null && auditContent!="null"){
		bottomText = "审核意见:"+auditContent;
	}
	var bText=bottomText;
	if(bottomText.length>50){
		bottomText = bottomText.substring(0,50)+"...";
	}
	top.$.jBox("iframe:"+encodeURI(url), {
		bottomText:"<span style='max-width:800px;display:block;text-overflow:ellipsis;overflow:hidden;' title='"+bText+"'>"+bottomText+"<span>",
		title:topTitle,
		top:30,
	    width: 1000,
	    height: 550,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
            if(v==2){
            	return true;
            }
        }
	});
}
