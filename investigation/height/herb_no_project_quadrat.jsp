<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String sampleAreaId = request.getParameter("sampleAreaId");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/height/herb.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<style>
	i{font-size: 16px;font-weight: bold;color:red;}
</style>
</head>
<script>
var id = '<%=id%>';
var sampleAreaId = '<%=sampleAreaId%>';
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
	 });
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 total("");
	 getQuadratNumber(1);
});
function saveQuadrat(){
	$("#quadratNumber").val($("#preNumber").text()+$("#curNumber").val());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsHerbQuadratController/saveHerbQuadrat.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsHerbQuadratController/updateHerbQuadrat.act";
		}
		top.$.jBox.tip("数据保存中", 'loading');
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					if(id!="null" && id!=null){
						top.$.jBox.tip(json.rtMsg, 'success');
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						top.$(".jbox-body").remove();
					 }else{
						var data = json.rtData;
						top.$.jBox.closeTip();
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						var that = top;
				    	top.$(".jbox-body").remove();
						var submit = function (v, h, f) {
						    if(v==2){
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addQuadrat(data.sampleAreaId,data.inOrOut,"无");
						    	 return true;
						    }else{
						    	return true;
						    }
						    return true;
						};
						// 自定义按钮
						that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加非工程草本样方': 2,'关闭':3}});
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function getHerbQuadratById(){
	getSampleAreaById();
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsHerbQuadratController/getHerbQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			var itemList= json.rtData.herbQuadratItem;
			getItemList(itemList,"");
			
			var quadratNumber = json.rtData.basicInfo.quadratNumber;
			var strs = quadratNumber.split("-");
			var preNumber = "";
			var curNumber = strs[strs.length-1];
			for(var i = 0 ;i<strs.length-1;i++){
				preNumber +=strs[i]+"-";
			}
			$("#preNumber").text(preNumber);
			$("#curNumber").val(curNumber);
			$("#quadratNumber").val(quadratNumber);
			
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


function getSampleAreaById(){
	if(sampleAreaId!="null" && sampleAreaId!=null){
		var url = contextPath+"/gmsSampleAreaController/getSampleAreaById.act?sid="+sampleAreaId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			var data = json.rtData.basicInfo;
			if(data.hasLitter=="有"){
				$("#litters").removeAttr("disabled");
			}else{
				$("#litters").attr("disabled","disabled");
			}
			$("#investigateUserNames").val(data.investigateUserNames);
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

/**
 * 数据校验	
 * 
 */
$.extend($.fn.validatebox.defaults.rules, {   
	qaNumberIsExist: {   //样方编码是否已存在
		validator: function(value, param){
			var url = contextPath+"/gmsHerbQuadratController/qaNumberIsExist.act";
			var params={};
			var sampleAreaId = $("#sampleAreaId").val();
			var quadratNumber = $("#preNumber").text()+$("#curNumber").val();
			params["sampleAreaId"] = sampleAreaId;
			params["quadratNumber"] = quadratNumber;
			params["inOrOut"] = param[0];
			if(id!="null" && id!=null){
				params["sid"]=id;
			}
			var json = tools.requestJsonRs(url,params);
			if(json.rtState){
				if(json.rtData){
					return false;
				}
			}
			return true;
			
		},  
	   message: '当前样方编码已存在，请重新输入！'
	},
	badGrassNums:{
		validator:function(value,params){
			var badGrassNums=$("#badGrassNums").val();
			if(badGrassNums=="0"){
				return false;
			}
			return true;			
		},
		message:'检查到毒害草种数和主要毒害草不对应!'
	}

});
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getHerbQuadratById();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 95%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><input type="text" id='investigateDate'
					name='investigateDate' class='SmallInput easyui-validatebox '
					readonly="readonly" /><i>*</i></td>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text"
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox' maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><input type="text" id='longitude'
					name='longitude' class='SmallInput easyui-validatebox' validType="numberBetweenLength[60,150] & addMethode[]"/>(度)<i>*</i></td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><input type="text" id='latitude'
					name='latitude' class='SmallInput easyui-validatebox' validType="numberBetweenLength[10,60] & addMethode[]"/>(度)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>海拔：</td>
				<td class='TableData' colspan='3'><input type="text" id='altitude'
					name='altitude' class='SmallInput easyui-validatebox' validType="numberBetweenLength[-160,8849] & addMethod[]"/>(米)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData' colspan='3'>
					<span id='preNumber'></span>
					<input id='curNumber' name='curNumber' class='SmallInput easyui-validatebox' required="true" validType="integeZero[] & qaNumberIsExist[0]"/><i>*</i>
					<input type="hidden" id='quadratNumber' name='quadratNumber'/>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'>样方面积：</td>
				<td class='TableData'><input type="text" id='quadratSize'
					name='quadratSize' class='SmallInput easyui-validatebox' value='1' validType="numberBetweenLength[0,100]"/>(㎡)<i>*</i></td>
				<td class='TableData'>植被盖度：</td>
				<td class='TableData'><input type="text" id='coverage'
					name='coverage' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethod[]"/>(%)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>草群平均高度：</td>
				<td class='TableData'><input type="text" id='grassAvgHeight'
					name='grassAvgHeight' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[0,80] & addMethod[]"/>(厘米)<i>*</i></td>
				<td class='TableData'>枯落物情况：</td>
				<td class='TableData'><input type="text" id='litters'
					name='litters' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[]"/>(千克/公顷)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>植物种数：</td>
				<td class='TableData'><input type="text" id='plantNums'
					name='plantNums' class='SmallInput easyui-validatebox' validType="positivIntege[]"/>(种)<i>*</i></td>
				<td class='TableData'>主要植物种名称：</td>
				<td class='TableData'><input type="text" id='mainPlant'
					name='mainPlant' class='BigInput easyui-validatebox' /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>毒害草种数：</td>
				<td class='TableData'><input type="text" id='badGrassNums'
					name='badGrassNums' class='SmallInput easyui-validatebox' validType="integeZero[]"/>(种)<i>*</i></td>
				<td class='TableData'>主要毒害草名称：</td>
				<td class='TableData'><input type="text" id='mainBadGrass'
					name='mainBadGrass' class='BigInput easyui-validatebox' validType="badGrassNums[]"/><i>*</i></td>
			</tr>
			
			<tr>
				<td class="TableData" style="text-align: left;" colspan="4">产草量测定</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<table class="TableBlock" width="100%" id="itemTable">
						<tr>
							<td class="TableData" align="center">编号</td>
							<td class="TableData" align="center">鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">可食鲜重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">干重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center">可食干重(g/㎡)<i>*</i></td>
							<td class="TableData" align="center"><input type='button' value='+' class='btn btn-success' style="background: #41a675;" onclick="addGrassAmount(this,'');"/></td>
						</tr>
						<tr>
							<td class="TableData" align='center'>1</td>
							<td class="TableData" align='center'><input type='text' name='itemFreshAmount' class='SmallInput easyui-validatebox' validType='integeZeroln[] & addMethod[]'/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleFreshAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleFreshValid[1,'']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemDryAmount' class='SmallInput easyui-validatebox' validType="integeZeroln[] & addMethod[] & dryFreshValid[1,'']"/></td>
							<td class="TableData" align='center'><input type='text' name='itemEdibleDryAmount' class='SmallInput easyui-validatebox' validType="integeZerol[] & addMethod[] & edibleDryValid[1,''] & edible[1,'']"/></td>
							<td class="TableData" align='center'>
							</td>
						</tr>
						<tr id="grassAvgAmount">
							<td class="TableHeader">平均</td>
							<td class="TableData"><span id='avgFreshAmount'></span></td>
							<td class="TableData"><span id='avgEdibleFreshAmount'></span></td>
							<td class="TableData"><span id='avgDryAmount'></span></td>
							<td class="TableData" colspan='2'><span id='avgEdibleDryAmount'></span></td>
						</tr>
					</table>
					
				</td>
			
			</tr>
			
			<tr>
				<td class='TableData'>总产草量鲜重：</td>
				<td class='TableData'><input type="text" id='freshAmount'
					name='freshAmount' class='SmallInput easyui-validatebox readonly' readonly="readonly" />(千克/公顷)</td>
				<td class='TableData'>总产草量风干重：</td>
				<td class='TableData'><input type="text" id='dryAmount'
					name='dryAmount' class='SmallInput easyui-validatebox readonly' readonly="readonly"  />(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>可食产草鲜重：</td>
				<td class='TableData'><input type="text" id='edibleFreshAmount'
					name='edibleFreshAmount' class='SmallInput easyui-validatebox readonly' readonly="readonly"  />(千克/公顷)</td>
				<td class='TableData'>可食产草干重：</td>
				<td class='TableData'><input type="text" id='edibleDryAmount'
					name='edibleDryAmount' class='SmallInput easyui-validatebox readonly' readonly="readonly"  />(千克/公顷)</td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><textarea id="remark"
						name="remark" rows="3" cols="60" class="BigTextarea"></textarea></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor">
						<div class="attachContainorDiv" style="margin-left:20px; float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)" >
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
							<input type="file" id="qd_np_hb_overlooking_photo" name="qd_np_hb_overlooking_photo" onchange="change(this)" />
					        请选择景观照片文件
					        </p>
							
					    </div>
					    <i style="float: left">*</i>
					</div>
					
				</td>
			</tr>   

		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='sampleAreaId' name='sampleAreaId'
			value='<%=sampleAreaId %>' /> <input type='hidden'
			id='investigateDataId' name='investigateDataId' /> <input
			type='hidden' id='inOrOut' name='inOrOut' value="0" />
	</form>
</body>
</html>