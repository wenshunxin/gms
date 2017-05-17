$.extend($.fn.validatebox.defaults.rules, {   
	//测产样方1
	edibleFreshValid: {   //可食鲜重应该小于等于鲜重
		validator: function(value){
			var freshAmount = $("#firstFreshAmount").val();
			if(value!="" && freshAmount!="" && parseFloat(value) > parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '可食鲜重应小于等于鲜重！'
	} ,
	dryFreshValid: {   //干重与鲜重比较
		validator: function(value){
			var freshAmount = $("#firstFreshAmount").val();
			if(value!="" && freshAmount!="" && parseFloat(value) >= parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '干重应小于鲜重！'
	} ,
	edibleDryValid: {   //可食干重与干重比较
		validator: function(value){
			var dryAmount = $("#firstDryAmount").val();
			if(value!="" && dryAmount!="" && parseFloat(value) > parseFloat(dryAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食干重应小于等于干重！'
	} ,
	edible: {   //可食干重与可食鲜重比较
		validator: function(value){
			var edibleFreshAmount = $("#firstEdibleFreshAmount").val();
			if(value!="" && edibleFreshAmount!="" && parseFloat(value) >= parseFloat(edibleFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食干重应小于可食鲜重！'
	},
	//测产样方2
	edibleFreshValids: {   //可食鲜重应该小于等于鲜重
		validator: function(value){
			var freshAmount = $("#secondFreshAmount").val();
			if(value!="" && freshAmount!="" && parseFloat(value) > parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '可食鲜重应小于等于鲜重！'
	} ,
	dryFreshValids: {   //干重与鲜重比较
		validator: function(value){
			var freshAmount = $("#secondFreshAmount").val();
			if(value!="" && freshAmount!="" && parseFloat(value) >= parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '干重应小于鲜重！'
	} ,
	edibleDryValids: {   //可食干重与干重比较
		validator: function(value){
			var dryAmount = $("#secondDryAmount").val();
			if(value!="" && dryAmount!="" && parseFloat(value) > parseFloat(dryAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食干重应小于等于干重！'
	} ,
	edibles: {   //可食干重与可食鲜重比较
		validator: function(value){
			var edibleFreshAmount = $("#secondEdibleFreshAmount").val();
			if(value!="" && edibleFreshAmount!="" && parseFloat(value) >= parseFloat(edibleFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食干重应小于可食鲜重！'
	},
	//测产样方3
	edibleFreshValidt: {   //可食鲜重应该小于等于鲜重
		validator: function(value){
			var freshAmount = $("#thirdFreshAmount").val();
			if(value!="" && freshAmount!="" && parseFloat(value) > parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '可食鲜重应小于等于鲜重！'
	} ,
	dryFreshValidt: {   //干重与鲜重比较
		validator: function(value){
			var freshAmount = $("#thirdFreshAmount").val();
			if(value!="" && freshAmount!="" && parseFloat(value) >= parseFloat(freshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '干重应小于鲜重！'
	} ,
	edibleDryValidt: {   //可食干重与干重比较
		validator: function(value){
			var dryAmount = $("#thirdDryAmount").val();
			if(value!="" && dryAmount!="" && parseFloat(value) > parseFloat(dryAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食干重应小于等于干重！'
	} ,
	ediblet: {   //可食干重与可食鲜重比较
		validator: function(value){
			var edibleFreshAmount = $("#thirdEdibleFreshAmount").val();
			if(value!="" && edibleFreshAmount!="" && parseFloat(value) >= parseFloat(edibleFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '可食干重应小于可食鲜重！'
	},
	shrubsFreshAmount :{
		validator: function(value){
			var shrubsFreshAmount = $("#shrubsFreshAmount").val();
			if(value!="" && shrubsFreshAmount!="" && parseFloat(value) >= parseFloat(shrubsFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
		message: '干重应小于鲜重！'
	},
	fileImg: {   //添加照片
		validator: function(value){
			var preview = $(".preview").attr("src");
			if(preview.indexOf("fileImg.png")>-1){
				return false;
			}else{
				return true;
			}
		},  
		message: '请添加照片！'
	}
});



	