<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	String type = (String)request.getParameter("type");
	String quadratSize = (String)request.getParameter("quadratSize");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resource/layer/layer.js"></script>
	
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<style>
	i{color:red;font-size: 16px;font-weight: bold;}
</style>

</head>

<script>
var id = '<%=id%>';
var type = '<%=type%>';
var quadratSize = '<%=quadratSize%>';
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
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 autoNumber();
	 $("#changeDate").datetimepicker({
		 language:"zh-CN",   
		 minView:"month",
		 format:"yyyy-mm-dd",
		 startDate:"",
		 todayBtn: true,
		 todayHighlight : true,  
		 endDate : new Date(),
	     autoclose: true
	 });
	 $("#changeDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 
	 getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
	 
	 $('#grassCategory').combobox({
		 onSelect: function(param){
			 var categoryNo = param.categoryNo;
			 getChildListByTypeCode("GRASSLAND_TYPE_"+categoryNo,"grassType");
			
		 }
	 });
	 $('#grassCategory').combobox('textbox').bind('click',function(){
		 $('#grassCategory').combobox('showPanel');
	 });
	 $('#grassType').combobox('textbox').bind('click',function(){
		 $('#grassType').combobox('showPanel');
	 });
	 getCityInfo("cityInfo");
	 getProvinceAndCounty("investigateCompanyName");
 	
	if(quadratSize!="0" && quadratSize!="null"){
		$("#curNumber").attr("disabled","disabled");
	}

});
function saveGreenYellowSampleArea(){
	$("#investigateArea").val($("#cityInfo").text()+"-"+$("#countyName").val());
	$("#sampleAreaNumber").val($("#preNumber").text()+$("#curNumber").val());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsGreenYellowSampleAreaController/saveGreenYellowSampleArea.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsGreenYellowSampleAreaController/updateGreenYellowSampleArea.act";
		}
		top.$.jBox.tip("数据保存中", 'loading');
		$("#form1").ajaxSubmit({
			type:'post',
			url:url,
			complete:function(data){
				var json =eval("("+data.responseText+")");
				if(json.rtState){
					if(id!="null" && id!=null){
						top.$.jBox.tip(json.rtMsg,"success");
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						if(type=="g"){
							top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(5);
						}else{
							top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(6);
						}
						top.$(".jbox-body").remove();
					 }else{
						var data = json.rtData;
						top.$.jBox.closeTip();
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						if(type=="g"){
							top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(5);
						}else{
							top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(6);
						}
						var that = top;
				    	top.$(".jbox-body").remove();
						var submit = function (v, h, f) {
						    if (v == 1){
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addGreenYellowSampleArea();
						        return true;
						    } else if(v==2){
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addQuadrat(data.sid);
						    	 return true;
						    }else{
						    	return true;
						    }
						    return true;
						};
						// 自定义按钮
						if(type=="g"){
							that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加返青期样地': 1,"添加返青期样方": 2,'关闭':3}});
						}else{
							that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {'继续添加枯黄期样地': 1,"添加枯黄期样方": 2,'关闭':3}});
						}
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function getGreenYellowSampleAreaById(){
	var fileInput=null;
	if(type=="g"){
		$("#sampleAreaType").val(0);
		fileInput = $("<input type='file'>").attr("name","sa_gn_landscape_photo").attr("id","sa_gn_landscape_photo").change(function(){
			change(this);
		});
		$("#p").append(fileInput);
		
	}else{
		$("#sampleAreaType").val(1);
		fileInput = $("<input type='file'>").attr("name","sa_yw_landscape_photo").attr("id","sa_yw_landscape_photo").change(function(){
			change(this);
		});;
		// $("#attachContainor").after("<input type='file' name='sa_yw_landscape_photo' id='sa_yw_landscape_photo'/> ");
		 $("#p").append(fileInput);
	}
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsGreenYellowSampleAreaController/getGreenYellowSampleAreaById.act?sid="+id;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			//基本信息
			bindJsonObj2Cntrl(json.rtData.basicInfo);
			$('#grassCategory').combobox('setValue', json.rtData.basicInfo.grassCategory);
			getChildListByTypeCode("GRASSLAND_TYPE_"+json.rtData.basicInfo.grassCategory,"grassType");
			$('#grassType').combobox('setValue', json.rtData.basicInfo.grassType);
			var area = json.rtData.basicInfo.investigateArea;
			var index = area.indexOf("-");
			if(index>-1){
				var countyName= area.substring(index+1,area.length);
				$("#countyName").val(countyName);
			}
			var sampleAreaNumber = json.rtData.basicInfo.sampleAreaNumber;
			if(sampleAreaNumber){
				var strs = sampleAreaNumber.split("-");
				$("#curNumber").val(strs[strs.length-1]);
			}
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

function autoNumber(){
	var investigateDate = $("#investigateDate").val();
	var investigateType=5;
	if(type=="g"){
		investigateType=5
	}else{
		investigateType=6;
	}
	var url = contextPath+"/gmsInvestigateDataController/autoSampleAreaNumber.act?investigateType="+investigateType+"&investigateDate="+investigateDate;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		$("#preNumber").text(json.rtData.preNumber);
		$("#curNumber").val(json.rtData.curNumber);
		$("#sampleAreaNumber").val(json.rtData.preNumber+$("#curNumber").val());
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}

//创建image对象获得原始宽高
function getNaturalWidthAndHeight(img) {
	var image = new Image();
	image.src = img.src;
	return [image.width,image.height];
}
     /**
      * 数据校验	
      * 
      */
     $.extend($.fn.validatebox.defaults.rules, {   
     	saNumberIsExist: {   //样方编码是否已存在
     		validator: function(value, param){
     			var url = contextPath+"/gmsGreenYellowSampleAreaController/saNumberIsExist.act";
     			var param={};
     			var investigateDate = $("#investigateDate").val();
     			var sampleAreaNumber = $("#preNumber").text()+$("#curNumber").val();
     			param["investigateDate"] = investigateDate;
     			param["sampleAreaNumber"] = sampleAreaNumber;
     			if(id!="null" && id!=null){
     				param["sid"]=id;
     			}
     			var json = tools.requestJsonRs(url,param);
     			if(json.rtState){
     				if(json.rtData){
     					return false;
     				}
     			}
     			return true;
     			
     		},  
     	   message: '当前样地编码已存在，请重新输入！'
     	} 
     });
</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getGreenYellowSampleAreaById();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'><input type="text" id='investigateDate'
					name='investigateDate' autocomplete="off"
					class='SmallInput easyui-validatebox ' readonly="readonly" /><i>*</i>
				</td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><input type="text" id='altitude'
					name='altitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[-160,8849] & addMethod[]" />(米)<i>*</i></td>
			</tr>
			<tr>			
				<td class='TableData'>东经：</td>
				<td class='TableData'><input type="text" id='longitude'
					name='longitude' class='SmallInput easyui-validatebox'   validType="numberBetweenLength[60,150] & addMethode[]" />(度)<i>*</i></td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><input type="text" id='latitude'
					name='latitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[10,60] & addMethode[]"/>(度)<i>*</i></td>
			</tr>
			<tr>				
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text"
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox' validType="" maxlength="20" /><i>*</i></td>
				<td class='TableData'>调查单位：</td>
				<td class='TableData'><input type="text"
					id='investigateCompanyName' name='investigateCompanyName'
					class='BigInput easyui-validatebox'   validType="" /><i>*</i></td>
				
			</tr>
			<tr>
				<td class='TableData'>所在区域：</td>
				<td class='TableData'>
					<span id="cityInfo"></span>
					<input type="hidden" id='investigateArea' name='investigateArea' class='BigInput easyui-validatebox' /></td>
				<td class='TableData'>乡镇：</td>
				<td class='TableData'><input id="countyName" name="countyName" class="BigInput" maxlength="20" /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>样地编号：</td>
				<td class='TableData' colspan='3'>
					<span id='preNumber'></span><input id='curNumber' name='curNumber' class='SmallInput easyui-validatebox' required="true" validType="integeZero[] & saNumberIsExist[]"/><i>*</i>
					<input type="hidden" id='sampleAreaNumber' name='sampleAreaNumber' class='BigInput' />
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData' colspan="3">
					<input id='grassCategory' name='grassCategory' class='BigInput easyui-combobox' style="height:28px;line-height: 28px;"/><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>草地型：</td>
				<td class='TableData' colspan="3"> 
					<input id='grassType' name='grassType' class='BigInput easyui-combobox' style="height:28px;line-height: 28px;"/><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>地形地貌：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='grassLandscape1' name='grassLandscape' class='' value="平原" checked="true" /><label
					for="grassLandscape1">平原</label>  <input type="radio"
					id='grassLandscape4' name='grassLandscape' class='' value="高原" /><label
					for="grassLandscape4">高原</label> <input type="radio"
					id='grassLandscape5' name='grassLandscape' class='' value="盆地" /><label
					for="grassLandscape5">盆地</label><input type="radio"
					id='grassLandscape2' name='grassLandscape' class='' value="丘陵" /><label
					for="grassLandscape2">丘陵</label> <input type="radio"
					id='grassLandscape3' name='grassLandscape' class='' value="山地" /><label
					for="grassLandscape3">山地</label></td>
			</tr>
			<tr>
				<td class='TableData'>
				
					<% if(type.equals("g")){ %>
						返青主要牧草种类：
					<%}else{ %>
						枯黄主要牧草种类：
					<%} %>
				</td>
				<td class='TableData' colspan="3"><input type="text"
					id='mainGrassTypes' name='mainGrassTypes'
					class='BigInput easyui-validatebox' /><i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>
				<% if(type.equals("g")){ %>
					返青日期：
				<%}else{ %>
					枯黄日期：
				<%} %>
				</td>
				<td class='TableData' colspan="3"><input type="text"
					id='changeDate' name='changeDate'
					class='SmallInput easyui-validatebox ' readonly="readonly" /><i>*</i>
				</td>
			</tr>
			<tr>
				<td class='TableData'>与常年比较：</td>
				<td class='TableData' colspan="3"><select id="changeDaysType"
					name="changeDaysType" class="BigSelect">
						<option value="提前">提前</option>
						<option value="推迟">推迟</option>
				</select> <input type="text" id='changeDaysNum' name='changeDaysNum'
					class='SmallInput easyui-validatebox'   validType="integeZero[]"/>(天)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>与上年比较：</td>
				<td class='TableData' colspan="3"><select id="preYearDaysType"
					name="preYearDaysType" class="BigSelect">
						<option value="提前">提前</option>
						<option value="推迟">推迟</option>
				</select> <input type="text" id='preYearDaysNum' name='preYearDaysNum'
					class='SmallInput easyui-validatebox'  validType="integeZero[]"/>(天)<i>*</i></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">利用</td>
			</tr>
			<tr>
				<td class='TableData'>利用方式：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='usingType1' name='usingType' class='' value="打草场" checked="true" /><label
					for="usingType1">打草场</label> <input type="radio" id='usingType2'
					name='usingType' class='' value="冷季放牧" /><label for="usingType2">冷季放牧</label>
					<input type="radio" id='usingType3' name='usingType' class=''
					value="暖季放牧" /><label for="usingType3">暖季放牧</label> <input
					type="radio" id='usingType4' name='usingType' class='' value="春季放牧" /><label
					for="usingType4">春季放牧</label> <input type="radio" id='usingType5'
					name='usingType' class='' value="全年放牧" /><label for="usingType5">全年放牧</label>
					<input type="radio" id='usingType6' name='usingType' class=''
					value="禁牧" /><label for="usingType6">禁牧</label> <input type="radio"
					id='usingType7' name='usingType' class='' value="其他" /><label
					for="usingType7">其他</label></td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3">
					<% if(type.equals("g")){ %>
						<textarea rows="3" cols="60" class="BigTextarea" id="remark" name="remark" placeholder="返青条件变化情况"></textarea>
					<%}else{ %>
						<textarea rows="3" cols="60" class="BigTextarea" id="remark" name="remark" placeholder="枯黄条件变化情况"></textarea>
					<%} %>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData TableDataLast' colspan="4">
					<div id="attachContainor" >
						<div class="attachContainorDiv" style="margin-left:20px; float: left;">
							<div class="temImg" onclick="getImg_W_H.call(this)" >
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
			type='hidden' id='investigateDataId' name='investigateDataId' /> <input
			type='hidden' id='sampleAreaType' name='sampleAreaType' />
	</form>
</body>
</html>