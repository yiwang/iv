//****************************************************************************
//Copyright (C) 2005  All Rights Reserved.
//****************************************************************************
/**
*  Disp
*
*  Author: Yi Wang
*  Date created: 3/24/05
*  Description: 
*               
*/
//[IconFile("Disp.png")]
import iv.utils.ArrayHelper;
import iv.core.IVShape;
import iv.utils.Loger;
[TagName("Disp")]
class iv.view.Disp extends mx.core.UIComponent {
	//____________start component stuff
	static var symbolName:String = "Disp";
	static var symbolOwner:Object = iv.view.Disp;
	static var version:String = "0.0.2.1";
	//____________end component stuff
	//instences of components
	//constants
	private var _LIMIT_TWEEN_SPECIES = 5;
	//the fast speed == the smallest interval
	private var _LIMIT_INTERVAL = 3;
	//the range of speed: from 1 to _LIMIT_SPEED
	private var _LIMIT_SPEED = 100;
	//the range of shpae scale
	private var _LIMIT_MIN_SCALE = 10;
	private var _LIMIT_MAX_SCALE = 200;
	//thick
	private var _LIMIT_MIN_THICK = 3;
	private var _LIMIT_MAX_THICK = 20;
	//bases static layers
	private var _LIMIT_MIN_BASE_SPECIES = 10;
	private var _LIMIT_MIN_BASE_FLUX = 3;
	//color
	var COLOR_POSITIVE = 0x6633CC;
	var COLOR_NEGATIVE = 0xFF0000;
	var COLOR_ZERO = 0x00FF00;
	//IVShape frame
	var N_FRAME_SP_STATIC:Number = 1;
	var N_FRAME_SP_DYNAMIC:Number = 10;
	var N_FRAME_SP_SHADOW:Number = 20;
	var N_FRAME_SP_ZERO:Number = 30;
	//define private properties
	private var _lg;
	private var _ctl;
	private var _stage;
	private var _stat;
	//play control
	private var _nextIntervalTime:Number;
	private var _direction:Number;
	private var _posStart:Number;
	private var _posEnd:Number;
	private var _posCur:Number;
	private var _speedFactor:Number;
	//model id
	private var s_id_model:String;
	//play data
	private var _a_time:Array;
	private var _a_spN:Array;
	private var _a_spD:Array;
	private var _n_time:Number;
	private var _n_sp:Number;
	//reactions
	private var _n_r:Number;
	private var _a_rN:Array;
	//max & min
	private var _a_time_interval:Array;
	private var _max_time_interval:Number;
	private var _min_time_interval:Number;
	private var _a_max_spData:Array;
	private var _a_min_spData:Array;
	//play flag
	private var _b_tw_reactions:Boolean;
	private var _b_tw_species:Boolean;
	private var _b_isPlaying:Boolean;
	private var _b_is_timelock:Boolean;
	//conform with static layer
	public var b_isConSp:Boolean;
	public var b_isConR:Boolean;
	public var n_factor_LogSp:Number;
	public var n_factor_LogR:Number;
	public var b_isLogSp:Boolean;
	public var b_isLogR:Boolean;
	//play speed & scale
	private var _ratio_itv_limit:Number;
	private var _a_ratio_scale:Array;
	private var _a_ratio_thick:Array;
	//play itv
	private var _itv_playOneStep;
	//scroll
	private var _maxhscroll:Number;
	private var _ratio_scroll:Number;
	private var _maxhscroll_speed:Number;
	private var _ratio_scroll_speed:Number;
	//public layer arrays
	public var a_layer_log_sp:Array;
	public var a_layer_log_r:Array;
	public var a_layer_sp:Array;
	public var a_layer_r:Array;
	public var a_layer_lb_sp:Array;
	public var a_layer_lb_r:Array;
	public var a_layer_arrow:Array;
	//	public var a_layers:Array;
	//constructor
	function Disp() {
	}
	function init() {
		super.init();
	}
	function onLoad() {
		_lg = _parent._parent.ivLg;
		_ctl = _parent._parent.ctrls;
		_stat = _parent._parent.stat;
		Mouse.addListener(this);
	}
	/////////////////////////////////////////
	//layer Control
	/////////////////////////////////////////	
	function setLayerVisible(layer:Array, b:Boolean) {
		var n_len:Number = layer.length;
		for (var i = 0; i<n_len; i++) {
			layer[i]._visible = b;
		}
	}
	function setScale_LogR() {
		//Base related to factor
		var n_Base:Number;
		if (b_isLogR) {
			n_Base = _LIMIT_MIN_BASE_FLUX-n_factor_LogR*Math.log(_lg.n_absMin_rData);
		} else {
			n_Base = _LIMIT_MIN_BASE_FLUX-n_factor_LogR*_lg.n_absMin_rData;
		}
		//loops
		var max_thick, max_color, min_thick, min_color;
		var data:Number;
		var n_len:Number = a_layer_log_r.length;
		for (var i = 0; i<n_len; i++) {
			if (_lg.o_rDataed[a_layer_log_r[i]._parent.id] == undefined) {
				trace('[Disp:setScale_LogR] r undefined');
				continue;
			}
			//max
			data = _lg.a_max_rData[_lg.o_rDataed[a_layer_log_r[i]._parent.id]];
			if (data>0) {
				max_color = COLOR_POSITIVE;
			}
			if (data<0) {
				max_color = COLOR_NEGATIVE;
			}
			if (data == 0) {
				max_color = COLOR_ZERO;
				max_thick = 0;
			}
			data = Math.abs(data);
			if (data != 0) {
				if (b_isLogR) {
					max_thick = n_Base+n_factor_LogR*Math.log(data);
				} else {
					max_thick = n_Base+n_factor_LogR*data;
				}
			}
			//min
			data = _lg.a_min_rData[_lg.o_rDataed[a_layer_log_r[i]._parent.id]];
			if (data>0) {
				min_color = COLOR_POSITIVE;
			}
			if (data<0) {
				min_color = COLOR_NEGATIVE;
			}
			if (data == 0) {
				min_color = COLOR_ZERO;
				min_thick = 0;
			}
			data = Math.abs(data);
			if (data != 0) {
				if (b_isLogR) {
					min_thick = n_Base+n_factor_LogR*Math.log(data);
				} else {
					min_thick = n_Base+n_factor_LogR*data;
				}
			}
			//final
			a_layer_log_r[i]._parent.setFluxStatic(max_thick, max_color, min_thick, min_color);
			a_layer_log_r[i]._parent.reDrawArcs();
		}
	}
	function setScale_LogSp() {
		//Base related to factor
		var n_Base:Number;
		if (b_isLogSp) {
			n_Base = _LIMIT_MIN_BASE_SPECIES-n_factor_LogSp*Math.log(Math.sqrt(_lg.n_absMin_spData));
		} else {
			n_Base = _LIMIT_MIN_BASE_SPECIES-n_factor_LogSp*Math.sqrt(_lg.n_absMin_spData);
		}
		//loops
		var n_len:Number = a_layer_log_sp.length;
		for (var i = 0; i<n_len; i++) {
			var circle = a_layer_log_sp[i];
			var n_scale:Number;
			var data:Number;
			if (circle.type == 'max') {
				data = _a_max_spData[_lg.o_spDataed[circle.id]];
				if (data>0) {
					circle.gotoAndStop(1);
				}
				if (data<0) {
					circle.gotoAndStop(5);
				}
				if (data == 0) {
					circle.gotoAndStop(10);
				}
			}
			if (circle.type == 'min') {
				data = _a_min_spData[_lg.o_spDataed[circle.id]];
				if (data>0) {
					circle.gotoAndStop(2);
				}
				if (data<0) {
					circle.gotoAndStop(6);
				}
				if (data == 0) {
					circle.gotoAndStop(10);
				}
			}
			//attention for the sqrt!
			data = Math.sqrt(Math.abs(data));
			if (data != 0) {
				if (b_isLogSp) {
					n_scale = n_Base+n_factor_LogSp*Math.log(data);
				} else {
					n_scale = n_Base+n_factor_LogSp*data;
				}
				circle._xscale = n_scale;
				circle._yscale = n_scale;
			}
		}
	}
	/////////////////////////////////////////
	//personal things here
	/////////////////////////////////////////	
	private var _b_wangyi:Boolean = true;
	function onMouseWheel(delta:Number) {
		//Loger.log(3,_parent.hPosition+' '+_parent.vPosition);
		var nextPosition = _parent.vPosition-15*delta;
		if (nextPosition<0) {
			_parent.vPosition = 0;
			return;
		}
		if (nextPosition>2212) {
			_parent.vPosition = 2211;
			//Loger.log(99, _parent.vPosition);
			//?can only get at most 2205 when
			//set 	_parent.vPosition = 2211;
			if (_b_wangyi && _parent.hPosition == 2004) {
				Loger.error(0, 'I think therefore I am.');
				_lg.viewEmc2();
				_b_wangyi = false;
			}
			return;
		}
		_parent.vPosition = nextPosition;
	}
	/////////////////////////////////////////
	//initialization
	/////////////////////////////////////////	
	function initStage(success:Boolean) {
		trace('Disp:initStage\t'+success);
		//pause is necessary, handled by Ctrls
		//pause();
		rmAllOnStage();
		_stage = attachMovie('Stage', 'stage', this.getNextHighestDepth());
		if (!success) {
			return;
		}
		initControlData();
		//init layer arrays
		delete a_layer_log_sp;
		delete a_layer_log_r;
		delete a_layer_sp;
		delete a_layer_r;
		delete a_layer_lb_sp;
		delete a_layer_lb_r;
		delete a_layer_arrow;
		a_layer_log_sp = new Array();
		a_layer_log_r = new Array();
		a_layer_sp = new Array();
		a_layer_r = new Array();
		a_layer_lb_sp = new Array();
		a_layer_lb_r = new Array();
		a_layer_arrow = new Array();
		placeReactions();
		placeSpecies();
		//wait and then set to start
		_itv_initRewind = setInterval(this, 'itv_initRewind', 3000);
		//layer setting
		setLayerVisible(a_layer_log_sp, false);
	}
	private var _itv_initRewind;
	function itv_initRewind() {
		clearInterval(_itv_initRewind);
		for (var i = 0; i<_n_sp; i++) {
			_stage[_a_spN[i]].gotoAndStop(N_FRAME_SP_DYNAMIC);
		}
		//layer setting
		//1==_LIMIT_MIN_SCALE in WinMoreOpt class
		setScale_LogSp(1, false);
		setScale_LogR(1, false);
		setLayerVisible(a_layer_log_r, false);
		trace('Disp:itv_initRewind');
		rewind();
	}
	function initControlData() {
		//model id
		s_id_model = _lg.s_id_model;
		//play data
		_a_time = _lg.a_time;
		_a_spN = _lg.a_spName;
		_a_spD = _lg.a_spData;
		_n_time = _a_time.length;
		_n_sp = _a_spN.length;
		//i reactions
		_a_rN = _lg.a_rName;
		_n_r = _a_rN.length;
		//max & min
		_a_time_interval = _lg.a_time_interval;
		_max_time_interval = _lg.max_time_interval;
		_min_time_interval = _lg.min_time_interval;
		_a_max_spData = _lg.a_max_spData;
		_a_min_spData = _lg.a_min_spData;
		//play control
		_direction = 1;
		_posStart = 0;
		_posEnd = _n_time-1;
		_posCur = 0;
		_speedFactor = 1;
		//play flag
		_b_tw_reactions = _lg.b_enable_reaction;
		_b_tw_species = true;
		_b_isPlaying = false;
		_b_is_timelock = false;
		//scroll
		_maxhscroll = _ctl.text_virtual.maxhscroll;
		_ratio_scroll = _maxhscroll/(_a_time[_a_time.length-1]-_a_time[0]);
		_maxhscroll_speed = _stat.text_virtual.maxhscroll;
		_ratio_scroll_speed = (_LIMIT_SPEED-1)/(_maxhscroll_speed-1);
		//trace('_maxhscroll\t'+_maxhscroll);
		//		_nextIntervalTime = _LIMIT_INTERVAL;
		_ratio_itv_limit = _LIMIT_INTERVAL/_min_time_interval;
		delete _a_ratio_scale;
		delete _a_ratio_thick;
		_a_ratio_scale = new Array();
		_a_ratio_thick = new Array();
		var diff_limit_scale = _LIMIT_MAX_SCALE-_LIMIT_MIN_SCALE;
		for (var i = 0; i<_n_sp; i++) {
			var diff_sqrt = (Math.sqrt(_lg.a_absMax_spData[i])-Math.sqrt(_lg.a_absMin_spData[i]));
			if (diff_sqrt == 0 || isNaN(diff_sqrt)) {
				trace('[Disp:initControlData] diff_sqrt: '+diff_sqrt);
				_a_ratio_scale[i] = 0;
			} else {
				_a_ratio_scale[i] = diff_limit_scale/diff_sqrt;
			}
			//trace('diff_limit_scale\t'+diff_limit_scale);
			//trace('diff\t'+diff);
			//trace(i+'\tratio\t'+_a_ratio_scale[i]);
		}
		var diff_limit_thick = _LIMIT_MAX_THICK-_LIMIT_MIN_THICK;
		var n_r = _lg.a_rName.length;
		for (var i = 0; i<n_r; i++) {
			var diff = _lg.a_absMax_rData[i]-_lg.a_absMin_rData[i];
			if (diff == 0 || isNaN(diff)) {
				trace('[Disp:initControlData] diff: '+diff);
				_a_ratio_thick[i] = 0;
			} else {
				_a_ratio_thick[i] = diff_limit_thick/diff;
			}
		}
	}
	/////////////////////////////////////////
	//ScrollBar
	/////////////////////////////////////////	
	function onScrollSpeed() {
		_speedFactor = (_maxhscroll_speed-1-_stat.speedBar.scrollPosition)*_ratio_scroll_speed+1;
		_stat.text_speed.text = Math.round((_LIMIT_SPEED-_speedFactor)*100)/100+1;
	}
	function onScroll() {
		_posCur = ArrayHelper.lookUpIndex(_a_time, _ctl.sBar.scrollPosition/_ratio_scroll+_a_time[0]);
		itv_playOneStep();
		//trace('_posCur'+_posCur);
	}
	/////////////////////////////////////////
	//refreshOther
	/////////////////////////////////////////	
	function setFrame() {
		_lg.setFrame(_posCur);
	}
	function setScroll() {
		_ctl.sBar.scrollPosition = _ratio_scroll*(_a_time[_posCur]-_a_time[0]);
		//_stat.speedBar.scrollPosition = _ctl.sBar.scrollPosition/4;
	}
	function refreshOther() {
		setScroll();
		setFrame();
		_ctl.text_pos.text = _posCur;
		_ctl.text_time.text = _a_time[_posCur];
	}
	/////////////////////////////////////////
	//core
	/////////////////////////////////////////
	function itv_playOneStep() {
		//trace('Disp:itv_playOneStep:\t'+_direction+'\t'+_posCur);
		clearInterval(_itv_playOneStep);
		if (_posCur<_posStart) {
			trace('_posCur < _posStart');
			_posCur = _posStart;
			_direction = 1;
			//return;
		}
		if (_posCur>_posEnd) {
			trace('_posCur > _posEnd');
			_posCur = _posStart;
			_direction = 1;
			//return;
		}
		//refreshOther: window frame
		refreshOther();
		/////////////////////////////////////////
		//Distinguish constant speed
		/////////////////////////////////////////
		if (_b_is_timelock) {
			_nextIntervalTime = compNIT();
		} else {
			_nextIntervalTime = _speedFactor*_LIMIT_INTERVAL;
		}
		//loop all reactions
		if (_b_tw_reactions) {
			for (var i = 0; i<_n_r; i++) {
				var r = _stage[_a_rN[i]];
				var value:Number;
				if (b_isConR) {
					value = compThisValue_Reactions_Conform(i);
				} else {
					value = compThisValue_Reactions(i);
				}
				r.tw(value);
			}
		}
		//var duration = _nextIntervalTime/1000;
		//loop all species
		if (_b_tw_species) {
			for (var i = 0; i<_n_sp; i++) {
				var value:Number;
				if (b_isConSp) {
					value = compThisValue_Species_Conform(i);
				} else {
					value = compThisValue_Species(i);
				}
				_stage[_a_spN[i]].tw(value);
				//trace(i+'  '+_a_spN[i]);
				//shadow
				var a_shadows = _lg.a_sp_shadow[_lg.o_sp_shadow[_a_spN[i]]];
				//*too slow using (for..in)
				var n_a_shadows = a_shadows.length;
				if (a_shadows != undefined) {
					for (var j = 0; j<n_a_shadows; j++) {
						//trace('s'+j+'  '+a_shadows[j].attributes.name);
						_stage[a_shadows[j].attributes.name].tw(value);
					}
				}
			}
		}
		//increase or decrease _posCur
		_posCur += _direction;
		if (_b_isPlaying) {
			_itv_playOneStep = setInterval(this, 'itv_playOneStep', _nextIntervalTime);
		}
	}
	//computer this value
	function compThisValue_Species(i:Number):Number {
		var nv;
		//var v = _a_spD[_posCur+_direction][i];
		var v = _a_spD[_posCur][i];
		if (v == 0) {
			return 0;
		}
		nv = _LIMIT_MIN_SCALE+_a_ratio_scale[i]*(Math.sqrt(Math.abs(v))-Math.sqrt(_lg.a_absMin_spData[i]));
		//trace(nv);
		if (v>0) {
			return nv;
		} else {
			return -nv;
		}
	}
	function compThisValue_Species_Conform(i:Number):Number {
		var v = _a_spD[_posCur][i];
		if (v == 0) {
			return 0;
		}
		var v_abs = Math.sqrt(Math.abs(v));
		var nv;
		var n_Base:Number;
		if (b_isLogSp) {
			n_Base = _LIMIT_MIN_BASE_SPECIES-n_factor_LogSp*Math.log(Math.sqrt(_lg.n_absMin_spData));
			nv = n_Base+n_factor_LogSp*Math.log(v_abs);
		} else {
			n_Base = _LIMIT_MIN_BASE_SPECIES-n_factor_LogSp*Math.sqrt(_lg.n_absMin_spData);
			nv = n_Base+n_factor_LogSp*v_abs;
		}
		if (v>0) {
			return nv;
		} else {
			return -nv;
		}
	}
	function compThisValue_Reactions(i:Number):Number {
		var nv;
		//var v = _a_spD[_posCur+_direction][i];
		var v = _lg.a_rData[_posCur][i];
		if (v == 0) {
			return 0;
		}
		//nv = _LIMIT_MIN_SCALE+_a_ratio_scale[i]*(Math.sqrt(v)-Math.sqrt(_a_min_spData[i]));		
		nv = _LIMIT_MIN_THICK+_a_ratio_thick[i]*(Math.abs(v)-_lg.a_absMin_rData[i]);
		//trace(nv);
		if (v>0) {
			return nv;
		} else {
			return -nv;
		}
	}
	function compThisValue_Reactions_Conform(i:Number):Number {
		var v = _lg.a_rData[_posCur][i];
		if (v == 0) {
			return 0;
		}
		var v_abs = Math.abs(v);
		var nv;
		var n_Base:Number;
		if (b_isLogR) {
			n_Base = _LIMIT_MIN_BASE_FLUX-n_factor_LogR*Math.log(_lg.n_absMin_rData);
			nv = n_Base+n_factor_LogR*Math.log(v_abs);
		} else {
			n_Base = _LIMIT_MIN_BASE_FLUX-n_factor_LogR*_lg.n_absMin_rData;
			nv = n_Base+n_factor_LogR*v_abs;
		}
		if (v>0) {
			return nv;
		} else {
			return -nv;
		}
	}
	//computer next value
	function compNextValue(i:Number):Number {
		var nv;
		var v = _a_spD[_posCur+_direction][i];
		nv = _LIMIT_MIN_SCALE+_a_ratio_scale[i]*(Math.sqrt(v)-Math.sqrt(_a_min_spData[i]));
		//trace(nv);
		return nv;
	}
	//compute nextIntervalTime
	function compNIT():Number {
		var nit;
		var shift;
		shift = (_direction == 1) ? 0 : -1;
		nit = _speedFactor*_ratio_itv_limit*_a_time_interval[_posCur+shift];
		return nit;
	}
	/////////////////////////////////////////
	//place reactions and species
	/////////////////////////////////////////
	function placeReactions() {
		trace('Disp:placeReactions');
		var a = _lg.m_rArray;
		var b = _lg.m_spArray;
		for (var r in a) {
			_stage.attachMovie('IVReaction', a[r].id, _stage.getNextHighestDepth(), {id:a[r].id, _dp:this, _lg:_lg, reaction:a[r], a_species:b});
		}
	}
	function placeSpecies() {
		trace('Disp:placeSpecies');
		var a = _lg.m_spArray;
		for (var sp in a) {
			/////////////////////////////////////////
			//createClassObject
			/////////////////////////////////////////
			var spID = a[sp].id;
			var b = a[sp].value.childNodes[0].childNodes[0].attributes;
			a_layer_sp.push(_stage.attachMovie('IVShape', spID, _stage.getNextHighestDepth(), {_initFrame:N_FRAME_SP_STATIC, _x:b.x, _y:b.y}));
			//circles max & min
			if (_lg.o_spDataed[spID] != undefined) {
				var circle_max = _stage.attachMovie('Circle', 'cl_max_'+spID, _stage.getNextHighestDepth(), {type:'max', id:spID, _x:b.x, _y:b.y});
				var circle_min = _stage.attachMovie('Circle', 'cl_min_'+spID, _stage.getNextHighestDepth(), {type:'min', id:spID, _x:b.x, _y:b.y});
				a_layer_log_sp.push(circle_max, circle_min);
			}
			//label species
			a_layer_lb_sp.push(_stage.attachMovie('IVLabel', 'lb_sp_'+spID, _stage.getNextHighestDepth(), {_lg:_lg, labelType:'Species', id:spID, attri:b, label:spID}));
			//shadow nodes
			var a_shadows = _lg.a_sp_shadow[_lg.o_sp_shadow[spID]];
			//trace('[a_shadows]'+a_shadows);
			if (a_shadows != undefined) {
				var n_a_shadows = a_shadows.length;
				for (var i = 0; i<n_a_shadows; i++) {
					var sp_shadow = a_shadows[i].attributes;
					var spID_shadow = sp_shadow.name;
					a_layer_sp.push(_stage.attachMovie('IVShape', spID_shadow, _stage.getNextHighestDepth(), {_initFrame:N_FRAME_SP_SHADOW, _x:sp_shadow.x, _y:sp_shadow.y}));
					var circle_max = _stage.attachMovie('Circle', 'cl_max_'+spID_shadow, _stage.getNextHighestDepth(), {type:'max', id:spID, _x:sp_shadow.x, _y:sp_shadow.y});
					var circle_min = _stage.attachMovie('Circle', 'cl_min_'+spID_shadow, _stage.getNextHighestDepth(), {type:'min', id:spID, _x:sp_shadow.x, _y:sp_shadow.y});
					a_layer_log_sp.push(circle_max, circle_min);
					a_layer_lb_sp.push(_stage.attachMovie('IVLabel', 'lb_sp_'+spID_shadow, _stage.getNextHighestDepth(), {_lg:_lg, labelType:'Species_shadow', id:spID, attri:sp_shadow, label:spID}));
				}
			}
		}
	}
	function rmAllOnStage() {
		trace('Disp:rmAllOnStage');
		s_id_model = '';
		_stage.removeMovieClip();
		//delete
		delete (this._stage);
		if (this._stage == undefined) {
			trace('Disp:_stage==undefined');
		} else {
			trace('Disp:_stage=='+typeof (this._stage));
		}
	}
	/////////////////////////////////////////
	//events handler
	/////////////////////////////////////////
	function rewind() {
		trace('Disp:rewind\t');
		_posCur = _posStart;
		itv_playOneStep();
	}
	function play() {
		trace('Disp:play\t'+_b_isPlaying);
		if (!_b_isPlaying) {
			_b_isPlaying = true;
			itv_playOneStep();
		}
	}
	function reverse() {
		trace('Disp:reverseTo\t'+(-_direction));
		_direction = -_direction;
	}
	function pause() {
		trace('Disp:pause\t'+_b_isPlaying);
		if (_b_isPlaying) {
			clearInterval(_itv_playOneStep);
			_b_isPlaying = false;
		}
	}
	function end() {
		trace('Disp:end');
		_posCur = _posEnd;
		itv_playOneStep();
	}
	function setPos(pos:Number) {
		_posCur = pos;
		itv_playOneStep();
	}
}
