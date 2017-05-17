function addQueryConditon(dataType,type){
	$("#queryCondition").empty();
	if(dataType=="植物群落特征及生产力"){
		$("#queryCondition").load("plant_community.jsp?type="+type);
	}else if(dataType=="生态状况调查"){
		$("#queryCondition").load("ms_ecological.jsp?type="+type);
	}else if(dataType=="物候期及降雪观测"){
		$("#queryCondition").load("phenological.jsp?type="+type);
	}else if(dataType=="经济社会指标调查"){
		$("#queryCondition").load("social.jsp?type="+type);
	}else if(dataType=="照片查询对比"){
		$("#queryCondition").load("picQuery.jsp");
	}else if(dataType=="其他指标调查"){
		$("#queryCondition").load("indicators.jsp?type="+type);
	}
}


function doReset(){
	document.getElementById("form1").reset(); 
	$('#grassCategory').combobox('clear');
	getProvince();
	cityPrivSettingForQuery();
}


function detailInfo(id){
	$.jBox("iframe:../../investigator/detailInfo.jsp?id="+id, {
		title:"查看调查人信息",
		top:0,
	    width: 600,
	    height: 500,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
             if(v==2){
            	return true;
            }
        }

	  });
}


function returnCategoryName(typeCode,codeValue){
	if(typeCode==null || typeCode==""){
		return "";
	}
	if(codeValue==null || codeValue==""){
		return "";
	}
	var url = contextPath+"/gmsSysCategoryController/getCategoryName.act?typeCode="+typeCode+"&codeValue="+codeValue;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		if(data){
			return data.categoryName;
		}
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}

// function toggle(){
// 	$("#form1").toggle();
// 	datagrid.datagrid("reload");
// }

function toggll(evt){
	var indexArray = [];
	var selections = $('#datagrid').datagrid('getSelections');
	for(var i=0;i<selections.length;i++){
		var index = $('#datagrid').datagrid('getRowIndex',selections[i]);
		indexArray[i]=index;
	}
	$("#form1").toggle();
	datagrid.datagrid("reload");
	setTimeout(function(){
		setValue(indexArray);
	},100);
	var src=$(evt).attr("src");
	if(src=="/gms/resource/images/sys/down.png"){
		src=contextPath+"/resource/images/sys/up.png";
		$(evt).attr("src",src);
		$(evt).attr("title","收起");
	}else{
		src=contextPath+"/resource/images/sys/down.png";
		$(evt).attr("src",src);
		$(evt).attr("title","展开");
	}
}
function setValue(indexArray){
	for(var i=0;i<indexArray.length;i++){
		$('#datagrid').datagrid('checkRow',indexArray[i]);
	}
}