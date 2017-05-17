function addQueryConditon(dataType){
	$("#queryCondition").empty();
	$("#imgZhe").attr("src",contextPath+"/resource/images/sys/down.png");
	$("#imgZhe").attr("title","展开");
	$("#queryCondition").hide();
	if(dataType=="非工程样地"){
		$("#queryCondition").load("np_sa.jsp","",function(response,status,xhr){
			getProvince();
			getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
			$('#grassCategory').combobox();
			$('#grassCategory').combobox('textbox').bind('click',function(){
				 $('#grassCategory').combobox('showPanel');
			});
			cityPrivSettingForQuery();
			$(".combo-text").css("height","26px")
		});	
	}else if(dataType=="非工程草本样方"){
		$("#queryCondition").load("np_hq.jsp","",function(){
			getProvince();
			getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
			$('#grassCategory').combobox();
			$('#grassCategory').combobox('textbox').bind('click',function(){
				 $('#grassCategory').combobox('showPanel');
			});
			cityPrivSettingForQuery();
		});
		
	}else if(dataType=="非工程灌木样方"){
		$("#queryCondition").load("np_sq.jsp","",function(){
			getProvince();
			getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
			$('#grassCategory').combobox();
			$('#grassCategory').combobox('textbox').bind('click',function(){
				 $('#grassCategory').combobox('showPanel');
			});
			cityPrivSettingForQuery();
		});
	}else if(dataType=="工程样地"){
		$("#queryCondition").load("p_sa.jsp","",function(){
			getProvince();
			getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
			$('#grassCategory').combobox();
			$('#grassCategory').combobox('textbox').bind('click',function(){
				 $('#grassCategory').combobox('showPanel');
			});
			cityPrivSettingForQuery();
		});
	}else if(dataType=="工程草本样方"){
		$("#queryCondition").load("p_hq.jsp","",function(){
			getProvince();
			cityPrivSettingForQuery();
		});
	}else if(dataType=="工程灌木样方"){
		$("#queryCondition").load("p_sq.jsp","",function(){
			getProvince();
			cityPrivSettingForQuery();
		});
	}else if(dataType=="分县补饲调查"){
		$("#queryCondition").load("fx_feeding.jsp","",function(){
			getProvince();
			cityPrivSettingForQuery();
			$("input[name=itemCondition]").each(function(){
				$(this).click(function(){
					if($(this).val()==3 || $(this).val()==4){
						$("#itemValue").hide();
						$("#itemValueDiv").show();
					}else{
						$("#itemValue").show();
						$("#itemValueDiv").hide();
					}
				});
			});
		});
	}else if(dataType=="入户补饲调查"){
		$("#queryCondition").load("rh_feeding.jsp","",function(){
			getProvince();
			cityPrivSettingForQuery();
			$("input[name=itemCondition]").each(function(){
				$(this).click(function(){
					if($(this).val()==3 || $(this).val()==4){
						$("#itemValue").hide();
						$("#itemValueDiv").show();
					}else{
						$("#itemValue").show();
						$("#itemValueDiv").hide();
					}
				});
			});
		});
	}else if(dataType=="返青期调查"){
		$("#queryCondition").load("fq_sa.jsp","",function(){
			getProvince();
			getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
			$('#grassCategory').combobox();
			$('#grassCategory').combobox('textbox').bind('click',function(){
				 $('#grassCategory').combobox('showPanel');
			});
			cityPrivSettingForQuery();
		});
	}else if(dataType=="枯黄期调查"){
		$("#queryCondition").load("kh_sa.jsp","",function(){
			getProvince();
			getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
			$('#grassCategory').combobox();
			$('#grassCategory').combobox('textbox').bind('click',function(){
				 $('#grassCategory').combobox('showPanel');
			});
			cityPrivSettingForQuery();
		});
	}else if(dataType=="植被长势调查"){
		$("#queryCondition").load("vegetation.jsp","",function(){
			getProvince();
			getChildListByTypeCode("GRASSLAND_TYPE","grassCategory");
			$('#grassCategory').combobox();
			$('#grassCategory').combobox('textbox').bind('click',function(){
				 $('#grassCategory').combobox('showPanel');
			});
			cityPrivSettingForQuery();
		});
	}else if(dataType=="调查人员"){
		$("#queryCondition").load("investigator.jsp","",function(){
			getProvince();
			cityPrivSettingForQuery();
		});
	}else if(dataType=="生态环境调查"){
		$("#queryCondition").load("ecological.jsp","",function(){
			getProvince();
			cityPrivSettingForQuery();
			$("#degradationCondition").change(function(){
				if($(this).val()==3 || $(this).val()==4){
					$("#degradationValue").hide();
					$("#degradationValueDiv").show();
				}else{
					$("#degradationValue").show();
					$("#degradationValueDiv").hide();
				}
			});
			$("#salinizationCondition").change(function(){
				if($(this).val()==3 || $(this).val()==4){
					$("#salinizationValue").hide();
					$("#salinizationValueDiv").show();
				}else{
					$("#salinizationValue").show();
					$("#salinizationValueDiv").hide();
				}
			});
			$("#desertificationCondition").change(function(){
				if($(this).val()==3 || $(this).val()==4){
					$("#desertificationValue").hide();
					$("#desertificationValueDiv").show();
				}else{
					$("#desertificationValue").show();
					$("#desertificationValueDiv").hide();
				}
			});
			$("#rockyDesertificationCondition").change(function(){
				if($(this).val()==3 || $(this).val()==4){
					$("#rockyDesertificationValue").hide();
					$("#rockyDesertificationValueDiv").show();
				}else{
					$("#rockyDesertificationValue").show();
					$("#rockyDesertificationValueDiv").hide();
				}
			});
		});
	}
	changeResource(dataType);
}

function changeResource(dataType){
	var columns = [];
	var url="";
	if(dataType=="非工程样地"){
		url=contextPath+"/gmsSampleAreaController/getSampleAreaDatagrid.act?inOrOut=0";//0代表非工程
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'sampleAreaNumber',title:'编号',width:250},
			{field:'grassCategory',title:'草地类',width:100,formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
			}},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:30,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[0];
			}},
			{field:'auditStatusDesc',title:'审核结果',align:"center",width:50},
			{field:'has_shrubs',title:'灌木和高大草本',width:50,align:"center",sortable:true,formatter:function(value,rowData,index){
				return rowData.hasShrubs;
			}},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sid+",'"+rowData.sampleAreaNumber+"',1)\"'></a>";
				return html;
			}}
		]];
	}else if(dataType=="非工程草本样方"){
		url=contextPath+"/gmsHerbQuadratController/getHerbQuadratDatagrid.act?inOrOut=0";//0代表非工程
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'quadratNumber',title:'编号',width:250},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:30,align:"center",formatter:function(value,rowData,index){
				var quadratNumber = rowData.quadratNumber;
				return quadratNumber.split("-")[0];
			}},
			{field:'coverage',title:'植物盖度',align:"center",width:50},
			{field:'freshAmount',title:'总产草量鲜重',align:"center",width:80},
			{field:'dryAmount',title:'总产草量风干重',align:"center",width:80},
			{field:'edibleFreshAmount',title:'可食产草量鲜重',align:"center",width:80},
			{field:'edibleDryAmount',title:'可食产草量风干重',align:"center",width:80},
			{field:'auditStatusDesc',title:'审核结果',align:"center",width:50},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sampleAreaId+",'"+rowData.quadratNumber+"',1)\"'></a>";
				return html;
			}}
		]];
	}else if(dataType=="非工程灌木样方"){
		url=contextPath+"/gmsShrubsQuadratController/getShrubsQuadratDatagrid.act?inOrOut=0";//0代表非工程
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'quadratNumber',title:'编号',width:250},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:30,align:"center",formatter:function(value,rowData,index){
				var quadratNumber = rowData.quadratNumber;
				return quadratNumber.split("-")[0];
			}},
			{field:'coverage',title:'植物盖度',align:"center",width:50},
			{field:'freshAmount',title:'总产草量鲜重',align:"center",width:80},
			{field:'dryAmount',title:'总产草量风干重',align:"center",width:80},
			{field:'auditStatusDesc',title:'审核结果',align:"center",width:50},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sampleAreaId+",'"+rowData.quadratNumber+"',1)\"'></a>";
				return html;
			}}
		]];
	}else if(dataType=="工程样地"){
		url=contextPath+"/gmsSampleAreaController/getSampleAreaDatagrid.act?inOrOut=1";//0代表非工程
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'sampleAreaNumber',title:'编号',width:250},
			{field:'grassCategory',title:'草地类',width:100,formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
			}},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:30,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[0];
			}},
			{field:'auditStatusDesc',title:'审核结果',align:"center",width:50},
			{field:'has_shrubs',title:'灌木和高大草本',width:50,align:"center",sortable:true,formatter:function(value,rowData,index){
				return rowData.hasShrubs;
			}},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sid+",'"+rowData.sampleAreaNumber+"',0)\"'></a>";
				return html;
			}}
		]];
		
	}else if(dataType=="工程草本样方"){
		url=contextPath+"/gmsHerbQuadratController/getHerbQuadratDatagrid.act?inOrOut=1";//0代表非工程
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'quadratNumber',title:'编号',width:250},
			{field:'projectName',title:'工程名称',width:100},
			{field:'buildingDate',title:'建设时间',width:80,align:"center"},
			{field:'projectSize',title:'工程面积',align:"center",width:50},
			{field:'projectInvestment',title:'项目投资',align:"center",width:80},
			{field:'auditStatusDesc',title:'审核结果',align:"center",width:50},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sampleAreaId+",'"+rowData.quadratNumber+"',0)\"'></a>";
				return html;
			}}
		]];
	}else if(dataType=="工程灌木样方"){
		url=contextPath+"/gmsShrubsQuadratController/getShrubsQuadratDatagrid.act?inOrOut=1";//0代表非工程
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'quadratNumber',title:'编号',width:250},
			{field:'projectName',title:'工程名称',width:100},
			{field:'buildingDate',title:'建设时间',width:80,align:"center"},
			{field:'projectSize',title:'工程面积',align:"center",width:50},
			{field:'projectInvestment',title:'项目投资',align:"center",width:80},
			{field:'auditStatusDesc',title:'审核结果',align:"center",width:50},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sampleAreaId+",'"+rowData.quadratNumber+"',0)\"'></a>";
				return html;
			}}
		]];
	}else if(dataType=="分县补饲调查"){
		url=contextPath+"/gmsFeedingController/getFeedingDatagrid.act?feedingType=0";//0代表分县
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'investigateDate',title:'调查时间',width:60},
			{field:'provinceName',title:'省份',width:50,align:"center",formatter:function(value,rowData,index){
				var investigateArea = rowData.investigateArea;
				return investigateArea.split(" ")[0];
			}},
			{field:'countyName',title:'县名称',width:50,align:"center",formatter:function(value,rowData,index){
				var investigateArea = rowData.investigateArea;
				return investigateArea.split(" ")[2];
			}},
			{field:'houseContractedSize',title:'家庭承包面积',align:"center",width:50},
			{field:'artificialGrassSize',title:'人工草地面积',align:"center",width:80},
			{field:'artificialGrassAmount',title:'人工草地草产总量',align:"center",width:80},
			{field:'strawAmount',title:'补饲秸秆等总量',align:"center",width:80},
			{field:'silageAmount',title:'青稞饲料总量',align:"center",width:80},
			{field:'foodAmount',title:'粮食补饲量',align:"center",width:80},
			{field:'grazingDays',title:'放牧总天数',align:"center",width:80},
			{field:'supplementDays',title:'补饲总天数',align:"center",width:80},
			{field:'auditStatus',title:'审核结果',align:"center",width:50,formatter:function(value,rowData,index){
				return getAuditStatusDesc(rowData.auditStatus);
			}},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+",0,"+rowData.sid+",'"+rowData.investigateArea+"',2)\"'></a>";
				return html;
			}}
		]];
		
	}else if(dataType=="入户补饲调查"){
		url=contextPath+"/gmsFeedingController/getFeedingDatagrid.act?feedingType=1";//1代表入户
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'investigateDate',title:'调查时间',width:60},
			{field:'provinceName',title:'省份',width:50,align:"center",formatter:function(value,rowData,index){
				var investigateArea = rowData.investigateArea;
				return investigateArea.split(" ")[0];
			}},
			{field:'countyName',title:'县名称',width:50,align:"center",formatter:function(value,rowData,index){
				var investigateArea = rowData.investigateArea;
				var areaStr = investigateArea.split(" ");
				if(areaStr.length>3){
					return (investigateArea.split(" ")[2]).split("-")[0];
				}else{
					return investigateArea;
				}
			}},
			{field:'householdUserName',title:'户主姓名',align:"center",width:50},
			{field:'houseContractedSize',title:'家庭承包面积',align:"center",width:50},
			{field:'artificialGrassSize',title:'人工草地面积',align:"center",width:80},
			{field:'artificialGrassAmount',title:'人工草地草产总量',align:"center",width:80},
			{field:'strawAmount',title:'补饲秸秆等总量',align:"center",width:80},
			{field:'silageAmount',title:'青稞饲料总量',align:"center",width:80},
			{field:'foodAmount',title:'粮食补饲量',align:"center",width:80},
			{field:'grazingDays',title:'放牧总天数',align:"center",width:80},
			{field:'supplementDays',title:'补饲总天数',align:"center",width:80},
			{field:'auditStatus',title:'审核结果',align:"center",width:50,formatter:function(value,rowData,index){
				return getAuditStatusDesc(rowData.auditStatus);
			}},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+",0,"+rowData.sid+",'"+rowData.investigateArea+"',3)\"'></a>";
				return html;
			}}
		]];
	}else if(dataType=="返青期调查"){
		url=contextPath+"/gmsGreenYellowSampleAreaController/getGreenYellowSampleAreaDatagrid.act?sampleAreaType=0";//0返青期调查
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'sampleAreaNumber',title:'编号',width:250},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:50,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[0];
			}},
			{field:'countyName',title:'县（旗）',width:80,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[1];
			}},
			{field:'grassCategory',title:'草地类',width:100,align:"center",formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
			}},
			{field:'grassLandscape',title:'地形地貌',width:50,align:"center"},
			{field:'investigateUserNames',title:'调查人',width:80,align:"center"},
			{field:'investigateDate',title:'调查时间',width:60,align:"center"},
			{field:'auditStatus',title:'审核结果',align:"center",width:50,formatter:function(value,rowData,index){
				return getAuditStatusDesc(rowData.auditStatus);
			}},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sid+",'"+rowData.sampleAreaNumber+"',5)\"'></a>";
				return html;
			}}
		]];
		
	}else if(dataType=="枯黄期调查"){
		url=contextPath+"/gmsGreenYellowSampleAreaController/getGreenYellowSampleAreaDatagrid.act?sampleAreaType=1";//0返青期调查
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'sampleAreaNumber',title:'编号',width:250},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:50,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[0];
			}},
			{field:'countyName',title:'县（旗）',width:80,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[1];
			}},
			{field:'grassCategory',title:'草地类',width:100,align:"center",formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
			}},
			{field:'grassLandscape',title:'地形地貌',width:50,align:"center"},
			{field:'investigateUserNames',title:'调查人',width:80,align:"center"},
			{field:'investigateDate',title:'调查时间',width:60,align:"center"},
			{field:'auditStatus',title:'审核结果',align:"center",width:50,formatter:function(value,rowData,index){
				return getAuditStatusDesc(rowData.auditStatus);
			}},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sid+",'"+rowData.sampleAreaNumber+"',6)\"'></a>";
				return html;
			}}
		]];
		
	}else if(dataType=="植被长势调查"){
		url=contextPath+"/gmsVegetationGrewController/getVegetationGrewDatagrid.act";
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'index',title:'序号',width:30,align:"center",formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'sampleAreaNumber',title:'编号',width:250,formatter:function(value,rowData,index){
				return rowData.sampleAreaNumber+"月长势";
			}},
			{field:'year',title:'年份',width:30,align:"center",formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:50,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[0];
			}},
			{field:'countyName',title:'县（旗）',width:80,align:"center",formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				return sampleAreaNumber.split("-")[1];
			}},
			{field:'grassCategory',title:'草地类',width:100,align:"center",formatter:function(value,rowData,index){
				return returnCategoryName("GRASSLAND_TYPE",rowData.grassCategory);
			}},
			{field:'grassLandscape',title:'地形地貌',width:50,align:"center"},
			{field:'investigateUserNames',title:'调查人',width:80,align:"center"},
			{field:'investigateDate',title:'调查时间',width:60,align:"center"},
			{field:'auditStatus',title:'审核结果',align:"center",width:50,formatter:function(value,rowData,index){
				return getAuditStatusDesc(rowData.auditStatus);
			}},
			{field:'f2',title:'详细',width:50,align:"center",formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+","+rowData.inOrOut+","+rowData.sid+",'"+rowData.sampleAreaNumber+"',7)\"'></a>";
				return html;
			}}
		]];
	}else if(dataType=="调查人员"){
		url = contextPath+"/gmsInvestigatorController/getInvestigatorDatagrid.act?parentId=0";
		columns=[[
			{field:'sid',checkbox:true,title:'ID',width:10},
			{field:'xuhao',title:'序号',align:"center",width:30,formatter:function(e,rowData,index){
				return index+1;
			}},
			{field:'investigatorCityFullName',title:'所在省市县',width:200,formatter:function(e,rowData,index){
				var cityJson = getCityFullInfo(rowData.investigatorCityCode);
				var cityDesc ="";
				if(cityJson){
					var cityDesc = cityJson.provinceFullName+" "+cityJson.cityFullName+" "+cityJson.countyFullName;
				}
				return cityDesc;
			}},
			{field:'investigatorName',title:'负责人姓名',width:100,align:'center'},
			{field:'investigatorDegree',title:'负责人学历',width:100,align:'center'},
			{field:'investigatorMajor',title:'负责人专业',width:100,align:'center'},
			{field:'investigatorAge',title:'负责人年龄',width:150,align:'center'},
			{field:'1',title:'操作',width:100,align:'center',formatter:function(e,rowData,index){
				return "<a href='javascript:void(0);' onclick='detailInfo("+rowData.sid+")'>详情</a>"
						+"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:void(0);' onclick='investigatorList("+rowData.sid+")'>调查人信息</a>";
			}}
		]];
		
	}else if(dataType=="生态环境调查"){
		url=contextPath+"/gmsEcologicalController/getEcologicalDatagrid.act";
		columns = [[
			{field:'sid',checkbox:true,title:'ID',width:10,rowspan:2},
			{field:'index',title:'序号',width:30,align:"center",rowspan:2,formatter:function(value,rowData,index){
				return index+1;
			}},
			{field:'sampleAreaNumber',title:'编号',width:250,rowspan:2},
			{field:'year',title:'年份',width:30,align:"center",rowspan:2,formatter:function(value,rowData,index){
				var investigateDate = rowData.investigateDate;
				return investigateDate.split("-")[0];
			}},
			{field:'provinceName',title:'省份',width:50,align:"center",rowspan:2,formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				if(sampleAreaNumber!="" && sampleAreaNumber!="null" && sampleAreaNumber!=undefined){
					return sampleAreaNumber.split("-")[0];
				}else{
					return "";
				}
			}},
			{field:'countyName',title:'县（旗）',width:150,align:"center",rowspan:2,formatter:function(value,rowData,index){
				var sampleAreaNumber = rowData.sampleAreaNumber;
				if(sampleAreaNumber!="" && sampleAreaNumber!="null" && sampleAreaNumber!=undefined){
					return sampleAreaNumber.split("-")[1];
				}else{
					return "";
				}
			}},
			{field:'',title:'主要分布区域',align:'center',colspan:4},
			{field:'f2',title:'详细',width:50,align:"center",rowspan:2,formatter:function(value,rowData,index){
				var html = "<a class='detailCtrl' href='javascript:void(0);' onclick=\"detail("+rowData.investigateDataId+",null,"+rowData.sid+",'"+rowData.sampleAreaNumber+"',4)\"'></a>";
				return html;
			}}
		],
		[
			{field:'degradationSize',title:'草原退化',width:50,align:'center'},
			{field:'desertificationSize',title:'草原沙化',width:50,align:'center'},
			{field:'salinizationSize',title:'草原盐渍化',width:50,align:'center'},
			{field:'rockyDesertificationSize',title:'草原石漠化',width:50,align:'center'}
			
		]
		
		];
	}
	setTimeout(function(){
		var province = $("#province").val();
		var city = $("#city").val();
		var county = $("#county").val();
		var cityCode="";
		if(county!=""){
			cityCode = county;
		}else if(city!=""){
			cityCode = city;
		}else if(province!=""){
			cityCode = province;
		}else{
			cityCode = "000000";
		}
		$("#cityCode").val(cityCode);
		var queryParams=tools.formToJson($("#form1"));
		datagrid.datagrid({
			url:url,
			queryParams:queryParams,
			pagination:true,
			singleSelect:false,
			toolbar:'#toolbar',//工具条对象
			checkbox:true,
			border:false,
			idField:'sid',//主键列
			fitColumns:true,//列是否进行自动宽度适应
			columns:columns
		});
		datagrid.datagrid("uncheckAll");
	},100);
	
}


/**
 * 
 *通用查询方法
 * @returns
 */
function doSearch(){
	 var province = $("#province").val();
	 var city = $("#city").val();
	 var county = $("#county").val();
	 var cityCode="";
	 if(county!=""){
		cityCode = county;
	 }else if(city!=""){
		cityCode = city;
	 }else if(province!=""){
		cityCode = province;
	 }else{
		cityCode = "000000";
	 }
	 $("#cityCode").val(cityCode);
	 var queryParams=tools.formToJson($("#form1"));
	 datagrid.datagrid('options').queryParams=queryParams; 
	 datagrid.datagrid("reload");
}


function doReset(){
	document.getElementById("form1").reset(); 
	$('#grassCategory').combobox('clear');
	getProvince();
	cityPrivSettingForQuery();
}


function detailInfo(id){
	$.jBox("iframe:../../investigator/headInfo.jsp?id="+id, {
		title:"查看调查人信息",
		top:0,
	    width: 800,
	    height: 600,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
             if(v==2){
            	return true;
            }
        }

	  });
}

function investigatorList(id){
	top.$.jBox("iframe:../investigator/investigatorListDetail.jsp?investigatorId="+id, {
		title:"调查人列表",
	    width: 1000,
	    height: 600,
	    buttons:{'关闭': 2},
	    submit: function (v, h, f) {
             if(v==2){
            	return true;
            }
        }

	  });
}


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

function toggle(evt){
	$("#queryCondition").toggle();
	datagrid.datagrid("reload");
	var src=$(evt).attr("src");
	if(src=="/gms/resource/images/sys/up.png"){
		src=contextPath+"/resource/images/sys/down.png";
		$(evt).attr("src",src);
		$(evt).attr("title","展开");
	}else{
		src=contextPath+"/resource/images/sys/up.png";
		$(evt).attr("src",src);
		$(evt).attr("title","收起");
	}
}



/**
 * 批量下载（选中的记录）
 * @returns
 */
function multiExportInfo(){
	var dataIds = getSelectItem();
	if(dataIds.length<1){
		$.jBox.tip("请选择需要下载的数据","info");
		return;
	}
	var dataType = $("#dataType").val();
	var url ="";
	if(dataType=="非工程样地"){
		url = contextPath+"/gmsSampleAreaController/exportNpSaData.act?inOrOut=0";
	}else if(dataType=="非工程草本样方"){
		url = contextPath+"/gmsHerbQuadratController/exportHerbQuadratInfo.act?inOrOut=0";
	}else if(dataType=="非工程灌木样方"){
		url = contextPath+"/gmsShrubsQuadratController/exportShrubsQuadratInfo.act?inOrOut=0";
	}else if(dataType=="工程样地"){
		url = contextPath+"/gmsSampleAreaController/exportPSaData.act?inOrOut=-1";
	}else if(dataType=="工程草本样方"){
		url = contextPath+"/gmsHerbQuadratController/exportHerbQuadratInfo.act?inOrOut=-1";
	}else if(dataType=="工程灌木样方"){
		url = contextPath+"/gmsShrubsQuadratController/exportShrubsQuadratInfo.act?inOrOut=-1";
	}else if(dataType=="分县补饲调查"){
		url = contextPath+"/gmsFeedingController/exportFeedingInfo.act?feedingType=0";
	}else if(dataType=="入户补饲调查"){
		url = contextPath+"/gmsFeedingController/exportFeedingInfo.act?feedingType=1";
	}else if(dataType=="返青期调查"){
		url=contextPath+"/gmsGreenYellowSampleAreaController/exportGySampleAreaInfo.act?sampleAreaType=0";//0返青期调查
	}else if(dataType=="枯黄期调查"){
		url=contextPath+"/gmsGreenYellowSampleAreaController/exportGySampleAreaInfo.act?sampleAreaType=1";//1枯黄期调查
	}else if(dataType=="植被长势调查"){
		url = contextPath+"/gmsVegetationGrewController/exportVegetationInfo.act?1=1";
	}else if(dataType=="调查人员"){
		url = contextPath+"/gmsInvestigatorController/exportInvestigatorInfo.act?parentId=0;";
	}else if(dataType=="生态环境调查"){
		url = contextPath+"/gmsEcologicalController/exportEcologicalInfo.act?1=1";
	}
	url+="&dataIds="+dataIds;
	document.form1.action= url;
	
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
	var cityCode="";
	if(county!=""){
		cityCode = county;
	}else if(city!=""){
		cityCode = city;
	}else if(province!=""){
		cityCode = province;
	}else{
		cityCode = "000000";
	}
	$("#cityCode").val(cityCode);
	document.form1.submit();
}

/**
 * 全部下载满足条件的数据
 * @returns
 */
function allExportInfo(){
	var dataType = $("#dataType").val();
	var url ="";
	if(dataType=="非工程样地"){
		url = contextPath+"/gmsSampleAreaController/exportNpSaData.act?inOrOut=0";
	}else if(dataType=="非工程草本样方"){
		url = contextPath+"/gmsHerbQuadratController/exportHerbQuadratInfo.act?inOrOut=0";
	}else if(dataType=="非工程灌木样方"){
		url = contextPath+"/gmsShrubsQuadratController/exportShrubsQuadratInfo.act?inOrOut=0";
	}else if(dataType=="工程样地"){
		url = contextPath+"/gmsSampleAreaController/exportPSaData.act?inOrOut=-1";
	}else if(dataType=="工程草本样方"){
		url = contextPath+"/gmsHerbQuadratController/exportHerbQuadratInfo.act?inOrOut=-1";
	}else if(dataType=="工程灌木样方"){
		url = contextPath+"/gmsShrubsQuadratController/exportShrubsQuadratInfo.act?inOrOut=-1";
	}else if(dataType=="分县补饲调查"){
		url = contextPath+"/gmsFeedingController/exportFeedingInfo.act?feedingType=0";
	}else if(dataType=="入户补饲调查"){
		url = contextPath+"/gmsFeedingController/exportFeedingInfo.act?feedingType=1";
	}else if(dataType=="返青期调查"){
		url=contextPath+"/gmsGreenYellowSampleAreaController/exportGySampleAreaInfo.act?sampleAreaType=0";//0返青期调查
	}else if(dataType=="枯黄期调查"){
		url=contextPath+"/gmsGreenYellowSampleAreaController/exportGySampleAreaInfo.act?sampleAreaType=1";//1枯黄期调查
	}else if(dataType=="植被长势调查"){
		url = contextPath+"/gmsVegetationGrewController/exportVegetationInfo.act";
	}else if(dataType=="调查人员"){
		url = contextPath+"/gmsInvestigatorController/exportInvestigatorInfo.act?parentId=0;";
	}else if(dataType=="生态环境调查"){
		url = contextPath+"/gmsEcologicalController/exportEcologicalInfo.act";
	}
	document.form1.action= url;
	
	var province = $("#province").val();
	var city = $("#city").val();
	var county = $("#county").val();
	var cityCode="";
	if(county!=""){
		cityCode = county;
	}else if(city!=""){
		cityCode = city;
	}else if(province!=""){
		cityCode = province;
	}else{
		cityCode = "000000";
	}
	$("#cityCode").val(cityCode);
	
	document.form1.submit();
}


/**
 * 获取选中值
 */
function getSelectItem(){
	var selections = datagrid.datagrid('getSelections');
	var ids = "";
	for(var i=0;i<selections.length;i++){
		ids+=selections[i].sid;
		if(i!=selections.length-1){
			ids+=",";
		}
	}
	return ids;
}

