function total(type){
	 $("input[name=itemAvgHeightly"+type+"]").each(function(){
	 	$(this).validatebox();
		 $(this).on("keyup",function(){
			var index = $(this).parents("table:first").find("tr").length-2;
			var length =  $("input[name=itemAvgHeightly"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemAvgHeightly"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgHeightly"+type).text(parseFloat(total/index).toFixed(2));
			$("#herbGrassAvgHeight"+type).val(parseFloat(total/index).toFixed(2));			
		 });
		var index = $(this).parents("table:first").find("tr").length-2;
		var length =  $("input[name=itemAvgHeightly"+type+"]").length;
		var total = 0;
		for(var i=0;i<length;i++){
			var input  = $("input[name=itemAvgHeightly"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		}
		$("#avgHeightly"+type).text(parseFloat(total/index).toFixed(2));
		$("#herbGrassAvgHeight"+type).val(parseFloat(total/index).toFixed(2));
	 });
	 
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
			 $("#herbAvgFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			 
		 });
		 var index = $(this).parents("table:first").find("tr").length-2;
		 var length =  $("input[name=itemFreshAmount"+type+"]").length;
		 var total = 0;
		 for(var i=0;i<length;i++){
			 var input  = $("input[name=itemFreshAmount"+type+"]")[i];
			 total +=parseFloat(input.value==""?0:input.value);
		 }
		 $("#avgFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
		 $("#herbAvgFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
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
			$("#herbAvgEdibleFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
			var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
			$("#freshAmount"+type).val(freshAmount);
			$("#dryAmount"+type).val(dryAmount);
		 });
		var index = $(this).parents("table:first").find("tr").length-2;
		var length =  $("input[name=itemEdibleFreshAmount"+type+"]").length;
		var total = 0;
		for(var i=0;i<length;i++){
			var input  = $("input[name=itemEdibleFreshAmount"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		}
		$("#avgEdibleFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
		$("#herbAvgEdibleFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize").val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
		var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize").val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
		$("#freshAmount"+type).val(freshAmount);
		$("#dryAmount"+type).val(dryAmount);
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
			$("#herbAvgDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		 });
		 var index = $(this).parents("table:first").find("tr").length-2;
		 var length =  $("input[name=itemDryAmount"+type+"]").length;
		 var total = 0;
		 for(var i=0;i<length;i++){
			var input  = $("input[name=itemDryAmount"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		 }
		 $("#avgDryAmount"+type).text(parseFloat(total/index).toFixed(2));
		 $("#herbAvgDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
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
			$("#herbAvgEdibleDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
			var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
			$("#freshAmount"+type).val(freshAmount);
			$("#dryAmount"+type).val(dryAmount);
		 });
		var index = $(this).parents("table:first").find("tr").length-2;
		var length =  $("input[name=itemEdibleDryAmount"+type+"]").length;
		var total = 0;
		for(var i=0;i<length;i++){
			var input  = $("input[name=itemEdibleDryAmount"+type+"]")[i];
			total +=parseFloat(input.value==""?0:input.value);
		}
		$("#avgEdibleDryAmount"+type).text(parseFloat(total/index).toFixed(2));
		$("#herbAvgEdibleDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
		var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
		$("#freshAmount"+type).val(freshAmount);
		$("#dryAmount"+type).val(dryAmount);
	 });

	 $("input[name=itemPlantNums"+type+"]").each(function(){
	 	$(this).validatebox();
	 });
};

function addGrassAmount(event,type){
	var index = $(event).parents("table:first").find("tr").length-1;
	var template="	<tr>"
	+"<td class='TableData' align='center'>样方"+index+"</td>"
	+"<td class='TableData' align='center'><input type='text' name='itemPlantNums"+type+"' class='SmallInput easyui-validatebox' validType='positivIntege[]'/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemAvgHeightly"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[] & numberBetweenLength[0,80]'/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemEdibleFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] & addMethod[] & edibleFreshValid["+index+",'"+type+"']\"/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZeroln[] & addMethod[] & dryFreshValid["+index+",'"+type+"']\"/></td>"
	+"<td class='TableData' align='center'><input type='text' name='itemEdibleDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] & addMethod[] & edibleDryValid["+index+",'"+type+"'] & edible["+index+",'"+type+"']\"/></td>"
	+"<td class='TableData' align='center'>"
	+"	<input type='button' value='-' name='plusGrassAmount"+type+"' class='btn btn-success' style='background:#41a675;'/>"
	+"</td>"
	+"</tr>";	
	$("#grassAvgAmount"+type).before(template);
	total(type);
	plusGrassAmount(type);
}

function getItemList(itemList,type){
	for(var i = 1 ;i<itemList.length;i++){
		var index = i+1;
		var template="	<tr>"
		+"<td class='TableData' align='center'>样方"+index+"</td>"
		+"<td class='TableData' align='center'><input type='text' name='itemPlantNums"+type+"' class='SmallInput easyui-validatebox' validType='positivIntege[]'/></td>"
		+"<td class='TableData' align='center'><input type='text' name='itemAvgHeightly"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[] & numberBetweenLength[0,80]'/></td>"
		+"<td class='TableData' align='center'><input type='text' name='itemFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData' align='center'><input type='text' name='itemEdibleFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[] & edibleFreshValid["+index+",'"+type+"']\"/></td>"
		+"<td class='TableData' align='center'><input type='text' name='itemDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZeroln[] &addMethod[] & dryFreshValid["+index+",'"+type+"']\"/></td>"
		+"<td class='TableData' align='center'><input type='text' name='itemEdibleDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[] & edibleDryValid["+index+",'"+type+"'] & edible["+index+",'"+type+"']\"/></td>"
		+"<td class='TableData' align='center'>"
		+"	<input type='button' value='-' name='plusGrassAmount"+type+"' class='btn btn-success' style='background:#41a675;'/>"
		+"</td>"
		+"</tr>";
		$("#grassAvgAmount"+type).before(template);
	}
	for(var i = 0 ;i<itemList.length;i++){
		$($("input[name=itemPlantNums"+type+"]")[i]).val(itemList[i].plantNums);
		$($("input[name=itemAvgHeightly"+type+"]")[i]).val(itemList[i].avgHeight);
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
			var length =  $("input[name=itemAvgHeightly"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemAvgHeightly"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgHeightly"+type).text(parseFloat(total/index).toFixed(2));
			$("#herbGrassAvgHeight"+type).val(parseFloat(total/index).toFixed(2));
			
			var length =  $("input[name=itemFreshAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemFreshAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#herbAvgFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			
			
			var length =  $("input[name=itemEdibleFreshAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemEdibleFreshAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgEdibleFreshAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#herbAvgEdibleFreshAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			
			var length =  $("input[name=itemDryAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemDryAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgDryAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#herbAvgDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
			
			var length =  $("input[name=itemEdibleDryAmount"+type+"]").length;
			var total = 0;
			for(var i=0;i<length;i++){
				var input  = $("input[name=itemEdibleDryAmount"+type+"]")[i];
				total +=parseFloat(input.value==""?0:input.value);
			}
			$("#avgEdibleDryAmount"+type).text(parseFloat(total/index).toFixed(2));
			$("#herbAvgEdibleDryAmount"+type).val(parseFloat(total/index*10).toFixed(2));
		});
	});
}

/**
 * 100平方米样方内灌木及高大草本调查
 * @param event
 * @returns
 */

function addShrubsItem(event,type){
	var index = $(event).parents("table:first").find("tr").length-2;
	var template="<tr>"
				+"<td class='TableData'><input type='text' name='plantName"+type+"' class='BigInput '/></td>"
				+"<td class='TableData'><input type='text' name='largeRadius"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='largeFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='largeDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[] & edibleFreshValidLarge["+index+",'"+type+"']\"/></td>"
				+"<td class='TableData'><input type='text' name='largeNums"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='middleRadius"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='middleFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='middleDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[] & edibleFreshValidMid["+index+",'"+type+"']\"/></td>"
				+"<td class='TableData'><input type='text' name='middleNums"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='smallRadius"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='smallFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='smallDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] &addMethod[] & edibleFreshValidSmall["+index+",'"+type+"']\"/></td>"
				+"<td class='TableData'><input type='text' name='smallNums"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type='text' name='coverSize"+type+"' class='SmallInput easyui-validatebox readonly' readonly=\"readonly\" validType=''/></td>"
				+"<td class='TableData'><input type='text' name='convertFreshAmount"+type+"' class='SmallInput easyui-validatebox readonly' readonly=\"readonly\" validType=''/></td>"
				+"<td class='TableData'><input type='text' name='convertDryAmount"+type+"' class='SmallInput easyui-validatebox readonly' readonly=\"readonly\" validType=''/></td>"
				+"<td class='TableData'><input type='text' name='heightly"+type+"' class='SmallInput easyui-validatebox ' validType='integeZerollf[] & addMethod[]'/></td>"
				+"<td class='TableData'><input type=button name='plusShrubsItem"+type+"' class='btn btn-success' value='-' style='background:#41a675;'/></td>"
				+"</tr>";
	$("#shrubsItemAmount"+type).before(template);
	plusShrubsItem(type);
	autoCalculate(type);
}


function plusShrubsItem(type){
	$("input[name=plusShrubsItem"+type+"]").each(function(){
		$(this).one("click",function(){
			var index = $(this).parents("table:first").find("tr").length-3;
			if(index<1){
				return;
			}
			$(this).parents("tr:first").remove();
			autoCalculate(type);
		});
	});
}



function getShrubsItemList(itemList,type){
	for(var i = 1 ;i<itemList.length;i++){
		var index = i+1;
		var template="<tr>"
		+"<td class='TableData'><input type='text' name='plantName"+type+"' class='BigInput'/></td>"
		+"<td class='TableData'><input type='text' name='largeRadius"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='largeFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='largeDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] & addMethod[] & edibleFreshValidLarge["+index+",'"+type+"']\"/></td>"
		+"<td class='TableData'><input type='text' name='largeNums"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='middleRadius"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='middleFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='middleDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] & addMethod[] & edibleFreshValidMid["+index+",'"+type+"']\"/></td>"
		+"<td class='TableData'><input type='text' name='middleNums"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='smallRadius"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='smallFreshAmount"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='smallDryAmount"+type+"' class='SmallInput easyui-validatebox' validType=\"integeZerol[] & addMethod[] & edibleFreshValidSmall["+index+",'"+type+"']\"/></td>"
		+"<td class='TableData'><input type='text' name='smallNums"+type+"' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type='text' name='coverSize"+type+"' class='SmallInput easyui-validatebox readonly' readonly='readonly' validType=''/></td>"
		+"<td class='TableData'><input type='text' name='convertFreshAmount"+type+"' class='SmallInput easyui-validatebox readonly' readonly='readonly' validType=''/></td>"
		+"<td class='TableData'><input type='text' name='convertDryAmount"+type+"' class='SmallInput easyui-validatebox readonly' readonly='readonly' validType=''/></td>"
		+"<td class='TableData'><input type='text' name='heightly"+type+"' class='SmallInput easyui-validatebox' validType='integeZerollf[] & addMethod[]'/></td>"
		+"<td class='TableData'><input type=button name='plusShrubsItem"+type+"' class='btn btn-success' value='-' style='background:#41a675;'/></td>"
		+"</tr>";
		$("#shrubsItemAmount"+type).before(template);
	}
	for(var i = 0 ;i<itemList.length;i++){
		$($("input[name=plantName"+type+"]")[i]).val(itemList[i].plantName);
		$($("input[name=largeRadius"+type+"]")[i]).val(itemList[i].largeRadius);
		$($("input[name=largeFreshAmount"+type+"]")[i]).val(itemList[i].largeFreshAmount);
		$($("input[name=largeDryAmount"+type+"]")[i]).val(itemList[i].largeDryAmount);
		$($("input[name=largeNums"+type+"]")[i]).val(itemList[i].largeNums);
		$($("input[name=middleRadius"+type+"]")[i]).val(itemList[i].middleRadius);
		$($("input[name=middleFreshAmount"+type+"]")[i]).val(itemList[i].middleFreshAmount);
		$($("input[name=middleDryAmount"+type+"]")[i]).val(itemList[i].middleDryAmount);
		$($("input[name=middleNums"+type+"]")[i]).val(itemList[i].middleNums);
		$($("input[name=smallRadius"+type+"]")[i]).val(itemList[i].smallRadius);
		$($("input[name=smallFreshAmount"+type+"]")[i]).val(itemList[i].smallFreshAmount);
		$($("input[name=smallDryAmount"+type+"]")[i]).val(itemList[i].smallDryAmount);
		$($("input[name=smallNums"+type+"]")[i]).val(itemList[i].smallNums);
		$($("input[name=coverSize"+type+"]")[i]).val(itemList[i].coverSize);
		$($("input[name=convertFreshAmount"+type+"]")[i]).val(itemList[i].convertFreshAmount);
		$($("input[name=convertDryAmount"+type+"]")[i]).val(itemList[i].convertDryAmount);
		$($("input[name=heightly"+type+"]")[i]).val(itemList[i].heightly);
	}
	plusShrubsItem(type);
	autoCalculate(type);
}

/**
 *圆周率 ：Math.PI
 *Math.pow(m,n) m的n次方
 * @returns
 */

function autoCalculate(type){
	 $("input[name=largeRadius"+type+"],input[name=middleRadius"+type+"],input[name=smallRadius"+type+"],input[name=largeNums"+type+"],input[name=middleNums"+type+"],input[name=smallNums"+type+"]").each(function(){
		 $(this).validatebox();
		 $(this).on("keyup",function(){
			var coverSize = $($(this).parents("tr:first").find("input[name=coverSize"+type+"]")[0]);
			var largeRadius = $($(this).parents("tr:first").find("input[name=largeRadius"+type+"]")[0]);
			var middleRadius = $($(this).parents("tr:first").find("input[name=middleRadius"+type+"]")[0]);
			var smallRadius = $($(this).parents("tr:first").find("input[name=smallRadius"+type+"]")[0]);
			var largeNums = $($(this).parents("tr:first").find("input[name=largeNums"+type+"]")[0]);
			var middleNums = $($(this).parents("tr:first").find("input[name=middleNums"+type+"]")[0]);
			var smallNums = $($(this).parents("tr:first").find("input[name=smallNums"+type+"]")[0]);
			var coverSizeValue = parseFloat((
					Math.pow(parseFloat(largeRadius.val()==""?0:largeRadius.val())/2,2)*Math.PI*parseInt(largeNums.val()==""?0:largeNums.val())
					+Math.pow(parseFloat(middleRadius.val()==""?0:middleRadius.val())/2,2)*Math.PI*parseInt(middleNums.val()==""?0:middleNums.val())
					+Math.pow(parseFloat(smallRadius.val()==""?0:smallRadius.val())/2,2)*Math.PI*parseInt(smallNums.val()==""?0:smallNums.val())
					)/10000).toFixed(2);
			coverSize.val(coverSizeValue);
			//求和
			var total = 0;
			$("input[name="+$(this).attr("name")+"]").each(function(){
				total+=parseFloat($(this).val()==""?0:$(this).val());
			});
			$("#"+$(this).attr("name")+"Total").text(parseFloat(total).toFixed(2));
			
			var coverSizeTotal=0;
			$("input[name=coverSize"+type+"]").each(function(){
				coverSizeTotal+=parseFloat($(this).val()==""?0:$(this).val());
			});
			$("#coverSizeTotal"+type).text(parseFloat(coverSizeTotal).toFixed(2));
			$("#totalCoverSize"+type).val(parseFloat(coverSizeTotal).toFixed(2));
			
			var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
			var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
			$("#freshAmount"+type).val(freshAmount);
			$("#dryAmount"+type).val(dryAmount);
		 });
		var coverSize = $($(this).parents("tr:first").find("input[name=coverSize"+type+"]")[0]);
		var largeRadius = $($(this).parents("tr:first").find("input[name=largeRadius"+type+"]")[0]);
		var middleRadius = $($(this).parents("tr:first").find("input[name=middleRadius"+type+"]")[0]);
		var smallRadius = $($(this).parents("tr:first").find("input[name=smallRadius"+type+"]")[0]);
		var largeNums = $($(this).parents("tr:first").find("input[name=largeNums"+type+"]")[0]);
		var middleNums = $($(this).parents("tr:first").find("input[name=middleNums"+type+"]")[0]);
		var smallNums = $($(this).parents("tr:first").find("input[name=smallNums"+type+"]")[0]);
		var coverSizeValue = parseFloat((
				Math.pow(parseFloat(largeRadius.val()==""?0:largeRadius.val())/2,2)*Math.PI*parseInt(largeNums.val()==""?0:largeNums.val())
				+Math.pow(parseFloat(middleRadius.val()==""?0:middleRadius.val())/2,2)*Math.PI*parseInt(middleNums.val()==""?0:middleNums.val())
				+Math.pow(parseFloat(smallRadius.val()==""?0:smallRadius.val())/2,2)*Math.PI*parseInt(smallNums.val()==""?0:smallNums.val())
				)/10000).toFixed(2);
		coverSize.val(coverSizeValue);
		//求和
		var total = 0;
		$("input[name="+$(this).attr("name")+"]").each(function(){
			total+=parseFloat($(this).val()==""?0:$(this).val());
		});
		$("#"+$(this).attr("name")+"Total").text(parseFloat(total).toFixed(2));
		
		var coverSizeTotal=0;
		$("input[name=coverSize"+type+"]").each(function(){
			coverSizeTotal+=parseFloat($(this).val()==""?0:$(this).val());
		});
		$("#coverSizeTotal"+type).text(parseFloat(coverSizeTotal).toFixed(2));
		$("#totalCoverSize"+type).val(parseFloat(coverSizeTotal).toFixed(2));
		
		var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
		var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
		$("#freshAmount"+type).val(freshAmount);
		$("#dryAmount"+type).val(dryAmount);
	 });
	 $("input[name=largeNums"+type+"],input[name=middleNums"+type+"],input[name=smallNums"+type+"],input[name=largeDryAmount"+type+"],input[name=middleDryAmount"+type+"],input[name=smallDryAmount"+type+"],input[name=largeFreshAmount"+type+"],input[name=middleFreshAmount"+type+"],input[name=smallFreshAmount"+type+"]").each(function(){
		 $(this).validatebox();
		 $(this).on("keyup",function(){
			 var convertFreshAmount = $($(this).parents("tr:first").find("input[name=convertFreshAmount"+type+"]")[0]);
			 var convertDryAmount = $($(this).parents("tr:first").find("input[name=convertDryAmount"+type+"]")[0]);
			 var largeFreshAmount = $($(this).parents("tr:first").find("input[name=largeFreshAmount"+type+"]")[0]);
			 var largeDryAmount = $($(this).parents("tr:first").find("input[name=largeDryAmount"+type+"]")[0]);
			 var largeNums = $($(this).parents("tr:first").find("input[name=largeNums"+type+"]")[0]);
			 var middleFreshAmount = $($(this).parents("tr:first").find("input[name=middleFreshAmount"+type+"]")[0]);
			 var middleDryAmount = $($(this).parents("tr:first").find("input[name=middleDryAmount"+type+"]")[0]);
			 var middleNums = $($(this).parents("tr:first").find("input[name=middleNums"+type+"]")[0]);
			 var smallFreshAmount = $($(this).parents("tr:first").find("input[name=smallFreshAmount"+type+"]")[0]);
			 var smallDryAmount = $($(this).parents("tr:first").find("input[name=smallDryAmount"+type+"]")[0]);
			 var smallNums = $($(this).parents("tr:first").find("input[name=smallNums"+type+"]")[0]);
			 var convertFreshAmountValue = parseFloat(parseFloat(largeFreshAmount.val()==""?0:largeFreshAmount.val())*parseInt(largeNums.val()==""?0:largeNums.val())/10+parseFloat(middleFreshAmount.val()==""?0:middleFreshAmount.val())*parseInt(middleNums.val()==""?0:middleNums.val())/10+parseFloat(smallFreshAmount.val()==""?0:smallFreshAmount.val())*parseInt(smallNums.val()==""?0:smallNums.val())/10).toFixed(2);
			 convertFreshAmount.val(convertFreshAmountValue);
			 var convertDryAmountValue = parseFloat(parseFloat(largeDryAmount.val()==""?0:largeDryAmount.val())*parseInt(largeNums.val()==""?0:largeNums.val())/10+parseFloat(middleDryAmount.val()==""?0:middleDryAmount.val())*parseInt(middleNums.val()==""?0:middleNums.val())/10+parseFloat(smallDryAmount.val()==""?0:smallDryAmount.val())*parseInt(smallNums.val()==""?0:smallNums.val())/10).toFixed(2);
			 convertDryAmount.val(convertDryAmountValue);
			//求和
			var total = 0;
			$("input[name="+$(this).attr("name")+"]").each(function(){
				total+=parseFloat($(this).val()==""?0:$(this).val());
			});
			$("#"+$(this).attr("name")+"Total").text(parseFloat(total).toFixed(2));
			
			var convertFreshAmountTotal=0;
			$("input[name=convertFreshAmount"+type+"]").each(function(){
				convertFreshAmountTotal+=parseFloat($(this).val()==""?0:$(this).val());
			});
			$("#convertFreshAmountTotal"+type).text(parseFloat(convertFreshAmountTotal).toFixed(2));
			$("#shrubsAvgFreshAmount"+type).val(parseFloat(convertFreshAmountTotal).toFixed(2));
			
			var convertDryAmountTotal=0;
			$("input[name=convertDryAmount"+type+"]").each(function(){
				convertDryAmountTotal+=parseFloat($(this).val()==""?0:$(this).val());
			});
			$("#convertDryAmountTotal"+type).text(parseFloat(convertDryAmountTotal).toFixed(2));
			$("#shrubsAvgDryAmount"+type).val(parseFloat(convertDryAmountTotal).toFixed(2));
			
			var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
			var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
			$("#freshAmount"+type).val(freshAmount);
			$("#dryAmount"+type).val(dryAmount);
		 });
		 var convertFreshAmount = $($(this).parents("tr:first").find("input[name=convertFreshAmount"+type+"]")[0]);
		 var convertDryAmount = $($(this).parents("tr:first").find("input[name=convertDryAmount"+type+"]")[0]);
		 var largeFreshAmount = $($(this).parents("tr:first").find("input[name=largeFreshAmount"+type+"]")[0]);
		 var largeDryAmount = $($(this).parents("tr:first").find("input[name=largeDryAmount"+type+"]")[0]);
		 var largeNums = $($(this).parents("tr:first").find("input[name=largeNums"+type+"]")[0]);
		 var middleFreshAmount = $($(this).parents("tr:first").find("input[name=middleFreshAmount"+type+"]")[0]);
		 var middleDryAmount = $($(this).parents("tr:first").find("input[name=middleDryAmount"+type+"]")[0]);
		 var middleNums = $($(this).parents("tr:first").find("input[name=middleNums"+type+"]")[0]);
		 var smallFreshAmount = $($(this).parents("tr:first").find("input[name=smallFreshAmount"+type+"]")[0]);
		 var smallDryAmount = $($(this).parents("tr:first").find("input[name=smallDryAmount"+type+"]")[0]);
		 var smallNums = $($(this).parents("tr:first").find("input[name=smallNums"+type+"]")[0]);
		 var convertFreshAmountValue = parseFloat(parseFloat(largeFreshAmount.val()==""?0:largeFreshAmount.val())*parseInt(largeNums.val()==""?0:largeNums.val())/10+parseFloat(middleFreshAmount.val()==""?0:middleFreshAmount.val())*parseInt(middleNums.val()==""?0:middleNums.val())/10+parseFloat(smallFreshAmount.val()==""?0:smallFreshAmount.val())*parseInt(smallNums.val()==""?0:smallNums.val())/10).toFixed(2);
		 convertFreshAmount.val(convertFreshAmountValue);
		 var convertDryAmountValue = parseFloat(parseFloat(largeDryAmount.val()==""?0:largeDryAmount.val())*parseInt(largeNums.val()==""?0:largeNums.val())/10+parseFloat(middleDryAmount.val()==""?0:middleDryAmount.val())*parseInt(middleNums.val()==""?0:middleNums.val())/10+parseFloat(smallDryAmount.val()==""?0:smallDryAmount.val())*parseInt(smallNums.val()==""?0:smallNums.val())/10).toFixed(2);
		 convertDryAmount.val(convertDryAmountValue);
		//求和
		var total = 0;
		$("input[name="+$(this).attr("name")+"]").each(function(){
			total+=parseFloat($(this).val()==""?0:$(this).val());
		});
		$("#"+$(this).attr("name")+"Total").text(parseFloat(total).toFixed(2));
		
		var convertFreshAmountTotal=0;
		$("input[name=convertFreshAmount"+type+"]").each(function(){
			convertFreshAmountTotal+=parseFloat($(this).val()==""?0:$(this).val());
		});
		$("#convertFreshAmountTotal"+type).text(parseFloat(convertFreshAmountTotal).toFixed(2));
		$("#shrubsAvgFreshAmount"+type).val(parseFloat(convertFreshAmountTotal).toFixed(2));
		
		var convertDryAmountTotal=0;
		$("input[name=convertDryAmount"+type+"]").each(function(){
			convertDryAmountTotal+=parseFloat($(this).val()==""?0:$(this).val());
		});
		$("#convertDryAmountTotal"+type).text(parseFloat(convertDryAmountTotal).toFixed(2));
		$("#shrubsAvgDryAmount"+type).val(parseFloat(convertDryAmountTotal).toFixed(2));
		
		var freshAmount =parseFloat(parseFloat($("#herbAvgFreshAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgFreshAmount"+type).val())).toFixed(2);
		var dryAmount =parseFloat(parseFloat($("#herbAvgDryAmount"+type).val())*(100-parseFloat($("#totalCoverSize"+type).val()))/100+parseFloat($("#shrubsAvgDryAmount"+type).val())).toFixed(2);
		$("#freshAmount"+type).val(freshAmount);
		$("#dryAmount"+type).val(dryAmount);
		
		
		
	 });
	 $("input[name=heightly"+type+"]").each(function(){
		 $(this).validatebox();
		 $(this).on("keyup",function(){
			var total = 0;
			$("input[name=heightly"+type+"]").each(function(){
				total +=parseFloat($(this).val()==""?0:$(this).val());
			});
			var len = $("input[name=heightly"+type+"]").length;
			$("#avgShrubsHeightly"+type).text(parseFloat(total/len).toFixed(2));
			$("#shrubsGrassAvgHeight"+type).val(parseFloat(total/len).toFixed(2));
		 });
		 var total = 0;
		$("input[name=heightly"+type+"]").each(function(){
			total +=parseFloat($(this).val()==""?0:$(this).val());
		});
		var len = $("input[name=heightly"+type+"]").length;
		$("#avgShrubsHeightly"+type).text(parseFloat(total/len).toFixed(2));
		$("#shrubsGrassAvgHeight"+type).val(parseFloat(total/len).toFixed(2));
		
	 });
}



function getQuadratNumber(type){
	var url = contextPath+"/gmsShrubsQuadratController/getQuadratNumber.act?sampleAreaId="+sampleAreaId;
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



$.extend($.fn.validatebox.defaults.rules, {   
	edibleFreshValid: {   //风干重应该小于鲜重
		validator: function(value, param){
			var index = param[0];
			var freshAmount = $($($("#itemTableHerb"+param[1]+" tr")[index]).find("input[name=itemFreshAmount"+param[1]+"]")[0]).val();
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
			var freshAmount = $($($("#itemTableHerb"+param[1]+" tr")[index]).find("input[name=itemFreshAmount"+param[1]+"]")[0]).val();
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
			var dryAmount = $($($("#itemTableHerb"+param[1]+" tr")[index]).find("input[name=itemDryAmount"+param[1]+"]")[0]).val();
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
			var edibleFreshAmount = $($($("#itemTableHerb"+param[1]+" tr")[index]).find("input[name=itemEdibleFreshAmount"+param[1]+"]")[0]).val();
			if(value!="" && edibleFreshAmount!="" && parseFloat(value) >= parseFloat(edibleFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食产草量风干重应小于可食产草量鲜重！'
	},

	edibleFreshValidLarge: {   //鲜重与鲜重比较
		validator: function(value, param){
			var index = param[0]+1;
			var freshAmount = $($($("#itemTableShrubs"+param[1]+" tr")[index]).find("input[name=largeFreshAmount"+param[1]+"]")[0]).val();
			if(value!="" && freshAmount!="" && parseFloat(value) >= parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '风干重应小于鲜重！'
	},
	edibleFreshValidMid: {   //风干重应该小于鲜重
		validator: function(value, param){
			var index = param[0]+1;
			var freshAmount = $($($("#itemTableShrubs"+param[1]+" tr")[index]).find("input[name=middleFreshAmount"+param[1]+"]")[0]).val();
			if(value!="" && freshAmount!="" && parseFloat(value) >=parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '风干重应小于鲜重！'
	},
	edibleFreshValidSmall: {   //风干重应该小于鲜重
		validator: function(value, param){
			var index = param[0]+1;
			var freshAmount = $($($("#itemTableShrubs"+param[1]+" tr")[index]).find("input[name=smallFreshAmount"+param[1]+"]")[0]).val();
			if(value!="" && freshAmount!="" && parseFloat(value) >= parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '风干重应小于鲜重！'
	}
});




