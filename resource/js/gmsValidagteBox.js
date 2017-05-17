$.extend($.fn.validatebox.defaults.rules, {   
	isBlank: {
        validator: function (value, param) { 
        	return $.trim(value) != '' 
        },
        message: '不能为空(包括空格)！'
    },
	intege: {   
		validator: function(value, param){   
			return  regexEnum.positivIntege.test(value); //整数
		},  
	   message: '请输入整数！'
	} , 
	

	// /包括0/ 
	integeZero: {   
		validator: function(value, param){   
			return  regexEnum.integeZero.test(value); //整数
		},  
	   message: '请输入正整数！'
	} , 
	 
	// 不包括0
	positivIntege: {   
		validator: function(value, param){   
			var reg = regexEnum.positivIntege;
			return reg.test(value); //正整数
		},   
	   message: '请输入正整数！'
	}, 
	 integeZerol: {   
		validator: function(value, param){   
			return  /^\d+(\.\d*)?$/.test(value);  ///^[1-9]\d*(\.\d+)?$/ 大于0
		},   
	   message: '必须大于等于0'
	},
	integeZeroln: {   
		validator: function(value, param){   
			if(value<=0){
				return false;
			}
			return  /^\d+(\.\d*)?$/.test(value);
		},   
	   message: '必须大于0'
	},
	integeZeroll: {   
		validator: function(value, param){   
			return  /^(\d|[0-9]\d|[1-2]\d\d|3[0-5]\d|36[0-5])$/.test(value);
		},   
	   message: '不能超过365天'
	},

	integeZerollf: {   
		validator: function(value, param){   
			return  /^(5[0-9])|([6-9][0-9])|([1-9]\d{2,})$/.test(value);
		},   
	   message: '必须大于等于50'
	},



	addMethod:{
		validator: function(value, param){   
			return   /^[+-]?\d+(\.\d{1,2})?$/.test(value);
		},  
	   message: '小数位不能超过两位'
	}, 

	 addMethodb:{
		validator: function(value, param){   
			return   /^(\d|[0-9]\d|100)$/.test(value);
		},  
	   message: '请输入0-100之间的数'
	}, 
	addMethodbb:{
		validator: function(value, param){   
			return   /^(\d{1,2}(\.\d{2})?|100)$/.test(value);
		},  
	   message: '请输入0-100之间的数小数点后两位'
	}, 

	//小数位不能超过8位
	addMethode:{
		validator: function(value, param){   
			return   /^\d+(\.\d{1,8})?$/.test(value);
		},  
	   message: '小数位不能超过8位'
	}, 
	// 不能超过小数点4位
	addMethodf:{
		validator: function(value, param){   
			return   /^\d+(\.\d{1,4})?$/.test(value);
		},  
	   message: '小数位不能超过4位'
	},

	addMethodfive:{
		validator: function(value, param){   
			return   /^\d+(\.\d{1,5})?$/.test(value);
		},  
	   message: '小数位不能超过5位'
	},
	
	negativeIntege: {   
		validator: function(value, param){   
			return regexEnum.negativeIntege.test(value);  //负整数
		},   
	   message: '请输入负整数！'
	} , 
	number: {   
		validator: function(value, param){   
			return regexEnum.num.test(value); //数字
		},   
	   message: '请输入数字！'
	} ,
	pointTwoNumber:{
		validator: function(value, param){   
			return regexEnum.pointTwoNumber.test(value); //数字
		},   
	   message: '请输入有效小数点两位数字！'
		   //
	} ,
	numberstrLength: {   
		validator: function(value, param){   
			var isNumberstr = regexEnum.numberstr.test(value); //数字
			if(isNumberstr == false){
				return false;
			}
			return value.length == param[0];
		},   
	   message: '请输入{0}数字！'
	} ,
	decmal: {   
		validator: function(value, param){   
			return regexEnum.decmal.test(value); //浮点数
		},   
	   message: '请输入浮点数！'
	} ,
	
   chinese: {
		validator: function (value, param) {
			return regexEnum.chinese.test(value);
			 ///^[\u0391-\uFFE5]+$/.test(value);
		},
		message: '请输入汉字'
	},
	minLength: {   
	   validator: function(value, param){   
		   return value.length >= param[0];   
	   },   
	   message: '请输入不得少于 {0}个字符串.'  
	}  , 
	maxLength: {   
		   validator: function(value, param){   
			   return value.length <= param[0];   
		   },   
		   message: '请输入不得多于 {0}个字符.'  
		}  , 
	integeLength:{
			validator:function(value,param){
				var isIntege = regexEnum.positivIntege.test(value);
				if(isIntege == false){
					return false;
				}
				return value.length == param[0];
			}
			,message: "请输入{0}位整数."
		},
	integeBetweenLength:{
		validator:function(value,param){
			var isIntege = regexEnum.integeZero.test(value);
			if(isIntege == false){
				return false;
			}
			var intValue = parseInt(value,10);
			return intValue>=param[0]&&intValue<=param[1];
		}
		,message: "请输入介于 {0} 到 {1}之间的整数."
	},
	
	numberBetweenLength:{
		validator:function(value,param){
			var isNumber = regexEnum.num.test(value);
			if(isNumber == false){
				return false;
			}
			var intValue = parseFloat(value,10);
			return intValue>=param[0]&&intValue<=param[1];
		}
		,message: "请输入介于 {0} 到 {1}之间的数."
	},
	range:{
		validator:function(value,param){
			if(/^[0-9]\d*$/.test(value)){
				return value >= param[0] && value <= param[1]
			}else{
				return false;
			}
		},
		message:'输入的数字在{0}到{1}之间'
	},
	numberComparTo:{
		validator:function(value,param){
			var intValue = parseFloat(value,10);
			return intValue >= parseFloat(param[0], 10);
		}
		,message: "最大值不能小于最小值."
	},
	
	email:{
		validator: function (value, param) {
			return regexEnum.email.test(value);
		},
		message: '邮件不格式不对'
	},
	
	ascii:{
		validator: function (value, param) {
			return regexEnum.ascii.test(value);
		},
		message: '请输入ASC码'
	},
	zipcode: {
		validator: function (value, param) {
			return regexEnum.zipcode.test(value);
		},
		message: '邮政编码不存在'
	},
	ipRule: {
		validator: function (value, param) {
			return regexEnum.ip4.test(value);
		},
		message: '请输入正确IP地址'
	},
	picture: {
		validator: function (value, param) {
			return regexEnum.picture.test(value);
		},
		message: '图片格式不正确！'
	},
	rar: {
		validator: function (value, param) { 	
			return regexEnum.rar.test(value);
		},
		message: '压缩文件格式 不正确'
	},
	QQ: {
		validator: function (value, param) { 	
			return regexEnum.QQ.test(value);
		   // return /^[1-9]\d{4,10}$/.test(value);
		},
		message: 'QQ号码不正确'
	},
	//座机号 只能输入数字和—(可有可无)
	landlineNum:{
		validator:function(value,param){
			return /^\d+([-])?\d*$/.test(value);
		},
		message:'请输入正确格式的座机号!'
	},
	mobile: {
		validator: function (value, param) {
			return regexEnum.mobile.test(value);
		},
		message: '手机号码不正确'
	},
	tel: {
		validator: function (value, param) {
			return regexEnum.tel.test(value);
		},
		message: '电话号码不正确'
	},
	//固定电话+手机号码的验证
	mobileTel:{
		validator: function (value, param) {
			return /^((\d{3,4})?\d{7,8})$|(1[34578]\d{9})$/.test(value);
		},
		message: '联系电话不正确！'
	},
	facsimile:{
	 	validator:function(value,param){
	 		return /^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/.test(value);
	 	},
	 	message:'请输入正确格式的传真！'
	 },
	letter_and_intege: {
		validator: function (value, param) {
			return regexEnum.letter_and_intege.test(value);
		},
		message: '请输入包含字母和数字'
	},
	letter: {
		validator: function (value, param) {
			return regexEnum.letter.test(value);
		},
		message: '请输入字母类型'
	},
	
	letter_numberStr: {
		validator: function (value, param) {
			return regexEnum.letter_intege.test(value);
		},
		message: '请输入字母或者数字'
	},
	
	letter_u: {
		validator: function (value, param) {
			return regexEnum.letter_u.test(value);
		},
		message: '请输入大写的字母类型'
	},
	letter_l: {
		validator: function (value, param) {
			return regexEnum.letter_l.test(value);
		},
		message: '请输入小写的字母类型'
	},
	
	loginName: {
		validator: function (value, param) {
			return /^[\u0391-\uFFE5\w]+$/.test(value);
		},
		message: '登录名称只允许汉字、英文字母、数字及下划线。'
	},
	identifier: {
		validator: function (value, param) {
			return /^[_a-zA-Z0-9]+$/.test(value);
		},
		message: '请输入英文字符、数字和_等符号!'
	},
	special_character: {
		validator: function (value, param) {
			return /[\~!`@;=#\+\|\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]/.test(value);
		},
		message: '请输入包含特殊字符。'
	},
	
	safepassword: {
		validator: function (value, param) {
			return safePassword(value);
		},
		message: '密码由字母和数字组成，至少6位'
	},
	equalTo: {
		validator: function (value, param) {
			return value == $(param[0]).val();
		},
		message: '两次输入的内容不一致'
	},
	noEqualTo: {
		validator: function (value, param) {
			return value != $(param[0]).val();
		},
		message: '两次输入内容不能一致'
	},
	idcard: {
		validator: function (value, param) {
			return idCardTee(value);
		},
		message:'请输入正确的身份证号码'
	},
	date: {
		validator: function (value, param) {
			return isDateTee(value);
		},
		message:'请输入正确的日期类型，形如(2003-12-05)'
	},
	dateTime: {
		validator: function (value, param) {
			return isDateTimeTee(value);
		},
		message:'请输入正确的日期类型，形如(2003-12-05 13:04:06)'
	},
	time: {
		validator: function (value, param) {
			return isTimeTee(value);
		},
		message:'请输入正确的时间类型，形如(13:04:06)'
	},
	
	timeHourSecond: {
		validator: function (value, param) {
			return isTimeHourSecondTee(value);
		},
		message:'请输入正确的时间类型，形如(13:04)'
	},
	selectValueRequired: {
		validator: function (value, param) {
			return false;
		},
		message:'该选择项为必填项！'
	},
	macRule: {
		validator: function (value, param) {
			return regexEnum.mac.test(value);
		},
		message: '请输入正确mac地址'
	},
	
});




var regexEnum = 
{
	integeZero:/^\d+$/,            //正整数 + 0
	intege:/^[-+]?[1-9][0-9]*$/,					//整数
	positivIntege:/^[1-9][0-9]*$/,					//正整数
	negativeIntege:/^-[1-9]\d*$/,					//负整数
	num:/^[+-]?\d*[.]?\d*$/,		//数字
	positivNum:/^[1-9]\d*|0$/,					//正数（正整数 + 0）
	negativeNum:/^-[1-9]\d*|0$/,					//负数（负整数 + 0）
	decmal:/^([+-]?)\d*\.\d+$/,			//浮点数
	positivDecmal:/^[1-9]\d*.\d*|0.d*[1-9]\d*$/,	//正浮点数
	negativeDecmal:/^-([1-9]\d*.\d*|0.\d*[1-9]\d*)$/,//负浮点数
	decmal3:/^-?([1-9]\d*.\d*|0.\d*[1-9]\d*|0?.0+|0)$/,//浮点数
	decmal4:/^[1-9]\d*.\d*|0.\d*[1-9]\d*|0?.0+|0$/,//非负浮点数（正浮点数 + 0）
	decmal5:/^(-([1-9]\d*.\d*|0.\d*[1-9]\d*))|0?.0+|0$/,//非正浮点数（负浮点数 + 0）
	email:/^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/, //邮件		
			//url:/^http[s]?:\/\/([\w-]+\.)+[\w-]+([\w-./?%&=]*)?$/,
	chinese:/^[\u4E00-\u9FA5\uF900-\uFA2D]+$/,					//仅中文
	ascii:/^[\x00-\xFF]+$/,				//仅ACSII字符
	zipcode:/^[1-9]\d{5}$/	,					//邮编
	mobile: /^1[34578]\d{9}$/,///^13[0-9]{9}|15[012356789][0-9]{8}|18[0256789][0-9]{8}|147[0-9]{8}$/,//手机
	ip4:/^(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\.(25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)$/,	//ip地址
	notempty:/^\S+$/,						//非空
	picture:/(.*)\.(jpg|bmp|gif|ico|pcx|jpeg|tif|png|raw|tga)$/,	//图片
	rar:/(.*)\.(rar|zip|7zip|tgz)$/,								//压缩文件
	date:/^\d{4}(\-|\/|\.)\d{1,2}\1\d{1,2}$/,					//日期
	QQ:/^[1-9]\d{4,10}$/,				//QQ号码
	tel:/^(([0\+]\d{2,3}-)?(0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$/,	//电话号码的函数(包括验证国内区号,国际区号,分机号)
	username:/^\w+$/,						//用来用户注册。匹配由数字、26个英文字母或者下划线组成的字符串
	letter_intege:/^[a-zA-Z0-9]*$/,        //数字+ 字母
	letter_and_intege:/[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/,
	letter:/[A-Za-z]+$/,					//字母
	letter_u:/^[A-Z]+$/,					//大写字母
	letter_l:/^[a-z]+$/,					//小写字母
	idcard:/^[1-9]([0-9]{14}|[0-9]{17})$/,	//身份证
	numberstr:/^\d+$/,   //数字
	pointTwoNumber:/^\d+(\.\d{1,2})?$/,
	mac:/[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}:[A-Fa-f0-9]{2}/
};

var aCity={11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"}; 
	
	/* 密码由字母和数字组成，至少6位 */
	var safePassword = function (value) {
		return !(/^(([A-Z]*|[a-z]*|\d*|[-_\~!@#\$%\^&\*\.\(\)\[\]\{\}<>\?\\\/\'\"]*)|.{0,5})$|\s/.test(value));
	};
	/**
	 * 身份证
	 */
	var idCardTee = function (value) {
		if (value.length == 18 && 18 != value.length) return false;
		var number = value.toLowerCase();
		var d, sum = 0, v = '10x98765432', w = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2], a = '11,12,13,14,15,21,22,23,31,32,33,34,35,36,37,41,42,43,44,45,46,50,51,52,53,54,61,62,63,64,65,71,81,82,91';
		var re = number.match(/^(\d{2})\d{4}(((\d{2})(\d{2})(\d{2})(\d{3}))|((\d{4})(\d{2})(\d{2})(\d{3}[x\d])))$/);
		if (re == null || a.indexOf(re[1]) < 0) return false;
		if (re[2].length == 9) {
			number = number.substr(0, 6) + '19' + number.substr(6);
			d = ['19' + re[4], re[5], re[6]].join('-');
		} else d = [re[9], re[10], re[11]].join('-');
		if (!isDateTimeTee.call(d, 'yyyy-MM-dd')) return false;
		for (var i = 0; i < 17; i++) sum += number.charAt(i) * w[i];
		return (re[2].length == 9 || number.charAt(17) == v.charAt(sum % 11));
	};
	/***
	 * 日期类型
	 */
	/*var isDateTime = function (format, reObj) {
		format = format || 'yyyy-MM-dd';
		var input = this, o = {}, d = new Date();
		var f1 = format.split(/[^a-z]+/gi), f2 = input.split(/\D+/g), f3 = format.split(/[a-z]+/gi), f4 = input.split(/\d+/g);
		var len = f1.length, len1 = f3.length;
		if (len != f2.length || len1 != f4.length) return false;
		for (var i = 0; i < len1; i++) if (f3[i] != f4[i]) return false;
		for (var i = 0; i < len; i++) o[f1[i]] = f2[i];
		o.yyyy = s(o.yyyy, o.yy, d.getFullYear(), 9999, 4);
		o.MM = s(o.MM, o.M, d.getMonth() + 1, 12);
		o.dd = s(o.dd, o.d, d.getDate(), 31);
		o.hh = s(o.hh, o.h, d.getHours(), 24);
		o.mm = s(o.mm, o.m, d.getMinutes());
		o.ss = s(o.ss, o.s, d.getSeconds());
		o.ms = s(o.ms, o.ms, d.getMilliseconds(), 999, 3);
		if (o.yyyy + o.MM + o.dd + o.hh + o.mm + o.ss + o.ms < 0) return false;
		if (o.yyyy < 100) o.yyyy += (o.yyyy > 30 ? 1900 : 2000);
		d = new Date(o.yyyy, o.MM - 1, o.dd, o.hh, o.mm, o.ss, o.ms);
		var reVal = d.getFullYear() == o.yyyy && d.getMonth() + 1 == o.MM && d.getDate() == o.dd && d.getHours() == o.hh && d.getMinutes() == o.mm && d.getSeconds() == o.ss && d.getMilliseconds() == o.ms;
		return reVal && reObj ? d : reVal;
		function s(s1, s2, s3, s4, s5) {
			s4 = s4 || 60, s5 = s5 || 2;
			var reVal = s3;
			if (s1 != undefined && s1 != '' || !isNaN(s1)) reVal = s1 * 1;
			if (s2 != undefined && s2 != '' && !isNaN(s2)) reVal = s2 * 1;
			return (reVal == s1 && s1.length != s5 || reVal > s4) ? -10000 : reVal;
		}
	};*/

/*	function isCardID(sId){ 
		var iSum=0 ;
		var info="" ;
		if(!/^\d{17}(\d|x)$/i.test(sId)) return "你输入的身份证长度或格式错误"; 
		sId=sId.replace(/x$/i,"a"); 
		if(aCity[parseInt(sId.substr(0,2))]==null) return "你的身份证地区非法"; 
		sBirthday=sId.substr(6,4)+"-"+Number(sId.substr(10,2))+"-"+Number(sId.substr(12,2)); 
		var d=new Date(sBirthday.replace(/-/g,"/")) ;
		if(sBirthday!=(d.getFullYear()+"-"+ (d.getMonth()+1) + "-" + d.getDate()))return "身份证上的出生日期非法"; 
		for(var i = 17;i>=0;i --) iSum += (Math.pow(2,i) % 11) * parseInt(sId.charAt(17 - i),11) ;
		if(iSum%11!=1) return "你输入的身份证号非法"; 
		return true;//aCity[parseInt(sId.substr(0,2))]+","+sBirthday+","+(sId.substr(16,1)%2?"男":"女") 
	} */

	//短时间，形如 (13:04:06)
	function isTimeTee(str)
	{
		var a = str.match(/^(\d{1,2})(:)?(\d{1,2})\2(\d{1,2})$/);
		if (a == null) {return false}
		if (a[1]>24 || a[3]>60 || a[4]>60)
		{
			return false;
		}
		return true;
	}
	
	//短时间，形如 (13:04)
	function isTimeHourSecondTee(str)
	{
		var a = str.match(/^(\d{1,2}):(\d{1,2})$/);
		if (a == null) {return false}
		if (a[1]>24 || a[2]>60 )
		{
			return false;
		}
		return true;
	}
	

	//短日期，形如 (2003-12-05)
	function isDateTee(str)
	{
		var r = str.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/); 
		if(r==null)return false; 
		var d= new Date(r[1], r[3]-1, r[4]); 
		return (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]);
	}

	//长时间，形如 (2003-12-05 13:04:06)
	function isDateTimeTee(str)
	{
		var reg = /^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2}) (\d{1,2}):(\d{1,2}):(\d{1,2})$/; 
		var r = str.match(reg); 
		if(r==null) return false; 
		var d= new Date(r[1], r[3]-1,r[4],r[5],r[6],r[7]); 
		return (d.getFullYear()==r[1]&&(d.getMonth()+1)==r[3]&&d.getDate()==r[4]&&d.getHours()==r[5]&&d.getMinutes()==r[6]&&d.getSeconds()==r[7]);
	}
	
