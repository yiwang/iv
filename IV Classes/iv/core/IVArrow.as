//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  IVArrow
*
*  Author: Yi Wang
*  Date created: 3/30/05
*  Description: 
*               
*/
//[IconFile("IVArrow.png")]
import iv.utils.Loger;
[TagName("IVArrow")]
class iv.core.IVArrow extends MovieClip {
	//____________start component stuff
	static var symbolName:String = "IVArrow";
	static var symbolOwner:Object = iv.core.IVArrow;
	static var version:String = "0.0.1.0";
	//____________end component stuff
	//private
	private var _LIMIT_MIN_SCALE = 0;
	private var _LIMIT_MAX_SCALE = 20;
	//correspond to below in Disp
	//private var _LIMIT_MIN_THICK = 1;
	//private var _LIMIT_MAX_THICK = 20;
	private var _LIMIT_MIN_ALPHA = 100;
	private var _LIMIT_MAX_ALPHA = 50;
	private var _ratio_alpha_scale;
	//_this
	private var _this;
	function IVArrow() {
		_this = this;
		//_alpha = 20;
		//trace(_alpha);
		_ratio_alpha_scale = (_LIMIT_MAX_ALPHA-_LIMIT_MIN_ALPHA)/(_LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE);
	}
	function onLoad() {
		//trace('IVArrow:onLoad');
		_x = _this.p0.x;
		_y = _this.p0.y;
		_rotation = 180*Math.atan2(_this.p0.y-_this.p1.y, _this.p0.x-_this.p1.x)/Math.PI;
		//it's not needed since rewind() will triger tw();
		//tw(_this.scaleFactor);
	}
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
		if (value != 0) {
			var v = Math.abs(value);
			_xscale = (v/4+1)*100;
			_yscale = (v/4+1)*100;
			if (v>_LIMIT_MAX_SCALE) {
				_alpha = _LIMIT_MAX_ALPHA;
			} else {
				_alpha = _LIMIT_MIN_ALPHA+_ratio_alpha_scale*(v-_LIMIT_MIN_SCALE);
			}
			//for negative value
			if (value<0) {
				_xscale = -_xscale;
				_yscale = -_yscale;
			}
		}
	}
}
