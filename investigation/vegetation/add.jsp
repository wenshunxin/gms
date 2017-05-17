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
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/fileImg.css" rel="stylesheet" />
<script type="text/javascript"
	src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/add.js"></script>
<script type="text/javascript" src="<%=contextPath%>/investigation/common/fileUpload.js"></script>
<style>
	i{color: red;font-size: 16px;font-weight: bold;}
</style>
</head>
<script>
var id = '<%=id%>';
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
		 $('#form1').form("validate");
		 $(this).trigger("blur");
	 });
	 $("#investigateDate").val(getFormatDateTimeStr(new Date().getTime(),"yyyy-MM-dd"));
	 autoNumber();
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

 	 	//地形地貌选择丘陵、山地是否单选框被选中	
 	$("input[name=grassLandscape]").change(function(){
 		var id=$(this).attr("id");
 		if(id=="grassLandscape2" || id=="grassLandscape3"){
 			$("input[name=grassSlope]").removeAttr("disabled");
 			$("input[name=grassSlopePosition]").removeAttr("disabled");
 			$("#grassSlope1").prop("checked","checked");
 			$("#grassSlopePosition1").prop("checked","checked");
 		}else{
 			$("input[name=grassSlope]").attr("disabled","disabled");
 			$("input[name=grassSlopePosition]").attr("disabled","disabled");
 		};
 	});

 	$('input[name=soilMoisture]').change(function(){
 		if($(this).val()=="其他"){
 			$("#soilMoistureOther").removeAttr("disabled").removeClass("readonly");
 		}else{
 			$("#soilMoistureOther").attr("disabled","disabled").addClass("readonly");
 			$("#soilMoistureOther").val("");
 		}
 	})

});

function saveVegetationGrew(){
	$("#investigateArea").val($("#cityInfo").text()+"-"+$("#countyName").val());
	$("#sampleAreaNumber").val($("#preNumber").text()+$("#curNumber").text());
	if($("#form1").form("validate")){
		var url = contextPath+"/gmsVegetationGrewController/saveVegetationGrew.act";
		if(id!="null" && id!=null){
			url = contextPath+"/gmsVegetationGrewController/updateVegetationGrew.act";
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
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(7);
						top.$(".jbox-body").remove();
					 }else{
						top.$.jBox.closeTip();
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.datagrid.datagrid('reload');
						top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.statistics(7);
						var that = top;
				    	top.$(".jbox-body").remove();
						var submit = function (v, h, f) {
						    if(v==2){
						    	that.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.addVegetationGrew();
						    	 return true;
						    }else{
						    	return true;
						    }
						    return true;
						};
						// 自定义按钮
						that.$.jBox.confirm("保存成功", "提示", submit, { buttons: {"继续添加植被长势调查": 2,'关闭':3} });
					 }
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}
}
function getVegetationGrewById(){
	if(id!="null" && id!=null){
		var url = contextPath+"/gmsVegetationGrewController/getVegetationGrewById.act?sid="+id;
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
				$("#curNumber").text(strs[strs.length-1]);
			}
			
			var soilMoisture4=$("#soilMoisture4").attr("checked")
			if(soilMoisture4){
				$("#soilMoistureOther").removeAttr("disabled").removeClass("readonly");		
			}else{
				$("#soilMoistureOther").val("");
			}

			var grassLandscape = json.rtData.basicInfo.grassLandscape;
			if(grassLandscape=="丘陵" || grassLandscape=='山地'){
				$("input[name=grassSlope]").removeAttr("disabled");
 				$("input[name=grassSlopePosition]").removeAttr("disabled");
			}
			//附件信息
			var ldAttachList = json.rtData.ldAttachList;
			for(var i = 0 ;i<ldAttachList.length;i++){
				var attach = ldAttachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorIn .preview").attr("src",encodeURI(attachUrl));
			}
			var olAttachList = json.rtData.olAttachList;
			for(var i = 0 ;i<olAttachList.length;i++){
				var attach = olAttachList[i];
				var attachUrl = encodeURI(contextPath+"/attachController/getAttach.act?attachPath="+attach.attachPath);
				$("#attachContainorOut .preview").attr("src",encodeURI(attachUrl));
			}
			
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}

function autoNumber(){
	var investigateDate = $("#investigateDate").val();
	var month=parseInt(investigateDate.substring(5,7));
 	var url = contextPath+"/gmsInvestigateDataController/autoSampleAreaNumber.act?investigateType=7&investigateDate="+investigateDate;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		$("#preNumber").text(json.rtData.preNumber);
		$("#curNumber").text(month);
		$("#sampleAreaNumber").val(json.rtData.preNumber+$("#curNumber").val());
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	} 
}



/**
 * 数据校验	
 * 
 */
$.extend($.fn.validatebox.defaults.rules, {   
	saNumberIsExist: {   //样方编码是否已存在
		validator: function(value, param){
			var url = contextPath+"/gmsVegetationGrewController/saNumberIsExist.act";
			var param={};
			var investigateDate = $("#investigateDate").val();
			var sampleAreaNumber = $("#preNumber").text()+$("#curNumber").text();
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
	   message: '当月调查数据已存在！！'
	} 
});


function SImage(callback) {  
    var img = new Image();  
    this.img = img;  
    var appname = navigator.appName.toLowerCase();  
    if (appname.indexOf("netscape") == -1) {  
       //ie  
        img.onreadystatechange = function () {  
            if (img.readyState == "complete") {  
                callback(img);  
            }  
        };  
    } else {  
       //firefox  
        img.onload = function () {  
            if (img.complete == true) {  
                callback(img);  
            }  
        };  
    }  
}

SImage.prototype.get = function (url) {  
    this.img.src = url;  
}

</script>
<body style="overflow-x: hidden; font-size: 12px; padding: 20px 0;"
	onload="getVegetationGrewById();">
	<form id="form1" name="form1" method="post"
		enctype="multipart/form-data">
		<table class='TableBlock' style='width: 90%; margin: 0 auto;'>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">基本信息</td>
			</tr>
			<tr>
				<td class='TableData'>调查时间：</td>
				<td class='TableData'>
				<input type="text" id='investigateDate' name='investigateDate' class='SmallInput easyui-validatebox' readonly="readonly" validType="saNumberIsExist[]" /><i>*</i>
				</td>
				<td class='TableData'>海拔：</td>
				<td class='TableData'><input type="text" id='altitude'
					name='altitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[-160,6649] & addMethod[]"/>(米)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>东经：</td>
				<td class='TableData'><input type="text" id='longitude'
					name='longitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[60,150] & addMethode[]" />(度)<i>*</i></td>
				<td class='TableData'>北纬：</td>
				<td class='TableData'><input type="text" id='latitude'
					name='latitude' class='SmallInput easyui-validatebox'  validType="numberBetweenLength[10,60] & addMethode[]"/>(度)<i>*</i></td>

				
			</tr>
			<tr>
				<td class='TableData'>调查人：</td>
				<td class='TableData'><input type="text"
					id='investigateUserNames' name='investigateUserNames'
					class='BigInput easyui-validatebox'  validType="" maxlength="20" /><i>*</i></td>
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
					<span id='preNumber'></span><span id='curNumber' name='curNumber'></span>月长势
					<input type="hidden" id='sampleAreaNumber' name='sampleAreaNumber' class='BigInput' />
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">类型</td>
			</tr>
			<tr>
				<td class='TableData'>草地类：</td>
				<td class='TableData'>
					<input id='grassCategory' name='grassCategory' class='BigInput easyui-combobox'  style="height:28px;line-height: 28px;"/><i>*</i>
				</td>
				<td class='TableData'>草地型：</td>
				<td class='TableData'>
					<input id='grassType' name='grassType' class='BigInput easyui-combobox' style="height:28px;line-height: 28px;"/><i>*</i>
				</td>
			</tr>
			<tr >
				<td class='TableData'>地形地貌：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='grassLandscape1' name='grassLandscape' class='' value="平原" checked="true"/><label
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
				<td class='TableData'>坡向：</td>
				<td class='TableData'><input type="radio" id='grassSlope1'
					name='grassSlope' class='' value="阳坡" disabled="true" checked="true"/><label for="grassSlope1">阳坡</label>
					<input type="radio" id='grassSlope2' name='grassSlope' class=''
					value="半阳坡" disabled="true"/><label for="grassSlope2">半阳坡</label><br /> <input
					type="radio" id='grassSlope3' name='grassSlope' class=''
					value="半阴坡" disabled="true"/><label for="grassSlope3">半阴坡</label> <input
					type="radio" id='grassSlope4' name='grassSlope' class=''
					value="阴坡 " disabled="true"/><label for="grassSlope4">阴坡 </label></td>
				<td class='TableData'>坡位：</td>
				<td class='TableData'><input type="radio"
					id='grassSlopePosition1' name='grassSlopePosition' class=''
					value="坡脚" checked="true" disabled="true"/><label for="grassSlopePosition1">坡脚</label> <input
					type="radio" id='grassSlopePosition2' name='grassSlopePosition'
					class='' value="坡顶"  disabled="true"/><label for="grassSlopePosition2">坡顶</label><br />
					<input type="radio" id='grassSlopePosition3'
					name='grassSlopePosition' class='' value="坡下部" disabled="true"/><label
					for="grassSlopePosition3">坡下部</label> <input type="radio"
					id='grassSlopePosition4' name='grassSlopePosition' class=''
					value="坡中部" disabled="true"/><label for="grassSlopePosition4">坡中部</label> <input
					type="radio" id='grassSlopePosition5' name='grassSlopePosition'
					class='' value="坡上部" disabled="true"/><label for="grassSlopePosition5">坡上部</label>
				</td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">概况</td>
			</tr>
			<tr>
				<td class='TableData'>平均盖度：</td>
				<td class='TableData'><input type="text" id='avgCoverage'
					name='avgCoverage' class='SmallInput easyui-validatebox' validType="numberBetweenLength[0,100] & addMethod[]"/>(%)<i>*</i></td>
				<td class='TableData'>平均高度：</td>
				<td class='TableData'><input type="text" id='avgHighly'
					name='avgHighly' class='SmallInput easyui-validatebox'  validType="integeZeroln[] & addMethod[]"/>(厘米)<i>*</i></td>
			</tr>
			<tr>
				<td class='TableData'>平均鲜草产量：</td>
				<td class='TableData'><input type="text"
					id='avgFreshGrassAmount' name='avgFreshGrassAmount'
					class='SmallInput easyui-validatebox'  validType="integeZeroln[] & addMethodf[]"/>(千克/公顷)<i>*</i></td>
				<td class='TableData'>平均干草产量：</td>
				<td class='TableData'><input type="text" id='avgGrassAmount'
					name='avgGrassAmount' class='SmallInput easyui-validatebox'  validType="integeZeroln[] & addMethodf[]"/>(千克/公顷)<i>*</i></td>
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
				<td class='TableData'>利用状况：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='usingStatus1' name='usingStatus' class='' value="未利用" checked="true"/><label
					for="usingStatus1">未利用</label> <input type="radio"
					id='usingStatus2' name='usingStatus' class='' value="轻度利用" /><label
					for="usingStatus2">轻度利用</label> <input type="radio"
					id='usingStatus3' name='usingStatus' class='' value="合理利用" /><label
					for="usingStatus3">合理利用</label> <input type="radio"
					id='usingStatus4' name='usingStatus' class='' value="超载" /><label
					for="usingStatus4">超载</label> <input type="radio" id='usingStatus5'
					name='usingStatus' class='' value="严重超载" /><label
					for="usingStatus5">严重超载</label></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">评价</td>
			</tr>
			<tr>
				<td class='TableData'>土壤墒情：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='soilMoisture1' name='soilMoisture' class='' value="干旱" checked="true"/><label
					for="soilMoisture1">干旱</label> <input type="radio"
					id='soilMoisture2' name='soilMoisture' class='' value="中等" /><label
					for="soilMoisture2">中等</label> <input type="radio"
					id='soilMoisture3' name='soilMoisture' class='' value="湿润" /><label
					for="soilMoisture3">湿润</label> <input type="radio"
					id='soilMoisture4' name='soilMoisture' class='' value="其他" /><label
					for="soilMoisture4">其他</label> <input type="text"
					id='soilMoistureOther' name='soilMoistureOther'
					class='SmallInput disabled easyui-validatebox' disabled="disabled" />
				</td>
			</tr>
			<tr>
				<td class='TableData'>综合评价：</td>
				<td class='TableData' colspan="3"><input type="radio"
					id='evaluation1' name='evaluation' class='' value="好" checked="true"/><label
					for="evaluation1">好</label> <input type="radio" id='evaluation2'
					name='evaluation' class='' value="中" /><label for="evaluation2">中</label>
					<input type="radio" id='evaluation3' name='evaluation' class=''
					value="差" /><label for="evaluation3">差</label></td>
			</tr>
			<tr>
				<td class='TableData'>备注：</td>
				<td class='TableData' colspan="3"><textarea rows="3" cols="60"
						class="BigTextarea" id="remark" name="remark"></textarea></td>
			</tr>
			<tr>
				<td class="TableHeader" style="text-align: left;" colspan="4">照片</td>
			</tr>
			<tr>
				<td class='TableData' colspan="4">
					<div id="attachContainorIn" style="width:40%;display:inline-block;float:left;">
						<div class="attachContainorDiv" style="float: left;margin-left: 10%">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="sa_vg_landscape_photo" onchange="change(this)" name="sa_vg_landscape_photo" /> 
					        请选择定点景观照片文件</p>
							
					    </div>
					    <i style="float: left;">*</i>
					</div> 
					<div id="attachContainorOut" style="width:40%;display:inline-block;float:left;">
						<div class="attachContainorDiv" style="float: left;margin-left: 10%">
							<div class="temImg" onclick="getImg_W_H.call(this)">
								<img class="preview"   src="<%=contextPath%>/resource/images/sys/fileImg.png"/>
							</div>
					        <p id="p">
								<input type="file" id="sa_vg_overlooking_photo" name="sa_vg_overlooking_photo" onchange="change(this)"/>
					        请选择俯视照片文件</p>
							
					    </div>
					    <i style="float: left;">*</i>
					</div> 
				</td>
			</tr>

		</table>
		<input type='hidden' id='sid' name='sid' value='<%=id %>' /> <input
			type='hidden' id='investigateDataId' name='investigateDataId' />
	</form>
</body>
</html>