<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
 String name =(String)request.getSession().getAttribute("userName");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<%@ include file="/header/header.jsp"%>
<%@ include file="/header/easyui.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>草原监测信息报送系统</title>
<link
	href="<%=contextPath %>/resource/portlet/theme/bootstrap/jquery-ui-1.10.0.custom.css"
	rel="stylesheet" />
<link
	href="<%=contextPath %>/resource/portlet/theme/bootstrap/jquery.ui.1.10.0.ie.css"
	rel="stylesheet" />
<link
	href="<%=contextPath %>/resource/portlet/css/jquery.portlet.css?v=1.3.1"
	rel="stylesheet" />
<script
	src="<%=contextPath %>/resource/portlet/jquery-ui-1.10.2.custom.min.js"></script>
<script
	src="<%=contextPath %>/resource/portlet/jquery.portlet.pack.js?v=1.3.1"></script>
<script>
$(function() {
    $('#portlet-demo').portlet({
        sortable: true,
        create: function() {
           
        },
        removeItem: function() {
          
        },
        columns: [{
            width: 600,
            portlets: [{
                attrs: {
                    id: 'feeds'
                },
                title: function() {
                    var d = new Date();
                    return 'Feeds(' + (d.getMonth() + 1) + '-' + d.getDate() + '日)';
                },
                icon: 'ui-icon-signal-diag',
                content: {
                    //设置区域内容属性
                    style: {
                        height: '100'
                    },
                    type: 'text',
                    text: '<ul><li>Feed item 1</li><li>Feed item 2</li></ul>',
                    beforeShow: function(aa) {
                    	
                    },
                    afterShow: function() {
                    	
                    }
                }
               // scripts: ['loaded-by-portlet.js']
            }, {
                attrs: {
                    id: 'weather'
                },
                title: "天气查询",
                icon: 'ui-icon-signal-diag',
                beforeRefresh: function() {
                },
                afterRefresh: function(data) {
                },
                content: {
                    style: {
                        height: '100'
                    },
                    type: 'text',
                    text: function() {
                        return "<iframe width=\"440\" height=\"70\" src=\"http://i.tianqi.com/index.php?c=code&amp;id=2&amp;icon=3&amp;num=3\" frameborder=\"0\" scrolling=\"no\" allowtransparency=\"true\"></iframe>"
                    }
                }
            }]
        }, {
            width: 500,
            portlets: [{
                title: 'Code',
                content: {
                    type: 'text',
                    text: function() {
                        return $('#code').html();
                    }
                }
            }, {
                title: 'Ajax 错误',
                content: {
                    type: 'text',
                    //url: 'noexsit.html',
                    error: function() {
                        $(this).append('<br/><br/>捕获到ajax错误');
                    }
                }
            }, {
                title: 'Table',
                content: {
                    type: 'text',
                    text: function() {
                        return $('#tableTemplate').html();
                    }
                }
            }]
        }]
    });
});
</script>
</head>
<body>
	<div id='portlet-demo'></div>
	<div id="code" style="display: none">hello everyone</div>
	<div id="tableTemplate" style="display: none">hello everyone</div>
	<div id="newsTemplate" style="display: none">hello everyone</div>
</body>
</html>