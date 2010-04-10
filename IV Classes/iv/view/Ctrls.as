//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  Ctrls
*
*  Author: Yi Wang
*  Date created: 3/24/05
*  Description: 
*               
*/
//[IconFile("Ctrls.png")]
import iv.utils.Loger;
import mx.utils.Delegate;
import mx.controls.Button;
import mx.controls.TextInput;
import mx.controls.UIScrollBar;
[TagName("Ctrls")]
class iv.view.Ctrls extends mx.core.UIComponent {
	//____________start component stuff
	static var symbolName:String = "Ctrls";
	static var symbolOwner:Object = iv.view.Ctrls;
	static var version:String = "0.0.1.0";
	//____________end component stuff
	//instences of components
	var text_path:TextInput;
	var text_pos:TextField;
	var text_time:TextField;
	var text_virtual:TextField;
	//bottons
	var btn_viewlog:Button;
	var btn_load:Button;
	var btn_rewind:Button;
	var btn_play:Button;
	var btn_reverse:Button;
	var btn_pause:Button;
	var btn_end:Button;
	var sBar:UIScrollBar;
	//define private property
	private var _lg;
	private var _dp;
	private var _stat;
	//flag
	private var _b_enable;
	//itv
	private var _itv_reg;
	//constructor
	function Ctrls() {
	}
	function init() {
		super.init();
		//_itv_reg = setInterval(this, 'itv_register', 100);
		//failure without wait in init
		//_dp = _parent.sPane.content;
		//trace(_dp);
		//_lg = _parent.ivLg;
	}
	/*/register _dp
										function itv_register() {
											trace('Ctrls:itv_register\t'+_parent.sPane.content);
											if (_parent.sPane.content == undefined) {
												return;
											}
											_dp = _parent.sPane.content;
											clearInterval(_itv_reg);
										}*/
	//events
	function lgOnLoadPath(evt) {
		_b_enable = evt.lg_b_data_check;
		trace('Ctrls:lgOnLoadPath\t'+_b_enable);
		Loger.log(0, 'Load files status: '+_b_enable+'\t\"'+text_path.text+'\"');
		setEnable(_b_enable);
		btn_load.enabled = true;
		_dp.initStage(_b_enable);
	}
	function setEnable(b:Boolean) {
		btn_rewind.enabled = b;
		btn_play.enabled = b;
		btn_reverse.enabled = b;
		btn_pause.enabled = b;
		btn_end.enabled = b;
		sBar.enabled = b;
	}
	function onLoad() {
		//define _lg _dp
		_lg = _parent.ivLg;
		_dp = _parent.sPane.content;
		_stat = _parent.stat;
		//unenable buttons etc.
		setEnable(false);
		//add listeners
		btn_viewlog.addEventListener("click", Delegate.create(this, btn_viewlog_onClick));
		btn_load.addEventListener("click", Delegate.create(this, btn_load_onClick));
		btn_rewind.addEventListener("click", Delegate.create(this, btn_rewind_onClick));
		btn_play.addEventListener("click", Delegate.create(this, btn_play_onClick));
		btn_reverse.addEventListener("click", Delegate.create(this, btn_reverse_onClick));
		btn_pause.addEventListener("click", Delegate.create(this, btn_pause_onClick));
		btn_end.addEventListener("click", Delegate.create(this, btn_end_onClick));
		//setup text_vitual
		text_virtual._visible = false;
		var s_const:String = new String('          ');
		var s:String = new String();
		for (var i = 0; i<300; i++) {
			s += i+s_const;
		}
		text_virtual.text = s;
		//sBar
		sBar.addEventListener("scroll", Delegate.create(this, scroll));
		//text_pos
		var __dp = _dp;
		text_pos.onChanged = function() {
			var pos = Number(this.text);
			if (!isNaN(pos)) {
				__dp.setPos(pos);
			}
		};
	}
	function scroll() {
		//trace('Ctrls:sBar:scroll');
		_dp.onScroll();
	}
	function btn_viewlog_onClick() {
		trace('btn_viewlog_onClick');
		_lg.viewLog();
	}
	function btn_load_onClick() {
		trace('btn_load_onClick');
		btn_load.enabled = false;
		setEnable(false);
		_dp.pause();
		//resolve the last char not '\ '
		var s = text_path.text;
		var s_end = s.charAt(s.length-1);
		if (s_end != '\\' && s_end != '/') {
			//s += '\\';
			s += '/';
		}
		_lg.loadPath(s);
	}
	function btn_rewind_onClick() {
		trace('btn_rewind_onClick');
		_dp.rewind();
	}
	function btn_play_onClick() {
		trace('btn_play_onClick');
		_dp.play();
	}
	function btn_reverse_onClick() {
		trace('btn_reverse_onClick');
		_dp.reverse();
	}
	function btn_pause_onClick() {
		trace('btn_pause_onClick');
		_dp.pause();
	}
	function btn_end_onClick() {
		trace('btn_end_onClick');
		_dp.end();
	}
}
