//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  ArrayAscii
*
*  Author: Yi Wang
*  Date created: 3/24/05
*  Description: 
*               Only for swf file on http server deployment
*/
//[IconFile("ArrayAscii.png")]
[TagName("ArrayAscii")]
class iv.utils.ArrayAscii {
	//____________start component stuff
	static var symbolName:String = "ArrayAscii";
	static var symbolOwner:Object = iv.utils.ArrayAscii;
	static var version:String = "0.0.2.0";
	//____________end component stuff
	//const
	//private var _LEN_ELE:Number = 16;
	//_lg
	private var _lg;
	//public
	public var n2d:Array;
	public var n2d_r:Array;
	public var n1d:Array;
	public var s1d:Array;
	public var s1d_r:Array;
	function ArrayAscii(lg) {
		_lg = lg;
	}
	//s1d_r
	public function loadAscii_s1d_r(str_filePath:String):Void {
		s1d_r = undefined;
		var _xml = new XML();
		_xml._tempArrayAscii = this;
		_xml.onLoad = function(success) {
			if (!success) {
				trace('loadAscii_s1d_r: Error when load xml file!');
				return;
			}
			var s:String = this.childNodes[0].nodeValue;
			//var str_array_all:Array = s.split('\r\n');
			var str_array_all:Array = s.split('\n');
			//trace(str_array_all);
			//notice ending with \r\n
			//define n_repeat
			var n_repeat:Number = str_array_all.length-1;
			//define a
			var a = this._tempArrayAscii.s1d_r=new Array(n_repeat);
			for (var i = 0; i<n_repeat; i++) {
				a[i] = str_array_all[i];
			}
			this._tempArrayAscii._lg.onLoadFiles();
		};
		_xml.load(str_filePath);
	}
	//s1d
	public function loadAscii_s1d(str_filePath:String):Void {
		s1d = undefined;
		var _xml = new XML();
		_xml._tempArrayAscii = this;
		_xml.onLoad = function(success) {
			if (!success) {
				trace('loadAscii_s1d: Error when load xml file!');
				return;
			}
			var s:String = this.childNodes[0].nodeValue;
			//var str_array_all:Array = s.split('\r\n');
			var str_array_all:Array = s.split('\n');
			//notice ending with \r\n
			//define n_repeat
			var n_repeat:Number = str_array_all.length-1;
			//define a
			var a = this._tempArrayAscii.s1d=new Array(n_repeat);
			for (var i = 0; i<n_repeat; i++) {
				a[i] = str_array_all[i];
			}
			this._tempArrayAscii._lg.onLoadFiles();
			trace('n_repeat: '+n_repeat);
			trace('s:'+ s);
			trace('s1d: '+a);
		};
		_xml.load(str_filePath);
		trace('str_filePath: '+str_filePath);
	}
	//n1d
	public function loadAscii_n1d(str_filePath:String):Void {
		n1d = undefined;
		var _xml = new XML();
		_xml._tempArrayAscii = this;
		_xml.onLoad = function(success) {
			if (!success) {
				trace('loadAscii_n1d: Error when load xml file!');
				return;
			}
			var s:String = this.childNodes[0].nodeValue;
			//var str_array_all:Array = s.split('\r\n');
			var str_array_all:Array = s.split('\n');			
			//notice ending with \r\n
			//define n_repeat
			var n_repeat:Number = str_array_all.length-1;
			//define a
			var a = this._tempArrayAscii.n1d=new Array(n_repeat);
			for (var i = 0; i<n_repeat; i++) {
				a[i] = Number(str_array_all[i]);
			}
			this._tempArrayAscii._lg.onLoadFiles();
		};
		_xml.load(str_filePath);
	}
	//n2d
	public function loadAscii_n2d(str_filePath:String):Void {
		n2d = undefined;
		var _xml = new XML();
		_xml._tempArrayAscii = this;
		_xml.onLoad = function(success) {
			if (!success) {
				trace('loadAscii_n2d: Error when load xml file!');
				return;
			}
			var s:String = this.childNodes[0].nodeValue;
			//var str_array_all:Array = s.split('\r\n');
			var str_array_all:Array = s.split('\n');			
			//notice ending with \r\n
			//'  ' is for positive number, ' -' for negative
			//define n_repeat, n_species
			var n_repeat:Number = str_array_all.length-1;
			var n_species = Math.round(str_array_all[0].length/16);
			//define a
			var a = this._tempArrayAscii.n2d=new Array(n_repeat);
			for (var i = 0; i<n_repeat; i++) {
				a[i] = new Array(n_species);
			}
			//assign value to num_array2d
			for (var i = 0; i<n_repeat; i++) {
				for (var j = 0; j<n_species; j++) {
					//convert to number
					a[i][j] = Number(str_array_all[i].substr(j*16, 16));
				}
			}
			this._tempArrayAscii._lg.onLoadFiles();
			trace('n_species: '+n_species);
		};
		_xml.load(str_filePath);
	}
	//n2d_r
	public function loadAscii_n2d_r(str_filePath:String):Void {
		n2d_r = undefined;
		var _xml = new XML();
		_xml._tempArrayAscii = this;
		_xml.onLoad = function(success) {
			if (!success) {
				trace('loadAscii_n2d_r: Error when load xml file!');
				return;
			}
			var s:String = this.childNodes[0].nodeValue;
			//var str_array_all:Array = s.split('\r\n');
			var str_array_all:Array = s.split('\n');			
			//notice ending with \r\n
			//'  ' is for positive number, ' -' for negative
			//define n_repeat, n_species
			var n_repeat:Number = str_array_all.length-1;
			var n_species = Math.round(str_array_all[0].length/16);
			//define a
			var a = this._tempArrayAscii.n2d_r=new Array(n_repeat);
			for (var i = 0; i<n_repeat; i++) {
				a[i] = new Array(n_species);
			}
			//assign value to num_array2d
			for (var i = 0; i<n_repeat; i++) {
				for (var j = 0; j<n_species; j++) {
					//convert to number
					a[i][j] = Number(str_array_all[i].substr(j*16, 16));
				}
			}
			this._tempArrayAscii._lg.onLoadFiles();
		};
		_xml.load(str_filePath);
	}
}
