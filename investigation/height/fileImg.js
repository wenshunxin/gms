function drag(elementToDrag,event){
	var elementToDrag = document.getElementById(elementToDrag);
    var startX=event.clientX,startY=event.clientY;
    var origX=elementToDrag.offsetLeft,origY=elementToDrag.offsetTop;
    var deltaX=startX-origX,deltaY=startY-origY;
    if(document.addEventListener){
       document.addEventListener("mousemove",moveHandler,true); 
    	document.addEventListener("mouseup",upHandler,true);
 	}
 	else{
    	elementToDrag.setCapture();
    	elementToDrag.attachEvent("onmousemove",moveHandler);
    	elementToDrag.attachEvent("onmouseup",upHandler);
    	elementToDrag.attachEvent("onlosecapture",upHandler);
 	}
 	if(event.stopPropagation) {event.stopPropagation();}
 	else{event.cancelBubble=true;}
 
 if(event.preventDefault){ event.preventDefault();}
 else {event.returnValue=false;}
 function moveHandler(e){
   if(!e) e=window.event;
	elementToDrag.style.left=(e.clientX-deltaX)+"px";
	elementToDrag.style.top=(e.clientY-deltaY)+"px";
   if(e.stopPropagation){e.stopPropagation();}
   else{ e.cancelBubble = true;}
 }
 function upHandler(e){
   if(!e) e=window.event;
   if(document.removeEventListener){
      document.removeEventListener("mouseup",upHandler,true);
   	  document.removeEventListener("mousemove",moveHandler,true);
   }
   else{
      	elementToDrag.detachEvent("onlosecapture",upHandler);
  	 	elementToDrag.detachEvent("onmouseup",upHandler);
   		elementToDrag.detachEvent("onmousemove",moveHandler);
   		elementToDrag.releaseCapture();
   }
   if(e.stopPropagation){ e.stopPropagation();}
   else{ e.cancelBubble=true;}
 	}
  }

/** 以下是图片缩放js */
var w_init =0; //图片初始宽度记录
var h_init=0;//图片初始高度记录
var t_init = 50; //缩放层初始距离顶部的top值
var l_init = 350;//缩放层初始距离左边的left值
var PhotoSize = {
  zoom: 0, // 缩放率
  count: 0, // 缩放次数
  cpu: 0, // 当前缩放倍数值
  elem: "", // 图片节点
  focusphotoDiv:"",//缩放图片的外框div层
  photoWidth: 0, // 图片初始宽度记录
  photoHeight: 0, // 图片初始高度记录
  
  init: function(){
    this.elem = document.getElementById("focusphoto");
    this.focusphotoDiv=document.getElementById("focusphoto_div");
	this.focusphotoDiv.style.top = t_init +"px";
	this.focusphotoDiv.style.left = l_init +"px";
	this.focusphotoDiv.style.width = w_init + 3 +"px";
	this.focusphotoDiv.style.height = h_init+ 3 +"px";
    this.zoom = 1; // 设置基本参数
    this.count = 0;
    this.cpu = 1;
  }, 
  action: function(x){
	  this.count = this.count + x; // 添加记录
	  if(this.count < 0){
		  this.count = 0;
	  }
	  if(this.count > 40){
		 this.count = 40;  
	  }	
     this.cpu = (this.zoom + this.count/10)*100;   
	  if(this.cpu > 200){
		  this.cpu= 200;
	  }else if(this.cpu < 100){
		  this.cpu= 100;
	}   
	var tempWidth = w_init * this.cpu/100;
	var tempHeight = h_init * this.cpu/100;
	var minWidth = w_init;   //最大宽度
	var minHeight = h_init;  //最小高度
    this.elem.style.width = tempWidth +"px";
    this.elem.style.height = tempHeight +"px";
	this.focusphotoDiv.style.width = tempWidth + 3 +"px";
	this.focusphotoDiv.style.height =  tempHeight + 3 +"px";
	document.getElementById("multipleVal").innerText = parseInt(this.cpu)+" %";
	if(x<0&&(tempWidth<minWidth)&&(tempHeight<minHeight)){
		this.elem.style.width = minWidth + "px";
		this.elem.style.height = minHeight +"px";
		this.focusphotoDiv.style.width = minWidth + 3 +"px";
		this.focusphotoDiv.style.height = minHeight  + 3 +"px";
		document.getElementById("multipleVal").innerText = 100+"%";  
	}
  }
};
// 启动放大缩小效果,用onload方式加载，防止第一次点击获取不到图片的宽高
function showZoomDiv(){
	document.getElementById("focusphoto").src=this.src;
	document.getElementById("focusphoto").style.width = w_init +"px";
	document.getElementById("focusphoto").style.height = h_init +"px";
	document.getElementById("focusphoto_div").style.width = w_init+ 3 +"px";
	document.getElementById("focusphoto_div").style.height = h_init  + 3 +"px";
	document.getElementById("focusphoto_div").style.top = t_init +"px";
	document.getElementById("focusphoto_div").style.left = l_init +"px";
	document.getElementById("multipleVal").innerText ="100 %";
	showOrHidden('focusphoto_div','block');
}
function showOrHidden(id,displayVal){
	document.getElementById(id).style.display = displayVal;
}
/**
*关闭缩放div，并清空内容
*/
function closeDiv(){
	showOrHidden('focusphoto_div','none');
	if(w_init > 0 && h_init>0){
		document.getElementById("focusphoto").style.width = w_init+"px";
		document.getElementById("focusphoto").style.height = h_init+"px";
		document.getElementById("focusphoto_div").style.width = w_init+ 3 +"px";
		document.getElementById("focusphoto_div").style.height = h_init  + 3 +"px";
	}
	document.getElementById("multipleVal").innerText ="100 %";
}

function scrollFunc(e){
    e=e || window.event;
    var wheelScroNum = event.wheelDelta;
	if(wheelScroNum>0){
		PhotoSize.action(1);  //向上滚动
	}else{
		PhotoSize.action(-1); //向下滚动
	}
}

