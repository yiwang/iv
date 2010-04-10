//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  IVReaction
*
*  Author: Yi Wang
*  Date created: 3/29/05
*  Description: 
*               
*/
//[IconFile("IVReaction.png")]
import iv.utils.Flux;
import iv.utils.Bezier;
import iv.utils.Loger;
[TagName("IVReaction")]
class iv.core.IVReaction extends MovieClip {
	//____________start component stuff
	static var symbolName:String = "IVReaction";
	static var symbolOwner:Object = iv.core.IVReaction;
	static var version:String = "0.0.2.0";
	//____________end component stuff
	//color
	var COLOR_POSITIVE = 0x6633CC;
	var COLOR_NEGATIVE = 0xFF0000;
	var COLOR_ZERO = 0x00FF00;
	//passed in
	private var _lg;
	private var _dp;
	private var _m_sbml:XML;
	//external data
	private var _a_reactants:Array;
	private var _a_products:Array;
	private var _a_pts:Array;
	private var _pt_arcCenter;
	private var _a_species:Array;
	//internal data
	private var _o_reactants:Object;
	private var _o_products:Object;
	//flag
	private var _b_isUniUni:Boolean;
	private var _pt0_Uni;
	private var _pt1_Uni;
	private var _pt2_Uni;
	private var _pt3_Uni;
	//array for _a_arrows
	private var _a_arrows:Array;
	//id and _this
	public var id:String;
	private var _this;
	//override set _visible
	//flux
	private var _flux;
	public var mc_flux_static:MovieClip;
	private var _o_flux_static_max_thick:Number;
	private var _o_flux_static_max_color:Number;
	private var _o_flux_static_min_thick:Number;
	private var _o_flux_static_min_color:Number;
	//flag
	private var _b_visible_dynamic:Boolean = true;
	private var _b_visible_static:Boolean = true;
	function IVReaction() {
		//trick to avoid Syntax error
		//{_lg:_lg, reaction:a[r], a_species:b}
		_this = this;
		_m_sbml = _lg.m_sbml;
	}
	function onLoad() {
		//flux visible issue
		var Owner = this;
		_flux = new Flux();
		_flux.setVisible = function(b:Boolean) {
			//trace("[Flux: setVisible] handled in IVReaction");
			Owner._b_visible_dynamic = b;
			Owner.reDrawArcs();
		};
		_flux.getVisible = function() {
			//trace("[Flux: getVisible] handled in IVReaction");
			return Owner._b_visible_dynamic;
		};
		mc_flux_static = this.createEmptyMovieClip('flux_static', this.getNextHighestDepth());
		_dp.a_layer_r.push(_flux);
		_dp.a_layer_log_r.push(mc_flux_static);
		//trace('IVReaction:onLoad\t'+_this.reaction.id);
		importSpecies();
		importReaction();
		//actually no need to call this since rewind() do
		reDrawArcs();
		initArrows();
		//label
		_dp.a_layer_lb_r.push(attachMovie('IVLabel', 'lb_r_'+_this.reaction.id, getNextHighestDepth(), {_lg:_lg, labelType:'Reaction', id:_this.reaction.id, attri:_pt_arcCenter, label:_this.reaction.id}));
	}
	function importSpecies() {
		//trace('IVReaction:importSpecies\t'+_this.reaction.id);
		_a_species = _this.a_species;
	}
	function importReaction() {
		//trace('IVReaction:importReactions\t'+_this.reaction.id);
		_a_reactants = _this.reaction.value.childNodes[0].childNodes;
		_a_products = _this.reaction.value.childNodes[1].childNodes;
		_a_pts = _this.reaction.value.childNodes[2].childNodes[0];
		_pt_arcCenter = _a_pts.childNodes[0].attributes;
		//check _b_isUniUni
		if (_a_reactants.length == 1 && _a_products.length == 1) {
			_b_isUniUni = true;
		} else {
			_b_isUniUni = false;
		}
		//trace('IVReaction:_b_isUniUni:\t'+_b_isUniUni);
		if (_b_isUniUni) {
			//reactant
			var r = _a_reactants[0];
			_pt0_Uni = assign_p0_shadow(r);
			//_pt0_Uni = _m_sbml[_a_reactants[0].attributes.species].childNodes[0].childNodes[0].attributes;
			//Bezier control points
			_pt1_Uni = _a_pts.childNodes[1].attributes;
			_pt2_Uni = _a_pts.childNodes[2].attributes;
			//product
			r = _a_products[0];
			_pt3_Uni = assign_p0_shadow(r);
			//_pt3_Uni = _m_sbml[_a_products[0].attributes.species].childNodes[0].childNodes[0].attributes;
			_pt_arcCenter = Bezier.findMiddlePoint(_pt0_Uni, _pt1_Uni, _pt2_Uni, _pt3_Uni);
		} else {
			//assign to internal data
			_o_reactants = new Object();
			_o_products = new Object();
			for (var i in _a_reactants) {
				var r = _a_reactants[i];
				var spID:String = r.attributes.species;
				var p0 = assign_p0_shadow(r);
				var p1 = _a_pts.childNodes[i*2+1].attributes;
				var p2 = _a_pts.childNodes[i*2+2].attributes;
				_o_reactants[spID] = [p0, p1, p2];
			}
			var pBase:Number = _a_reactants.length;
			for (var i in _a_products) {
				var r = _a_products[i];
				var spID:String = r.attributes.species;
				var p0 = assign_p0_shadow(r);
				/////////////////////////////////////////
				//be much careful that i is a string.
				/////////////////////////////////////////
				var p1 = _a_pts.childNodes[i*2+pBase*2+1].attributes;
				var p2 = _a_pts.childNodes[i*2+pBase*2+2].attributes;
				//the order is different from _o_reactants
				_o_products[spID] = [p0, p2, p1];
			}
		}
	}
	/////////////////////////////////////////
	//assign_p0_shadow
	/////////////////////////////////////////	
	function assign_p0_shadow(r) {
		var spID:String = r.attributes.species;
		var p0;
		// = new Object();
		if (r.hasChildNodes()) {
			var spID_shadow:String = r.childNodes[0].childNodes[0].attributes.shadowRef;
			var a_shadows = _lg.a_sp_shadow[_lg.o_sp_shadow[spID]];
			for (var i in a_shadows) {
				if (a_shadows[i].attributes.name == spID_shadow) {
					p0 = a_shadows[i].attributes;
					//trace(p0);
					//trace(a_shadows[i].attributes);
					//return a_shadows[i].attributes;
					/////////////////////////////////////////
					//p0 = undefined and it seems p0.x can be accessed by chance?
					/////////////////////////////////////////							
					//Loger.error(33, p0.x);
					//p0.x = a_shadows[i].attributes.x;
					//p0.y = a_shadows[i].attributes.y;
					break;
				}
			}
		} else {
			p0 = _m_sbml[spID].childNodes[0].childNodes[0].attributes;
			//return _m_sbml[spID].childNodes[0].childNodes[0].attributes;
		}
		//trace('[p0]'+p0.x+'f'+p0.y);
		return p0;
	}
	function tw(value:Number) {
		_value = value;
		reDrawArcs();
		reDrawArrows(value);
	}
	function setFluxStatic(p1, p2, p3, p4) {
		_o_flux_static_max_thick = p1;
		_o_flux_static_max_color = p2;
		_o_flux_static_min_thick = p3;
		_o_flux_static_min_color = p4;
	}
	private var _value:Number = 0;
	function reDrawArcs() {
		clear();
		mc_flux_static.clear();
		//actual work
		if (_b_isUniUni) {
			drawOneArc(_pt0_Uni, _pt1_Uni, _pt2_Uni, _pt3_Uni, _value);
		} else {
			for (var spID in _o_reactants) {
				drawOneArc(_o_reactants[spID][0], _o_reactants[spID][1], _o_reactants[spID][2], _pt_arcCenter, _value);
			}
			for (var spID in _o_products) {
				drawOneArc(_o_products[spID][0], _o_products[spID][1], _o_products[spID][2], _pt_arcCenter, _value);
			}
		}
	}
	function drawOneArc(p0, p1, p2, p3, value:Number) {
		//for dynamic layer
		if (_b_visible_dynamic) {
			var color:Number;
			if (value>0) {
				color = COLOR_POSITIVE;
			} else if (value<0) {
				color = COLOR_NEGATIVE;
			} else if (value == 0) {
				color = COLOR_ZERO;
			}
			Bezier.drawCurve(this, p0, p1, p2, p3, Math.abs(value), false, color);
		}
		//for static layer
		if (_dp.a_layer_log_r[0]._visible) {
			var alpha_max = 10;
			var alpha_min = 10;
			if (_o_flux_static_max_thick == 0) {
				alpha_max = 20;
			}
			if (_o_flux_static_min_thick == 0) {
				alpha_min = 20;
			}
			Bezier.drawCurve(mc_flux_static, p0, p1, p2, p3, _o_flux_static_max_thick, true, _o_flux_static_max_color, alpha_max);
			Bezier.drawCurve(mc_flux_static, p0, p1, p2, p3, _o_flux_static_min_thick, true, _o_flux_static_min_color, alpha_min);
		}
		//lineStyle(1, 0x000000, 50);
		//moveTo(p0.x, p0.y);
		//ineTo(p3.x, p3.y);
	}
	function reDrawArrows(value:Number) {
		for (var i in _a_arrows) {
			_a_arrows[i].tw(value);
		}
	}
	//init
	function initArrows() {
		_a_arrows = new Array();
		if (_b_isUniUni) {
			_a_arrows[0] = attachMovie('IVArrow', 'ar_'+_this.reaction.id, getNextHighestDepth(), {p0:_pt3_Uni, p1:_pt2_Uni});
		} else {
			for (var spID in _o_products) {
				_a_arrows.push(attachMovie('IVArrow', 'ar_'+_this.reaction.id+spID, getNextHighestDepth(), {p0:_o_products[spID][0], p1:_o_products[spID][1]}));
			}
		}
		//register arrow array to a_layer_arrow
		_dp.a_layer_arrow = _dp.a_layer_arrow.concat(_a_arrows);
	}
}
