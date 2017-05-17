<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	int userId = (Integer)request.getSession().getAttribute("id");
	Integer userLevel =(Integer)request.getSession().getAttribute("userLevel");
	String userCityCode =(String)request.getSession().getAttribute("cityCode");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="<%=contextPath %>/user/user.js"></script>
<script type="text/javascript" src="<%=contextPath%>/city/js/chinaCity.js"></script>
<script>
var datagrid;
var userLevel = '<%=userLevel%>';
var userCityCode = '<%=userCityCode%>';
function doInit(){
	getProvince();
	getRoleList();
	cityPrivSetting();
	var url = contextPath+"/userController/getUserDatagrid.act";
	datagrid = $('#datagrid').datagrid({
		url:url,
		pagination:true,
		singleSelect:true,
		toolbar:'#toolbar',//工具条对象
		checkbox:true,
		border:false,
		idField:'sid',//主键列
		fitColumns:true,//列是否进行自动宽度适应
		columns:[[
			/* {field:'sid',checkbox:true,title:'ID',width:10}, */
			{field:'userId',title:'用户名',width:100},
			{field:'userName',title:'用户姓名',width:100},
			{field:'sex',title:'性别',width:50,align:'center',formatter:function(e,rowData,index){
				if(rowData.sex==0){
					return "男";
				}else if(rowData.sex==1){
					return "女";
				}
			}},
			{field:'userPhone',title:'手机号',width:200,align:'center'},
			{field:'userLevel',title:'用户级别',width:100,align:'center',formatter:function(e,rowData,index){
				if(rowData.userLevel==0){
					return "部级";
				}else if(rowData.userLevel==1){
					return "省级";
				}else if(rowData.userLevel==2){
					return "市级";
				}else if(rowData.userLevel==3){
					return "县级";
				}
			}},
			{field:'cityFullName',title:'所属省市县',width:200,formatter:function(e,rowData,index){
				var cityJson = getCityFullInfo(rowData.cityCode);
				var cityDesc ="";
				if(cityJson){
					var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName;
				}
				return cityDesc;
			}},
			{field:'companyName',title:'单位名称',width:200},
			{field:'roleName',title:'所属角色',width:100,align:'center'},
			{field:'1',title:'操作',width:200,align:'center',formatter:function(e,rowData,index){
				return "<a href='javascript:void(0);' onclick='eidtUser("+rowData.sid+")'>修改</a>"
						+"&nbsp;&nbsp;&nbsp;&nbsp;<a <a href='javascript:void(0);' onclick='deleteUser("+rowData.sid+")'>删除</a>"
						+"&nbsp;&nbsp;&nbsp;&nbsp;<a <a href='javascript:void(0);' onclick='resetPwd("+rowData.sid+")'>重置密码</a>";
			}}
		]]
	});
}

function addUser(){
	 top.$.jBox("iframe:../user/user.jsp", {
		title:"添加用户",
		top:10,
	    width: 650,
	    height: 450,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveUser();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  }); 
}
function eidtUser(id){
	top.$.jBox("iframe:../user/update.jsp?id="+id, {
		title:"修改用户信息",
		top:0,
	    width: 650,
	    height: 400,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveUser();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function deleteUser(id){
	$.jBox.confirm("确定删除该用户信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath+"/userController/deleteUserById.act?id="+id;
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
}

function clearPwd(){
	var ids = getSelectItem();
	if(ids.length>0){
		$.jBox.confirm("确定清空选中用户的密码吗","确认",function(v){
			if(v=="ok"){
				var url = contextPath+"/userController/clearPwd.act?sids="+ids;
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
		$.jBox.tip("至少选中一个用户","info");
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

function resetPwd(id){
	top.$.jBox("iframe:../user/resetPwd.jsp?userId="+id, {
		title:"重置用户密码",
		top:100,
	    width: 650,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	top.document.getElementById("jbox-iframe").contentWindow.resetPassword();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
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

function getRoleList(){
	var url = contextPath+"/roleController/getRoleDatagrid.act?rows=100&page=1";
	var json = tools.requestJsonRs(url);
	if(json.total>0){
		var html = "";
		for(var i=0;i<json.total;i++){
			var data = json.rows[i];
			if(userLevel=='0' && (data.id==1 || data.id==4 || data.id==5)){
				continue;
			}
			if(userLevel=='1' && (data.id==1 || data.id==2 || data.id==3 || data.id==5)){
				continue;
			}
			if(userLevel=='2' && (data.id==1 || data.id==2 || data.id==3 || data.id==4)){
				continue;
			}
			if(userLevel=='3' && (data.id==1 || data.id==2 || data.id==3 || data.id==4 || data.id==5)){
				continue;
			}
			html+="<option value='"+data.id+"'>"+data.name+"</option>";
		}
		$("#roleId").html(html);
	}
}
function doReset(){
	document.getElementById("form1").reset(); 
	getProvince();
	cityPrivSetting();
}

</script>
</head>
<body onload="doInit();" style="overflow: hidden; font-size: 12px">
	<table id="datagrid" fit="true"></table>
	<div id="toolbar">
		<div class="moduleHeader">
			<img src='<%=contextPath%>/resource/images/sys/home.png' /><b class="first">当前位置：系统管理》<b class="second">用户管理</b>
		</div>
		<form id="form1" name="form1" method="post">
			<table class="TableBlock" style="width:100%;">
				<tr>
					<td class="TableData" width="10%">角色：</td>
					<td class="TableData" width="25%">
						<select id='roleId' name='roleId' class='easyui-validatebox BigSelect'>
							<option value="">所有</option>
						</select>
					</td>
					<td class="TableData" width="10%">城市:</td>
					<td class="TableData">
						省： <select name="province" id="province" onchange="getCity();" class="BigSelect">
								<option value="">全国</option>
							</select> 
						市： <select name="city" id="city" onchange="getCounty();"class="BigSelect">
								<option value="">所有</option>
							</select>
						县： <select name="county" id="county" class="BigSelect">
								<option value="">所有</option>
							</select>
					</td>
				</tr>
				<tr>
					<td class="TableData">用户名:</td>
					<td class="TableData">
						<input type="text" class="BigInput" id="userId" name="userId" maxlength="20"/>
					</td>
					<td class="TableData">用户姓名：</td>
					<td class="TableData">
						<input type="text" class="BigInput" id="userName" name="userName" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<td class="TableData" colspan="4" style="text-align:center;">
							<input type="button" class="btn btn-success" style="background: #41a675;" onclick="addUser();" value="新增" /> 
							<input type="button" class="btn btn-success" style="background: #41a675;" onclick="doSearch();" value="查询" /> 
							<input type="button" class="btn btn-warning"  onclick="doReset();" value="重置" /> 
							<!-- <input type="button" class="btn btn-warning" onclick="clearPwd();" value="清空密码" /> -->
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>