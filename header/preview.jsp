<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 上传图片js代码 -->
<script type="text/javascript" src="<%=contextPath%>/investigation/height/fileImg.js"></script>
	
<div id="focusphoto_div"  style="display:none; position:absolute; z-index:9999; top:10px; width:100%;text-align:center; margin:0 auto;">
<table cellpadding="0" cellspacing="0">
<tr>
<td  class="tab_lay_a01"></td>
<td class="tab_lay_a02" ></td>
<td class="tab_lay_a01"><div style="float: left; z-index:9999; margin-left:-15px; vertical-align:bottom; position:absolute; ">
<img src="<%=contextPath %>/resource/images/sys/close_layer.png" onclick="closeDiv();"  style="cursor:pointer;"  title="" onmouseover="this.src='<%=contextPath %>/resource/images/sys/close_hover.png';" onmouseout="this.src='<%=contextPath %>/resource/images/sys/close_layer.png';"/>
</div></td>
</tr>
<tr>
<td class="tab_lay_a01">&nbsp;&nbsp;</td>
<td>
<div id="multipleVal" style="z-index:9998; position:absolute; width:100px;height:30px;line-height:30px; border:1pt solid #BEBEBE;margin:0 auto;color:#FFF;font-weight:bold;font-size:18px;background:#000000;filter: alpha(opacity=40);;font-family:Georgia, serif;">100 %</div>
<img id="focusphoto" style="cursor:move;border:2px solid #FFF;" src="" title="滚轴进行缩放，双击关闭" onmousewheel="scrollFunc()"  ondblclick="closeDiv();" onmousedown="drag('focusphoto_div',event)" />
</td>
<td class="tab_lay_a01">&nbsp;&nbsp;</td>
</tr>
<tr>
<td class="tab_lay_a01"></td>
<td class="tab_lay_a02"></td>
<td class="tab_lay_a01"></td>
</tr>
</table>
</div>