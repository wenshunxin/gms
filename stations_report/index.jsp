<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int userId = (Integer)request.getSession().getAttribute("id");
	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
	String type = request.getParameter("type");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var datagrid;
var userLevel = '<%= userLevel%>';
var userCityCode = "<%= userCityCode %>";
function doInit(){
	getProvince();
	cityPrivSettingForQuery();
	$("#beginStationsBuildingDate,#endStationsBuildingDate").datetimepicker({
	 language:"zh-CN",   
	 minView:"month",
	 format:"yyyy-mm-dd",
	 startDate:"",
	 todayBtn: true,
	 todayHighlight : true,  
	 endDate : new Date(),
	    autoclose: true
	})
	
	if(userLevel==3){
		$("#delBtn").show();
	}else{
		$("#delBtn").hide();
	}
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
	var cityCode="";
	if(county!=""){
	cityCode = county;
	}else if(city!=""){
	cityCode = city;
	}else if(province!=""){
	cityCode = province;
	}else{
	cityCode = "000000";
	}
	var queryParams=tools.formToJson($("#form1"));
	queryParams["cityCode"] = cityCode;
	var url = contextPath+"/stationsReportController/getStationsReportDatagrid.act?type=<%=type%>";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:false,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		queryParams:queryParams,
		columns:[[
			{field:'sid',checkbox:true,title:'ID',width:30,align:'center'},
			{field:'index',title:'序号',width:30,align:'center',formatter:function(e,rowData,index){
				return index+1;
			}},
			{field:'cityCode',title:'监测点所在地',width:100,align:'center',formatter:function(e,rowData,index){
				var jsonObj = getCityFullInfo(rowData.cityCode);
				if(jsonObj!=null){
					return jsonObj.provinceFullName+"  "+jsonObj.cityFullName+"  "+jsonObj.countyFullName;
					}
				}
			},
			{field:'year',title:'调查年份',width:100,align:'center'},
			{field:'attachName',title:'文件名',width:100},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				var ext = rowData.attachSuffix;
				var downUrl = encodeURI(contextPath+"/attachController/download.act?attachPath="+rowData.attachPath);
				/* if(ext=="gif" || ext=="jpg" || ext=="png" || ext=="bmp"){
					return "<a href='javascript:void(0);' onclick='eidtStationsReport("+rowData.sid+")'>浏览</a>"
							+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='"+encodeURI(downUrl)+"'>下载</a>";
				}else{
				} */
				return "<a href='"+encodeURI(downUrl)+"'>下载</a>";
			}}
		]]
	});
}

function addStationsReport(){
	top.$.jBox("iframe:../stations_report/add.jsp", {
		title:"科研试验区报告录入",
		top:0,
	    width: 1000,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveStationsReport();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }
	  });
}


function eidtStationsReport(id){
	top.$.jBox("iframe:../StationsReport/add.jsp?id="+id, {
		title:"修改科研报告",
		top:0,
		width: 600,
		height: 250,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.saveStationsReport();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function deleteStationsReport(){
	var ids = getSelectItem();
	if(ids.length>0){
		$.jBox.confirm("确定删除科研报告信息吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/stationsReportController/deleteStationsReportById.act?sids="+ids;
				var json = tools.requestJsonRs(url);
				if(json.rtState){
					top.$.jBox.tip(json.rtMsg,"success");
					datagrid.datagrid("reload");
					datagrid.datagrid("unselectAll");
				}else{
					$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
				}
			}
		});
	}else{
		$.jBox.tip("至少选中一条信息","info");
	}
}



/**
 * 获取选中值
 */
function getSelectItem(){
	var selections = datagrid.datagrid('getSelections');
	var ids = "";
	for(var i=0;i<selections.length;i++){
		ids+=selections[i].sid;
		if(i!=selections.length-1){
			ids+=",";
		}
	}
	return ids;
}

/**
 * 
 *通用查询方法
 * @returns
 */
function doSearch(){
	 var province = $("#province").val();
	 var city = $("#city").val();
	 var county = $("#county").val();
	 var cityCode="";
	 if(county!=""){
		cityCode = county;
	 }else if(city!=""){
		cityCode = city;
	 }else if(province!=""){
		cityCode = province;
	 }else{
		cityCode = "";
	 }
	 var queryParams=tools.formToJson($("#form1"));
	 queryParams["cityCode"] = cityCode;
	 datagrid.datagrid('options').queryParams=queryParams; 
	 datagrid.datagrid("reload");
}


function doReset(){
	document.getElementById("form1").reset(); 
	getProvince();
	cityPrivSettingForQuery();
}
function toggll(evt){
	$("#form1").toggle();
	datagrid.datagrid("reload");
	var src=$(evt).attr("src");
	if(src=="/gms/resource/images/sys/down.png"){
		src=contextPath+"/resource/images/sys/up.png";
		$(evt).attr("src",src);
		$(evt).attr("title","收起");
	}else{
		src=contextPath+"/resource/images/sys/down.png";
		$(evt).attr("src",src);
		$(evt).attr("title","展开");
	}
}

</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">

	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
	<table class='TableBlock' fit="true"  style='width:100%; margin: 0 auto; border-bottom: 0;'>
		<tr class="TableHeader">
			<td class='TableData'  style="text-align: left;border-bottom: 0;">
				查询条件
			</td>
			<img src="<%=contextPath%>/resource/images/sys/down.png" title='展开' alt='展开/收起' style="position:absolute;top:3px;right:0;float:right;cursor: pointer;margin-right: 0px; z-index: 20" onclick='toggll(this)'>
		</tr>
	 </table>
		<form id="form1" name="form1" method="post" style="display: none;">
		<div>
			<table class='TableBlock' style='width:100%; margin: 0 auto;'>
			<tr>
				<td class='TableData' >监测点所在地：</td>
						<td class='TableData'>省： <select name="province" id="province"
						onchange="getCity();" class="BigSelect easyui-validatebox">
							<option value="">请选择</option>
					</select> 市： <select name="city" id="city" onchange="getCounty();"
						class="BigSelect easyui-validatebox">
							<option value="">请选择</option>
					</select> 县： <select name="county" id="county"
						class="BigSelect easyui-validatebox">
							<option value="">请选择</option>
					</select>
					<input type="hidden" id='cityCode' name='cityCode' class='SmallInput easyui-validatebox' />
				</td>
				<td class='TableData'>年份：</td>
				<td class='TableData'>
					<select id="beginYear" class="BigSelect" name="beginYear" >
						<option value="请选择">请选择</option>
					<%
						Calendar cl = Calendar.getInstance();
						int year = cl.get(Calendar.YEAR);
						for(int i=0;i<50;i++){
					%>
					    <option value="<%=year-i%>"><%=year-i%></option>
					<%
						}
					%>
					</select>至<select id="endYear" name="endYear" class="BigSelect" >
						<option value="请选择">请选择</option>
					<%
						for(int i=0;i<50;i++){
					%>
					    <option value="<%=year-i%>"><%=year-i%></option>
					<%
						}
					%>
					</select>
				</td>
			</tr>
			<tr>
				<td align="center" class='TableData' colspan="4">
					<input type="button" class="btn btn-success" style="background: #41a675;" onclick="doSearch();" value="查询" />
					<input type="button" class="btn btn-warning" onclick="doReset();" value="重置" />
					<input id="delBtn" type="button" class="btn btn-danger" onclick="deleteStationsReport();" value="删除" />
				</td>
			</tr>
			</table>
		</form>
	</div>
</body>
</html>