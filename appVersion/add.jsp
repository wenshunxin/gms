<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="<%=contextPath%>/resource/js/jquery/jquery-form.js"></script>
<script>
	 function save(){
		if($("#form1").form("validate")){
			 $("#form1").ajaxSubmit({
		         type:'post',
		         url:contextPath+"/appVersionController/saveApk.act",
		         dataType:"text/html",
		         complete:function(data){
						var json =eval("("+data.responseText+")");
						top.$.jBox.tip("发布成功","success");
		            	location.reload();
		            }
		     });
	    }
	 }
	 
	 $.extend($.fn.validatebox.defaults.rules, {   
		 checkVerID: {   //
				validator: function(value, param){
					 var versionId = $("#versionId").val();
					 var url = contextPath+"/appVersionController/webCheckVer.act?appVersionId="+versionId;
					 var json = tools.requestJsonRs(url);
					 if(json.rtState){
						 return false;
					 }
					return true;
				},  
			   message: '版本过低，请输入高版本！'
			}
		});
</script>
</head>

<body>
	<div class="container kv-main">
		<div class="page-header">
			<form id="form1" name="form1" method="post" enctype="multipart/form-data">
				<div style='margin: 0 auto; text-align: center; margin-top: 20px;'>
					<table class="table table-bordered"
						style="width: 70%; margin: 0 auto; text-align: center;">
						<tr>
							<td colspan='4' align="left">APP发布</td>
						</tr>
						<tr
							style="vertical-align: calc; padding: 8px; line-height: 1.42857143;">
							<td style="vertical-align: middle;text-align: right;">标题：</td>
							<td style="text-align: left;">
							<input id="title" class="BigInput easyui-validatebox" required="true"  maxlength="20" name="versionName" style="width: 220px;"type="text" class="form_input_class" /></td>
						</tr>
						 <tr>
							<td style="vertical-align: middle;text-align: right;">版本Id：</td>
							<td style="text-align:left; ">
							<input id="versionId" class="BigInput easyui-validatebox" required="true" validType="checkVerID[]" maxlength="20" name="appVersionId" style="width: 220px;"
									type="text" /></td>
							</div>
						 </td>
					 </tr> 
						<tr>
						<td style='width: 20%;vertical-align: middle;text-align: right;'>上传文件：</td>
						<td>
						<input id="path" class="BigInput"  maxlength="20" name="appFile" style="width: 220px;"type="file" class="form_input_class" />
						</td>
						</tr>
					 </tr>
						<tr>
							<td style='width: 20%;vertical-align: middle;text-align: right;'>安装包大小(MB)：</td>
							<td style="text-align: left;">
					
						<input id="size" class="BigInput easyui-numberbox" required="true" precision="2"	 maxlength="20" name="apkSize" style="width: 220px;"
									type="text" class="form_input_class" /></td>
						 </tr>
					</table>
				</div>
				<div style="margin: 0 auto; width: 70%; text-align: left; overflow-x: hidden;">
			 <div>
		     <h5>更新内容：</h5>
				<textarea id="content" required="true" class="BigInput easyui-validatebox"  name="content" style="width:99%; height: 100px;"></textarea>
			 </div>
		   </div> 
		   <div style="text-align: center;">
		   <input class="btn btn-success" id="add" type="button"  onclick="save()" value="发布" style="background:#41a675;margin-top:30px;"/>
		  <%--  <a href="<%= contextPath %>/appVersionController/getNewVer.act?versionId=3">下载app</a>  --%>
			</div>
		</form>
	</div>
	</div>
	
	<div id="holders" class="holder" style="display: none">
		<div id="citys" class="center" style="width: 390px; height: 300px;">
		</div>
	</div>
</body>
</html>
