<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	String contextPath = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ contextPath + "/";
%>
<!-- jQuery库 -->
<link rel="shortcut icon" href="<%=contextPath %>/favicon.ico"
	type="image/x-icon" />
<link href="<%=contextPath %>/resource/css/bootstrap.css"
	rel="stylesheet" />
<link href="<%=contextPath %>/resource/css/style.css" rel="stylesheet" />
<link
	href="<%=contextPath %>/resource/bootstrap/css/bootstrap-theme.css"
	rel="stylesheet" />
<link
	href="<%=contextPath %>/resource/bootstrap/css/bootstrap-datetimepicker.css"
	rel="stylesheet" />

<script src="<%=contextPath %>/resource/js/jquery/jquery-1.11.3.min.js"></script>
<script type="text/javascript">
window.UEDITOR_HOME_URL = "<%=contextPath%>/resource/js/ueditor/";
$.browser = {};
$.browser.mozilla = /firefox/.test(navigator.userAgent.toLowerCase());
$.browser.webkit = /webkit/.test(navigator.userAgent.toLowerCase());
$.browser.opera = /opera/.test(navigator.userAgent.toLowerCase());
$.browser.msie = /msie/.test(navigator.userAgent.toLowerCase());
</script>


<script src="<%=contextPath %>/resource/bootstrap/js/bootstrap.min.js"></script>
<script
	src="<%=contextPath %>/resource/bootstrap/js/bootstrap-datetimepicker.js"></script>
<script
	src="<%=contextPath %>/resource/bootstrap/js/bootstrap-datetimepicker.zh-CN.js"></script>

<!-- jbox -->
<script type="text/javascript"
	src="<%=contextPath %>/resource/jBox/jquery.jBox-2.3.min.js"></script>
<script type="text/javascript"
	src="<%=contextPath %>/resource/jBox/i18n/jquery.jBox-zh-CN.js"></script>
<link type="text/css" rel="stylesheet"
	href="<%=contextPath %>/resource/jBox/Skins2/Green/jbox.css" />

<!-- 其他工具库类 -->
<script src="<%=contextPath %>/resource/js/tools.js"></script>
<script src="<%=contextPath %>/resource/js/sys.js"></script>
<script type="text/javascript" src="<%=contextPath%>/resource/layer/layer.js"></script>


<link
	href="<%=contextPath %>/resource/layer/skin/default/layer.css"
	rel="stylesheet" />

<script type="text/javascript">
/** 变量定义 **/
var contextPath = "<%=contextPath %>";
$(document).ajaxComplete(function(event, xhr, settings) { 
	if(xhr.getResponseHeader("sessionstatus")=="timeOut"){ 
		if(xhr.getResponseHeader("loginPath")){
			window.location.replace(xhr.getResponseHeader("loginPath")); 
		}
	} 
}); 
</script>
</script>

