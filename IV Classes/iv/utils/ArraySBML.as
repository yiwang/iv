//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  ArraySBML
*
*  Author: Yi Wang
*  Date created: 3/28/05
*  Description: 
*               
*/
//[IconFile("ArraySBML.png")]
[TagName("ArraySBML")]
class iv.utils.ArraySBML {
	//____________start component stuff
	static var symbolName:String = "ArraySBML";
	static var symbolOwner:Object = iv.utils.ArraySBML;
	static var version:String = "0.0.0.2";
	//____________end component stuff
	//_lg
	private var _lg;
	//public
	public var sbml_root:XML;
	public var sp1d:Array;
	public var r1d:Array;
	public var s_id_model:String;
	public var s_level_sbml:String;
	function ArraySBML(lg) {
		_lg = lg;
	}
	//s1d
	public function loadSBML(str_filePath:String):Void {
		//init
		sbml_root = undefined;
		sp1d = undefined;
		r1d = undefined;
		//xml
		var owner:ArraySBML = this;
		var _xml:XML = new XML();
		//set ignoreWhite
		_xml.ignoreWhite = true;
		//parseXML works here
		//_xml.parseXML(s_xml);
		_xml.onLoad = function(success:Boolean) {
			if (!success) {
				trace('loadSBML: Error when load xml file!');
				return;
			}
			owner.onLoadSBML(this);
		};
		_xml.load(str_filePath);
		//onLoad will never be called when using XML(s:String)
		//_xml.onLoad(true);
	}
	function onLoadSBML(_xml:XML) {
		sbml_root = _xml;
		//trace('_xml: '+_xml);
		sp1d = new Array();
		r1d = new Array();
		s_level_sbml = _xml.childNodes[0].attributes.level;
		for (var node in _xml) {
			switch (_xml[node].nodeName) {
			case "model" :
				s_id_model = node;
				break;
			case "species" :
				sp1d.push({id:node, value:_xml[node]});
				break;
			case "reaction" :
				r1d.push({id:node, value:_xml[node]});
				break;
			}
		}
		_lg.onLoadFiles();
	}
}
