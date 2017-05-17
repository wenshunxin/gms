
/**
 * 根据分类编码获取下拉列表选项
 * @param typeCode
 * @param ctrl
 * @returns
 */

function getChildListByTypeCode(typeCode,ctrl){
	if(typeCode==null || typeCode==""){
		return;
	}
	var url = contextPath+"/gmsSysCategoryController/getChildCategoryListByParentNo.act?categoryNo="+typeCode;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		var html="";
		$("#"+ctrl).combobox({
		    data:data,
		    valueField:'categoryNo',
		    textField:'categoryName'
		});
	}
}


function getCategoryName(typeCode,codeValue,ctrl){
	if(typeCode==null || typeCode==""){
		return;
	}
	if(codeValue==null || codeValue==""){
		return;
	}
	var url = contextPath+"/gmsSysCategoryController/getCategoryName.act?typeCode="+typeCode+"&codeValue="+codeValue;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		if(data){
			$("#"+ctrl).text(data.categoryName);
		}
	}
}

function getCityInfo(ctrl){
	var url = contextPath+"/gmsInvestigateDataController/getCityInfo.act";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		if(data){
			$("#"+ctrl).text(data);
			$("#"+ctrl).val(data);
		}
	}
}

function getProvinceAndCounty(ctrl){
	var url = contextPath+"/gmsInvestigateDataController/getProvinceAndCounty.act";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		if(data){
			$("#"+ctrl).text(data);
			$("#"+ctrl).val(data);
		}
	}
}