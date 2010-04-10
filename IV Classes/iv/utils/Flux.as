//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  Flux
*
*  Author: Yi Wang
*  Date created: 4/25/05
*  Description: 
*               
*/
//[IconFile("Flux.png")]
[TagName("Flux")]
class iv.utils.Flux {
	//____________start component stuff
	static var symbolName:String = "Flux";
	static var symbolOwner:Object = iv.utils.Flux;
	static var version:String = "0.0.1.0";
	//____________end component stuff
	function Flux() {
	}
	public function set _visible(b:Boolean) {
		setVisible(b);
	}
	public function get _visible():Boolean {
		return getVisible();
	}
	function getVisible(b:Boolean) {
		trace("[Flux: getVisible] not handled");
		return 'not handled';
	}
	function setVisible(b:Boolean) {
		trace("[Flux: setVisible] not handled");
	}
}
