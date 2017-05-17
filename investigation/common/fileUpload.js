
function change(input) {
   //支持chrome IE10
        var parents=$(input).parents(".attachContainorDiv");
        if(parents.find("img.delectImg").length>0){
            parents.find("img.delectImg").remove()
        };
        var img=$("<img/>")
        img.css({"position":"absolute","right":0,"top":0,"z-index":9999,"cursor":'pointer'}).attr("title","删除").addClass("delectImg").click(function(){
            delectImg(this)
        })
        img.attr("src",contextPath+"/resource/images/sys/close_hover.png");
        if (window.FileReader) {
          var file = input.files[0];
          var size=file.size;
          if(!/image\/\w+/.test(file.type)){  
          	  alert("图片格式不对");
              $(input).val("");
              return false;   
          } 
          if(size>20480*1024){
        	  alert("图片大小不能超过20M");
        	  $(input).val("");
        	  return false;
          }
          var reader = new FileReader();
          reader.readAsDataURL(file);
          reader.onload = function() {
        	  $(input).parents(".attachContainorDiv:first").find("img")[0].src = this.result
          }
          parents.append(img);
        }else if (typeof window.ActiveXObject != 'undefined'){//支持IE 7 8 9 10
          input.select();  
          $($(input).parents(".attachContainorDiv:first").find(".temImg")[0]).focus(); 
          var nfile = document.selection.createRange().text;
          var image = new Image(); 
      	  image.src=nfile;
      	  image.onreadystatechange = function() {
      	  if(image.readyState == "complete"){
      			var size = image.fileSize;
      				if(size>20480*1024)
      				{
      					alert("图片大小不能超过20M");
      				    return false;
      				}
                    $($(input).parents(".attachContainorDiv:first").find("img")[0]).remove();
                    $($(input).parents(".attachContainorDiv:first").find(".temImg")[0]).css("filter","progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+nfile+"')");   
      			    parents.append(img);
                }
      	  };
          
        } 
        

    }
 
function delectImg(img){ 
   if(typeof window.ActiveXObject != 'undefined'){
        var src=contextPath+"/resource/images/sys/fileImg.png";
        $(img).siblings(".temImg").css("filter","progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+src+"')");   
   }else{
        $(img).siblings(".temImg").children("img").attr("src",contextPath+"/resource/images/sys/fileImg.png"); 
   }
    $(img).siblings("#p").children("input").val("");
    $(img).parents(".attachContainorDiv").find("img.delectImg").remove();
    return true;
}
function getImg_W_H(){
    if (window.FileReader) {
    	var src = this.children[0].src;
        if(src.indexOf("fileImg.png")>-1){
            return;
        }
        var that = this.children[0];
        var image = new SImage(function(img){
                top.w_init = img.width;
                top.h_init = img.height;
                if(top.w_init>1080){
                    top.w_init=1080;
                };
                if(top.h_init>600){
                    top.h_init=600;
                }
                top.PhotoSize.init();
                top.showZoomDiv.call(that);
        });
    	image.get(src);
    }else if (typeof window.ActiveXObject != 'undefined'){
    	if(this.children[0]){
    		var src = this.children[0].src;
    		if(src.indexOf("fileImg.png")>-1){
    			return;
    		}
    		var that = this.children[0];
    		var image = new SImage(function(img){
    			top.w_init = img.width;
    			top.h_init = img.height;
    			if(top.w_init>1080){
    				top.w_init=1080;
    			};
    			if(top.h_init>600){
    				top.h_init=600;
    			}
    			top.PhotoSize.init();
    			top.showZoomDiv.call(that);
    		});
    		image.get(src);
    	}else{
            var that = this;
            var image = new SImage(function(img){
                    top.w_init = img.width;
                    top.h_init = img.height;
                    if(top.w_init>1080){
                        top.w_init=1080;
                    };
                    if(top.h_init>600){
                        top.h_init=600;
                    }
                    top.PhotoSize.init();
                    top.showZoomDiv.call(that);
            });
        	image.get(src);
    	}
    }
}

function SImage(callback) {  
    var img = new Image();  
    this.img = img;  
    var appname = navigator.appName.toLowerCase();  
    if (appname.indexOf("netscape") == -1) {  
       //ie  
        img.onreadystatechange = function () {  
            if (img.readyState == "complete") {  
                callback(img);  
            }  
        };  
    } else {  
       //firefox  
        img.onload = function () {  
            if (img.complete == true) {  
                callback(img);  
            }  
        };  
    }  
}

SImage.prototype.get = function (url) {  
    this.img.src = url;  
}

function add(key){             
    addfile(key);
    $("#fileAttachContainor").children(':last-child').find("input").click();
}
function addfile(key){             
    var html=$("<div><input type='file' name='"+key+"' style='display:none;' onchange=\" fileUpload(this) \"/><a class='add'></a></div>");
    $("#fileAttachContainor").append(html);
}
function fileUpload(evt){
        var fileName = $(evt).val().split("\\").pop();
        $(evt).siblings("a").html(fileName).after("<b style='font-weight:bold;font-size:16px;margin-left:5px;cursor: pointer;color:red;' title='删除' onclick=\"delet(this)\">&times;</b>");  
};
function delet(evt){
    $(evt).parent().remove();
};
