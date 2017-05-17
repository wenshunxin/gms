
function allExportInfo(){
	var stationsType = $("#stationsType").val();
	var url ="";
	if(stationsType=="常规观测区"){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}else if(stationsType=="辅助观测区"){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}else if(stationsType=="刈割监测区"){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}else if(stationsType=="火烧管理区"){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}else if(stationsType=="生态状况调查"){
		url = contextPath+"/gmeController/exportGmeInfo.act";
	}else if(stationsType=="物候期及降雪观测"){
		url = contextPath+"/gmpController/exportGmpInfo.act";
	}else if(stationsType=="经济社会指标"){
		url = contextPath+"/gmsController/exportGmsInfo.act";
	}
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


function multiExportInfo(type){
	var sids = getSelectItem();
	if(sids.length<1){
		$.jBox.tip("请选择需要下载的信息","info");
		return;
	}
	var stationsType = $("#stationsType").val();
	var url ="";
	if(stationsType==0){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}else if(stationsType==1){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}else if(stationsType==2){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}else if(stationsType==3){
		url = contextPath+"/ghoaController/exportGhoaInfo.act";
	}
	if(type=="0"){
		url = contextPath+"/gmeController/exportGmeInfo.act";
	}else if(type=="1"){
		url = contextPath+"/gmpController/exportGmpInfo.act";
	}else if(type=="2"){
		url = contextPath+"/gmsController/exportGmsInfo.act";
	}
	url += "?sids="+sids;
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