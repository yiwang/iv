//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  ArrayHelper
*
*  Author: Yi Wang
*  Date created: 3/29/05
*  Description: 
*               
*/
//[IconFile("ArrayHelper.png")]
[TagName("ArrayHelper")]
class iv.utils.ArrayHelper {
	//____________start component stuff
	static var symbolName:String = "ArrayHelper";
	static var symbolOwner:Object = iv.utils.ArrayHelper;
	static var version:String = "0.0.2.5";
	//____________end component stuff
	static var _a:Array;
	static var _v:Number;
	function ArrayHelper() {
	}
	//assign value to all elements in the array
	static function assignAll(a:Array, v) {
		var len = a.length;
		for (var i = 0; i<len; i++) {
			a[i] = v;
		}
	}
	static function find_AbsMax_nonZero_1(a:Array):Number {
		var n_len = a.length;
		var max:Number;
		for (var i = 0; i<n_len; i++) {
			max = Math.abs(a[i]);
			if (max>0) {
				break;
			}
		}
		if (max == 0) {
			trace("[ArrayHelper:find_AbsMin_nonZero_1] max==0");
			return 0;
		}
		var temp:Number;
		for (var i = 0; i<n_len; i++) {
			temp = Math.abs(a[i]);
			if (temp != 0 && temp>max) {
				max = temp;
			}
		}
		return max;
	}
	static function find_AbsMin_nonZero_1(a:Array):Number {
		var n_len = a.length;
		var min:Number;
		for (var i = 0; i<n_len; i++) {
			min = Math.abs(a[i]);
			if (min>0) {
				break;
			}
		}
		if (min == 0) {
			trace("[ArrayHelper:find_AbsMin_nonZero_1] min==0");
			return 0;
		}
		var temp:Number;
		for (var i = 0; i<n_len; i++) {
			temp = Math.abs(a[i]);
			if (temp != 0 && temp<min) {
				min = temp;
			}
		}
		return min;
	}
	static function find_AbsMin_nonZero_2(a:Array):Number {
		var n_len_1 = a.length;
		var n_len_2 = a[0].length;
		var min:Number;
		for (var i = 0; i<n_len_1; i++) {
			for (var j = 0; j<n_len_2; j++) {
				min = Math.abs(a[i][j]);
				if (min>0) {
					break;
				}
			}
			if (min>0) {
				break;
			}
		}
		if (min == 0) {
			trace("[ArrayHelper:find_AbsMin_nonZero_2] min==0");
			return 0;
		}
		var temp:Number;
		for (var i = 0; i<n_len_1; i++) {
			for (var j = 0; j<n_len_2; j++) {
				temp = Math.abs(a[i][j]);
				if (temp != 0 && temp<min) {
					min = temp;
				}
			}
		}
		return min;
	}
	static function lookUpFirstIndex(a:Array, v:Number):Number {
		var n_len = a.length;
		for (var i = 0; i<n_len; i++) {
			if (a[i] == v) {
				return i;
			}
		}
		trace("[ArrayHelper:lookUpFirstIndex] not found");
		return -1;
	}
	//look up index from content
	static function lookUpIndex(a:Array, v:Number):Number {
		_a = a;
		_v = v;
		return rec2d(0, Math.round(_a.length/2), _a.length);
	}
	static function rec2d(l:Number, i:Number, r:Number):Number {
		if (l == r) {
			return i;
		}
		if (l+1 == r) {
			return i;
		}
		if (_a[i] == _v) {
			return i;
		} else if (_v<_a[i]) {
			if (_a[i-1]<_v) {
				return i;
			}
			return rec2d(l, Math.round((l+i)/2), i);
		} else if (_a[i]<_v) {
			if (_v<_a[i+1]) {
				return i;
			}
			return rec2d(i, Math.round((i+r)/2), r);
		}
	}
	//find min & max
	static function findMin(a:Array):Number {
		var min = a[0];
		var len = a.length;
		for (var i = 1; i<len; i++) {
			if (a[i]<min) {
				min = a[i];
			}
		}
		return min;
	}
	static function findMax(a:Array):Number {
		var max = a[0];
		var len = a.length;
		for (var i = 1; i<len; i++) {
			if (a[i]>max) {
				max = a[i];
			}
		}
		return max;
	}
}
