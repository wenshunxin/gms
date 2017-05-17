function upload(input) {
  var fileUpload=$($(input).parent(".fileUpload"));
  var oBox=$($(input).parent(".fileUpload").find(".tempImg"));
  var tipDiv = $(fileUpload.find("div"))[1];
  if(tipDiv!=undefined){
	  tipDiv.remove(); 
  }
  //支持chrome IE10
  if (window.FileReader) {
    var file = input.files[0];
    var size=file.size;
    if(!/image\/\w+/.test(file.type)){  
    	var tipSpan=$("<div style='margin-top:150px;'>").html("图片格式不对，请重新上传！");
    	fileUpload.append(tipSpan);
        return false;   
    }  
    if(size>204800){
    	var tipSpan=$("<div style='margin-top:150px;'>").html("图片过大，请重新上传！");
    	fileUpload.append(tipSpan);
    	return false;
    }
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function() {
    oBox.html('<img src="'+this.result+'" alt="" />');
    }
  }else if (typeof window.ActiveXObject != 'undefined'){//支持IE 7 8 9 10
    input.select();  
   // input.blur();  
    var nfile = document.selection.createRange().text;

    var image = new Image(); 
	image.src=nfile;
	image.onreadystatechange = function() {
		if(image.readyState == "complete"){
			var size = image.fileSize;
				if(size>204800)
				{
					var tipSpan=$("<div style='margin-top:150px;'>").html("图片过大，请重新上传！");
			    	fileUpload.append(tipSpan);
				    return false;
				}
			}
		};
		oBox.css("filter","progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+nfile+"')"); 
   		oBox.html("");
  } 
}

