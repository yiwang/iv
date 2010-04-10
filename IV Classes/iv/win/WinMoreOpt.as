//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  WinMoreOpt
*
*  Author: Yi Wang
*  Date created: 4/25/05
*  Description: 
*               
*/
//[IconFile("WinMoreOpt.png")]
import mx.utils.Delegate;
import mx.controls.UIScrollBar;
//import iv.core.IVPlot;
import mx.controls.Button;
import mx.controls.CheckBox;
[TagName("WinMoreOpt")]
class iv.win.WinMoreOpt extends mx.core.UIComponent {
	//____________start component stuff
	static var symbolName:String = "WinMoreOpt";
	static var symbolOwner:Object = iv.win.WinMoreOpt;
	static var version:String = "0.0.1.0";
	//____________end component stuff
	//const
	private var _LIMIT_MIN_SCALE = -3;
	private var _LIMIT_MAX_SCALE = 3;
	private var _LIMIT_MAX_SCALE_FLUX = 3;
	private var _ratio_spLogScaleBar:Number;
	private var _ratio_rLogScaleBar:Number;
	//sub components
	var cb_timelock:CheckBox;
	//layer static
	var cb_spStatic:CheckBox;
	var cb_rStatic:CheckBox;
	var cb_spLog:CheckBox;
	var cb_rLog:CheckBox;
	//layer dynamic
	var cb_sp:CheckBox;
	var cb_r:CheckBox;
	var cb_lb_sp:CheckBox;	
	var cb_lb_r:CheckBox;
	//layer arrow
	var cb_arrow:CheckBox;
	//conform
	var cb_spCon:CheckBox;
	var cb_rCon:CheckBox;
	//scrollBar
	var text_virtual_spLog:TextField;
	var text_virtual_rLog:TextField;
	var sb_spLog:UIScrollBar;
	var sb_rLog:UIScrollBar;
	//text
	var text_spLog:TextField;
	var text_rLog:TextField;
	//mc_frame
	var mc_frame:MovieClip;
	//const
	private var _SHIFT_X = 3;
	private var _SHIFT_Y = 31;
	//passed in 
	public var id;
	private var _p;
	private var _lg;
	private var _dp;
	//type
	public var typeWin:String;
	function WinMoreOpt() {
	}
	function onLoad() {
		mc_frame._visible = false;
		_lg = _parent._parent.ivLg;
		_dp = _parent._parent.sPane.content;
		//setup text_vitual
		text_virtual_spLog._visible = false;
		text_virtual_rLog._visible = false;
		var s_const:String = new String('          ');
		var s:String = new String();
		for (var i = 0; i<100; i++) {
			s += i+s_const;
		}
		text_virtual_spLog.text = s;
		text_virtual_rLog.text = s;
		//Bars
		sb_spLog.addEventListener("scroll", Delegate.create(this, spLog_Scroll));
		sb_rLog.addEventListener("scroll", Delegate.create(this, rLog_Scroll));
		//ratios
		_ratio_spLogScaleBar = (_LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE)/(text_virtual_spLog.maxhscroll-1);
		_ratio_rLogScaleBar = (_LIMIT_MAX_SCALE_FLUX-_LIMIT_MIN_SCALE)/(text_virtual_rLog.maxhscroll-1);
		//add listeners
		cb_timelock.addEventListener("click", Delegate.create(this, cb_timelock_click));
		cb_spStatic.addEventListener("click", Delegate.create(this, cb_spStatic_click));
		cb_rStatic.addEventListener("click", Delegate.create(this, cb_rStatic_click));
		cb_spLog.addEventListener("click", Delegate.create(this, cb_spLog_click));
		cb_rLog.addEventListener("click", Delegate.create(this, cb_rLog_click));
		cb_sp.addEventListener("click", Delegate.create(this, cb_sp_click));
		cb_r.addEventListener("click", Delegate.create(this, cb_r_click));
		cb_lb_sp.addEventListener("click", Delegate.create(this, cb_lb_sp_click));
		cb_lb_r.addEventListener("click", Delegate.create(this, cb_lb_r_click));
		cb_arrow.addEventListener("click", Delegate.create(this, cb_arrow_click));
		//conform
		cb_spCon.addEventListener("click", Delegate.create(this, cb_spCon_click));
		cb_rCon.addEventListener("click", Delegate.create(this, cb_rCon_click));
		//recoverAll
		recoverAll();
		//doLater
		doLater(this, 'setScale_LogSp');
		doLater(this, 'setScale_LogR');
	}
	//conform
	function cb_spCon_click() {
		_dp.b_isConSp = cb_spCon.selected;
	}
	function cb_rCon_click() {
		_dp.b_isConR = cb_rCon.selected;
	}
	//core
	function setScale_LogSp() {
		var factor = Math.pow(10,_ratio_spLogScaleBar*sb_spLog.scrollPosition+_LIMIT_MIN_SCALE);
		_dp.n_factor_LogSp = factor;
		_dp.b_isLogSp = cb_spLog.selected;
		_dp.setScale_LogSp();
		//_dp.setScale_LogSp(factor, cb_spLog.selected);
		text_spLog.text = String(Math.round(1000*factor)/1000);
	}
	function setScale_LogR() {
		var factor = Math.pow(10,_ratio_rLogScaleBar*sb_rLog.scrollPosition+_LIMIT_MIN_SCALE);
		_dp.n_factor_LogR = factor;
		_dp.b_isLogR = cb_rLog.selected;
		_dp.setScale_LogR();
		//_dp.setScale_LogR(factor, cb_rLog.selected);
		text_rLog.text = String(Math.round(1000*factor)/1000);
	}
	//events
	function spLog_Scroll() {
		setScale_LogSp();
	}
	function rLog_Scroll() {
		setScale_LogR();
	}
	function cb_spLog_click() {
		setScale_LogSp();
	}
	function cb_rLog_click() {
		setScale_LogR();
	}
	//play control
	function cb_timelock_click() {
		_dp._b_is_timelock = cb_timelock.selected;
	}
	//cb layer visible
	function cb_spStatic_click() {
		_dp.setLayerVisible(_dp.a_layer_log_sp, cb_spStatic.selected);
		setScale_LogSp();
	}
	function cb_rStatic_click() {
		_dp.setLayerVisible(_dp.a_layer_log_r, cb_rStatic.selected);
		setScale_LogR();
	}
	function cb_sp_click() {
		_dp.setLayerVisible(_dp.a_layer_sp, cb_sp.selected);
	}
	function cb_r_click() {
		_dp.setLayerVisible(_dp.a_layer_r, cb_r.selected);
	}
	function cb_lb_sp_click() {
		_dp.setLayerVisible(_dp.a_layer_lb_sp, cb_lb_sp.selected);
	}
	function cb_lb_r_click() {
		_dp.setLayerVisible(_dp.a_layer_lb_r, cb_lb_r.selected);
	}
	function cb_arrow_click() {
		_dp.setLayerVisible(_dp.a_layer_arrow, cb_arrow.selected);
	}
	//recoverAll
	function recoverAll() {
		//sub components
		cb_timelock.selected = _dp._b_is_timelock;
		//layer static
		cb_spStatic.selected = _dp.a_layer_log_sp[0]._visible;
		cb_rStatic.selected = _dp.a_layer_log_r[0]._visible;
		cb_spLog.selected = _dp.b_isLogSp;
		cb_rLog.selected = _dp.b_isConR;
		//layer dynamic
		cb_sp.selected = _dp.a_layer_sp[0]._visible;
		cb_r.selected = _dp.a_layer_r[0]._visible;
		cb_lb_sp.selected = _dp.a_layer_lb_sp[0]._visible;
		cb_lb_r.selected = _dp.a_layer_lb_r[0]._visible;
		//layer arrow
		cb_arrow.selected = _dp.a_layer_arrow[0]._visible;
		//conform
		cb_spCon.selected = _dp.b_isConSp;
		cb_rCon.selected = _dp.b_isConR;
	}
}
