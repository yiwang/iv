//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  IVShape
*
*  Author: Yi Wang
*  Date created: 3/24/05
*  Description: 
*               
*/
//[IconFile("IVShape.png")]
[TagName("IVShape")]
class iv.core.IVShape extends MovieClip {
	//____________start component stuff
	static var symbolName:String = "IVShape";
	static var symbolOwner:Object = iv.core.IVShape;
	static var version:String = "0.0.3.0";
	//____________end component stuff
	//cosnt
	private var _LIMIT_MIN_SCALE = 10;
	private var _LIMIT_MAX_SCALE = 200;
	private var _LIMIT_MIN_ALPHA = 90;
	private var _LIMIT_MAX_ALPHA = 20;
	private var _ratio_alpha_scale;
	//_this == this
	private var _initFrame;
	//IVShape frame
	var N_FRAME_SP_STATIC:Number = 1;
	var N_FRAME_SP_DYNAMIC:Number = 10;
	var N_FRAME_SP_SHADOW:Number = 20;
	var N_FRAME_SP_ZERO:Number = 30;
	function IVShape() {
		_alpha = 20;
		_ratio_alpha_scale = (_LIMIT_MAX_ALPHA-_LIMIT_MIN_ALPHA)/(_LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE);
	}
	function onLoad() {
		//choose the graph
		//can't call gotoAndStop(2) in IVShape()
		gotoAndStop(_initFrame);
	}
	//flag
	private var _pre:Number = 1;
	function tw(value:Number) {
		if (value>0) {
			if (_pre == 1) {
			} else if (_pre == -1) {
				gotoAndStop(_currentframe-1);
			} else if (_pre == 0) {
				gotoAndStop(_currentframe-2);
			}
			_pre = 1;
		} else if (value<0) {
			if (_pre == 1) {
				gotoAndStop(_currentframe+1);
			} else if (_pre == -1) {
			} else if (_pre == 0) {
				gotoAndStop(_currentframe-1);
			}
			_pre = -1;
		} else if (value == 0) {
			if (_pre == 1) {
				gotoAndStop(_currentframe+2);
			} else if (_pre == -1) {
				gotoAndStop(_currentframe+1);
			} else if (_pre == 0) {
			}
			_pre = 0;
		}
		if (value == 0) {
			_xscale = 100;
			_yscale = 100;
			_alpha = 100;
		} else {
			var v = Math.abs((value));
			_xscale = v;
			_yscale = v;
			if (v>_LIMIT_MAX_SCALE) {
				_alpha = _LIMIT_MAX_ALPHA;
			} else {
				_alpha = _LIMIT_MIN_ALPHA+_ratio_alpha_scale*(v-_LIMIT_MIN_SCALE);
			}
		}
	}
	function tw_v13(value:Number) {
		_xscale = value;
		_yscale = value;
		//_alpha = 120-next;
		_alpha = _LIMIT_MIN_ALPHA+_ratio_alpha_scale*(value-_LIMIT_MIN_SCALE);
		//the first time tw() call is made after IVShape() but before onLoad()
		//trace('IVShape:_alpha'+_ratio_alpha_scale);
	}
	function tw_old(next:Number, time:Number):Void {
		//trace('tw called:'+this);
		var easeType = mx.transitions.easing.None.easeNone;
		new mx.transitions.Tween(this, "_xscale", easeType, this._xscale, next, time, true);
		new mx.transitions.Tween(this, "_yscale", easeType, this._xscale, next, time, true);
		new mx.transitions.Tween(this, "_alpha", easeType, this._alpha, _LIMIT_MIN_ALPHA+_ratio_alpha_scale*(next-_LIMIT_MIN_SCALE), time, true);
	}
}
