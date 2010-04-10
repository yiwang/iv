//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  IVLabel
*
*  Author: Yi Wang
*  Date created: 3/29/05
*  Description: 
*               
*/
//[IconFile("IVLabel.png")]
import iv.utils.Loger;
[TagName("IVLabel")]
class iv.core.IVLabel extends mx.core.UIObject {
	//____________start component stuff
	static var symbolName:String = "IVLabel";
	static var symbolOwner:Object = iv.core.IVLabel;
	static var version:String = "0.0.2.0";
	//____________end component stuff
	//global
	private var _this;
	private var _lg;
	//pass in properties
	private var labelType:String;
	private var id:String;
	private var attri;
	private var label;
	//subcomponent
	private var text_label:TextField;
	function IVLabel() {
		//trace('IVLabel:'+this['label']);
		_this = this;
		_x = attri.x;
		_y = attri.y;
	}
	function onLoad() {
		addEventListener('lbOnRelease_Species', _lg);
		addEventListener('lbOnRelease_Reaction', _lg);
		var text_format:TextFormat = new TextFormat();
		if (labelType == 'Species_shadow') {
			text_format.italic = true;
		}
		if (labelType == 'Reaction') {
			//text_format.underline = true;
			text_label.border = true;
			text_label.borderColor =0x6633CC;
			text_format.color = 0x6633CC;
		}
		text_label.setTextFormat(text_format);
		text_label.autoSize = 'center';
	}
	function onRelease() {
		if (labelType == 'Species' || labelType == 'Species_shadow') {
			//trace(this+'Species\t'+id);
			dispatchEvent({type:"lbOnRelease_Species", id:id});
		}
		if (labelType == 'Reaction') {
			//trace(this+'Species\t'+id);
			dispatchEvent({type:"lbOnRelease_Reaction", id:id});
		}
	}
}
