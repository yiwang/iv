//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  Win
*
*  Author: Yi Wang
*  Date created: 3/31/05
*  Description: 
*               
*/
//[IconFile("Win.png")]
import mx.utils.Delegate;
import mx.controls.UIScrollBar;
import iv.core.IVPlot;
[TagName("Win")]
class iv.win.Win extends mx.core.UIObject {
	//____________start component stuff
	static var symbolName:String = "Win";
	static var symbolOwner:Object = iv.win.Win;
	static var version:String = "0.0.0.1";
	//____________end component stuff
	//const
	private var _LIMIT_MIN_SCALE = 150;
	private var _LIMIT_MAX_SCALE = 600;
	private var _ratio_wScaleBar:Number;
	private var _ratio_hScaleBar:Number;
	//sub components	
	var text_virtual_H:TextField;
	var text_virtual_W:TextField;
	var sBar_H:UIScrollBar;
	var sBar_W:UIScrollBar;
	//passed in 
	public var id;
	private var _p;
	private var _lg;
	//plot
	public var _plot;
	function Win() {
	}
	function onLoad() {
		trace('win:'+this.x+'\t'+this.y+'\t '+this.width+'\t'+this.height);
		_x= 0;
		_y =0;
		_p = _parent;
		_lg = _p._lg;
		id = _p.id;
		//setup text_vitual
		text_virtual_H._visible = false;
		text_virtual_W._visible = false;
		var s_const:String = new String('          ');
		var s:String = new String();
		for (var i = 0; i<100; i++) {
			s += i+s_const;
		}
		text_virtual_H.text = s;
		text_virtual_W.text = s;
		//Bars
		sBar_H.addEventListener("scroll", Delegate.create(this, hScroll));
		sBar_W.addEventListener("scroll", Delegate.create(this, wScroll));
		//ratios
		_ratio_wScaleBar = (_LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE)/(text_virtual_W.maxhscroll-1);
		_ratio_hScaleBar = (_LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE)/(text_virtual_H.maxscroll-1);
		//		doLater(this, 'initPlot');
		initPlot();
	}
	//plot
	function plot() {
		_plot.clear();
		_plot.rePlot();
	}
	function initPlot() {
		_plot = this.createClassObject(IVPlot, 'sp_'+id, this.getNextHighestDepth(),{win:_parent,_lg:_lg,id:id});
	}
	//scroll events
	function hScroll() {
		var v = _ratio_hScaleBar*sBar_H.scrollPosition+_LIMIT_MIN_SCALE;
		_p.setSize(_p.width, _ratio_hScaleBar*sBar_H.scrollPosition+_LIMIT_MIN_SCALE);
		plot();
	}
	function wScroll() {
		var v = _ratio_wScaleBar*sBar_W.scrollPosition+_LIMIT_MIN_SCALE;
		_p.setSize(_ratio_wScaleBar*sBar_W.scrollPosition+_LIMIT_MIN_SCALE, _p.height);
		plot();
	}
}
