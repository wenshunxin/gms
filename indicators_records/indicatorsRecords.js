/*
 * 根据所选监测点所在城市 选择指标列表
 */
function getIndicatorsByCityCode(cityCode){
	url = contextPath+"/indicatorsRecordsController/getIndicatorsByCityCode.act?cityCode="+cityCode;
	var json = tools.requestJsonRs(url);
	 $('#indicatorsId').combobox({
		data:json.rows,
		valueField:'sid',
		textField:'indicatorsName',
	 });
	 $('#indicatorsId').combobox('textbox').bind('click',function(){
		 $('#indicatorsId').combobox('showPanel');
	});
}




function eidtIndicatorsRecords(id){
	top.$.jBox("iframe:../indicators_records/add.jsp?id="+id, {
		title:"修改指标信息",
		width: 700,
		height: 400,
		top:100,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveIndicatorsRecords();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}

function findIndicatorsRecordsById(id){
	top.$.jBox("iframe:../indicators_records/details.jsp?id="+id, {
		title:"详细信息",
		width: 700,
		height: 300,
		top:100,
	    buttons:{'关闭': 1},
	    submit: function (v, h, f) {
            if (v == 1) {
            	return true;
            }
        }
	  });
};
function deleteIndicatorsRecords(){
	var ids = getSelectItem();
	if(ids.length>0){
		top.$.jBox.confirm("确定删除指标信息吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/indicatorsRecordsController/deleteIndicatorsRecordsById.act?sids="+ids;
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
};


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
	$("#indicatorsId").combobox("clear");
	 var curCityCode="";
	 var province = $("#province").val();
	 var city = $("#city").val();
	 var county = $("#county").val();
	 var curCityCode="";
	 if(county!=""){
		 curCityCode = county;
	 }else if(city!=""){
		 curCityCode = city;
	 }else if(province!=""){
		 curCityCode = province;
	 }else{
		 curCityCode = "000000";
	 }
	 $("#cityCode").val(curCityCode);
	var curCityCode = $("#cityCode").val();
	getIndicatorsByCityCode(curCityCode);
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



function multiExportInfo(){
	var dataIds = getSelectItem();
	if(dataIds.length<1){
		$.jBox.tip("请选择需要下载的数据","info");
		return;
	}
	var	url = contextPath+"/indicatorsRecordsController/exportIndicatorsInfo.act?1=1";
	url+="&dataIds="+dataIds;
	document.form1.action= url;
	
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
	document.form1.submit();
}
