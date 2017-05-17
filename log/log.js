/**
 * 系统日志类型
 * @param logId
 */
function parse2SysLogTypeDesc(logId){
	var logTypeDesc="";
	switch (logId){
		case 0:
			logTypeDesc="添加用户";
			break;
		case 1:
			logTypeDesc="修改用户";
			break;
		case 2:
			logTypeDesc="删除用户";
			break;
		case 3:
			logTypeDesc="添加角色";
			break;
		case 4:
			logTypeDesc="修改角色";
			break;
		case 5:
			logTypeDesc="删除角色";
			break;
		case 6:
			logTypeDesc="添加菜单";
			break;
		case 7:
			logTypeDesc="修改菜单";
			break;
		case 8:
			logTypeDesc="删除菜单";
			break;
		case 9:
			logTypeDesc="登录系统";
			break;
		case 10:
			logTypeDesc="退出系统";
			break;
	
	}
	return logTypeDesc;
}
