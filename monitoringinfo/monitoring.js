/*
 * 选择监测点 对应调查类型
 * id:检测点id
 */
function changeMonitoring(id){
	var content;
	if(id!="" && id!=null){
		var url = contextPath+"/monitoringStationsController/getMonitoringStationsById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			var basicInfo = json.rtData.basicInfo;
			if(basicInfo.hasShrubs==0){
				content = contextPath+"/monitoringinfo/herb_observation_area.jsp";
				$("#td").text("草本调查");
			}else if(basicInfo.hasShrubs==1){
				content = contextPath+"/monitoringinfo/shrubs_observation_area.jsp";
				$("#td").text("灌木调查");
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
	return content;
}


/**
 * 0-常规观测区
1-辅助观测区
2-刈割观测区
3-火烧管理区
 */
function returnStationType(){
	var title =parent.$('.tabs-selected').text(); 
	if(title=="常规观测区"){
		return 0;
	}else if(title=="辅助观测区"){
		return 1;
	}else if(title=="刈割监测区"){
		return 2;
	}else if(title=="火烧管理区"){
		return 3;
	}
		
}


function eidtSocial(sid){
	top.$.jBox("iframe:../monitoringinfo/ms_social.jsp?id="+sid, {
		title:"修改经济社会指标",
	    width: 1000,
	    height: 500,
	    top:30,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveGms();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function socialDetail(sid){
	top.$.jBox("iframe:../monitoringinfo/ms_social_detail.jsp?id="+sid, {
		title:"经济社会指标详情",
	    width: 1000,
	    height: 500,
	    top:30,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
           if(v==2){
            	return true;
            }
        }
	  });
}

function deleteSocial(){
	var ids = getSelectItem();
	if(ids.length>0){
		top.$.jBox.confirm("确定删除选中经济社会指标信息吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/gmsController/deleteGmsById.act?sids="+ids;
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


function eidtPhenological(sid){
	top.$.jBox("iframe:../monitoringinfo/ms_phenological.jsp?id="+sid, {
		title:"修改物候及降雪信息",
		width: 1000,
		height: 500,
		top:30,
		buttons:{"确定":1,'关闭': 2},
		submit: function (v, h, f) {
			if (v == 1) {
				top.document.getElementById("jbox-iframe").contentWindow.saveGmp();
				return false;
			}
			else if(v==2){
				return true;
			}
		}
		
	});
}

function phenologicalDetail(sid){
	top.$.jBox("iframe:../monitoringinfo/ms_phenological_detail.jsp?id="+sid, {
		title:"物候期及降雪详情",
		width: 1000,
		height: 500,
		top:30,
		buttons:{'关闭': 2},
		submit: function (v, h, f) {
			if(v==2){
				return true;
			}
		}
		
	});
}

function deletePhenological(){
	var ids = getSelectItem();
	if(ids.length>0){
		top.$.jBox.confirm("确定删除选中物候期及降雪信息吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/gmpController/deleteGmpById.act?sids="+ids;
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

function doReset(){
	document.getElementById("form1").reset(); 
	getProvince();
	cityPrivSettingForQuery();
	$("#grassCategory").combobox("clear");
	$("#grassType").combobox("clear");
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
	 $("#cityCode").val(cityCode);
	 var queryParams=tools.formToJson($("#form1"));
	 datagrid.datagrid('options').queryParams=queryParams; 
	 datagrid.datagrid("reload");
}
