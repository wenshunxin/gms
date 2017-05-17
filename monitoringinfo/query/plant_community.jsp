<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
	String cityCode = (String)request.getSession().getAttribute("cityCode");
	String type = request.getParameter("type");
%>

<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="<%=contextPath %>/resource/css/ctrl.css" rel="stylesheet" />
<script src="<%=contextPath%>/monitoringinfo/query/query.js"></script>
<script>
function iFrameHeight(evt) { 
	evt.height = $(evt).parent().height();
}
$('#tabss').resizable({ 
	maxWidth:"100%"
	}); 
$("#tabss").tabs({
	onSelect:function(title,index){
		var content="";
		if(title=="常规观测区" || title=="辅助观测区" || title=="刈割监测区" || title=="火烧管理区"){
			if(<%=type%>=="1"){
				content = "<iframe frameborder='0' width='100%' "
					+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/query/shrubs_observation_area.jsp'>"
			        +"</iframe>";
			}else{
				content = "<iframe frameborder='0' width='100%' "
					+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/query/herb_observation_area.jsp'>"
			        +"</iframe>";
			}
		}else if(title=="永久性观测区"){
			content = "<iframe frameborder='0' width='100%' "
				+"onload='iFrameHeight(this)' src='<%=contextPath %>/monitoringinfo/query/perpetual.jsp?type=<%=type%>'>"
		        +"</iframe>";
		}else if(title=="科研试验区"){
			content = "<iframe frameborder='0' width='100%' "
				+"onload='iFrameHeight(this)' src='<%=contextPath %>/stations_report/index.jsp?type=<%=type%>'>"
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
})

</script>
<div id="tabss" class="easyui-tabs" fit="true" style="width: 100%;">
	<div title="常规观测区" style="padding:10px;" >
     </div>
	<div title="辅助观测区" style="padding:10px;">
    </div>
	<div title="刈割监测区" style="padding:10px;">
    </div>
	<div title="火烧管理区" style="padding:10px;">
    </div>
	<div title="永久性观测区" style="padding:10px;">
    </div>
	<div title="科研试验区" style="padding:10px;">
    </div>
</div>