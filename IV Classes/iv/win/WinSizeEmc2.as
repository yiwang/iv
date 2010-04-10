//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  WinSizeEmc2
*
*  Author: Yi Wang
*  Date created: 4/2/05
*  Description: 
*               
*/
//[IconFile("WinSizeEmc2.png")]
//import mx.utils.Delegate;
//import mx.controls.UIScrollBar;
//import iv.core.IVPlot;
//import mx.controls.Button;
import mx.controls.TextArea;
[TagName("WinSizeEmc2")]
class iv.win.WinSizeEmc2 extends iv.win.WinSize {
	//____________start component stuff
	static var symbolName:String = "WinSizeEmc2";
	static var symbolOwner:Object = iv.win.WinSizeEmc2;
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
	function WinSizeEmc2() {
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
							//trace('WinSizeEmc2:sq_onPress');
							sizeSquare.startDrag();
							_b_isDrag = true;
						}
						function sq_onMove() {
							//trace('WinSizeEmc2:sq_onMove');
							//trace(sizeSquare._width+'\t'+sizeSquare._height+'\t');
							if (_b_isDrag) {
								_p.setSize(_SHIFT_X+sizeSquare._x+sizeSquare._width, _SHIFT_Y+sizeSquare._y+sizeSquare._height);
								_plot.rePlot();
							}
						}
						function sq_onRelease() {
							//trace('WinSizeEmc2:onRelease');
							sizeSquare.stopDrag();
							_b_isDrag = false;
						}
						//plot
						function initPlot() {
							_plot = this.createClassObject(IVPlot, 'plot_sp_'+id, this.getNextHighestDepth(), {win:_parent, _lg:_lg, id:id});
						}*/
	//override initPlot
	function initPlot() {
		//trace('WinSizeEmc2:override initPlot');
		_plot = this.attachMovie('emc2Image', 'plot_emc2_'+id, this.getNextHighestDepth(), {win:_parent, _lg:_lg, id:id});
		//_plot.setSize(_p.width-_SHIFT_X-3, _p.height-_SHIFT_Y-20);
		var Owner = this;
		var wScale = _plot._width;
		var yScale = _plot._height;
		_plot.rePlot = function() {
			Owner._plot._height = Owner._p.height-Owner._SHIFT_Y-20;
			Owner._plot._width = Owner._plot._height*wScale/yScale;
		};
		_plot.rePlot();
	}
}
