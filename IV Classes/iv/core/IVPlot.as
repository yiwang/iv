//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  IVPlot
*
*  Author: Yi Wang
*  Date created: 3/31/05
*  Description: 
*               
*/
//[IconFile("IVPlot.png")]
import iv.core.IVArrow;
import iv.utils.Loger;
[TagName("IVPlot")]
class iv.core.IVPlot extends mx.core.UIObject {
	//____________start component stuff
	static var symbolName:String = "IVPlot";
	static var symbolOwner:Object = iv.core.IVPlot;
	static var version:String = "0.0.0.3";
	//____________end component stuff
	//const
	private var _SHIFT_X = 3;
	private var _SHIFT_Y = 31;
	private var _TOP = 40;
	private var _LEFT = 10;
	private var _RIGHT = 10;
	private var _BOTTOM = 10;
	//passed in 
	private var _lg;
	public var id;
	public var win;
	//type
	public var typePlot:String;
	//public
	public var xArray:Array;
	public var yArray:Array;
	public var ymin:Number;
	public var ymax:Number;
	public var xmin:Number;
	public var xmax:Number;
	//private
	private var n_len:Number;
	private var _w;
	private var _h;
	private var _ratio_x;
	private var _ratio_y;
	//frame
	private var _f;
	private var _posCur;
	//axis arrow
	private var _mc_ar_x:MovieClip;
	private var _mc_ar_y:MovieClip;
	//constructor
	function IVPlot() {
	}
	function onLoad() {
		//set to left uper corner
		move(-_SHIFT_X, -_SHIFT_Y);
		//public
		xArray = _lg.a_time;
		if (typePlot == 'sp') {
			yArray = _lg.a_spData_t[id];
			ymax = _lg.a_max_spData[id];
			ymin = _lg.a_min_spData[id];
		} else if (typePlot == 'r') {
			yArray = _lg.a_rData_t[id];
			ymax = _lg.a_max_rData[id];
			ymin = _lg.a_min_rData[id];
		} else {
			Loger.log(999, 'IVPlot:onLoad: typePlot = '+typePlot);
		}
		n_len = yArray.length;
		xmin = xArray[0];
		xmax = xArray[n_len-1];
		//_posCur
		_posCur = _lg._posCur;
		rePlot();
		createFrame();
	}
	//frame
	/*tween is delayed, slow
						function tw(next:Number, time:Number):Void {
							//trace('tw called:'+this);
							var easeType = mx.transitions.easing.None.easeNone;
							new mx.transitions.Tween(_f, "_x", easeType, _f._x, next, time, true);
						}
						*/
	function setFrame(i:Number) {
		_posCur = i;
		moveFrame();
	}
	function moveFrame() {
		_f._x = cpX(xArray[_posCur]);
		//tw(cpX(xArray[_posCur]),1);
	}
	function createFrame() {
		_f = this.createEmptyMovieClip('f', this.getNextHighestDepth());
		_f.lineStyle(1, 0xFF0000, 50);
		_f.lineTo(0, 1000);
		moveFrame();
	}
	//convert point
	function cpX(x):Number {
		var px;
		px = _ratio_x*(x-xmin)+_LEFT;
		return px;
	}
	function cpY(y):Number {
		var py;
		py = _h-_ratio_y*(y-ymin)+_TOP;
		return py;
	}
	function rePlot() {
		//moveFrame first
		moveFrame();
		clear();
		//private
		var w_out = win.width;
		//var h_out = win.height-30;
		//revised for WinSize;
		var h_out = win.height;
		_w = w_out-_LEFT-_RIGHT;
		_h = h_out-_TOP-_BOTTOM;
		//recompute ratio
		_ratio_x = _w/(xmax-xmin);
		_ratio_y = _h/(ymax-ymin);
		//draw
		lineStyle(1, 0x000000, 50);
		//axis
		var pt_x = {x:_LEFT, y:_TOP};
		var pt_o = {x:_LEFT, y:_TOP+_h};
		var pt_y = {x:_LEFT+_w, y:_TOP+_h};
		moveTo(_LEFT, _TOP);
		lineTo(_LEFT, _TOP+_h);
		lineTo(_LEFT+_w, _TOP+_h);
		//axis arrow
		_mc_ar_x.removeMovieClip();
		_mc_ar_y.removeMovieClip();
		_mc_ar_x = attachMovie('IVArrow', 'ar_', getNextHighestDepth(), {p0:pt_x, p1:pt_o});
		_mc_ar_y = attachMovie('IVArrow', 'ar_', getNextHighestDepth(), {p0:pt_y, p1:pt_o});
		//choose arrow color
		_mc_ar_x.gotoAndStop(30);
		_mc_ar_y.gotoAndStop(30);
		//curve
		moveTo(cpX(xArray[0]), cpY(yArray[0]));
		for (var i = 1; i<n_len; i++) {
			lineTo(cpX(xArray[i]), cpY(yArray[i]));
		}
	}
}
