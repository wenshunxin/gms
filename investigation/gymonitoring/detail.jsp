<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder"%>
<%
	String dataId = request.getParameter("dataId");
	String sampleAreaId = request.getParameter("sampleAreaId");
	String title = URLDecoder.decode(request.getParameter("title"),"UTF-8");
	int userLevel = (Integer)request.getSession().getAttribute("userLevel");
	String type = request.getParameter("type");
	String datagridIndex = request.getParameter("index");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<script>
var title = '<%=title%>';
var sampleAreaId='<%=sampleAreaId%>';
var userLevel='<%=userLevel%>';
var datagridIndex='<%=datagridIndex%>';
var type='<%=type%>';
$(function(){ 
	$("#tabs").tabs({ 
		width:1000,
		height:486
		});
	getGreenYellowSampleAreaById();
	getQuadratList();
	if(datagridIndex=="null"){
		return;
	}
	$("#tabs li").each(function(index,value){
		$(this).click(function(){
			var selectTitle = $(this).text();
			if(index==0){
				var url = contextPath+"/gmsGreenYellowSampleAreaController/getGreenYellowSampleAreaById.act?sid="+sampleAreaId;
				var json = tools.requestJsonRs(url);
				if(json.rtState){
					var recordsType = json.rtData.basicInfo.recordsType;
					var param = {};
					param["investigateDataId"]=json.rtData.basicInfo.investigateDataId;
					param["sampleAreaId"]=json.rtData.basicInfo.sid;
					param["quadratId"]=0;
					param["investigateType"] = type;
					top.$(".jbox-button").each(function(){
						if($(this).text()=="通过" || $(this).text()=="驳回"){
							$(this).remove();
						}
					});
					if(userLevel=="2"){//市级审核
						if(recordsType==0 || recordsType==1 || recordsType==2){
							
						}else{
							var approvedButton = $("<button>").text("通过").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
								$(this).addClass("jbox-button-hover");
							},function(){
								$(this).removeClass("jbox-button-hover");
							}).click(function(){
								top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.approved(param,datagridIndex);
							});
							
							var rejectedButton = $("<button>").text("驳回").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
								$(this).addClass("jbox-button-hover");
							},function(){
								$(this).removeClass("jbox-button-hover");
							}).click(function(){
								top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.rejected(param,datagridIndex);
							});
							top.$(".jbox-button-panel span").after(rejectedButton);
							top.$(".jbox-button-panel span").after(approvedButton);
						}
					}
					if(userLevel=="1"){//省级审核
						 if(recordsType==2 || recordsType==3){
							top.$(".jbox-button").each(function(){
								if($(this).text()=="通过" || $(this).text()=="驳回"){
									$(this).remove();
								}
							});
						 }else{
							var approvedButton = $("<button>").text("通过").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
								$(this).addClass("jbox-button-hover");
							},function(){
								$(this).removeClass("jbox-button-hover");
							}).click(function(){
								top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.approved(param,datagridIndex);
							});
							
							var rejectedButton = $("<button>").text("驳回").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
								$(this).addClass("jbox-button-hover");
							},function(){
								$(this).removeClass("jbox-button-hover");
							}).click(function(){
								top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.rejected(param,datagridIndex);
							});
							top.$(".jbox-button-panel span").after(rejectedButton);
							top.$(".jbox-button-panel span").after(approvedButton);
						 }
					}
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}else{
				var url = contextPath+"/gmsGreenYellowQuadratController/getQuadratListByDataId.act?dataId=<%=dataId%>";
				var json = tools.requestJsonRs(url);
				if(json.rtState){
					var data = json.rtData;
					for(var i=0;i<data.length;i++){
						if(data[i].quadratNumber==selectTitle){
							var recordsType = data[i].recordsType;
							var param = {};
							param["investigateDataId"]=data[i].investigateDataId;
							param["sampleAreaId"]=data[i].sampleAreaId;
							param["quadratId"]=data[i].sid;
							param["investigateType"] = type;
							top.$(".jbox-button").each(function(){
								if($(this).text()=="通过" || $(this).text()=="驳回"){
									$(this).remove();
								}
							});
							if(userLevel=="2"){//市级审核
								if(recordsType==0 || recordsType==1 || recordsType==2){
									
								}else{
									var approvedButton = $("<button>").text("通过").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
										$(this).addClass("jbox-button-hover");
									},function(){
										$(this).removeClass("jbox-button-hover");
									}).click(function(){
										top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.approved(param,datagridIndex);
									});
									
									var rejectedButton = $("<button>").text("驳回").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
										$(this).addClass("jbox-button-hover");
									},function(){
										$(this).removeClass("jbox-button-hover");
									}).click(function(){
										top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.rejected(param,datagridIndex);
									});
									top.$(".jbox-button-panel span").after(rejectedButton);
									top.$(".jbox-button-panel span").after(approvedButton);
								}
							}
							if(userLevel=="1"){//省级审核
								 if(recordsType==2 || recordsType==3){
									
								 }else{
									 var approvedButton = $("<button>").text("通过").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
										$(this).addClass("jbox-button-hover");
									},function(){
										$(this).removeClass("jbox-button-hover");
									}).click(function(){
										top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.approved(param,datagridIndex);
									});
									
									var rejectedButton = $("<button>").text("驳回").addClass("jbox-button").css({"padding":"0 10px"}).hover(function(){
										$(this).addClass("jbox-button-hover");
									},function(){
										$(this).removeClass("jbox-button-hover");
									}).click(function(){
										top.$("#tabs").tabs("getSelected").find('iframe')[0].contentWindow.rejected(param,datagridIndex);
									});
									top.$(".jbox-button-panel span").after(rejectedButton);
									top.$(".jbox-button-panel span").after(approvedButton);
								 }
							}
						}
					}
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
			
			
		});
	});
	
}); 
function iFrameHeight() {  
	var ifm= document.getElementById("mainFrame");   
	var subWeb = document.frames ? document.frames["mainFrame"].document : ifm.contentDocument;   
	if(ifm != null && subWeb != null) {
	   ifm.height = 485;
	}   
}

function getGreenYellowSampleAreaById(){
	if(sampleAreaId!="null" && sampleAreaId!=null){
		var url = contextPath+"/gmsGreenYellowSampleAreaController/getGreenYellowSampleAreaById.act?sid="+sampleAreaId;
		var json = tools.requestJsonRs(url);
		if(json.rtState){
			var tab = $('#tabs').tabs('getTab',"样地详情");
	    	$('#tabs').tabs("update",{
	    		tab:tab,
	    		options: {
	                 title: json.rtData.basicInfo.sampleAreaNumber,
	                 closable: false
	             }
	    	});
		}else{
			$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
		}
	}
}
function getQuadratList(){
	var url = contextPath+"/gmsGreenYellowQuadratController/getQuadratListByDataId.act?dataId=<%=dataId%>";
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		for(var i=0;i<data.length;i++){
			(function(i){
				var type = "g";
				if(data[i].quadratType==0){
					type = "g";
				}else{
					type="y";
				}
				var qurl = "/investigation/gymonitoring/qdDetail.jsp?id="+data[i].sid+"&type="+type;
				var content = "<iframe frameborder=\"0\" style=\"width:100%;height:100%;\" onLoad=\"iFrameHeight();\" src=\""+contextPath+qurl+"\"></iframe>"
				if ($('#tabs').tabs('exists', data[i].quadratNumber)){
			        //$('#tabs').tabs('select', data[i].quadratNumber);    
			    }else{
			    	$('#tabs').tabs('add',{
			    		title: data[i].quadratNumber,
			    		content: content,
			    		style:{"padding":"10px"},
			    		closable: false
			    	});
			    } 
			})(i);
		}
		$('#tabs').tabs('select',title);  
	}else{
		$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
	}
}
</script>
<body
	style="overflow-x: hidden; font-size: 12px; margin: 0 auto; width: 100%; height: 100%;"
	onload="">
	<div id="tabs" class="easyui-tabs">
		<div title="样地详情" style="padding: 10px">
			<iframe id="mainFrame" name="mainFrame" frameborder="0" width="100%"
				height="100%" onload="iFrameHeight()"
				src="<%=contextPath %>/investigation/gymonitoring/saDetail.jsp?id=<%=sampleAreaId %>">
			</iframe>
		</div>
	</div>
</body>
</html>