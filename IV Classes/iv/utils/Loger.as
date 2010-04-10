//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  Loger
*
*  Author: Yi Wang
*  Date created: 4/2/05
*  Description: 
*               
*/
//[IconFile("Loger.png")]
[TagName("Loger")]
class iv.utils.Loger {
	//____________start component stuff
	static var symbolName:String = "Loger";
	static var symbolOwner:Object = iv.utils.Loger;
	static var version:String = "0.0.0.1";
	//____________end component stuff
	static var _a_logArray:Array;
	static var _a_errorIdArray:Array;
	//error function handler
	public static var onError:Function;
	public static var onLog:Function;
	function Loger() {
		_a_logArray = new Array();
		_a_errorIdArray = new Array();
		_a_logArray[0] = {code:0, desc:'Loger:Started'};
		onLog = function () {
			trace('[Loger:onLog] not handled');
		};
		onError = function () {
			trace('[Loger:onError] not handled');
		};
	}
	static function log(logCode:Number, logDescription):Number {
		_a_logArray.push({code:logCode, desc:logDescription});
		var logId = _a_logArray.length-1;
		trace("["+logId+"] "+logDescription+" ["+logCode+"]");
		onLog(logId, _a_logArray, _a_errorIdArray);
		return logId;
	}
	static function error(errorCode:Number, errorDescription):Number {
		_a_logArray.push({code:errorCode, desc:errorDescription});
		var errorId = _a_logArray.length-1;
		trace("["+errorId+"]\t"+errorDescription+"\t["+errorCode+"]");
		_a_errorIdArray.push(errorId);
		onError(errorId, _a_logArray, _a_errorIdArray);
		return errorId;
	}
}
