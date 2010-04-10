//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  Bezier
*
*  Author: Yi Wang
*  Date created: 3/29/05
*  Description: 
*               
*/
//[IconFile("Bezier.png")]
[TagName("Bezier")]
class iv.utils.Bezier {
	//____________start component stuff
	static var symbolName:String = "Bezier";
	static var symbolOwner:Object = iv.utils.Bezier;
	static var version:String = "0.0.0.2";
	//____________end component stuff
	private static var _LIMIT_MIN_THICK = 3;
	private static var _LIMIT_MAX_THICK = 20;
	private static var _LIMIT_MIN_ALPHA = 50;
	private static var _LIMIT_MAX_ALPHA = 20;
	private static var _ratio_alpha_thick;
	function Bezier() {
		_ratio_alpha_thick = (_LIMIT_MAX_ALPHA-_LIMIT_MIN_ALPHA)/(_LIMIT_MAX_THICK-_LIMIT_MIN_THICK);
	}
	public static function findMiddlePoint(p0, p1, p2, p3):Object {
		var b0, b1, b2, b3;
		var v;
		var px, py;
		//calc middle point on the curve
		var u = 0.5;
		v = 1-u;
		b0 = v*v*v;
		b1 = 3*u*v*v;
		b2 = 3*u*u*v;
		b3 = u*u*u;
		px = b0*p0.x+b1*p1.x+b2*p2.x+b3*p3.x;
		py = b0*p0.y+b1*p1.y+b2*p2.y+b3*p3.y;
		return {x:px, y:py};
	}
	public static function drawCurve(mc:MovieClip, p0, p1, p2, p3, lineThick:Number, b_static:Boolean, color:Number, alpha:Number) {
		if (b_static) {
			mc.lineStyle(lineThick, color, alpha);
		} else {
			//set alpha
			if (lineThick>_LIMIT_MAX_THICK) {
				var alpha = _LIMIT_MAX_ALPHA;
			} else {
				alpha = _LIMIT_MIN_ALPHA+_ratio_alpha_thick*(lineThick-_LIMIT_MIN_THICK);
				//the alpha for lineThick==0 will be special largest.
			}
			mc.lineStyle(lineThick, color, alpha);
		}
		mc.moveTo(p0.x, p0.y);
		var res = 1/24;
		var b0, b1, b2, b3;
		var v;
		var px, py;
		for (var u = 0; u<=1; u += res) {
			v = 1-u;
			b0 = v*v*v;
			b1 = 3*u*v*v;
			b2 = 3*u*u*v;
			b3 = u*u*u;
			px = b0*p0.x+b1*p1.x+b2*p2.x+b3*p3.x;
			py = b0*p0.y+b1*p1.y+b2*p2.y+b3*p3.y;
			mc.lineTo(px, py);
		}
	}
}
