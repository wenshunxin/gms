<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String cityCode = (String)request.getSession().getAttribute("cityCode");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="<%=contextPath %>/monitoringinfo/monitoring.js"></script>
<script>
$(function(){
	var height = (document.documentElement.clientHeight)+"px";
	$("#tabss").css("height",height);
	$("#tabss").tabs({
		onSelect:function(title,index){
			var content="";
			var sId = $("#monitoringStationsId").val();
			var url = changeMonitoring(sId);
			if(url==undefined){
				return;
			}
			if(title=="常规观测区" || title=="辅助观测区" || title=="刈割监测区" || title=="火烧管理区"){
				content = "<iframe id='general' frameborder='0' width='100%' "
					+"onload='iFrameHeight(this)' src='"+url+"'>"
			        +"</iframe>";
			}else if(title=="生态状况调查"){
				content = "<iframe frameborder='0' width='100%' "
					+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/ms_ecological.jsp'>"
			        +"</iframe>";
			}else if(title=="物候期及降雪观测"){
				content = "<iframe frameborder='0' width='100%' "
					+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/ms_phenological.jsp'>"
			        +"</iframe>";
				
			}else if(title=="经济社会指标"){
				content = "<iframe frameborder='0' width='100%' "
					+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/ms_social.jsp'>"
			        +"</iframe>";
				
			}
			var tab = $('#tabss').tabs('getSelected');
	    	$('#tabss').tabs("update",{
	    		tab:tab,
	    		options: {
	                 content: content,
	                 closable: false,
	                 selected:true
	             }
	    	});
		}
	});

 	$("#monitoringStationsId").change(function(){
		var stationId = $(this).val();
		if(stationId==""){
			return;
		}
		var sId = $("#monitoringStationsId").val();
		var url = changeMonitoring(sId);
		var content = "<iframe id='general' frameborder='0' width='100%' onload='iFrameHeight(this)' src='"+url+"'></iframe>";
		var tab = $('#tabss').tabs('getSelected');
		var title = $('.tabs-selected').text();  
	 	if(title=="生态状况调查"){
	 		content = "<iframe frameborder='0' width='100%' "
				+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/ms_ecological.jsp'>"
		        +"</iframe>";
		} else if(title=="物候期及降雪观测"){
			content = "<iframe frameborder='0' width='100%' "
				+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/ms_phenological.jsp'>"
		        +"</iframe>";
		}else if(title=="经济社会指标"){
			content = "<iframe frameborder='0' width='100%' "
				+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/ms_social.jsp'>"
		        +"</iframe>";
		}
		$('#tabss').tabs("update",{
			tab:tab,
			options: {
		           content: content,
		           closable: false,
		           selected:true
		     }
		});
	}); 

});

function doInit(){
	var url = contextPath+"/monitoringStationsController/getMonitoringStationsDatagrid.act?cityCode=<%=cityCode%>";
	var json = tools.requestJsonRs(url);
	if(json.total>0){
		for(var i=0;i<json.rows.length;i++){
			html="<option value='"+json.rows[i].sid+"'>"+json.rows[i].stationsNum+"</option>";
			$("#monitoringStationsId").append(html);
		}
		var sId = $("#monitoringStationsId").val();
		var url = changeMonitoring(sId);
		var content = "<iframe id='general' frameborder='0' width='100%' onload='iFrameHeight(this)' src='"+url+"'></iframe>";
		var tab = $('#tabss').tabs('getSelected');
		$('#tabss').tabs("update",{
			tab:tab,
			options: {
		           content: content,
		           closable: false,
		           selected:true
		         }
		});
	}else{
		$("#tabss").remove();
		messageMsg("当前县（旗）下没有固定监测点,不可录入信息！","msg","warning");
	}
 }
 function iFrameHeight(evt) { 
	evt.height = $(evt).parents(".easyui-tabs").height()-110;
}
</script>
</head>
<body onload="doInit();" style="font-size: 12px;border-left:0;">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png'/><b class="first">当前位置：固定监测点》<b class="second">监测信息录入</b></b>
		</div>
		<table class='TableBlock' style='width: 100%;border-bottom: 0;border-left:0;'>
			<tr >
				<td class='TableData' width="10%">选择监测点：</td>
				<td class='TableData' width='10%'>
					<select class='BigSelect' id='monitoringStationsId' name='monitoringStationsId' style="width:180px;">
					</select>
				</td>
				<td class='TableData' width='10%'>调查类型:</td>
				<td class='TableData' id="td"></td>
			</tr>
		</table>
		<div id='msg'></div>
		<div id="tabss" class="easyui-tabs" fit="true">
			<div title="常规观测区" >
	      
	       	</div>
			<div title="辅助观测区">
	       
	       	</div>
			<div title="刈割监测区">
	         
	       	</div>
			<div title="火烧管理区">
	         
	       	</div>
			<div title="生态状况调查">
	         
	       	</div>
			<div title="物候期及降雪观测">
	         
	       	</div>
			<div title="经济社会指标">
	         
	       	</div>
		</div>
</body>
</html>