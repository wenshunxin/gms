
$.extend($.fn.validatebox.defaults.rules, {   
	//土壤含水量测定
	beginSoilMoisture: {  
		validator: function(value,param){
			var beginSoilMoisture = $("#beginSoilMoisture").val();
			if(value!="" && beginSoilMoisture!="" && parseFloat(value)<parseFloat(beginSoilMoisture)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginCoverage: {  
		validator: function(value,param){
			var beginCoverage = $("#beginCoverage").val();
			if(value!="" && beginCoverage!="" && parseFloat(value)<parseFloat(beginCoverage)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginGrassAvgHeight: {  
		validator: function(value,param){
			var beginGrassAvgHeight = $("#beginGrassAvgHeight").val();
			if(value!="" && beginGrassAvgHeight!="" && parseFloat(value)<parseFloat(beginGrassAvgHeight)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginPlantNums: {  
		validator: function(value,param){
			var beginPlantNums = $("#beginPlantNums").val();
			if(value!="" && beginPlantNums!="" && parseFloat(value)<parseFloat(beginPlantNums)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginBadGrassNums: {  
		validator: function(value,param){
			var beginBadGrassNums = $("#beginBadGrassNums").val();
			if(value!="" && beginBadGrassNums!="" && parseFloat(value)<parseFloat(beginBadGrassNums)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginFreshAmount: {  
		validator: function(value,param){
			var beginFreshAmount = $("#beginFreshAmount").val();
			if(value!="" && beginFreshAmount!="" && parseFloat(value)<parseFloat(beginFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginEdibleFreshAmount: {  
		validator: function(value,param){
			var beginEdibleFreshAmount = $("#beginEdibleFreshAmount").val();
			if(value!="" && beginEdibleFreshAmount!="" && parseFloat(value)<parseFloat(beginEdibleFreshAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginDryAmount: {  
		validator: function(value,param){
			var beginDryAmount = $("#beginDryAmount").val();
			if(value!="" && beginDryAmount!="" && parseFloat(value)<parseFloat(beginDryAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginEdibleDryAmount: {  
		validator: function(value,param){
			var beginEdibleDryAmount = $("#beginEdibleDryAmount").val();
			if(value!="" && beginEdibleDryAmount!="" && parseFloat(value)<parseFloat(beginEdibleDryAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginPermanentCoverage: {  
		validator: function(value,param){
			var beginPermanentCoverage = $("#beginPermanentCoverage").val();
			if(value!="" && beginPermanentCoverage!="" && parseFloat(value)<parseFloat(beginPermanentCoverage)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginPermanentGrassAvgHeight: {  
		validator: function(value,param){
			var beginPermanentGrassAvgHeight = $("#beginPermanentGrassAvgHeight").val();
			if(value!="" && beginPermanentGrassAvgHeight!="" && parseFloat(value)<parseFloat(beginPermanentGrassAvgHeight)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	//生态环境调查起始值应该小于等于终止值
	beginSoilMoisture: {  
		validator: function(value,param){
			var beginSoilMoisture = $("#beginSoilMoisture").val();
			if(value!="" && beginSoilMoisture!="" && parseFloat(value)<parseFloat(beginSoilMoisture)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginSoilWeight: {  
		validator: function(value,param){
			var beginSoilWeight = $("#beginSoilWeight").val();
			if(value!="" && beginSoilWeight!="" && parseFloat(value)<parseFloat(beginSoilWeight)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginSoilSalt: {  
		validator: function(value,param){
			var beginSoilSalt = $("#beginSoilSalt").val();
			if(value!="" && beginSoilSalt!="" && parseFloat(value)<parseFloat(beginSoilSalt)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginSoilPh: {  
		validator: function(value,param){
			var beginSoilPh = $("#beginSoilPh").val();
			if(value!="" && beginSoilPh!="" && parseFloat(value)<parseFloat(beginSoilPh)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginSoilOrganic: {  
		validator: function(value,param){
			var beginSoilOrganic = $("#beginSoilOrganic").val();
			if(value!="" && beginSoilOrganic!="" && parseFloat(value)<parseFloat(beginSoilOrganic)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginSoilNitrogen: {  
		validator: function(value,param){
			var beginSoilNitrogen = $("#beginSoilNitrogen").val();
			if(value!="" && beginSoilNitrogen!="" && parseFloat(value)<parseFloat(beginSoilNitrogen)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	beginPlantAmount: {  
		validator: function(value,param){
			var beginPlantAmount = $("#beginPlantAmount").val();
			if(value!="" && beginPlantAmount!="" && parseFloat(value)<parseFloat(beginPlantAmount)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	//物候及降雪观测
	januarySnowThicknessStart: {  
		validator: function(value,param){
			var januarySnowThicknessStart = $("#januarySnowThicknessStart").val();
			if(value!="" && januarySnowThicknessStart!="" && parseFloat(value)<parseFloat(januarySnowThicknessStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	februarySnowThicknessStart: {  
		validator: function(value,param){
			var februarySnowThicknessStart = $("#februarySnowThicknessStart").val();
			if(value!="" && februarySnowThicknessStart!="" && parseFloat(value)<parseFloat(februarySnowThicknessStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	decemberSnowThicknessStart: {  
		validator: function(value,param){
			var decemberSnowThicknessStart = $("#decemberSnowThicknessStart").val();
			if(value!="" && decemberSnowThicknessStart!="" && parseFloat(value)<parseFloat(decemberSnowThicknessStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	//经济社会指标起始值应该小于等于终止值
	prairieAreaStart: {  
		validator: function(value,param){
			var prairieAreaStart = $("#prairieAreaStart").val();
			if(value!="" && prairieAreaStart!="" && parseFloat(value)<parseFloat(prairieAreaStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	naturalPrairieAreaStart: {  
		validator: function(value,param){
			var naturalPrairieAreaStart = $("#naturalPrairieAreaStart").val();
			if(value!="" && naturalPrairieAreaStart!="" && parseFloat(value)<parseFloat(naturalPrairieAreaStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	availableNaturalPrairieAreaStart: {  
		validator: function(value,param){
			var availableNaturalPrairieAreaStart = $("#availableNaturalPrairieAreaStart").val();
			if(value!="" && availableNaturalPrairieAreaStart!="" && parseFloat(value)<parseFloat(availableNaturalPrairieAreaStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	degradationPrairieAreaStart: {  
		validator: function(value,param){
			var degradationPrairieAreaStart = $("#degradationPrairieAreaStart").val();
			if(value!="" && degradationPrairieAreaStart!="" && parseFloat(value)<parseFloat(degradationPrairieAreaStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	herdingNumsStart: {  
		validator: function(value,param){
			var herdingNumsStart = $("#herdingNumsStart").val();
			if(value!="" && herdingNumsStart!="" && parseFloat(value)<parseFloat(herdingNumsStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	animalAmountStart: {  
		validator: function(value,param){
			var animalAmountStart = $("#animalAmountStart").val();
			if(value!="" && animalAmountStart!="" && parseFloat(value)<parseFloat(animalAmountStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	workerAvgSalaryStart: {  
		validator: function(value,param){
			var workerAvgSalaryStart = $("#workerAvgSalaryStart").val();
			if(value!="" && workerAvgSalaryStart!="" && parseFloat(value)<parseFloat(workerAvgSalaryStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	},
	herdingNetIncomeStart: {  
		validator: function(value,param){
			var herdingNetIncomeStart = $("#herdingNetIncomeStart").val();
			if(value!="" && herdingNetIncomeStart!="" && parseFloat(value)<parseFloat(herdingNetIncomeStart)){
				return false;
			}else{
				return true;
			}
		},  
	   message: '应该大于等于起始值!'
	}
});
