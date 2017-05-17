<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%
	String name =(String)request.getSession().getAttribute("userName");

%>
<html>
<head>
<title>草原监测信息报送系统欢迎页</title>
<style>
	p{
		text-align: left;
		line-height: 26px;
		font-size: 16px;
		text-indent:2em;
		margin:0;
	}
	h4{
		text-align: left;
		color:#41a675;
		margin-top:10px;
		margin-bottom: 10px;
	}
	.h2{
		color:#41a675;
		margin:15px 0;
	}
</style>
</head>

<body>
	<center>
	<div id="content" style="padding:0px 30px 10px;">
		<h2 class="h2">系统功能介绍</h2>
        <p >此系统应用网络、数据库等技术对全国草原监测数据进行录入和管理，实现监测数据的快速录入、分级处理、集中管理、资源共享等功能。系统包括常规监测报送、常规监测审核、固定监测点、数据查询、年度监测计划、数据下载、系统管理七大模块。</p>
		<h4>常规监测报送</h4>		 
		<p>县级用户将常规监测数据（包括盛期地面调查、补饲调查、生态环境调查、返青期调查、植被长势调查、枯黄期调查）进行录入和上报。</p>
		<h4>常规监测审核</h4>
		<p>省级和市级用户对常规监测数据进行逐级审核，审核不通过的数据将被打回县级，重新修改后再上报。</p>		 
		<h4>固定监测点</h4>		 
		<p>县级用户将固定监测点数据（包括常规监测区、辅助监测区、刈割监测区、火烧监测区、永久监测区）、生态状况调查数据、物候观测数据和当地经济社会数据以及相关资料进行录入。</p>		 
		<h4>数据查询</h4>		 
		<p>根据不同查询条件对常规监测数据和固定监测点数据进行查询。</p>		 
		<h4>年度监测计划</h4>		 
		<p>年度监测计划的管理，以及对各省监测计划实施情况的统计。</p>	 
		<h4>数据下载</h4>		 
		<p>常规监测数据和固定监测数据按条件进行批量下载。</p>		 
		<h4>系统管理</h4>
        <p>包括用户管理、调查人员管理、监测点管理和其他指标管理。</p>	
	</div>
	</center>
</body>
</html>
