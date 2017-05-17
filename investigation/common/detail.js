function queryAuditRecords(dataId,saId,qId){
	var url = contextPath+"/gmsAuditRecordsController/getAuditRecords.act";
	var param = {};
	param["dataId"]=dataId;
	param["sampleAreaId"] = saId;
	param["quadratId"] = qId;
	var json = tools.requestJsonRs(url,param);
	if(json.rtState){
		var data = json.rtData;
		if(data.length<1){
			var record = "<tr><td class='TableData' align='center' colspan='5'>暂无审核记录！</td></tr>"
			$("#auditRecords").append(record);
		}
		for(var i = 0;i<data.length;i++){
			var recordsTypeDesc = getRecordsTypeDesc(data[i].recordsType);
			var auditContent=data[i].auditContent==undefined?"":data[i].auditContent;
			var record = "<tr>" +
					"<td class='TableData' align='center'>"+data[i].auditUserName+"</td>" +
					"<td class='TableData' align='center'>"+data[i].companyName+"</td>" +
					"<td class='TableData' align='center'>"+recordsTypeDesc+"</td>" +
					"<td class='TableData' align='left' style='text-indent:2em;'>"+auditContent+"</td>" +
					"<td class='TableData' align='center'>"+getFormatDateTimeStr(data[i].operateTime,'yyyy-MM-dd HH:ss:mm')+"</td>" +
					"</tr>";
			$("#auditRecords").append(record);
		}
	}
}


/**
 * 返回数据的审核状态
 * @param auditStatus
 * @returns
 */
function getRecordsTypeDesc(recordsType){
	var recordsTypeDesc="";
	switch(recordsType)
	{
	case 0:
		recordsTypeDesc="市级审核通过";
		break;
	case 1:
		recordsTypeDesc =  "市级审核驳回";
		break;
	case 2:
		recordsTypeDesc =  "省级审核通过";
		break;
	case 3:
		recordsTypeDesc =  "省级审核驳回";
		break;
	default:
		recordsTypeDesc="市级待审核";
	}
	
	return recordsTypeDesc;
}