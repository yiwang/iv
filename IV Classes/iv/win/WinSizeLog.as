//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  WinSizeLog
*
*  Author: Yi Wang
*  Date created: 4/2/05
*  Description: 
*               
*/
//[IconFile("WinSizeLog.png")]
//import mx.utils.Delegate;
//import mx.controls.UIScrollBar;
//import iv.core.IVPlot;
//import mx.controls.Button;
import mx.controls.TextArea;
[TagName("WinSizeLog")]
class iv.win.WinSizeLog extends iv.win.WinSize {
	//____________start component stuff
	static var symbolName:String = "WinSizeLog";
	static var symbolOwner:Object = iv.win.WinSizeLog;
	static var version:String = "0.0.0.1";
	//____________end component stuff
		//const
	private var _SHIFT_X = 3;
	private var _SHIFT_Y = 31;
	//sub components
	/*var sizeSquare:MovieClip;
			//const
			private var _SHIFT_X = 3;
			private var _SHIFT_Y = 31;
			//passed in 
			public var id;
			private var _p;
			private var _lg;
			//plot
			public var _plot;
			//flag
			private var _b_isDrag;*/
	function WinSizeLog() {
	}
	/*
			function onLoad() {
				_p = _parent;
				_lg = _p._lg;
				id = _p.id;
				_b_isDrag = false;
				//event
				var Owner = this;
				sizeSquare.onPress = function() {
					Owner.sq_onPress();
				};
				sizeSquare.onMouseMove = function() {
					Owner.sq_onMove();
				};
				sizeSquare.onRelease = function() {
					Owner.sq_onRelease();
				};
				//sizeSquare.addEventListener("onPress", Delegate.create(this, sq_onRelease ));
				//^^^^^^^now work
				initPlot();
				trace('')
			}
			//events
			function sq_onPress() {
				//trace('WinSizeLog:sq_onPress');
				sizeSquare.startDrag();
				_b_isDrag = true;
			}
			function sq_onMove() {
				//trace('WinSizeLog:sq_onMove');
				//trace(sizeSquare._width+'\t'+sizeSquare._height+'\t');
				if (_b_isDrag) {
					_p.setSize(_SHIFT_X+sizeSquare._x+sizeSquare._width, _SHIFT_Y+sizeSquare._y+sizeSquare._height);
					_plot.rePlot();
				}
			}
			function sq_onRelease() {
				//trace('WinSizeLog:onRelease');
				sizeSquare.stopDrag();
				_b_isDrag = false;
			}
			//plot
			function initPlot() {
				_plot = this.createClassObject(IVPlot, 'plot_sp_'+id, this.getNextHighestDepth(), {win:_parent, _lg:_lg, id:id});
			}*/
	//override initPlot
	function initPlot() {
		//trace('WinSizeLog:override initPlot');
		_plot = this.createClassObject(TextArea, 'plot_log_'+id, this.getNextHighestDepth(), {win:_parent, _lg:_lg, id:id});
		_plot.setSize(_p.width-_SHIFT_X-3,_p.height-_SHIFT_Y-20);
		_plot.editable = false;
		_plot.html = true;
		_plot.text = _lg.s_text_log;
		var Owner = this;
		_plot.rePlot=function(){
			Owner._plot.setSize(Owner._p.width-Owner._SHIFT_X-3,Owner._p.height-Owner._SHIFT_Y-20);
			Owner._plot.text = Owner._lg.s_text_log;
		}
	}
}
