//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  Status
*
*  Author: Yi Wang
*  Date created: 3/30/05
*  Description: 
*               
*/
//[IconFile("Status.png")]
import mx.utils.Delegate;
import mx.controls.UIScrollBar;
import mx.controls.CheckBox;
import mx.controls.Button;
[TagName("Status")]
class iv.view.Status extends mx.core.UIComponent {
	//____________start component stuff
	static var symbolName:String = "Status";
	static var symbolOwner:Object = iv.view.Status;
	static var version:String = "0.0.2.0";
	//____________end component stuff
	//const
	private var _LIMIT_MIN_SCALE = 20;
	private var _LIMIT_MAX_SCALE = 200;
	private var _ratio_xScaleBar:Number;
	private var _ratio_yScaleBar:Number;
	//sub components	
	var text_speed:TextField;
	var text_xScale:TextField;
	var text_yScale:TextField;
	var text_virtual_xScale:TextField;
	var text_virtual_yScale:TextField;
	var text_virtual:TextField;
	var xScaleBar:UIScrollBar;
	var yScaleBar:UIScrollBar;
	var speedBar:UIScrollBar;
	var cb_timelock:CheckBox;
	//More Options
	var btn_moreOpt:Button;
	//other
	private var _lg;
	private var _dp;
	function Status() {
	}
	function onLoad() {
		_lg = _parent.ivLg;
		_dp = _parent.sPane.content;
		//setup text_vitual
		text_virtual._visible = false;
		text_virtual_xScale._visible = false;
		text_virtual_yScale._visible = false;
		var s_const:String = new String('          ');
		var s:String = new String();
		for (var i = 0; i<100; i++) {
			s += i+s_const;
		}
		text_virtual.text = s;
		text_virtual_xScale.text = s;
		text_virtual_yScale.text = s;
		//Bars
		xScaleBar.addEventListener("scroll", Delegate.create(this, xScroll));
		yScaleBar.addEventListener("scroll", Delegate.create(this, yScroll));
		speedBar.addEventListener("scroll", Delegate.create(this, speedScroll));
		//speedBar.addEventListener("load", Delegate.create(this, speedBarOnLoad));
		//^^^^^^not work for setting the scrollPosition property, use doLater instead
		doLater(this, 'speedBarOnLoad');
		doLater(this, 'xScaleBarOnLoad');
		doLater(this, 'yScaleBarOnLoad');
		//ratios
		_ratio_xScaleBar = (_LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE)/(text_virtual_xScale.maxhscroll-1);
		_ratio_yScaleBar = (_LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE)/(text_virtual_yScale.maxhscroll-1);
		//cb_timelock
		cb_timelock.addEventListener("click", Delegate.create(this, cb_timelock_click));
		btn_moreOpt.addEventListener("click", Delegate.create(this, btn_moreOpt_onClick));
	}
	//btn_moreOpt_onClick
	function btn_moreOpt_onClick(){
		_lg.viewMoreOpt();
	}
	//cb_timelock_click
	function cb_timelock_click() {
		_dp._b_is_timelock = cb_timelock.selected;
	}
	//scroll events
	function xScroll() {
		_dp._stage._xscale = _ratio_xScaleBar*xScaleBar.scrollPosition+_LIMIT_MIN_SCALE;
		text_xScale.text = String(Math.round(_dp._stage._xscale));
	}
	function yScroll() {
		_dp._stage._yscale = _ratio_yScaleBar*yScaleBar.scrollPosition+_LIMIT_MIN_SCALE;
		text_yScale.text = String(Math.round(_dp._stage._yscale));
	}
	function speedScroll() {
		//trace('speedBar.scrollPosition'+speedBar.scrollPosition);
		_dp.onScrollSpeed();
	}
	//load bars
	function xScaleBarOnLoad() {
		//trace('Status:xScaleBarOnLoad');
		xScaleBar.scrollPosition = (100-_LIMIT_MIN_SCALE)/_ratio_xScaleBar;
	}
	function yScaleBarOnLoad() {
		//trace('Status:yScaleBarOnLoad');
		yScaleBar.scrollPosition = (100-_LIMIT_MIN_SCALE)/_ratio_yScaleBar;
	}
	function speedBarOnLoad() {
		//trace('Status:speedBarOnLoad');
		speedBar.scrollPosition = text_virtual.maxhscroll-1;
	}
}
