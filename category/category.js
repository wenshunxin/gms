function saveCategory(){
	document.getElementById("jbox-iframe").contentWindow.saveCategory();
}



function addParentCategory(){
	$.jBox("iframe:pcategory.jsp", {
		title:"添加主分类",
		top:0,
	    width: 500,
	    height: 300,
	    buttons:{"确定":1,'关闭': 2},
	    submit: function (v, h, f) {
            if (v == 1) {
            	saveCategory();
            	return false;
            }
            else if(v==2){
            	return true;
            }
        }

	  });
}
function editParentCategory(id){
	$.jBox("iframe:pcategory.jsp?id="+id, {
		title:"修改主分类码",
		top:0,
		width: 500,
		height: 300,
		buttons:{"确定":1,'关闭': 2},
		submit: function (v, h, f) {
			if (v == 1) {
				saveCategory();
				return false;
			}
			else if(v==2){
				return true;
			}
		}
		
	});
}
function addChildCategory(parentId){
	$.jBox("iframe:ccategory.jsp?parentId="+parentId, {
		title:"添加子分类",
		top:0,
		width: 500,
		height: 300,
		buttons:{"确定":1,'关闭': 2},
		submit: function (v, h, f) {
			if (v == 1) {
				saveCategory();
				return false;
			}
			else if(v==2){
				return true;
			}
		}
		
	});
}
function editChildCategory(id,parentId){
	$.jBox("iframe:ccategory.jsp?id="+id, {
		title:"修改主分类码",
		top:0,
		width: 500,
		height: 300,
		buttons:{"确定":1,'关闭': 2},
		submit: function (v, h, f) {
			if (v == 1) {
				saveCategory();
				return false;
			}
			else if(v==2){
				return true;
			}
		}
		
	});
}

function deleteCategory(sid,parentId){
	$.jBox.confirm("确定删除该信息吗","确认",function(v){
		if(v=="ok"){
			var url = contextPath + "/gmsSysCategoryController/deleteCategoryById.act?sid="+sid;
			var json = tools.requestJsonRs(url);
			if(json.rtState){
				$.jBox.tip(json.rtMsg,"success");
				datagrid.datagrid("reload");
				datagrid.datagrid("unselectAll");
			}else{
				$.jBox.tip("操作失败，连接中断或者系统异常，请刷新重试","info");
			}
		}
	});
}

function getParentCategory(){
	var url = contextPath+"/gmsSysCategoryController/getParentCategoryList.act";
	var json = tools.requestJsonRs(url);
	var html="<table class='TableBlock' width='80%' style='margin:0 auto;'>"
			+"<tr class='TableHeader' align='center'><td>分类名称</td><td>编码编号</td><td>操作</td></tr>";
	if(json.rtState){
		var data = json.rtData;
		for(var i=0;i<data.length;i++){
			
			html+="<tr><td class='TableData'>"+data[i].categoryName+"</td><td class='TableData'>"+data[i].categoryNo+"</td>"
				+"<td class='TableData'>"
				+"<a href='javascript:void(0)' onclick='editParentCategory("+data[i].sid+")'>修改</a>" 
				+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='getChildCategory("+data[i].sid+")'>下一级</a>" 
				+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0)' onclick='deleteCategory("+data[i].sid+")'>删除</a>" 
				+"</td></tr>";
		}
		if(data.length==0){
			html+="<tr><td class='TableData' align='center' colspan='3'>没有查到相关数据</td></tr>";
		}
	}else{
		html+="<tr><td class='TableData' align='center' colspan='3'>没有查到相关数据</td></tr>";
	}
	html+="</tabel>";
	$("#parentList").html(html);
}



function getChildCategory(parentId){
	var url = contextPath+"/category/childList.jsp?parentId="+parentId;
	document.location.href = url;
}

/**
 * 返回代码名称
 * @param typeCode
 * @param codeValue
 * @returns
 */
function returnCategoryName(typeCode,codeValue){
	if(typeCode==null || typeCode==""){
		return "";
	}
	if(codeValue==null || codeValue==""){
		return "";
	}
	var url = contextPath+"/gmsSysCategoryController/getCategoryName.act?typeCode="+typeCode+"&codeValue="+codeValue;
	var json = tools.requestJsonRs(url);
	if(json.rtState){
		var data = json.rtData;
		if(data){
			return data.categoryName;
		}
	}
}
