<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<script type="text/javascript" src="<%=contextPath%>//investigation/common/detail.js"></script>
</head>
<script>
var id = '<%=id%>';
function getShrubsQuadratById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsShrubsQuadratController/getShrubsQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			var itemList= json.rtData.herbItemList;
			var shrubsItemList = json.rtData.shrubsItemList;
			getItemList(itemList,"");
			getShrubsItemList(shrubsItemList,"");
			//审核记录
			var dataId = json.rtData.basicInfo.investigateDataId;
			var saId = json.rtData.basicInfo.sampleAreaId;
			queryAuditRecords(dataId,saId,id);
			//附件信息
			var attachList = json.rtData.attachList;
			for(var i = 0 ;i<attachList.length;i++){
				var attach = attachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainor .preview").attr("src",encodeURI(attachUrl));
			}
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}


function getItemList(itemList,type){
	for(var i = 0 ;i<itemList.length;i++){
		var plantNums = itemList[i].plantNums==null?"":itemList[i].plantNums;
		var avgHeight = itemList[i].avgHeight==null?"":itemList[i].avgHeight;
		var freshAmount = itemList[i].freshAmount==null?"":itemList[i].freshAmount;
		var edibleFreshAmount = itemList[i].edibleFreshAmount==null?"":itemList[i].edibleFreshAmount;
		var dryAmount = itemList[i].dryAmount==null?"":itemList[i].dryAmount;
		var edibleDryAmount = itemList[i].edibleDryAmount==null?"":itemList[i].edibleDryAmount;
		var template="	<tr>"
		+"<td class='TableData' align='center'>样方"+(i+1)+"</td>"
		+"<td class='TableData' align='center'><span id='itemPlantNums"+type+"' >"+plantNums+"</span></td>"
		+"<td class='TableData' align='center'><span id='itemAvgHeightly"+type+"'  >"+avgHeight+"</span></td>"
		+"<td class='TableData' align='center'><span id='itemFreshAmount"+type+"'  >"+freshAmount+"</span></td>"
		+"<td class='TableData' align='center'><span id='itemEdibleFreshAmount"+type+"'  >"+edibleFreshAmount+"</span></td>"
		+"<td class='TableData' align='center'><span id='itemDryAmount"+type+"'  >"+dryAmount+"</span></td>"
		+"<td class='TableData' align='center'><span id='itemEdibleDryAmount"+type+"'  >"+edibleDryAmount+"</span></td>"
		+"</tr>";
		$("#grassAvgAmount"+type).before(template);
	}
	var avgFreshAmount = parseFloat($("#herbAvgFreshAmount"+type).text()/10).toFixed(2);
	var avgEdibleFreshAmount = parseFloat($("#herbAvgEdibleFreshAmount"+type).text()/10).toFixed(2);
	var avgDryAmount = parseFloat($("#herbAvgDryAmount"+type).text()/10).toFixed(2);
	var avgEdibleDryAmount = parseFloat($("#herbAvgEdibleDryAmount"+type).text()/10).toFixed(2);
	$("#avgFreshAmount"+type).text(avgFreshAmount);
	$("#avgEdibleFreshAmount"+type).text(avgEdibleFreshAmount);
	$("#avgDryAmount"+type).text(avgDryAmount);
	$("#avgEdibleDryAmount"+type).text(avgEdibleDryAmount);
	$("#avgHeightly"+type).text(parseFloat($("#herbGrassAvgHeight").text()).toFixed(2));
}


function getShrubsItemList(itemList,type){
	for(var i = 0 ;i<itemList.length;i++){
		var plantName = itemList[i].plantName==null?"":itemList[i].plantName;
		var largeRadius = itemList[i].largeRadius==null?"":itemList[i].largeRadius;
		var largeFreshAmount = itemList[i].largeFreshAmount==null?"":itemList[i].largeFreshAmount;
		var largeDryAmount = itemList[i].largeDryAmount==null?"":itemList[i].largeDryAmount;
		var largeNums = itemList[i].largeNums==null?"":itemList[i].largeNums;
		var middleRadius = itemList[i].middleRadius==null?"":itemList[i].middleRadius;
		var middleFreshAmount = itemList[i].middleFreshAmount==null?"":itemList[i].middleFreshAmount;
		var middleDryAmount = itemList[i].middleDryAmount==null?"":itemList[i].middleDryAmount;
		var middleNums = itemList[i].middleNums==null?"":itemList[i].middleNums;
		var smallRadius = itemList[i].smallRadius==null?"":itemList[i].smallRadius;
		var smallFreshAmount = itemList[i].smallFreshAmount==null?"":itemList[i].smallFreshAmount;
		var smallDryAmount = itemList[i].smallDryAmount==null?"":itemList[i].smallDryAmount;
		var smallNums = itemList[i].smallNums==null?"":itemList[i].smallNums;
		var coverSize = itemList[i].coverSize==null?"":itemList[i].coverSize;
		var convertFreshAmount = itemList[i].convertFreshAmount==null?"":itemList[i].convertFreshAmount;
		var convertDryAmount = itemList[i].convertDryAmount==null?"":itemList[i].convertDryAmount;
		var convertDryAmount = itemList[i].convertDryAmount==null?"":itemList[i].convertDryAmount;
		var heightly = itemList[i].heightly==null?"":itemList[i].heightly;
		var template="<tr>"
			+"<td class='TableData'><span name='plantName"+type+"' >"+plantName+"</span></td>"
			+"<td class='TableData'><span name='largeRadius"+type+"' >"+largeRadius+"</span></td>"
			+"<td class='TableData'><span name='largeFreshAmount"+type+"' >"+largeFreshAmount+"</span></td>"
			+"<td class='TableData'><span name='largeDryAmount"+type+"' >"+largeDryAmount+"</span></td>"
			+"<td class='TableData'><span name='largeNums"+type+"' >"+largeNums+"</span></td>"
			+"<td class='TableData'><span name='middleRadius"+type+"' >"+middleRadius+"</span></td>"
			+"<td class='TableData'><span name='middleFreshAmount"+type+"' >"+middleFreshAmount+"</span></td>"
			+"<td class='TableData'><span name='middleDryAmount"+type+"' >"+middleDryAmount+"</span></td>"
			+"<td class='TableData'><span name='middleNums"+type+"' >"+middleNums+"</span></td>"
			+"<td class='TableData'><span name='smallRadius"+type+"' >"+smallRadius+"</span></td>"
			+"<td class='TableData'><span name='smallFreshAmount"+type+"' >"+smallFreshAmount+"</span></td>"
			+"<td class='TableData'><span name='smallDryAmount"+type+"' >"+smallDryAmount+"</span></td>"
			+"<td class='TableData'><span name='smallNums"+type+"' >"+smallNums+"</span></td>"
			+"<td class='TableData'><span name='coverSize"+type+"' >"+coverSize+"</span></td>"
			+"<td class='TableData'><span name='convertFreshAmount"+type+"' >"+convertFreshAmount+"</span></td>"
			+"<td class='TableData'><span name='convertDryAmount"+type+"' >"+convertDryAmount+"</span></td>"
			+"<td class='TableData'><span name='heightly"+type+"' >"+heightly+"</span></td>"
			+"</tr>";
		$("#shrubsItemAmount"+type).before(template);
	}
	 $("span[name=largeRadius"+type+"],span[name=middleRadius"+type+"],span[name=smallRadius"+type+"]").each(function(){
		var total = 0;
		$("span[name="+$(this).attr("name")+"]").each(function(){
			total+=parseFloat($(this).text()==""?0:$(this).text());
		});
		$("#"+$(this).attr("name")+"Total").text(parseFloat(total).toFixed(2));
	});
	 $("span[name=largeNums"+type+"],span[name=middleNums"+type+"],span[name=smallNums"+type+"],span[name=largeDryAmount"+type+"],span[name=middleDryAmount"+type+"],span[name=smallDryAmount"+type+"],span[name=largeFreshAmount"+type+"],span[name=middleFreshAmount"+type+"],span[name=smallFreshAmount"+type+"]").each(function(){
		 var total = 0;
		$("span[name="+$(this).attr("name")+"]").each(function(){
			total+=parseFloat($(this).text()==""?0:$(this).text());
		});
		$("#"+$(this).attr("name")+"Total").text(parseFloat(total).toFixed(2));
	 });
	 var coverSizeTotal = parseFloat($("#totalCoverSize"+type).text()).toFixed(2);
	 var convertFreshAmountTotal = parseFloat($("#shrubsAvgFreshAmount"+type).text()).toFixed(2);
	 var convertDryAmountTotal = parseFloat($("#shrubsAvgDryAmount"+type).text()).toFixed(2);
	 var avgShrubsHeightly = parseFloat($("#shrubsGrassAvgHeight"+type).text()).toFixed(2);
	 $("#coverSizeTotal"+type).text(coverSizeTotal);
	 $("#convertFreshAmountTotal"+type).text(convertFreshAmountTotal);
	 $("#convertDryAmountTotal"+type).text(convertDryAmountTotal);
	 $("#avgShrubsHeightly"+type).text(avgShrubsHeightly);
}
</script>
<body style="overflow-x: hidden; font-size: 12px;" onload="getShrubsQuadratById();">
	<table id="auditRecords" class="TableBlock" style='width:96.3%;margin:0 auto;margin-bottom:10px;'>
		<tr>
			<td class="TableHeader" colspan='5' style="text-align:left;">审核记录</td>
		</tr>
		<tr>
			<td class="TableData" align="center" width="10%">审核人</td>
			<td class="TableData" align="center" width="10%">审核单位</td>
			<td class="TableData" align="center" width="10%">审核结果</td>
			<td class="TableData" align="center">审核意见</td>
			<td class="TableData" align="center" width="15%">审核时间</td>
		</tr>
	</table>
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><span id='investigateDate'
					name='investigateDate'></span></td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><span id='investigateUserNames'
					name='investigateUserNames'></span></td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><span id='longitude' name='longitude'></span>度</td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><span id='latitude' name='latitude'></span>度</td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData'><span id='quadratNumber'
					name='quadratNumber'></span></td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><span id='altitude' name='altitude'></span>米</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内草本及矮小灌木测定</td>
			</tr>
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">1平方米草本及矮小灌木小样方</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<table class="TableBlock" width="100%">
						<tr>
							<td class="TableData" align='center'>编号</td>
							<td class="TableData" align='center'>植物种数</td>
							<td class="TableData" align='center'>平均高度(cm)</td>
							<td class="TableData" align='center'>鲜重(g/㎡)</td>
							<td class="TableData" align='center'>可食鲜重(g/㎡)</td>
							<td class="TableData" align='center'>干重(g/㎡)</td>
							<td class="TableData" align='center'>可食干重(g/㎡)</td>
						</tr>
						<tr id="grassAvgAmount">
							<td class="TableHeader">平均</td>
							<td class="TableData"><span id='avgPlantNums'></span></td>
							<td class="TableData"><span id='avgHeightly'></span></td>
							<td class="TableData"><span id='avgFreshAmount'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmount'></span></td>
							<td class="TableData"><span id='avgDryAmount'></span></td>
							<td class="TableData"><span id='avgEdibleDryAmount'></span></td>
						</tr>
					</table>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData dividingLine'><span id='herbPlantNums'
					name='herbPlantNums'></span></td>
				<td class='TableData'>平均高度：</td>
				<td class='TableData dividingLine'><span
					id='herbGrassAvgHeight' name='herbGrassAvgHeight'></span>厘米</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData dividingLine' colspan="3"><span id='herbMainPlant'
					name='herbMainPlant'></span></td>
			</tr>
			<tr>
				<td class='TableData'>平均草产量折算鲜重：</td>
				<td class='TableData dividingLine'><span
					id='herbAvgFreshAmount' name='herbAvgFreshAmount'></span>千克/公顷</td>
				<td class='TableData'>平均草产量折算干重：</td>
				<td class='TableData dividingLine'><span id='herbAvgDryAmount'
					name='herbAvgDryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData dividingLine'><span
					id='herbAvgEdibleFreshAmount' name='herbAvgEdibleFreshAmount'></span>千克/公顷</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData dividingLine'><span
					id='herbAvgEdibleDryAmount' name='herbAvgEdibleDryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">100平方米内灌木及高大草本测定</td>
			</tr>
			<tr>
				<td class="TableData" colspan='4'>
					<div style='width:910px;overflow-x:scroll;'>
						<table class="TableBlock" width="100%">
							<tr>
								<td class="TableData" align='center' rowspan='2'>灌木及高大草本名称</td>
								<td class="TableData" align='center' colspan='4'>大株丛(cm,g)</td>
								<td class="TableData" align='center'  colspan='4'>中株丛(cm,g)</td>
								<td class="TableData" align='center' colspan='4'>小株丛(cm,g)</td>
								<td class="TableData" align='center' rowspan='2'>覆盖<br/>面积(㎡)</td>
								<td class="TableData" align='center' colspan='2'>产草量折算<br/>(kg/h㎡)</td>
								<td class="TableData" align='center' rowspan='2'>灌丛<br/>高度<br/>(cm)</td>
							</tr>
							<tr>
								<td class="TableData" align='center'>丛径</td>
								<td class="TableData" align='center'>鲜重</td>
								<td class="TableData" align='center'>风干重</td>
								<td class="TableData" align='center'>株丛数</td>
								<td class="TableData" align='center'>丛径</td>
								<td class="TableData" align='center'>鲜重</td>
								<td class="TableData" align='center'>风干重</td>
								<td class="TableData" align='center'>株丛数</td>
								<td class="TableData" align='center'>丛径</td>
								<td class="TableData" align='center'>鲜重</td>
								<td class="TableData" align='center'>风干重</td>
								<td class="TableData" align='center'>株丛数</td>
								<td class="TableData" align='center'>鲜重</td>
								<td class="TableData" align='center'>风干重</td>
								</td>
							</tr>
							<tr id='shrubsItemAmount'>
								<td class='TableHeader'>合计</td>
								<td class='TableData'><span id='largeRadiusTotal'/></td>
								<td class='TableData'><span id='largeFreshAmountTotal' /></td>
								<td class='TableData'><span id='largeDryAmountTotal'/></td>
								<td class='TableData'><span id='largeNumsTotal'></span></td>
								<td class='TableData'><span id='middleRadiusTotal' ></span></td>
								<td class='TableData'><span id='middleFreshAmountTotal' ></span></td>
								<td class='TableData'><span id='middleDryAmountTotal' ></span></td>
								<td class='TableData'><span id='middleNumsTotal'></span></td>
								<td class='TableData'><span id='smallRadiusTotal'></span></td>
								<td class='TableData'><span id='smallFreshAmountTotal'></span></td>
								<td class='TableData'><span id='smallDryAmountTotal'></span></td>
								<td class='TableData'><span id='smallNumsTotal'></span></td>
								<td class='TableData'><span id='coverSizeTotal'></span></td>
								<td class='TableData'><span id='convertFreshAmountTotal'></span></td>
								<td class='TableData'><span id='convertDryAmountTotal'></span></td>
								<td class='TableData'><span id='avgShrubsHeightly'></span></td>
							</tr>
						</table>
					</div>
				
				</td>
			</tr>
			<tr>
				<td class='TableData'>植物种类：</td>
				<td class='TableData'><span id='shrubsPlantNums'
					name='shrubsPlantNums'></span></td>
				<td class='TableData'>总覆盖面积：</td>
				<td class='TableData'><span id='totalCoverSize'
					name='totalCoverSize'></span>m²</td>
			</tr>
			<tr>
				<td class='TableData'>主要植物名称：</td>
				<td class='TableData' colspan="3"><span id='shrubsMainPlant'
					name='shrubsMainPlant'></span></td>
			</tr>
			<tr>
				<td class='TableData'>草产量折算鲜重：</td>
				<td class='TableData'><span id='shrubsAvgFreshAmount'
					name='shrubsAvgFreshAmount'></span>千克/公顷</td>
				<td class='TableData'>草产量折算干重：</td>
				<td class='TableData'><span id='shrubsAvgDryAmount'
					name='shrubsAvgDryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>灌丛平均高度：</td>
				<td class='TableData' colspan="3"><span id='shrubsGrassAvgHeight'
					name='shrubsGrassAvgHeight'></span>厘米</td>
			</tr>
			<tr>
				<td class='TableHeader' style="text-align: left;" colspan="4">概况：</td>
			</tr>
			<tr>
				<td class='TableData'>枯落物：</td>
				<td class='TableData'><span id='litters' name='litters'></span>千克/公顷</td>
				<td class='TableData'>总盖度：</td>
				<td class='TableData'><span id='coverage' name='coverage'></span>%</td>
			</tr>
			<tr>
				<td class='TableData'>总产草量折算鲜重：</td>
				<td class='TableData'><span id='freshAmount' name='freshAmount'></span>千克/公顷</td>
				<td class='TableData'>总产草量折算干重：</td>
				<td class='TableData'><span id='dryAmount' name='dryAmount'></span>千克/公顷</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><span id="remark"
					name="remark" rows="3" cols="60" class="BigTextarea"></span></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor">
						<div class="attachContainorDiv" style="margin-left:20px;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					    </div>
					</div>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>