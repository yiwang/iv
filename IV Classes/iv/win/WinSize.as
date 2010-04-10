//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  WinSize
*
*  Author: Yi Wang
*  Date created: 4/1/05
*  Description: 
*               
*/
//[IconFile("WinSize.png")]
import mx.utils.Delegate;
//import mx.controls.UIScrollBar;
import iv.core.IVPlot;
import mx.controls.Button;
[TagName("WinSize")]
class iv.win.WinSize extends mx.core.UIComponent {
	//____________start component stuff
	static var symbolName:String = "WinSize";
	static var symbolOwner:Object = iv.win.WinSize;
	static var version:String = "0.0.2.0";
	//____________end component stuff
	//sub components
	var sizeSquare:MovieClip;
	//const
	private var _SHIFT_X = 3;
	private var _SHIFT_Y = 31;
	//passed in 
	public var id;
	private var _p;
	private var _lg;
	//type
	public var typeWin:String;
	//plot
	public var _plot;
	//flag
	private var _b_isDrag;
	function WinSize() {
	}
	function onLoad() {
		_p = _parent;
		_lg = _p._lg;
		typeWin = _p.typeWin;
		id = _p.id;
		_b_isDrag = false;
		//position of sizeSquare
		sizeSquare._x=_p.width-sizeSquare._width-_SHIFT_X;
		sizeSquare._y=_p.height-sizeSquare._height-_SHIFT_Y;
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
	}
	//events
	function sq_onPress() {
		//trace('WinSize:sq_onPress');
		sizeSquare.startDrag();
		_b_isDrag = true;
	}
	function sq_onMove() {
		//trace('WinSize:sq_onMove');
		//trace(sizeSquare._width+'\t'+sizeSquare._height+'\t');
		if (_b_isDrag) {
			_p.setSize(_SHIFT_X+sizeSquare._x+sizeSquare._width, _SHIFT_Y+sizeSquare._y+sizeSquare._height);
			_plot.rePlot();
		}
	}
	function sq_onRelease() {
		//trace('WinSize:onRelease');
		sizeSquare.stopDrag();
		_b_isDrag = false;
	}
	//plot
	function initPlot() {
		trace('initPlot: '+typeWin);
		_plot = this.createClassObject(IVPlot, 'plot_sp_'+id, this.getNextHighestDepth(), {typePlot:typeWin,win:_parent, _lg:_lg, id:id});
	}
}
