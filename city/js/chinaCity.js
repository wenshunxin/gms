
/**
 * 获取省
 */
function getProvince(){
	var url = contextPath + "/gmsCityController/getProvinceList.act";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var province = document.getElementById('province');
		var prcList = json.rtData;
		if(prcList.length){
			$.each(prcList,function(i,prc){
				var option = new Option(prc.cityFullName,prc.cityCode);
				province.options.add(option);
			});
		}
	}
}

/**
 * 获取市
 */
function getCity(){
	var province = document.getElementById('province').value;
	var city = document.getElementById('city');
	city.length = 1;
	var county = document.getElementById('county');
	county.length = 1;
	if(province==""){
		return;
	}
	var county = document.getElementById('county');
	county.length = 1;
	var url = contextPath + "/gmsCityController/getCityListByCode.act";
	var param={cityCode:province};

	var json = tools.requestJsonRs(url,param);
	if(json.rtState){
		var prcList = json.rtData;
		if(prcList.length){
			$.each(prcList,function(i,prc){
				var option = new Option(prc.cityFullName,prc.cityCode);
				city.options.add(option);
			});
			
		}
	}
	
}


/**
 * 获取县
 */
function getCounty(){
	var city = document.getElementById('city').value;
	var county = document.getElementById('county');
	county.length = 1;
	if(city==""){
		return;
	}
	var url = contextPath + "/gmsCityController/getCountyListByCode.act";
	var param={cityCode:city};
	var json = tools.requestJsonRs(url,param);
	if(json.rtState){
		var prcList = json.rtData;
		if(prcList.length){
			$.each(prcList,function(i,prc){
				var option = new Option(prc.cityFullName,prc.cityCode);
				county.options.add(option);
			});
		}
	}
}

/**
 * 根据城市编号获取数据对象
 * @param cityCode
 * @returns {String}
 */
function getInfoByCityCode(cityCode){
	var url = contextPath + "/gmsCityController/getInfoByCityCode.act";
	var param = {cityCode:cityCode};
	var json = tools.requestJsonRs(url,param);
	var returnObj = "";
	if(json.rtState){
		returnObj = json.rtData;
	}
	return returnObj;
}



/**
 * 根据城市编号自动获取下一个
 * cityCode 城市编号
 * cityFlag 城市标识，1-省；2-市；3-县
 * inputObjId 绑定输入框id
 */
function getAutoNumber(cityCode,cityFlag,inputObjId){
	var url = contextPath + "/gmsCityController/getAutoNumberByCityCode.act";
	var para = {cityCode : cityCode,cityFlag:cityFlag};
	var jsonObj = tools.requestJsonRs(url, para);
	if (jsonObj.rtState) {
		var prc = jsonObj.rtData;
		var autoNumber = prc.autoNumber;
		$("#" + inputObjId).val(autoNumber);
	} else {
		alert(jsonObj.rtMsg);
	}
}


function getCityFullInfo(cityCode){
	if(cityCode=="" || cityCode=="000000"){
		return null;
	}
	var url = contextPath + "/gmsCityController/getCityFullInfoByCityCode.act";
	var param = {cityCode:cityCode};
	var json = tools.requestJsonRs(url,param);
	var returnObj = "";
	if(json.rtState){
		returnObj = json.rtData;
	}
	return returnObj;
}


function cityPrivSetting(){
	if(userLevel=="0"){
		$("#city").attr("disabled","disabled");
		$("#county").attr("disabled","disabled");
		$("#city").addClass("readonly");
		$("#county").addClass("readonly");
	}else if(userLevel==1){//省级用户只能管理市级用户
		$("#province").val(userCityCode);
		getCity();
		$("#province").attr("disabled","disabled");
		$("#county").attr("disabled","disabled");
		$("#province").addClass("readonly");
		$("#county").addClass("readonly");
	}else if(userLevel==2){//市级用户只能管理县级用户
		var json = getCityFullInfo(userCityCode);
		if(json){
			$("#province").val(json.provinceCode);
			getCity();
			$("#city").val(json.cityCode);
			getCounty();
		}
		$("#province").attr("disabled","disabled");
		$("#city").attr("disabled","disabled");
		$("#province").addClass("readonly");
		$("#city").addClass("readonly");
	}else if(userLevel==3){//县级用户没有用户管理模块，因此这里就不用判断了
		var json = getCityFullInfo(userCityCode);
		if(json){
			$("#province").val(json.provinceCode);
			getCity();
			$("#city").val(json.cityCode);
			getCounty();
			$("#county").val(json.countyCode);
		}
		$("#province").attr("disabled","disabled");
		$("#city").attr("disabled","disabled");
		$("#county").attr("disabled","disabled");
		$("#province").addClass("readonly");
		$("#city").addClass("readonly");
		$("#county").addClass("readonly");
	}
}
function cityPrivSettingForQuery(){
	if(userLevel=="0"){
		
	}else if(userLevel==1){//省级用户只能管理市级用户
		$("#province").val(userCityCode);
		getCity();
		$("#province").attr("disabled","disabled");
		$("#province").addClass("readonly")
	}else if(userLevel==2){//市级用户只能管理县级用户
		var json = getCityFullInfo(userCityCode);
		if(json){
			$("#province").val(json.provinceCode);
			getCity();
			$("#city").val(json.cityCode);
			getCounty();
		}
		$("#province").attr("disabled","disabled");
		$("#city").attr("disabled","disabled");
		$("#province").addClass("readonly")
		$("#city").addClass("readonly");
	}else if(userLevel==3){//县级用户没有用户管理模块，因此这里就不用判断了
		var json = getCityFullInfo(userCityCode);
		if(json){
			$("#province").val(json.provinceCode);
			getCity();
			$("#city").val(json.cityCode);
			getCounty();
			$("#county").val(json.countyCode);
		}
		$("#province").attr("disabled","disabled");
		$("#city").attr("disabled","disabled");
		$("#county").attr("disabled","disabled");
		$("#province").addClass("readonly");
		$("#city").addClass("readonly");
		$("#county").addClass("readonly");
	}
}