<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String sampleAreaId = request.getParameter("sampleAreaId");
	String type = (String)request.getParameter("type");
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
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<style>
	i{color:red;font-size: 16px;font-weight: bold;}
</style>
</head>
<script>
var id = '<%=id%>';
var sampleAreaId = '<%=sampleAreaId%>';
var type = '<%=type%>';

function saveGreenYellowQuadrat(){
	$("#quadratNumber").val($("#preNumber").text()+$("#curNumber").val());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsGreenYellowQuadratController/saveGreenYellowQuadrat.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsGreenYellowQuadratController/updateGreenYellowQuadrat.act";
		}
		top.$.jBox.tip("数据保存中", 'loading');
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			dataType:"text/html",  
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					if(id!="null" && id!=null){
						top.$.jBox.tip(json.rtMsg,"success");
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
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addQuadrat(data.sampleAreaId);
						    	 return true;
						    }else{
						    	return true;
						    }
						    return true;
						};
						// 自定义按钮
						if(type=="g"){
							that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {"继续添加返青期样方": 2,'关闭':3}});
						}else{
							that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {"继续添加枯黄期样方": 2,'关闭':3}});
						}
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function getGreenYellowQuadratById(){
	var fileInput=null;
	getQuadratNumber();
	if(type=="g"){
		$("#quadratType").val(0);
		$("#percentageTitle").text("返青率");
		// $("#attachContainor").after("<input type='file' name='qd_gn_overlooking_photo' id='qd_gn_overlooking_photo'/> ");
		fileInput = $("<input type='file'>").attr("name","qd_gn_overlooking_photo").attr("id","qd_gn_overlooking_photo").change(function(){
			change(this);
		});
		$("#p").append(fileInput);

	}else{
		$("#quadratType").val(1);
		$("#percentageTitle").text("枯黄率");
		// $("#attachContainor").after("<input type='file' name='qd_yw_overlooking_photo' id='qd_yw_overlooking_photo'/> ");
		fileInput = $("<input type='file'>").attr("name","qd_yw_overlooking_photo").attr("id","qd_yw_overlooking_photo").change(function(){
			change(this);
		});
		$("#p").append(fileInput);
	}
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsGreenYellowQuadratController/getGreenYellowQuadratById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
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

function getQuadratNumber(){
	var url = contextPath+"/gmsGreenYellowQuadratController/getQuadratNumber.act?sampleAreaId="+sampleAreaId;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var quadratNumber = json.rtData;
		var strs = quadratNumber.split("-");
		var preNumber = "";
		var curNumber = strs[strs.length-1];
		for(var i = 0 ;i<strs.length-1;i++){
			preNumber +=strs[i]+"-";
		}
		$("#preNumber").text(preNumber);
		$("#curNumber").val(curNumber);
		$("#quadratNumber").val(quadratNumber);
	}
}


/**
 * 数据校验	
 * 
 */
$.extend($.fn.validatebox.defaults.rules, {   
	qaNumberIsExist: {   //样方编码是否已存在
		validator: function(value, param){
			var url = contextPath+"/gmsGreenYellowQuadratController/qaNumberIsExist.act";
			var params={};
			var sampleAreaId = $("#sampleAreaId").val();
			var quadratNumber = $("#preNumber").text()+$("#curNumber").val();
			params["sampleAreaId"] = sampleAreaId;
			params["quadratNumber"] = quadratNumber;
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
	} 
});
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getGreenYellowQuadratById();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><input type="text" id='longitude'
					name='longitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[60,150] & addMethode[]" />(度)<i>*</i></td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><input type="text" id='latitude'
					name='latitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[10,60] & addMethode[]" />(度)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>海拔：</td>
				<td class='TableData' colspan='3'><input type="text" id='altitude'
					name='altitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[-160,8849] & addMethod[]" />(米)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>样方编号：</td>
				<td class='TableData' colspan='3'>
					<span id='preNumber'></span>
					<input id='curNumber' name='curNumber' class='SmallInput easyui-validatebox' required="true" validType="integeZero[] & qaNumberIsExist[]"/><i>*</i>
					<input type="hidden" id='quadratNumber' name='quadratNumber'/>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'><span id="percentageTitle"></span>：</td>
				<td class='TableData' colspan="3"><input type="text"
					id='percentage' name='percentage'
					class='SmallInput easyui-validatebox'   validType="numberBetweenLength[0,100] & addMethod[]"  />(%)<i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainor" >
						<div class="attachContainorDiv" style="margin-left:20px;float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">请选择景观照片文件</p>
						   <!-- <input type="file" id="sa_np_landscape_photo" name="sa_np_landscape_photo" onchange="change(this)" style="display: none;" /> -->
					    </div>
					    <i style="float: left;">*</i>
					</div>
				</td>
			</tr>

		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='sampleAreaId' name='sampleAreaId'
			value='<%=sampleAreaId %>' /> <input type='hidden'
			id='investigateDataId' name='investigateDataId' /> <input
			type='hidden' id='quadratType' name='quadratType' />
	</form>
</body>
</html>