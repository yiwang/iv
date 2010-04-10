//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  IVLogic
*
*  Author: Yi Wang
*  Date created: 3/24/05
*  Description: 
*               
*/
//[IconFile("IVShape.png")]
import iv.utils.Loger;
import iv.utils.ArrayHelper;
import iv.utils.ArrayAscii;
import iv.utils.ArraySBML;
import iv.utils.Bezier;
import mx.managers.PopUpManager;
import mx.containers.Window;
import mx.utils.Delegate;
[TagName("IVLogic")]
class iv.core.IVLogic extends mx.core.UIObject {
	//____________start component stuff
	static var symbolName:String = "IVLogic";
	static var symbolOwner:Object = iv.core.IVLogic;
	static var version:String = "0.0.1.0";
	//____________end component stuff
	//private properties;
	private var _path_model:String;
	private var _path_r_data:String;
	private var _path_r_name:String;
	private var _path_sp_data:String;
	private var _path_sp_name:String;
	private var _path_time:String;
	//const
	private static var _FILE_MODEL:String = 'model.xml';
	private static var _FILE_R_DATA:String = 'r_data.txt';
	private var _FILE_R_NAME:String = 'r_name.txt';
	private static var _FILE_SP_DATA:String = 'sp_data.txt';
	private static var _FILE_SP_NAME:String = 'sp_name.txt';
	private static var _FILE_TIME:String = 'time.txt';
	private static var _TRY_TIME:Number = 3;
	//flag
	private var _b_ascii:Boolean;
	private var _b_model:Boolean;
	private var _b_data_load:Boolean;
	private var _b_data_check:Boolean;
	public var b_enable_reaction:Boolean;
	//ascii
	private var _aa:ArrayAscii;
	public var a_time:Array;
	public var a_spName:Array;
	public var a_spData:Array;
	public var a_rName:Array;
	public var a_rData:Array;
	//obj
	public var o_spDataed:Object;
	public var o_rDataed:Object;
	public var a_spData_t:Array;
	public var a_rData_t:Array;
	//max & min
	public var a_time_interval:Array;
	public var max_time_interval:Number;
	public var min_time_interval:Number;
	public var a_max_spData:Array;
	public var a_min_spData:Array;
	public var a_max_rData:Array;
	public var a_min_rData:Array;
	public var a_absMax_spData:Array;
	public var a_absMin_spData:Array;
	public var a_absMax_rData:Array;
	public var a_absMin_rData:Array;
	public var i_max_spData:Number;
	public var i_min_spData:Number;
	public var n_absMin_spData:Number;
	public var i_max_rData:Number;
	public var i_min_rData:Number;
	public var n_absMin_rData:Number;
	//model
	private var _mdl:ArraySBML;
	public var m_sbml:XML;
	public var m_spArray:Array;
	public var m_rArray:Array;
	public var s_id_model:String;
	public var s_level_sbml:String;
	//shadow
	public var a_sp_shadow:Array;
	public var o_sp_shadow:Object;
	//itv
	private var _itv_aa:Number;
	private var _itv_model:Number;
	private var _itv_data:Number;
	private var _count_aa_assign:Number;
	private var _count_mdl_assign:Number;
	private var _count_data:Number;
	//windows control
	private var _a_b_win_species:Array;
	private var _a_win_species:Array;
	private var _a_b_win_reactions:Array;
	private var _a_win_reactions:Array;
	private var _posCur:Number;
	//constructor
	function IVLogic() {
		var __lg:Object = this;
		//init XML, important to ensure robust
		XML.prototype.onData = function(src:String) {
			if (src == undefined) {
				trace('IVLogic:XML_src==undefined');
				__lg.onLoadFiles();
				//this.onLoad(false);
			} else {
				this.parseXML(src);
				this.loaded = true;
				this.onLoad(true);
			}
		};
		//init Bezier
		new Bezier();
		//init Loger
		//var __loger =
		new Loger();
		//Static members can only be accessed directly through classes.
		//trace(__loger.__proto__);//=[object Object]?
		//override onError of Loger
		Loger.onLog = function(logId, _a_logArray, _a_errorIdArray) {
			__lg.onLog(logId, _a_logArray, _a_errorIdArray);
		};
		Loger.onError = function(errorId, _a_logArray, _a_errorIdArray) {
			__lg.onError(errorId, _a_logArray, _a_errorIdArray);
		};
	}
	function init() {
		super.init();
	}
	function onLoad() {
		//_parent.attachMovie('Brand','brand',99999);
		_visible = false;
		addEventListener('onLoadPath', this);
		addEventListener('lgOnLoadPath', _parent.ctrls);
		var curDate = new Date();
		s_text_log = "<b><font color= '#0000FF'>[Log Started]  "+curDate.toString()+"</font></b>";
	}
	/////////////////////////////////////////
	//MoreOpt
	/////////////////////////////////////////		
	private var _moreOpt_win;
	private var _b_win_moreOpt:Boolean = false;
	function viewMoreOpt() {
		if (!_b_win_moreOpt) {
			_b_win_moreOpt = true;
			_moreOpt_win = PopUpManager.createPopUp(_parent, Window, false, {_x:_parent._xmouse-300, _y:_parent._ymouse, _lg:this, id:19821005, closeButton:true, title:'More Options'});
			_moreOpt_win.addEventListener("click", Delegate.create(this, closeWin_moreOpt));
			_moreOpt_win.contentPath = 'WinMoreOpt';
			_moreOpt_win.setSize(300, 420);
		}
	}
	function closeWin_moreOpt(evt) {
		var win = evt.target;
		_b_win_moreOpt = false;
		win.deletePopUp();
	}
	function killWin_moreOpt() {
		if (_b_win_moreOpt) {
			_moreOpt_win.deletePopUp();
			_b_win_moreOpt = false;
		}
	}
	/////////////////////////////////////////
	//emc2
	/////////////////////////////////////////		
	private var _emc2_win;
	private var _b_win_emc2:Boolean = false;
	function viewEmc2() {
		if (!_b_win_emc2) {
			_b_win_emc2 = true;
			_emc2_win = PopUpManager.createPopUp(_parent, Window, false, {_x:_parent._xmouse-300, _y:_parent._ymouse, _lg:this, id:-13, closeButton:true, title:'Author'});
			_emc2_win.addEventListener("click", Delegate.create(this, closeWin_Emc2));
			_emc2_win.contentPath = 'WinSizeEmc2';
			_emc2_win.setSize(300, 420);
		} else {
			_emc2_win.content._plot.rePlot();
		}
	}
	function closeWin_Emc2(evt) {
		var win = evt.target;
		_b_win_emc2 = false;
		win.deletePopUp();
	}
	/////////////////////////////////////////
	//log
	/////////////////////////////////////////		
	private var _log_win;
	private var _b_win_log:Boolean = false;
	public var s_text_log:String;
	function viewLog() {
		if (!_b_win_log) {
			_b_win_log = true;
			_log_win = PopUpManager.createPopUp(_parent, Window, false, {_x:_parent._xmouse, _y:_parent._ymouse, _lg:this, id:-1, closeButton:true, title:'Log'});
			_log_win.addEventListener("click", Delegate.create(this, closeWin_Log));
			_log_win.contentPath = 'WinSizeLog';
			_log_win.setSize(300, 420);
		} else {
			_log_win.content._plot.rePlot();
		}
	}
	function closeWin_Log(evt) {
		var win = evt.target;
		_b_win_log = false;
		win.deletePopUp();
	}
	function upDateLogText(s:String) {
		s_text_log += '<br>'+s;
	}
	function onLog(logId, _a_logArray, _a_errorIdArray) {
		upDateLogText("<b>["+logId+"]\t"+_a_logArray[logId].desc+"</b>");
		if (_b_win_log) {
			_log_win.content._plot.rePlot();
		}
	}
	function onError(errorId, _a_logArray, _a_errorIdArray) {
		upDateLogText("<b><font color= '#FF0000'>["+errorId+"]\t"+_a_logArray[errorId].desc+"</font></b>");
		killAllWindows();
		deleteAllData();
		_parent.ctrls.setEnable(false);
		viewLog();
	}
	/////////////////////////////////////////
	//windows for Species & Reactions
	/////////////////////////////////////////	
	function setFrame(_dpPosCur:Number) {
		_posCur = _dpPosCur;
		//species
		if (_a_b_win_species != undefined) {
			for (var i in _a_b_win_species) {
				if (_a_b_win_species[i]) {
					_a_win_species[i].content._plot.setFrame(_posCur);
					_a_win_species[i].title = a_spName[i]+': '+a_spData[_posCur][i];
				}
			}
		}
		//reactions
		if (_a_b_win_reactions != undefined) {
			for (var i in _a_b_win_reactions) {
				if (_a_b_win_reactions[i]) {
					_a_win_reactions[i].content._plot.setFrame(_posCur);
					_a_win_reactions[i].title = a_rName[i]+': '+a_rData[_posCur][i];
				}
			}
		}
	}
	function killAllWindows() {
		//species
		if (_a_b_win_species != undefined) {
			for (var i in _a_b_win_species) {
				if (_a_b_win_species[i]) {
					_a_win_species[i].deletePopUp();
					trace('IVLogic:killAllWindows sp\t'+i+'\tdeleted');
				}
			}
		}
		//reactions
		if (_a_b_win_reactions != undefined) {
			for (var i in _a_b_win_reactions) {
				if (_a_b_win_reactions[i]) {
					_a_win_reactions[i].deletePopUp();
					trace('IVLogic:killAllWindows r\t'+i+'\tdeleted');
				}
			}
		}
	}
	function checkExistWin_Species(i:Number) {
		//lazy init _a_b_win_species
		if (_a_b_win_species == undefined) {
			_a_b_win_species = new Array(a_spName.length);
			_a_win_species = new Array(a_spName.length);
			ArrayHelper.assignAll(_a_b_win_species, false);
		}
		return _a_b_win_species[i];
	}
	function checkExistWin_Reactions(i:Number) {
		//lazy init _a_b_win_reactions
		if (_a_b_win_reactions == undefined) {
			_a_b_win_reactions = new Array(a_rName.length);
			_a_win_reactions = new Array(a_rName.length);
			ArrayHelper.assignAll(_a_b_win_reactions, false);
		}
		return _a_b_win_reactions[i];
	}
	function createWin_Species(i:Number) {
		_a_b_win_species[i] = true;
		var win = PopUpManager.createPopUp(_parent, Window, false, {typeWin:'sp', _x:_parent._xmouse, _y:_parent._ymouse, _lg:this, id:i, closeButton:true, title:a_spName[i]});
		_a_win_species[i] = win;
		win.addEventListener("click", Delegate.create(this, closeWin_Species));
		win.contentPath = 'WinSize';
		win.setSize(120, 120);
	}
	function createWin_Reactions(i:Number) {
		_a_b_win_reactions[i] = true;
		var win = PopUpManager.createPopUp(_parent, Window, false, {typeWin:'r', _x:_parent._xmouse, _y:_parent._ymouse, _lg:this, id:i, closeButton:true, title:a_rName[i]});
		_a_win_reactions[i] = win;
		win.addEventListener("click", Delegate.create(this, closeWin_Reactions));
		win.contentPath = 'WinSize';
		win.setSize(120, 120);
	}
	function closeWin_Species(evt) {
		var win = evt.target;
		_a_b_win_species[win.id] = false;
		win.deletePopUp();
	}
	function closeWin_Reactions(evt) {
		var win = evt.target;
		_a_b_win_reactions[win.id] = false;
		win.deletePopUp();
	}
	/////////////////////////////////////////
	//handle events
	/////////////////////////////////////////
	function lbOnRelease_Species(evt) {
		trace('IVLogic:lbOnRelease_Species');
		var spId:String = evt.id;
		var i = o_spDataed[spId];
		if (i == undefined) {
			trace('IVLogic:o_spDataed['+spId+']==undefined');
		} else {
			if (checkExistWin_Species(i)) {
				//can't assign _x,_y like this
				//_a_win_species[i] = {_x:_parent._xmouse, _y:_parent._ymouse};
				_a_win_species[i]._x = _parent._xmouse;
				_a_win_species[i]._y = _parent._ymouse;
			} else {
				createWin_Species(i);
			}
		}
	}
	function lbOnRelease_Reaction(evt) {
		trace('IVLogic:lbOnRelease_Reaction');
		var rId:String = evt.id;
		var i = o_rDataed[rId];
		if (i == undefined) {
			trace('IVLogic:o_rDataed['+rId+']==undefined');
		} else {
			if (checkExistWin_Reactions(i)) {
				_a_win_reactions[i]._x = _parent._xmouse;
				_a_win_reactions[i]._y = _parent._ymouse;
			} else {
				createWin_Reactions(i);
			}
		}
	}
	function onLoadPath(evt) {
		trace('IVLogic:onLoadPath\t'+_b_data_load);
		//checkData & compute max (min)
		_b_data_check = checkData();
		//triger event
		dispatchEvent({type:"lgOnLoadPath", lg_b_data_check:_b_data_check});
	}
	/////////////////////////////////////////
	//check data
	/////////////////////////////////////////
	function checkData() {
		if (!_b_data_load) {
			return false;
		}
		var n_time = a_time.length;
		var n_spName = a_spName.length;
		var n_spData = a_spData.length;
		//Loger.log(22, n_time+' '+n_spName+' '+n_spData+' '+n_rName+' '+n_rData);
		if (n_time != n_spData) {
			trace('IVLogic:n_time!=n_spData');
			Loger.error(-1, 'IVLogic:n_time!=n_spData:\t'+n_time+'!='+n_spData);
			return false;
		}
		if (n_spName != a_spData[0].length) {
			trace('IVLogic:n_spName!=a_spData[0].length');
			Loger.error(-1, 'IVLogic:n_spName!=a_spData[0].length:\t'+n_spName+'!='+a_spData[0].length);
			return false;
		}
		//construct Arrays
		a_time_interval = new Array(n_time-1);
		a_max_spData = new Array(n_spName);
		a_min_spData = new Array(n_spName);
		a_absMax_spData = new Array(n_spName);
		a_absMin_spData = new Array(n_spName);
		//a_time_interval
		for (var i = 1; i<n_time; i++) {
			a_time_interval[i-1] = a_time[i]-a_time[i-1];
		}
		//construct o_spDataed & a_spData_t
		o_spDataed = new Object();
		a_spData_t = new Array(n_spName);
		for (var i = 0; i<n_spName; i++) {
			o_spDataed[a_spName[i]] = i;
			a_spData_t[i] = new Array(n_spData);
			for (var j = 0; j<n_spData; j++) {
				a_spData_t[i][j] = a_spData[j][i];
			}
		}
		//find max & min
		max_time_interval = ArrayHelper.findMax(a_time_interval);
		min_time_interval = ArrayHelper.findMin(a_time_interval);
		//trace('IVLogic:max_time_interval\t'+max_time_interval);
		//trace('IVLogic:min_time_interval\t'+min_time_interval);
		for (var i = 0; i<n_spName; i++) {
			a_max_spData[i] = ArrayHelper.findMax(a_spData_t[i]);
			a_min_spData[i] = ArrayHelper.findMin(a_spData_t[i]);
			a_absMax_spData[i] = ArrayHelper.find_AbsMax_nonZero_1(a_spData_t[i]);
			a_absMin_spData[i] = ArrayHelper.find_AbsMin_nonZero_1(a_spData_t[i]);
			//trace('a_max_spData'+i+'\t'+a_max_spData[i]);
			//trace('a_min_spData'+i+'\t'+a_min_spData[i]);
		}
		//max_max min_min
		//var min_min = ArrayHelper.findMin(a_min_spData);
		//var max_max = ArrayHelper.findMax(a_max_spData);
		//i_min_spData = ArrayHelper.lookUpFirstIndex(a_min_spData, min_min);
		//i_max_spData = ArrayHelper.lookUpFirstIndex(a_max_spData, max_max);
		n_absMin_spData = ArrayHelper.find_AbsMin_nonZero_2(a_spData_t);
		//shadow
		a_sp_shadow = new Array();
		o_sp_shadow = new Object();
		var _n_sp_all:Number = m_spArray.length;
		for (var i = 0; i<_n_sp_all; i++) {
			a_sp_shadow[i] = m_spArray[i].value.childNodes[0].childNodes[1].childNodes;
			o_sp_shadow[m_spArray[i].id] = i;
		}
		//b_enable_reaction == true
		if (b_enable_reaction) {
			var n_rName = a_rName.length;
			var n_rData = a_rData.length;
			if (n_rName != a_rData[0].length) {
				trace('IVLogic:n_rName != a_rData[0].length');
				Loger.error(-1, 'IVLogic:n_rName != a_rData[0].length:\t'+n_rName+'!='+a_rData[0].length);
				return false;
			}
			if (n_rData != n_spData) {
				trace('IVLogic:n_rData != n_spData');
				Loger.error(-111, 'IVLogic:n_rData != n_spData:\t'+n_rData+'!='+n_spData);
				return false;
			}
			//construct o_rDataed & a_rData_t
			o_rDataed = new Object();
			a_rData_t = new Array(n_rName);
			for (var i = 0; i<n_rName; i++) {
				o_rDataed[a_rName[i]] = i;
				a_rData_t[i] = new Array(n_rData);
				for (var j = 0; j<n_rData; j++) {
					a_rData_t[i][j] = a_rData[j][i];
				}
			}
			a_max_rData = new Array(n_rName);
			a_min_rData = new Array(n_rName);
			a_absMax_rData = new Array(n_rName);
			a_absMin_rData = new Array(n_rName);
			for (var i = 0; i<n_rName; i++) {
				a_max_rData[i] = ArrayHelper.findMax(a_rData_t[i]);
				a_min_rData[i] = ArrayHelper.findMin(a_rData_t[i]);
				a_absMax_rData[i] = ArrayHelper.find_AbsMax_nonZero_1(a_rData_t[i]);
				a_absMin_rData[i] = ArrayHelper.find_AbsMin_nonZero_1(a_rData_t[i]);
				//trace('a_max_rData'+i+'\t'+a_max_rData[i]);
				//trace('a_min_rData'+i+'\t'+a_min_rData[i]);
			}
			//max_max min_min
			//min_min = ArrayHelper.findMin(a_min_rData);
			//max_max = ArrayHelper.findMax(a_max_rData);
			//i_min_rData = ArrayHelper.lookUpFirstIndex(a_min_rData, min_min);
			//i_max_rData = ArrayHelper.lookUpFirstIndex(a_max_rData, max_max);
			n_absMin_rData = ArrayHelper.find_AbsMin_nonZero_2(a_rData_t);
		}
		trace('n_absMin_spData: '+n_absMin_spData);
		trace('n_absMin_rData: '+n_absMin_rData);
		return true;
	}
	/////////////////////////////////////////
	//load data
	/////////////////////////////////////////
	function deleteAllData() {
		//ascii
		delete _aa;
		delete a_time;
		delete a_spName;
		delete a_spData;
		delete a_rName;
		delete a_rData;
		//obj
		delete o_spDataed;
		delete o_rDataed;
		delete a_spData_t;
		delete a_rData_t;
		//max & min
		delete a_time_interval;
		//	public var max_time_interval:Number;
		//	public var min_time_interval:Number;
		delete a_max_spData;
		delete a_min_spData;
		delete a_max_rData;
		delete a_min_rData;
		delete a_absMax_spData;
		delete a_absMin_spData;
		delete a_absMax_rData;
		delete a_absMin_rData;
		//model
		delete _mdl;
		delete m_sbml;
		delete m_spArray;
		delete m_rArray;
		//shadow
		delete a_sp_shadow;
		delete o_sp_shadow;
		//:Object;
		//tv
		//private var _itv_aa:Number;
		//private var _itv_model:Number;
		//private var _itv_data:Number;
		//private var _count_aa_assign:Number;
		//private var _count_mdl_assign:Number;
		//private var _count_data:Number;
		//windows control
		delete _a_b_win_species;
		delete _a_win_species;
		delete _a_b_win_reactions;
		delete _a_win_reactions;
		delete _posCur;
		//:Number;
	}
	function loadPath(path:String) {
		//kill moreOpt
		killWin_moreOpt();
		//killAllWindows
		killAllWindows();
		//delete all data
		deleteAllData();
		//set flags
		_b_ascii = false;
		_b_model = false;
		_b_data_load = false;
		//set counts
		_count_aa_assign = 0;
		_count_mdl_assign = 0;
		_count_data = 0;
		//call functions
		setPaths(path);
		//6 files to load
		_n_count_files = 6;
		loadAscii();
		loadModel();
		//_itv_data = setInterval(this, 'itv_data_assign', 3000);
	}
	//files
	private static var _n_count_files;
	function onLoadFiles() {
		trace('IVLogic:onLoadFiles: '+_n_count_files);
		_n_count_files--;
		if (_n_count_files == 0) {
			assignFileData();
			checkFileData();
			dispatchEvent({type:"onLoadPath"});
		}
	}
	function checkFileData() {
		if (checkFileModel()) {
			if (checkFile_Species()) {
				_b_data_load = true;
				if (checkFile_Reactions()) {
					b_enable_reaction = true;
				} else {
					b_enable_reaction = false;
					Loger.log(-100, "Load REACTION files failed, reaction flux animation is unavailable.");
				}
			} else {
				_b_data_load = false;
			}
		} else {
			_b_data_load = false;
		}
	}
	function checkFileModel() {
		var s:String = ":\t\""+_path_model+"\"";
		if (m_sbml == undefined) {
			Loger.error(-400, "Load SBML file failed, file not found or format error"+s);
			return false;
		}
		if (s_level_sbml != "2") {
			Loger.error(-400, "SBML file must be leve 2, or file format error"+s);
			return false;
		}
		if (m_spArray == undefined) {
			Loger.error(-400, "No vaild SPECIES information found in SBML file"+s);
			return false;
		}
		if (m_rArray == undefined) {
			Loger.error(-400, "No vaild REACTION information found in SBML file"+s);
			return false;
		}
		return true;
	}
	function checkFile_Species() {
		var s:String;
		if (a_time == undefined) {
			s = ":\t\""+_path_time+"\"";
			Loger.error(-300, "Load TIME file failed, file not found or format error"+s);
			return false;
		}
		if (a_spName == undefined) {
			s = ":\t\""+_path_sp_name+"\"";
			Loger.error(-300, "Load SPECIES NAME file failed, file not found or format error"+s);
			return false;
		}
		if (a_spData == undefined) {
			s = ":\t\""+_path_sp_data+"\"";
			Loger.error(-300, "Load SPECIES DATA file failed, file not found or format error"+s);
			return false;
		}
		return true;
	}
	function checkFile_Reactions() {
		var s:String;
		if (a_rName == undefined) {
			s = ":\t\""+_path_r_name+"\"";
			Loger.log(-200, "Load REACTION NAME file failed, file not found or format error"+s);
			return false;
		}
		if (a_rData == undefined) {
			s = ":\t\""+_path_r_data+"\"";
			Loger.log(-200, "Load REACTION DATA file failed, file not found or format error"+s);
			return false;
		}
		return true;
	}
	function assignFileData() {
		//model
		m_sbml = _mdl.sbml_root;
		m_spArray = _mdl.sp1d;
		m_rArray = _mdl.r1d;
		s_id_model = _mdl.s_id_model;
		s_level_sbml = _mdl.s_level_sbml;
		//ascii
		a_time = _aa.n1d;
		a_spName = _aa.s1d;
		a_spData = _aa.n2d;
		a_rName = _aa.s1d_r;
		a_rData = _aa.n2d_r;
		//flag
		_b_model = true;
		_b_ascii = true;
	}
	//load sbml	
	function loadModel() {
		trace('IVLogic:loadModel');
		_mdl = new ArraySBML(this);
		_mdl.loadSBML(_path_model);
		//_itv_model = setInterval(this, 'itv_mdl_assign', 2000);
	}
	//load txt
	function loadAscii() {
		trace('IVLogic:loadAscii');
		_aa = new ArrayAscii(this);
		_aa.loadAscii_s1d(_path_sp_name);
		_aa.loadAscii_n2d(_path_sp_data);
		_aa.loadAscii_s1d_r(_path_r_name);
		_aa.loadAscii_n1d(_path_time);
		_aa.loadAscii_n2d_r(_path_r_data);
		//_itv_aa = setInterval(this, 'itv_aa_assign', 2000);
	}
	function setPaths(path:String) {
		_path_model = path+_FILE_MODEL;
		_path_r_data = path+_FILE_R_DATA;
		_path_r_name = path+_FILE_R_NAME;
		_path_sp_data = path+_FILE_SP_DATA;
		_path_sp_name = path+_FILE_SP_NAME;
		_path_time = path+_FILE_TIME;
	}
	/////////////////////////////////////////
	//deprecate
	/////////////////////////////////////////	
	function itv_data_assign() {
		_count_data++;
		trace('IVLogic:itv_data_assign\t'+_count_data);
		//beyound time limit
		if (_count_data>_TRY_TIME) {
			clearInterval(_itv_data);
			//triger event
			dispatchEvent({type:"onLoadPath"});
			return;
		}
		//check flag
		if (_b_ascii && _b_model) {
			_b_data_load = true;
			clearInterval(_itv_data);
			trace('IVLogic:_b_data_load\t'+_b_data_load);
			//triger event
			dispatchEvent({type:"onLoadPath"});
		} else {
			trace('IVLogic:_b_ascii'+_b_ascii);
			trace('IVLogic:_b_model'+_b_model);
		}
	}
	function itv_mdl_assign() {
		_count_mdl_assign++;
		trace('IVLogic:itv_mdl_assign\t'+_count_mdl_assign);
		//beyound time limit
		if (_count_mdl_assign>_TRY_TIME) {
			clearInterval(_itv_model);
			Loger.error(-1, 'Load \"'+_path_model+'\" failed');
			return;
		}
		//wait till all defined
		if (_mdl.sbml_root == undefined) {
			trace('IVLogic:_mdl.sbml_root == undefined');
			return;
		} else {
			m_sbml = _mdl.sbml_root;
			m_spArray = _mdl.sp1d;
			m_rArray = _mdl.r1d;
			s_id_model = _mdl.s_id_model;
			clearInterval(_itv_model);
			//flag
			_b_model = true;
		}
	}
	function itv_aa_assign() {
		_count_aa_assign++;
		trace('IVLogic:itv_aa_assign\t'+_count_aa_assign);
		//beyond time limit
		if (_count_aa_assign>_TRY_TIME) {
			clearInterval(_itv_aa);
			if (_aa.s1d == undefined) {
				trace(_aa.s1d);
				trace('IVLogic:_aa.s1d == undefined');
				Loger.error(-1, 'Load \"'+_path_sp_name+'\" failed');
			}
			if (_aa.n1d == undefined) {
				trace(_aa.n1d.length);
				trace(typeof (_aa.n1d));
				trace('IVLogic:_aa.n1d == undefined');
				Loger.error(-1, 'Load \"'+_path_time+'\" failed');
			}
			if (_aa.n2d == undefined) {
				trace(_aa.n2d.length);
				trace('IVLogic:_aa.n2d == undefined');
				Loger.error(-1, 'Load \"'+_path_sp_data+'\" failed');
			}
			if (_aa.s1d_r == undefined) {
				trace(_aa.s1d_r);
				trace('IVLogic:_aa.s1d_r == undefined');
				Loger.error(-1, 'Load \"'+_path_r_name+'\" failed');
			}
			if (_aa.n2d_r == undefined) {
				trace(_aa.n2d_r);
				trace('IVLogic:_aa.n2d_r == undefined');
				Loger.error(-1, 'Load \"'+_path_r_data+'\" failed');
			}
			return;
		}
		//with time limit
		if (_aa.s1d == undefined || _aa.s1d_r == undefined || _aa.n1d == undefined || _aa.n2d == undefined || _aa.n2d_r == undefined) {
			//wait till all defined
			return;
		} else {
			a_time = _aa.n1d;
			a_spName = _aa.s1d;
			a_spData = _aa.n2d;
			a_rName = _aa.s1d_r;
			a_rData = _aa.n2d_r;
			clearInterval(_itv_aa);
			//change flag
			_b_ascii = true;
		}
	}
}
