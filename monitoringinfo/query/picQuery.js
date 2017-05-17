function doReset(){
	document.getElementById("form1").reset(); 
	getProvince();
	cityPrivSettingForQuery();
}



function queryPic(){
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
	 var queryType = $("input[name=queryType]:checked").val();
	 var param=tools.formToJson($("#form1"));
	 $("#queryResult").empty();
	 if(queryType==0){
		 var url = contextPath+"/gsoaController/queryPic.act";
		 var json = tools.requestJsonRs(url,param);
		 if(json.rtState){
			 var startYear = $("#startYear").val();
			 var endYear = $("#endYear").val();
			 var flag = false;
			 for(var i= 0;i<=endYear-startYear;i++){
				 var year = parseInt(startYear)+i;
				 var data = json.rtData["pic"+year];
				 if(data.length>0){
					 flag = true;
					 for(var m=0;m<data.length;m++){
						 var attach = data[m];
						 var investigateDate="";
						 if(attach.investigateDate1){
							 investigateDate = attach.investigateDate1;
						 }else{
							 investigateDate = attach.investigateDate2;
						 }
						 var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
						 var downloadUrl = encodeURI(contextPath+"/attachController/download.act?attachPath="+attach.attachPath);
						 var html = "<div class='attachContainorDiv' style='margin-left:20px;float:left;width:300px;'>"
							 +"<img class='preview' src='"+encodeURI(attachUrl)+"' onclick='getImg_W_H.call(this)'/>"
							 +"<label>"+investigateDate+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='"+encodeURI(downloadUrl)+"'>下载</a></label>"
							 +"</div>";
						 $("#queryResult").append(html);
					 }
				 }
			 }
			 if(!flag){
				 messageMsg("没有找到相关图片信息！","queryResult","warning");
			 }
		 }else{
			 messageMsg(json.rtMsg,"queryResult","warning");
		 }
	 }else if(queryType==1){
		 var url = contextPath+"/gsoaController/queryPic.act";
		 var json = tools.requestJsonRs(url,param);
		 if(json.rtState){
			 var startYear = $("#startYear").val();
			 var endYear = $("#endYear").val();
			 var flag = false;
			 for(var i= 0;i<=endYear-startYear;i++){
				 var year = parseInt(startYear)+i;
				 var cgData = json.rtData["cgPic"+year];
				 var cgDiv="<div id='cgDiv' style='width:50%;float:left;text-align:center;'>"
					 +"<label style='display:block;width:100%;text-align:center;font-weight:bolder;height:40px;line-height:40px;'>常规观测区照片</label></div>";
				 $("#queryResult").append(cgDiv);
				 if(cgData.length>0){
					 flag = true;
					 for(var m=0;m<cgData.length;m++){
						 var attach = cgData[m];
						 var investigateDate="";
						 if(attach.investigateDate1){
							 investigateDate = attach.investigateDate1;
						 }else{
							 investigateDate = attach.investigateDate2;
						 }
						 var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
						 var downloadUrl = encodeURI(contextPath+"/attachController/download.act?attachPath="+attach.attachPath);
						 var html = "<div class='attachContainorDiv' style='margin-left:20px;float:left;width:100%;'>"
							 +"<img class='preview' src='"+encodeURI(attachUrl)+"' onclick='getImg_W_H.call(this)'/>"
							 +"<label>"+investigateDate+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='"+encodeURI(downloadUrl)+"'>下载</a></label>"
							 +"</div>";
						 $("#cgDiv").append(html);
					 }
				 }
				 var fzData = json.rtData["fzPic"+year];
				 var fzDiv="<div id='fzDiv' style='width:50%;float:left;text-align:center;'>"
					 +"<label style='display:block;width:100%;text-align:center;font-weight:bolder;;height:40px;line-height:40px;'>辅助观测区照片</label></div>";
				 $("#queryResult").append(fzDiv);
				 if(fzData.length>0){
					 flag = true;
					 for(var m=0;m<fzData.length;m++){
						 var attach = fzData[m];
						 var investigateDate="";
						 if(attach.investigateDate1){
							 investigateDate = attach.investigateDate1;
						 }else{
							 investigateDate = attach.investigateDate2;
						 }
						 var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
						 var downloadUrl = encodeURI(contextPath+"/attachController/download.act?attachPath="+attach.attachPath);
						 var html = "<div class='attachContainorDiv' style='margin-left:20px;float:left;width:100%;'>"
							 +"<img class='preview' src='"+encodeURI(attachUrl)+"' onclick='getImg_W_H.call(this)'/>"
							 +"<label>"+investigateDate+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='"+encodeURI(downloadUrl)+"'>下载</a></label>"
							 +"</div>";
						 $("#fzDiv").append(html);
					 }
				 }
			 }
			 if(!flag){
				 messageMsg("没有找到相关图片信息！","queryResult","warning");
			 }
		 }else{
			 messageMsg(json.rtMsg,"queryResult","warning");
		 }
	 }
	 
}


function getMonitoringStations(){
	var monitoringStationsId = document.getElementById('monitoringStationsId');
	monitoringStationsId.length = 0;
	var cityCode = $("#cityCode").val();
	if(cityCode=="000000"){
		return;
	}
	var url = contextPath+"/monitoringStationsController/getMonitoringStationsDatagrid.act?cityCode="+cityCode;
	var json = tools.requestJsonRs(url);
	if(json.total>0){
		for(var i=0;i<json.rows.length;i++){
			html="<option value='"+json.rows[i].sid+"'>"+json.rows[i].stationsNum+"</option>";
			$("#monitoringStationsId").append(html);
		}
	}
 }