/**
 * 样地数据统计
 * @param dataType
 * @returns
 */
function statistics(dataType,queryCityCode){
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
	var queryParams = {};
	queryParams["queryCityCode"]=cityCode;
	queryParams["dataType"]=dataType;
	var url = contextPath+"/gmsInvestigateDataController/statisticsTotalNums.act";
	var json = tools.requestJsonRs(url,queryParams);
	if(json.rtState){
		var data = json.rtData;
		$("#saTotal").text(data.saTotal);
		$("#submitNums").text(data.submitNums);
		$("#noSubmitNums").text(data.noSubmitNums);
		$("#auditYesNums").text(data.auditYesNums);
		$("#auditProvinceNoNums").html("<a href='javascript:void(0)' style='text-decoration:underline;color:red;'>"+data.auditProvinceNoNums+"</a>");
		$("#auditCityNoNums").html("<a href='javascript:void(0)' style='text-decoration:underline;color:red;'>"+data.auditCityNoNums+"</a>");
		$("#waitProvinceAudit").text(data.waitProvinceAudit);
		$("#waitCityAudit").text(data.waitCityAudit);
	}
	$("#auditProvinceNoNums").unbind("click").bind("click",function(){
		auditNoNums(dataType,queryCityCode,5);
	});
	$("#auditCityNoNums").unbind("click").bind("click",function(){
		auditNoNums(dataType,queryCityCode,3);
	});
	
}


function auditNoNums(dataType,queryCityCode,auditNoStatus){
	if(queryCityCode==undefined){
		queryCityCode="";
	}
	top.$.jBox("iframe:../investigation/auditNoNums.jsp?investigateType="+dataType+"&auditNoStatus="+auditNoStatus+"&queryCityCode="+queryCityCode, {
		title:"被驳回数据",
		top:30,
	    width: 1000,
	    height: 500,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
           if(v==2){
            	return true;
            }
        }
	  });
}

