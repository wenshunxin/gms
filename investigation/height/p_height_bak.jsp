<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String dataId = request.getParameter("dataId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
</head>
<script>
var id = '<%=id%>';
var dataId = '<%=dataId%>';
$(function(){
	 $("#investigateDate").datetimepicker({
		 language:"zh-CN",   
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 }).on('changeDate',function(){
		 autoNumber();
	 });
 	$("#selectProject").hide();
	$("#projectId").val(0);
	getProjectById(0);
	$("#projectInfo").html(template);
	$("#projectInfo").show(); 
	$("#projectDetail").hide(100);
	triggerCheckbox();
	 autoNumber();
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 getChildListByTypeCode("GRASSLAND_TYPE","grassCategoryIn");
	 
	 $('#grassCategoryIn').combobox({
		 onSelect: function(param){
			 var categoryNo = param.categoryNo;
			 getChildListByTypeCode("GRASSLAND_TYPE_"+categoryNo,"grassTypeIn");
			
		 }
	});
	 getChildListByTypeCode("GRASSLAND_TYPE","grassCategoryOut");
	 
	 $('#grassCategoryOut').combobox({
		 onSelect: function(param){
			 var categoryNo = param.categoryNo;
			 getChildListByTypeCode("GRASSLAND_TYPE_"+categoryNo,"grassTypeOut");
			
		 }
	});
	getSampleAreaById();
});
function triggerCheckbox(){
	$("input[name=projectMeasures]").each(function(e,i){
		$(this).click(function(){
			if($(this).attr("checked")){
				$(this).removeAttr("checked");
			}else{
				$(this).attr("checked","checked");
			}
		});
	});
	 $("#projectBuildingDate").datetimepicker({
		 language:"zh-CN",   
		 startView: 'decade',
		 minView: 'decade',
		 format:"yyyy",
		 endDate : new Date(),
	     autoclose: true
	 });
	 $("#projectBuildingDate").val(new Date().getFullYear());
	 getCityInfo("cityInfo");
	 $("#projectName").on("change",function(){
		 autoNumber();
	 });
}

var template="<tr>"
	+"<td class='TableData'>工程名称：</td>"
	+"<td class='TableData'><select id='projectName' name='projectName'  class='BigSelect' >"
	+"<option value='京津风沙源治理工程'>京津风沙源治理工程</option>"
	+"<option value='退牧还草工程'>退牧还草工程</option>"
	+"<option value='西南岩溶地区草地治理试点工程'>西南岩溶地区草地治理试点工程</option>"
	+"<option value='岩溶地区石漠化综合治理'>岩溶地区石漠化综合治理</option>"
	+"</select></td>"
	+"<td class='TableData'>工程面积：</td>"
	+"<td class='TableData'><input type='text' id='projectSize' name='projectSize' class='SmallInput easyui-validatebox' />(公顷)</td>"
	+"</tr>"
	+"<tr>"
	+"<td class='TableData'>工程措施：</td>"
	+"<td class='TableData' colspan='3'>"
	+"	<input type='checkbox' id='measure1' name='projectMeasures' class='' value='人工种草'/><label for='measure1'>人工种草</label>"
	+"	<input type='checkbox' id='measure2' name='projectMeasures' class='' value='飞播牧草'/><label for='measure2'>飞播牧草</label>"
	+"	<input type='checkbox' id='measure3' name='projectMeasures' class='' value='围栏封育'/><label for='measure3'>围栏封育</label>"
	+"	<input type='checkbox' id='measure4' name='projectMeasures' class='' value='基本牧草'/><label for='measure4'>基本牧草</label>"
	+"	<input type='checkbox' id='measure5' name='projectMeasures' class='' value='草种基地'/><label for='measure5'>草种基地</label>"
	+"	<input type='checkbox' id='measure6' name='projectMeasures' class='' value='禁牧'/><label for='measure6'>禁牧</label>"
	+"</td>"
	+"</tr>"
	+"<tr>"
	+"<td class='TableData'>工程投资：</td>"
	+"<td class='TableData'><input type='text' id='projectInvestment' name='projectInvestment' class='SmallInput easyui-validatebox'/>(万元)</td>"
	+"<td class='TableData'>中央投资：</td>"
	+"<td class='TableData'><input type='text' id='projectNationalInvestment' name='projectNationalInvestment' class='SmallInput easyui-validatebox'/>(万元)</td>"
	+"</tr>"
	+"<tr>"
	+"<td class='TableData'>工程建设年份：</td>"
	+"<td class='TableData' colspan='3'><input type='text' id='projectBuildingDate' name='projectBuildingDate' class='SmallInput easyui-validatebox readonly' readonly='readonly'/>(年)</td>"
	+"</tr>"
	+"<tr>"
	+"<td class='TableData'>工程地点：</td>"
	+"<td class='TableData' colspan='3'>"
	+"	<span id='cityInfo'></span>乡镇：<input id='countyName' name='countyName' class='SmallInput easyui-validatebox'/>"
	+"	<input type='hidden' id='projectAddress' name='projectAddress'/>"
	+"</td>"
	+"</tr>"; 


function saveSampleArea(){
	$("#sampleAreaNumberIn").val($("#preNumberIn").text()+$("#curNumberIn").val());
	$("#sampleAreaNumberOut").val($("#preNumberOut").text()+$("#curNumberOut").val());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsSampleAreaController/saveSampleArea.act?type=0";//type=0代表工程样地，1-非工程样地
		if(id!="null" && id!=null){
			url = contextPath+"/gmsSampleAreaController/updateSampleArea.act?type=0";//type=0代表工程样地 1-非工程样地
		}
		var param={};
		$("input[name=projectMeasures]").each(function(i,obj){
			if($(obj).attr("checked")){
				if(param["measures"]){
					param["measures"] =param["measures"]+","+$(obj).val();
				}else{
					param["measures"] = $(obj).val();
				}
			}
		});
		$("#projectAddress").val($("#cityInfo").text()+"-"+$("#countyName").val());
		$("#form1").ajaxSubmit({
			type: 'post',
			url: url,
			data: param,
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					top.$.jBox.tip(json.rtMsg,"success");
					top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
					top.$(".jbox-body").remove();
				}else{
					$.jBox.tip("系统异常！","error");
				} 
			}
		});
	}
}
function getSampleAreaById(){
	getProjectList();
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsSampleAreaController/getSampleAreaById.act?sid="+id+"&dataId="+dataId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//工程信息
			getProjectById(json.rtData.sampleAreaIn.projectId);
			//基本信息
			bindJsonObj2Cntrl(json.rtData.sampleAreaIn);
			bindJsonObj2Cntrl(json.rtData.sampleAreaIn,null,"In");
			bindJsonObj2Cntrl(json.rtData.sampleAreaOut,null,"Out");
			$('#grassCategoryIn').combobox('setValue', json.rtData.sampleAreaIn.grassCategory);
			$('#grassTypeIn').combobox('setValue', json.rtData.sampleAreaIn.grassType);
			$('#grassCategoryOut').combobox('setValue', json.rtData.sampleAreaOut.grassCategory);
			$('#grassTypeInOut').combobox('setValue', json.rtData.sampleAreaOut.grassType);
			
			var sampleAreaNumberIn = json.rtData.sampleAreaIn.sampleAreaNumber;
			if(sampleAreaNumberIn){
				var strs = sampleAreaNumberIn.split("-");
				$("#curNumberIn").val(strs[strs.length-1]);
			}
			var sampleAreaNumberOut = json.rtData.sampleAreaOut.sampleAreaNumber;
			if(sampleAreaNumberOut){
				var strs = sampleAreaNumberOut.split("-");
				$("#curNumberOut").val(strs[strs.length-1]);
			}
			
			
			
			
			//附件信息
			var attachListIn = json.rtData.attachListIn;
			for(var i = 0 ;i<attachListIn.length;i++){
				var attach = attachListIn[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				var img = $("<img>").attr("src",encodeURI(attachUrl)).css({"width":200,"height":100,"margin-left":20});
				$("#attachContainor").append(img);
			}
			var attachListOut = json.rtData.attachListOut;
			for(var i = 0 ;i<attachListOut.length;i++){
				var attach = attachListOut[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				var img = $("<img>").attr("src",encodeURI(attachUrl)).css({"width":200,"height":100,"margin-left":20});
				$("#attachContainor").append(img);
			}
		}
	}
	$("input[name=selectProject]").each(function(i,e){
		$(this).click(function(){
			$(this).attr("checked","checked");
			if($(this).val()==0 && $(this).attr("checked")){
				$("#selectProject").show();
				$("#projectDetail").show();
				$("#projectInfo").empty();
				$("#projectInfo").hide();
			}
			if($(this).val()==1 && $(this).attr("checked")){
				$("#selectProject").hide();
				$("#projectId").val(0);
				getProjectById(0);
				$("#projectDetail").hide();
				$("#projectInfo").html(template);
				$("#projectInfo").show();
				triggerCheckbox();
			}
		})
	});
}

function getProjectById(projectId){
	$("#projectDetail span").each(function(){
		$(this).html("");
	})
	if(projectId!="null" && projectId!=null){
		var url = contextPath+"/gmsProjectController/getProjectById.act?sid="+projectId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			if(json.rtData){
			    bindJsonObj2Cntrl(json.rtData);
				var area = json.rtData.projectAddress;
				var index = area.indexOf("-");
				if(index>-1){
					var countyName= area.substring(index+1,area.length);
					$("#countyName").val(countyName);
				}
				autoNumber();
			}
		}
	}
}

function getProjectList(){
	var url = contextPath+"/gmsProjectController/getProjectDatagrid.act";
	var param={"page":1,"pageSize":9999};
	var json = tools.requestJsonRs(url,param);
	if(json.total>0){
		var data = json.rows;
		var html="<option value='0'>请选择工程</option>";
		for(var i=0;i<data.length;i++){
			html+="<option value='"+data[i].sid+"'>"+data[i].projectName+"</option>";
		}
		$("#projectId").html(html);
		$("#projectDetail").show();
	}
}

function autoNumber(){
	var param = {};
	var projectName = $("#projectName").val();
	if(projectName==null || projectName=="" || projectName=="null" || projectName=="undefined"){
		projectName = $("#projectName").text();
	}
	var investigateDate = $("#investigateDate").val();
	param["projectName"] = projectName;
	param["investigateDate"] = investigateDate;
	var url = contextPath+"/gmsInvestigateDataController/autoSampleAreaNumber.act?investigateType=0";
	var json = tools.requestJsonRs(url,param);
	if(json.rtState){
		$("#preNumberIn").text(json.rtData.preNumber);
		$("#curNumberIn").val(json.rtData.curNumber);
		$("#sampleAreaNumberIn").val(json.rtData.preNumber+$("#curNumberIn").val());
		$("#preNumberOut").text(json.rtData.preNumber);
		$("#curNumberOut").val(json.rtData.curNumber);
		$("#sampleAreaNumberOut").val(json.rtData.preNumber+$("#curNumberOut").val());
	}
}

</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData' style="width: 135px;">调查时间：</td>
				<td class='TableData'><input type='text' id='investigateDate'
					name='investigateDate' autocomplete="off"
					class='SmallInput easyui-validatebox readonly' readonly="readonly" /></td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type='text'
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox'/></td>
			</tr>
			<tr>
				<td class='TableData'>具有灌木和高大草木：</td>
				<td class='TableData' colspan="3"><input type="radio" id='hasShrubs1'
					name='hasShrubs' class='' value="无" checked="checked" /><label
					for="hasShrubs1">无</label> <input type="radio" id='hasShrubs2'
					name='hasShrubs' class='' value="有" /><label for="hasShrubs2">有</label>
				</td>
			</tr>

			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">工程信息
					<span style="margin-left: 90px;">
						<input type="radio" id='selectProject2' name="selectProject" value="1" checked="checked"  /><label for="selectProject2">新建工程</label>
						<input type="radio" id='selectProject1' name="selectProject" value="0"/><label for="selectProject1">选择已有工程</label> 
					</span>

				</td>
			</tr>
			<tbody id="projectInfo" style="display: none;">
			</tbody>
			<tr id="selectProject">
				<td class='TableData'>工程：</td>
				<td class='TableData' colspan='3'><select id="projectId"
					name="projectId" class="BigSelect"
					onchange='getProjectById(this.value)'>

				</select></td>
			</tr>
			<tbody id="projectDetail">
				<tr>
					<td class='TableData'>工程名称：</td>
					<td class='TableData'><span id='projectName'></span></td>
					<td class='TableData'>工程面积：</td>
					<td class='TableData'><span id='projectSize'></span>(公顷)</td>
				</tr>
				<tr>
					<td class='TableData'>工程投资：</td>
					<td class='TableData'><span id='projectInvestment'></span>(万元)</td>
					<td class='TableData'>中央投资：</td>
					<td class='TableData'><span id='projectNationalInvestment'></span>(万元)</td>
				</tr>
				<tr>
					<td class='TableData'>工程建设年份：</td>
					<td class='TableData' colspan='3'><span id='projectBuildingDate'></span></td>
				</tr>
				<tr>
					<td class='TableData'>工程措施：</td>
					<td class='TableData' colspan='3'><span id="projectMeasures"></span>
					</td>
				</tr>
				<tr>
					<td class='TableData'>工程地点：</td>
					<td class='TableData' colspan='3'><span id='projectAddress'></span>
					</td>
				</tr>
			</tbody>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="2">工程区域内样地</td>
				<td class="TableHeader" style="text-align: left;" colspan="2">工程区域外样地</td>
			</tr>

			<tr>
				<td class='TableData'>样地编号：</td>
				<td class='TableData'>
					<span id='preNumberIn'></span><input id='curNumberIn' name='curNumberIn' class='SmallInput easyui-validatebox' required="true" validType="integeZero[]"/><span>-内</span>
					<input type='hidden'id='sampleAreaNumberIn' name='sampleAreaNumberIn' class='BigInput easyui-validatebox' />
				</td>
				<td class='TableData'>样地编号：</td>
				<td class='TableData'>
					<span id='preNumberOut'></span><input id='curNumberOut' name='curNumberOut' class='SmallInput easyui-validatebox' required="true" validType="integeZero[]"/><span>-外</span>
					<input type='hidden'id='sampleAreaNumberOut' name='sampleAreaNumberOut' class='BigInput easyui-validatebox' />
				</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'>
					<input id='grassCategoryIn' name='grassCategoryIn' class='BigInput easyui-combobox'/>
				</td>
				<td class='TableData'>草地类：</td>
				<td class='TableData'>
					<input id='grassCategoryOut' name='grassCategoryOut' class='BigInput easyui-combobox'/>
				</td>
			</tr>
			<tr>
				<td class='TableData'>草地型：</td>
				<td class='TableData'>
					<input id='grassTypeIn' name='grassTypeIn' class='BigInput easyui-combobox'/>
				</td>
				<td class='TableData'>草地型：</td>
				<td class='TableData'>	
					<input id='grassTypeOut' name='grassTypeOut' class='BigInput easyui-combobox'/>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="TableData" style="padding: 0 0;">
					<table class="TableBlock" style="border-left: 0; width: 100%;">
						<tr>
							<td class='TableData' style="width: 135px;">地形地貌：</td>
							<td class='TableData'><select id="grassLandscapeIn"
								name="grassLandscapeIn" class="BigSelect">
									<option value="平原">平原</option>
									<option value="丘陵">丘陵</option>
									<option value="山地">山地</option>
									<option value="高原">高原</option>
									<option value="盆地">盆地</option>
							</select></td>
							<td class='TableData'>土壤质地：</td>
							<td class='TableData'><select id="soilTextureIn"
								name="soilTextureIn" class="BigSelect">
									<option value="沙土">沙土</option>
									<option value="壤土">壤土</option>
									<option value="砾石质">砾石质</option>
									<option value="粘土">粘土</option>
									<option value="栗钙土">栗钙土</option>
									<option value="浮沙">浮沙</option>
							</select></td>
						</tr>
						<tr>
							<td class='TableData'>坡向：</td>
							<td class='TableData'><select id="grassSlopeIn"
								name="grassSlopeIn" class="BigSelect">
									<option value="阳坡">阳坡</option>
									<option value="半阳坡">半阳坡</option>
									<option value="半阴坡">半阴坡</option>
									<option value="阴坡">阴坡</option>
							</select></td>
							<td class='TableData'>坡位：</td>
							<td class='TableData'><select id="grassSlopePositionIn"
								name="grassSlopePositionIn" class="BigSelect">
									<option value="坡脚">坡脚</option>
									<option value="坡顶">坡顶</option>
									<option value="坡下部">坡下部</option>
									<option value="坡中部">坡中部</option>
									<option value="坡上部">坡上部</option>
							</select></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">地表特征</td>
						</tr>
						<tr>
							<td class='TableData'>枯落物情况：</td>
							<td class='TableData'><input type="radio" id='hasLitterIn1'
								name='hasLitterIn' class='' value="无" /><label
								for="hasLitterIn1">无</label> <input type="radio"
								id='hasLitterIn2' name='hasLitterIn' class='' value="有" /><label
								for="hasLitterIn2">有</label></td>
							<td class='TableData'>覆沙情况：</td>
							<td class='TableData'><input type="radio" id='hasSandIn1'
								name='hasSandIn' class='' value="无" /><label for="hasSandIn1">无</label>
								<input type="radio" id='hasSandIn2' name='hasSandIn' class=''
								value="有" /><label for="hasSand2In">有</label></td>
						</tr>
						<tr>
							<td class='TableData'>地表侵蚀：</td>
							<td class='TableData'><input type="radio"
								id='hasSurfaceErosionIn1' name='hasSurfaceErosionIn' class=''
								value="无" /><label for="hasSurfaceErosionIn1">无</label> <input
								type="radio" id='hasSurfaceErosionIn2'
								name='hasSurfaceErosionIn' class='' value="有" /><label
								for="hasSurfaceErosionIn2">有</label></td>
							<td class='TableData'>侵蚀原因：</td>
							<td class='TableData'><select id="erosionReasonIn"
								name="erosionReasonIn" class="BigSelect">
									<option value="风蚀">风蚀</option>
									<option value="水蚀">水蚀</option>
									<option value="冻蚀">冻蚀</option>
									<option value="超载">超载</option>
									<option value="其他">其他</option>
							</select></td>
						</tr>
						<tr>
							<td class='TableData'>盐碱斑：</td>
							<td class='TableData'><input type="radio"
								id='hasSalineSpotIn1' name='hasSalineSpotIn' class='' value="无" /><label
								for="hasSalineSpotIn1">无</label> <input type="radio"
								id='hasSalineSpotIn2' name='hasSalineSpotIn' class='' value="有" /><label
								for="hasSalineSpotIn2">有</label></td>
							<td class='TableData'>裸地面积比例：</td>
							<td class='TableData'><input type='text'
								id='bareLandAreaRatioIn' name='bareLandAreaRatioIn'
								class='BigInput easyui-validatebox' style="width: 40px;" validType="numberBetweenLength[0,100] & addMethodbbbf[]"/>(%)</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">积水和降水</td>
						</tr>
						<tr>
							<td class='TableData'>地表有无季节性积水：</td>
							<td class='TableData'><input type="radio"
								id='hasSeasonalWaterIn1' name='hasSeasonalWaterIn' class=''
								value="无" /><label for="hasSeasonalWaterIn1">无</label> <input
								type="radio" id='hasSeasonalWaterIn2' name='hasSeasonalWaterIn'
								class='' value="有" /><label for="hasSeasonalWaterIn2">有</label>
							</td>
							<td class='TableData'>年平均降水量：</td>
							<td class='TableData'><input type='text'
								id='averageAnnualRainfallIn' name='averageAnnualRainfallIn'
								class='BigInput easyui-validatebox' style="width: 40px;" validType="integeZerol[] & addMethodbbbf[]"/>(毫米)</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">利用</td>
						</tr>
						<tr>
							<td class='TableData'>利用方式：</td>
							<td class='TableData' colspan='3'><select id="usingTypeIn"
								name="usingTypeIn" class="BigSelect">
									<option value="打草场">打草场</option>
									<option value="冷季放牧">冷季放牧</option>
									<option value="暖季放牧">暖季放牧</option>
									<option value="春季放牧">春季放牧</option>
									<option value="全年放牧">全年放牧</option>
									<option value="禁牧">禁牧</option>
									<option value="其他">其他</option>
							</select></td>
						</tr>
						<tr>
							<td class='TableData'>利用状态：</td>
							<td class='TableData' colspan='3'><select id="usingStatusIn"
								name="usingStatusIn" class="BigSelect">
									<option value="未利用">未利用</option>
									<option value="轻度利用">轻度利用</option>
									<option value="合理利用">合理利用</option>
									<option value="超载">超载</option>
									<option value="严重超载">严重超载</option>
							</select></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">评价</td>
						</tr>
						<tr>
							<td class='TableData'>综合评价：</td>
							<td class='TableData' colspan='3'><select id="evaluationIn"
								name="evaluationIn" class="BigSelect">
									<option value="好">好</option>
									<option value="中">中</option>
									<option value="差">差</option>
							</select></td>
						</tr>
					</table>
				</td>
				<td colspan="2" class="TableData" style="padding: 0 0;">
					<table class="TableBlock" style="border-left: 0; width: 100%;">
						<tr>
							<td class='TableData' style="width: 135px;">地形地貌：</td>
							<td class='TableData'><select id="grassLandscapeOut"
								name="grassLandscapeOut" class="BigSelect">
									<option value="平原">平原</option>
									<option value="丘陵">丘陵</option>
									<option value="山地">山地</option>
									<option value="高原">高原</option>
									<option value="盆地">盆地</option>
							</select></td>
							<td class='TableData'>土壤质地：</td>
							<td class='TableData'><select id="soilTextureOut"
								name="soilTextureOut" class="BigSelect">
									<option value="沙土">沙土</option>
									<option value="壤土">壤土</option>
									<option value="砾石质">砾石质</option>
									<option value="粘土">粘土</option>
									<option value="栗钙土">栗钙土</option>
									<option value="浮沙">浮沙</option>
							</select></td>
						</tr>
						<tr>
							<td class='TableData'>坡向：</td>
							<td class='TableData'><select id="grassSlopeOut"
								name="grassSlopeOut" class="BigSelect">
									<option value="阳坡">阳坡</option>
									<option value="半阳坡">半阳坡</option>
									<option value="半阴坡">半阴坡</option>
									<option value="阴坡">阴坡</option>
							</select></td>
							<td class='TableData'>坡位：</td>
							<td class='TableData'><select id="grassSlopePositionOut"
								name="grassSlopePositionOut" class="BigSelect">
									<option value="坡脚">坡脚</option>
									<option value="坡顶">坡顶</option>
									<option value="坡下部">坡下部</option>
									<option value="坡中部">坡中部</option>
									<option value="坡上部">坡上部</option>
							</select></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">地表特征</td>
						</tr>
						<tr>
							<td class='TableData'>枯落物情况：</td>
							<td class='TableData'><input type="radio" id='hasLitterOut1'
								name='hasLitterOut' class='' value="无" /><label
								for="hasLitterOut1">无</label> <input type="radio"
								id='hasLitterOut2' name='hasLitterOut' class='' value="有" /><label
								for="hasLitterOut2">有</label></td>
							<td class='TableData'>覆沙情况：</td>
							<td class='TableData'><input type="radio" id='hasSandOut1'
								name='hasSandOut' class='' value="无" /><label for="hasSandOut1">无</label>
								<input type="radio" id='hasSandOut2' name='hasSandOut' class=''
								value="有" /><label for="hasSandOut2">有</label></td>
						</tr>
						<tr>
							<td class='TableData'>地表侵蚀：</td>
							<td class='TableData'><input type="radio"
								id='hasSurfaceErosionOut1' name='hasSurfaceErosionOut' class=''
								value="无" /><label for="hasSurfaceErosionOut1">无</label> <input
								type="radio" id='hasSurfaceErosionOut2'
								name='hasSurfaceErosionOut' class='' value="有" /><label
								for="hasSurfaceErosionOut2">有</label></td>
							<td class='TableData'>侵蚀原因：</td>
							<td class='TableData'><select id="erosionReasonOut"
								name="erosionReasonOut" class="BigSelect">
									<option value="风蚀">风蚀</option>
									<option value="水蚀">水蚀</option>
									<option value="冻蚀">冻蚀</option>
									<option value="超载">超载</option>
									<option value="其他">其他</option>
							</select></td>
						</tr>
						<tr>
							<td class='TableData'>盐碱斑：</td>
							<td class='TableData'><input type="radio"
								id='hasSalineSpotOut1' name='hasSalineSpotOut' class=''
								value="无" /><label for="hasSalineSpotOut1">无</label> <input
								type="radio" id='hasSalineSpotOut2' name='hasSalineSpotOut'
								class='' value="有" /><label for="hasSalineSpotOut2">有</label></td>
							<td class='TableData'>裸地面积比例：</td>
							<td class='TableData'><input type='text'
								id='bareLandAreaRatioOut' name='bareLandAreaRatioOut'
								class='BigInput easyui-validatebox' style="width: 40px;" validType="numberBetweenLength[0,100] & addMethodbbbf[]" />(%)</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">积水和降水</td>
						</tr>
						<tr>
							<td class='TableData'>地表有无季节性积水：</td>
							<td class='TableData'><input type="radio"
								id='hasSeasonalWaterOut1' name='hasSeasonalWaterOut' class=''
								value="无" /><label for="hasSeasonalWaterOut1">无</label> <input
								type="radio" id='hasSeasonalWaterOut2'
								name='hasSeasonalWaterOut' class='' value="有" /><label
								for="hasSeasonalWaterOut2">有</label></td>
							<td class='TableData'>年平均降水量：</td>
							<td class='TableData'><input type='text'
								id='averageAnnualRainfallOut' name='averageAnnualRainfallOut'
								class='BigInput easyui-validatebox' style="width: 40px;" validType="integeZerol[] & addMethodbbbf[]"/>(毫米)</td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">利用</td>
						</tr>
						<tr>
							<td class='TableData'>利用方式：</td>
							<td class='TableData' colspan='3'><select id="usingTypeOut"
								name="usingTypeOut" class="BigSelect">
									<option value="打草场">打草场</option>
									<option value="冷季放牧">冷季放牧</option>
									<option value="暖季放牧">暖季放牧</option>
									<option value="春季放牧">春季放牧</option>
									<option value="全年放牧">全年放牧</option>
									<option value="禁牧">禁牧</option>
									<option value="其他">其他</option>
							</select></td>
						</tr>
						<tr>
							<td class='TableData'>利用状态：</td>
							<td class='TableData' colspan='3'><select
								id="usingStatusOut" name="usingStatusOut" class="BigSelect">
									<option value="未利用">未利用</option>
									<option value="轻度利用">轻度利用</option>
									<option value="合理利用">合理利用</option>
									<option value="超载">超载</option>
									<option value="严重超载">严重超载</option>
							</select></td>
						</tr>
						<tr>
							<td class="TableHeader" style="text-align: left;" colspan="4">评价</td>
						</tr>
						<tr>
							<td class='TableData'>综合评价：</td>
							<td class='TableData' colspan='3'><select id="evaluationOut"
								name="evaluationOut" class="BigSelect">
									<option value="好">好</option>
									<option value="中">中</option>
									<option value="差">差</option>
							</select></td>
						</tr>
					</table>
				</td>

			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor"></div> <input type="file"
					id="sa_pi_landscape_photo" name="sa_pi_landscape_photo" /> <!-- <input
					type="file" id="sa_po_landscape_photo" name="sa_po_landscape_photo" /> -->
				</td>
			</tr>

		</table>
		<input type='hidden' id='sidIn' name='sidIn' /> <input type='hidden'
			id='sidOut' name='sidOut' /> <input type='hidden'
			id='investigateDataId' name='investigateDataId' />
	</form>
</body>
</html>