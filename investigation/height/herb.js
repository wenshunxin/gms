function total(type){
	 $("input[name=itemFreshAmount"+type+"]").each(function(){
		 $(this).validatebox();
		 $(this).on("keyup",function(){
			var index = $(this).parents("table:first").find("tr").length-2;
			var length =  $("input[name=itemFreshAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemFreshAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#freshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			
		 });
		 var index = $(this).parents("table:first").find("tr").length-2;
		 var length =  $("input[name=itemFreshAmount"+type+"]").length;
		 var total = 0;
		 for(var i=0;i<length;i++){
			var input  = $("input[name=itemFreshAmount"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		 }
		 $("#avgFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
		 $("#freshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
	 });
	 $("input[name=itemEdibleFreshAmount"+type+"]").each(function(){
		 $(this).validatebox();
		 $(this).on("keyup",function(){
			var index = $(this).parents("table:first").find("tr").length-2;
			var length =  $("input[name=itemEdibleFreshAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemEdibleFreshAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgEdibleFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#edibleFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		 });
		var index = $(this).parents("table:first").find("tr").length-2;
		var length =  $("input[name=itemEdibleFreshAmount"+type+"]").length;
		var total = 0;
		for(var i=0;i<length;i++){
			var input  = $("input[name=itemEdibleFreshAmount"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		}
		$("#avgEdibleFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
		$("#edibleFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
	 });
	 $("input[name=itemDryAmount"+type+"]").each(function(){
		 $(this).validatebox();
		 $(this).on("keyup",function(){
			var index = $(this).parents("table:first").find("tr").length-2;
			var length =  $("input[name=itemDryAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemDryAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgDryAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#dryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		 });
		var index = $(this).parents("table:first").find("tr").length-2;
		var length =  $("input[name=itemDryAmount"+type+"]").length;
		var total = 0;
		for(var i=0;i<length;i++){
			var input  = $("input[name=itemDryAmount"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		}
		$("#avgDryAmount"+type).text(parseFloat(total/index).toFixed(2));
		$("#dryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
	 });
	 $("input[name=itemEdibleDryAmount"+type+"]").each(function(){
		 $(this).validatebox();
		 $(this).on("keyup",function(){
			var index = $(this).parents("table:first").find("tr").length-2;
			var length =  $("input[name=itemEdibleDryAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemEdibleDryAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgEdibleDryAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#edibleDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		 });
		 var index = $(this).parents("table:first").find("tr").length-2;
		var length =  $("input[name=itemEdibleDryAmount"+type+"]").length;
		var total = 0;
		for(var i=0;i<length;i++){
			var input  = $("input[name=itemEdibleDryAmount"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		}
		$("#avgEdibleDryAmount"+type).text(parseFloat(total/index).toFixed(2));
		$("#edibleDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
	 });
}

function addGrassAmount(event,type){
	var index = $(event).parents("table:first").find("tr").length-1;
	var template="	<tr>"
	+"<td class='TableData' align='center'>"+index+"</td>"
	+"<td class='TableData' align='center'><input type='text' name='itemFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] &addMethod[]'/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemEdibleFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[]  & edibleFreshValid["+index+",'"+type+"']\"/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZeroln[] &addMethod[] & dryFreshValid["+index+",'"+type+"']\"/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemEdibleDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[]  & edibleDryValid["+index+",'"+type+"'] & edible["+index+",'"+type+"']\"/></td>"
	+"<td class='TableData' align='center'>"
	+"	<input type='button' value='-' name='plusGrassAmount"+type+"' class='btn btn-success' style='background:#41a675;'/>"
	+"</td>"
	+"</tr>";
	
	$("#grassAvgAmount"+type).before(template);
	total(type);
	plusGrassAmount(type);
}

function getItemList(itemList,type){
	for(var i = 0 ;i<itemList.length-1;i++){
		var index = i+2;
		var template="	<tr>"
			+"<td class='TableData' align='center'>"+index+"</td>"
			+"<td class='TableData' align='center'><input type='text' name='itemFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] &addMethod[]'/></td>"
			+"<td class='TableData' align='center'><input type='text' name='itemEdibleFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[]  & edibleFreshValid["+index+",'"+type+"']\"/></td>"
			+"<td class='TableData' align='center'><input type='text' name='itemDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZeroln[] &addMethod[] & dryFreshValid["+index+",'"+type+"']\"/></td>"
			+"<td class='TableData' align='center'><input type='text' name='itemEdibleDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[]  & edibleDryValid["+index+",'"+type+"'] & edible["+index+",'"+type+"']\"/></td>"
			+"<td class='TableData' align='center'>"
			+"	<input type='button' value='-' name='plusGrassAmount"+type+"' class='btn btn-success' style='background:#41a675;'/>"
			+"</td>"
			+"</tr>";
		$("#grassAvgAmount"+type).before(template);
	}
	for(var i = 0 ;i<itemList.length;i++){
		$($("input[name=itemFreshAmount"+type+"]")[i]).val(itemList[i].freshAmount);
		$($("input[name=itemEdibleFreshAmount"+type+"]")[i]).val(itemList[i].edibleFreshAmount);
		$($("input[name=itemDryAmount"+type+"]")[i]).val(itemList[i].dryAmount);
		$($("input[name=itemEdibleDryAmount"+type+"]")[i]).val(itemList[i].edibleDryAmount);
	}
	total(type);
	plusGrassAmount(type);
}





function plusGrassAmount(type){
	$("input[name=plusGrassAmount"+type+"]").each(function(){
		$(this).one("click",function(){
			var index = $(this).parents("table:first").find("tr").length-3;
			if(index<1){
				return;
			}
			$(this).parents("tr:first").remove();
			var length =  $("input[name=itemFreshAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemFreshAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#freshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			
			
			var length =  $("input[name=itemEdibleFreshAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemEdibleFreshAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgEdibleFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#edibleFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			
			var length =  $("input[name=itemDryAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemDryAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgDryAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#dryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			
			var length =  $("input[name=itemEdibleDryAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemEdibleDryAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgEdibleDryAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#edibleDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		});
	});
}


function getQuadratNumber(type){
	var url = contextPath+"/gmsHerbQuadratController/getQuadratNumber.act?sampleAreaId="+sampleAreaId;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var quadratNumber = json.rtData;
		var strs = quadratNumber.split("-");
		var preNumber = "";
		var curNumber = strs[strs.length-1];
		for(var i = 0 ;i<strs.length-1;i++){
			preNumber +=strs[i]+"-";
		}
		if(type==0){//工程
			$("#preNumberIn").text(preNumber);
			$("#curNumberIn").val(curNumber);
			$("#quadratNumberIn").val(quadratNumber);
			$("#preNumberOut").text(preNumber);
			$("#curNumberOut").val(curNumber);
			$("#quadratNumberOut").val(quadratNumber);
		}else if(type==1){//非工程
			$("#preNumber").text(preNumber);
			$("#curNumber").val(curNumber);
			$("#quadratNumber").val(quadratNumber);
		}
	}
}

/**
 * 数据校验	
 * 
 */
$.extend($.fn.validatebox.defaults.rules, {   
	edibleFreshValid: {   //可食鲜重与鲜重比较
		validator: function(value, param){
			var index = param[0];
			var freshAmount = $($($("#itemTable"+param[1]+" tr")[index]).find("input[name=itemFreshAmount"+param[1]+"]")[0]).val();
			if(value!="" && freshAmount!="" && parseFloat(value) > parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '可食产草量鲜重应小于等于产草量鲜重！'
	} ,
	dryFreshValid: {   //干重与鲜重比较
		validator: function(value, param){
			var index = param[0];
			var freshAmount = $($($("#itemTable"+param[1]+" tr")[index]).find("input[name=itemFreshAmount"+param[1]+"]")[0]).val();
			if(value!="" && freshAmount!="" && parseFloat(value) >= parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '产草量风干重应小于草产量鲜重！'
	} ,
	edibleDryValid: {   //可食干重与干重比较
		validator: function(value, param){
			var index = param[0];
			var dryAmount = $($($("#itemTable"+param[1]+" tr")[index]).find("input[name=itemDryAmount"+param[1]+"]")[0]).val();
			if(value!="" && dryAmount!="" && parseFloat(value) > parseFloat(dryAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食产草量风干重应小于等于产草量风干重！'
	} ,
	edible: {   //可食干重与可食鲜重比较
		validator: function(value, param){
			var index = param[0];
			var edibleFreshAmount = $($($("#itemTable"+param[1]+" tr")[index]).find("input[name=itemEdibleFreshAmount"+param[1]+"]")[0]).val();
			if(value!="" && edibleFreshAmount!="" && parseFloat(value) >= parseFloat(edibleFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食产草量风干重应小于可食产草量鲜重！'
	} 
});
