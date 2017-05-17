<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
 	String name =(String)request.getSession().getAttribute("userName");
	Integer userLevel = (Integer)request.getSession().getAttribute("userLevel");
 	String cityName =(String)request.getSession().getAttribute("cityName");
 	if(userLevel==0){
 		cityName = "农业部管理员";
 	}else{
 		cityName=cityName+"管理员";
 	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<%@ include file="/header/preview.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>全国草原监测信息报送系统</title>
<link href="<%=contextPath %>/frame/menu.css" rel="stylesheet" />
<link href="<%=contextPath %>/resource/css/frame.css" rel="stylesheet" />
<link rel="stylesheet" href="aside.css" />
<script src="<%=contextPath %>/frame/frame.js"></script>
<script>
$(function(){
	$('#asideParent').mouseover(function(){
		$("#foldImg").show();
	});
	$('#asideParent').mouseleave(function(){
		$("#foldImg").hide();
	});
	$("#tabs").tabs({ 
		width:$("#tabs").parent().width(), 
		height:$("#tabs").parent().height() 
		}); 
	$(".bottom_top").click(function(){
		$(this).siblings().toggle();
		if($(this).siblings().is(':hidden')){
			$(this).children("span").css("transform","rotate(-90deg)");
		}else{
			$(this).children("span").css("transform","rotate(0)");
		}	
	});
	$(".bottom_bot_li").click(function(){
        $(".bottom_bot_li").each(function(i){

            $(".bottom_bot_li").eq(i).children("b").hide();
             $(".bottom_bot_li").eq(i).css("background","#307856");
        });                 
		$(this).children("b").show();
		$(this).siblings().children("b").hide();
		$(this).css("background","#2c654a");
		$(this).siblings().css("background","#307856");
	}); 
	
	$('#tabs').tabs({ 
		border:false, 
		onSelect:function(title){ 
			 var tab = $('#tabs').tabs('getSelected');
			 if(title=="首页"){
				 return;
			 }
			 var url = $(tab.panel('options').content).attr("src");
			 $('#tabs').tabs("update",{
			    	tab:tab,
			    	options:{  
			            title:title,  
			            style:{padding:'1px'},  
			            content:'<iframe height="100%" name="indextab" scrolling="auto" src="'+url+'" frameborder="0" style="width:100%;height:100%;"></iframe>',  
				        closable:true,  
				        fit:true,  
				        selected:true  
			         }  
			    });
		}
	});

	$('#westOne').panel({         
	    onExpand:function(){
	    	setTimeout(function(){
				show();
				
			},150)
	    }
	});
});


function fold(){
	$('#dd').layout('collapse','west');
	setTimeout(function(){
		show();
	},10)
}
function show(){
	var tab = $('#tabs').tabs('getSelected');
	var title = tab.panel('options').title;
	 if(title=="固定监测点数据"){
		 var url = $(tab.panel('options').content).attr("src");
		 $('#tabs').tabs("update",{
		    	tab:tab,
		    	options:{  
		            title:title,  
		            style:{padding:'1px'},  
		            content:'<iframe name="indextab" scrolling="auto" src="'+url+'" frameborder="0" style="width:100%;height:100%;"></iframe>',  
			        closable:true,  
			        fit:true,  
			        selected:true  
		         }  
		 });
	 }
}
</script>
</head>
  <body class="easyui-layout" id="dd" >  
     <div region="north"  style="height:80px;line-height:80px;background:#41a675;overflow:hidden;border-bottom:1px solid #258d6a;">
     	<div class="frameTop">
     		<div id="topLeft">
     			<p class="topLeft_p">
     				<span class="logo"></span><b></b><i></i>
     				<span class="span">全国草原监测信息报送管理系统</span>
     			</p>
     			
     		</div>
     		<!--<div id="topRight""></div>
     		<div id="lastRight"></div>-->
     	</div>
     	<div class="frameTips">
     		
     		<div id="tipLeft" style="float:right">
     			<div class="outSystem" onclick="outSystem();"><img title="退出" src="<%=contextPath %>/resource/images/sys/out.png" />退出</div>
     			<!--<div class="outSystem">欢迎您：<%=name %></div>-->
     		</div>
     		
     		<div id="tipLeft" onclick="openMenu('/user/setPassword.jsp','修改密码')">
     			<img title="修改密码" src="<%=contextPath %>/resource/images/sys/pwd.png"/>修改密码
     		</div>
     		<div id="tipLeft" onclick="openMenu('/user/personal.jsp','我的资料')">
     			<!--<img title="密云县系统管理员" src="<%=contextPath %>/resource/images/sys/sysmanager.png"/>密云县系统管理员-->
     			<div class="outSystem"><img title="<%=cityName %>" src="<%=contextPath %>/resource/images/sys/sysmanager.png"/><%=cityName %></div>
     		</div>
     		
     		
     	</div>
     </div>  
     <div id="westOne"  region="west" data-options="region:'west',collapsed:false"  style="width:260px;padding-top:5px;background:#41a675;border:0;">   	<div style="width:280px;height:100%;overflow-y:scroll;position:absolute;" id="asideParent">
		     <div id="aside">
				<div  class="top">
					<img style="margin-right:10px !important" src="../resource/images/sys/nav.png"/>功能导航
					<img id="foldImg" src="<%=contextPath %>/resource/images/sys/foldLeft.png" alt="折叠" title="折叠" onclick="fold()"/>
				</div>
				<div class="bottom">
					<ul class="bottom_ul">
						
					</ul>
				</div>
			</div>
     	</div>
     </div>  
      <div region="center" style="padding:5px;background:#eee;text-align:center;border-top:0;height:auto;">
      	  <%--  <iframe  id="mainFrame" name="mainFrame" frameborder="0" width="100%" height="100%" onLoad="iFrameHeight();" src="<%=contextPath %>/frame/portlet/index.jsp">
      		</iframe> --%>	
	     <div id="tabs" class="easyui-tabs" fit="true">
	       	<div title="首页">
	          <iframe  id="mainFrame" name="mainFrame" frameborder="0" width="100%" height="100%" onLoad="iFrameHeight();" src="<%=contextPath %>/frame/portlet/index.jsp">
      		</iframe>
	       	</div>
	    </div>
      </div>  
  </body>  
</html>