﻿//****************************************************************************
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

		var s_xml:String = '<?xml version="1.0" encoding="UTF-8"?><!-- Created by XMLPrettyPrinter on 4/5/2005 from JDesigner 1.951 --><sbml level = "2" version = "1" xmlns = "http://www.sbml.org/sbml/level2" xmlns:jd = "http://www.sys-bio.org/sbml">   <annotation>      <jd:header>         <VersionHeader SBMLVersion = "1.0"/>         <ModelHeader Author = "Mr Untitled" ModelTitle = "untitled" ModelVersion = "0.0"/>      </jd:header>      <jd:display>         <SBMLGraphicsHeader BackGroundColor = "15728639"/>      </jd:display>      <jd:otherDisplayObjects>         <textObject name = "Heinrich__IV_REPLACE__s 77 Model">            <font fontColor = "0" fontName = "Arial" fontSize = "10" fontStyle = ""/>            <boundingBox h = "16" w = "113" x = "23" y = "16"/>         </textObject>         <textObject name = "Has positive feedback from S2 to v2, results in instability at certain parameter values">            <font fontColor = "0" fontName = "Arial" fontSize = "10" fontStyle = ""/>            <boundingBox h = "16" w = "486" x = "23" y = "33"/>         </textObject>      </jd:otherDisplayObjects>   </annotation>   <!--                     -->   <!--  Model Starts Here  -->   <!--                     -->   <model id = "oscil">      <listOfCompartments>         <compartment id = "compartment" size = "1">            <annotation>               <jd:display>                  <boundingBox h = "0" w = "0" x = "0" y = "0"/>               </jd:display>            </annotation>         </compartment>      </listOfCompartments>      <listOfSpecies>         <species boundaryCondition = "false" compartment = "compartment" id = "S1" initialConcentration = "0">            <annotation>               <jd:display borderType = "ntRound" edgeColor = "0" edgeThickness = "1" fillColor = "16777215"                           selectedEdgeColor = "255" x = "206" y = "106">                  <font fontColor = "0" fontName = "Arial" fontSize = "10" fontStyle = ""/>               </jd:display>            </annotation>         </species>         <species boundaryCondition = "false" compartment = "compartment" id = "S2" initialConcentration = "1">            <annotation>               <jd:display borderType = "ntRound" edgeColor = "0" edgeThickness = "1" fillColor = "16777215"                           selectedEdgeColor = "255" x = "122" y = "170">                  <font fontColor = "0" fontName = "Arial" fontSize = "10" fontStyle = ""/>               </jd:display>            </annotation>         </species>         <species boundaryCondition = "true" compartment = "compartment" id = "X0" initialConcentration = "1">            <annotation>               <jd:display borderType = "ntRound" edgeColor = "0" edgeThickness = "1" fillColor = "16777215"                           selectedEdgeColor = "255" x = "84" y = "71">                  <font fontColor = "0" fontName = "Arial" fontSize = "10" fontStyle = ""/>               </jd:display>            </annotation>         </species>         <species boundaryCondition = "true" compartment = "compartment" id = "X1" initialConcentration = "0">            <annotation>               <jd:display borderType = "ntRound" edgeColor = "0" edgeThickness = "1" fillColor = "16777215"                           selectedEdgeColor = "255" x = "339" y = "168">                  <font fontColor = "0" fontName = "Arial" fontSize = "10" fontStyle = ""/>               </jd:display>            </annotation>         </species>         <species boundaryCondition = "true" compartment = "compartment" id = "X2" initialConcentration = "0">            <annotation>               <jd:display borderType = "ntRound" edgeColor = "0" edgeThickness = "1" fillColor = "16777215"                           selectedEdgeColor = "255" x = "234" y = "229">                  <font fontColor = "0" fontName = "Arial" fontSize = "10" fontStyle = ""/>               </jd:display>            </annotation>         </species>      </listOfSpecies>      <listOfParameters>      </listOfParameters>      <listOfReactions>         <reaction id = "J0" reversible = "false">            <listOfReactants>               <speciesReference species = "X0" stoichiometry = "1"/>            </listOfReactants>            <listOfProducts>               <speciesReference species = "S1" stoichiometry = "1"/>            </listOfProducts>            <annotation>               <jd:arcSeg fillColor = "0" lineColor = "6587523" lineThickness = "1" lineType = "ltBezier"                          selectedLineColor = "255">                  <pt x = "155" y = "96"/>                  <pt x = "159" y = "97"/>                  <pt x = "159" y = "97"/>               </jd:arcSeg>            </annotation>            <kineticLaw>               <math xmlns = "http://www.w3.org/1998/Math/MathML">                  <ci>                         v0                   </ci>               </math>               <listOfParameters>                  <parameter id = "v0" value = "8"/>               </listOfParameters>            </kineticLaw>         </reaction>         <reaction id = "J1" reversible = "false">            <listOfReactants>               <speciesReference species = "S1" stoichiometry = "1"/>            </listOfReactants>            <listOfProducts>               <speciesReference species = "X1" stoichiometry = "1"/>            </listOfProducts>            <annotation>               <jd:arcSeg fillColor = "0" lineColor = "0" lineThickness = "1" lineType = "ltBezier"                          selectedLineColor = "255">                  <pt x = "281" y = "145"/>                  <pt x = "281" y = "145"/>                  <pt x = "285" y = "148"/>               </jd:arcSeg>            </annotation>            <kineticLaw>               <math xmlns = "http://www.w3.org/1998/Math/MathML">                  <apply>                     <times/>                     <ci>                            k3                      </ci>                     <ci>                            S1                      </ci>                  </apply>               </math>               <listOfParameters>                  <parameter id = "k3" value = "0"/>               </listOfParameters>            </kineticLaw>         </reaction>         <reaction id = "J2" reversible = "false">            <listOfReactants>               <speciesReference species = "S1" stoichiometry = "1"/>            </listOfReactants>            <listOfProducts>               <speciesReference species = "S2" stoichiometry = "1"/>            </listOfProducts>            <annotation>               <jd:arcSeg fillColor = "0" lineColor = "6587523" lineThickness = "1" lineType = "ltBezier"                          selectedLineColor = "255">                  <pt x = "175" y = "143"/>                  <pt x = "175" y = "144"/>                  <pt x = "175" y = "144"/>               </jd:arcSeg>            </annotation>            <kineticLaw>               <math xmlns = "http://www.w3.org/1998/Math/MathML">                  <apply>                     <times/>                     <apply>                        <minus/>                        <apply>                           <times/>                           <ci>                                  k1                            </ci>                           <ci>                                  S1                            </ci>                        </apply>                        <apply>                           <times/>                           <ci>                                  k_1                            </ci>                           <ci>                                  S2                            </ci>                        </apply>                     </apply>                     <apply>                        <plus/>                        <cn type = "integer">                               1                         </cn>                        <apply>                           <times/>                           <ci>                                  c                            </ci>                           <apply>                              <power/>                              <ci>                                     S2                               </ci>                              <ci>                                     q                               </ci>                           </apply>                        </apply>                     </apply>                  </apply>               </math>               <listOfParameters>                  <parameter id = "k1" value = "1"/>                  <parameter id = "k_1" value = "0"/>                  <parameter id = "c" value = "1"/>                  <parameter id = "q" value = "3"/>               </listOfParameters>            </kineticLaw>         </reaction>         <reaction id = "J3" reversible = "false">            <listOfReactants>               <speciesReference species = "S2" stoichiometry = "1"/>            </listOfReactants>            <listOfProducts>               <speciesReference species = "X2" stoichiometry = "1"/>            </listOfProducts>            <annotation>               <jd:arcSeg fillColor = "0" lineColor = "6587523" lineThickness = "1" lineType = "ltBezier"                          selectedLineColor = "255">                  <pt x = "189" y = "206"/>                  <pt x = "192" y = "208"/>                  <pt x = "192" y = "208"/>               </jd:arcSeg>            </annotation>            <kineticLaw>               <math xmlns = "http://www.w3.org/1998/Math/MathML">                  <apply>                     <times/>                     <ci>                            k2                      </ci>                     <ci>                            S2                      </ci>                  </apply>               </math>               <listOfParameters>                  <parameter id = "k2" value = "5"/>               </listOfParameters>            </kineticLaw>         </reaction>      </listOfReactions>   </model></sbml>';


		var owner:ArraySBML = this;
		var _xml:XML = new XML();
		//set ignoreWhite
		_xml.ignoreWhite = true;
		//parseXML works here
		_xml.parseXML(s_xml);
		_xml.onLoad = function(success:Boolean) {
			if (!success) {
				trace('loadSBML: Error when load xml file!');
				return;
			}
			owner.onLoadSBML(this);
		};
		//_xml.load(str_filePath);
		//onLoad will never be called when using XML(s:String)
		_xml.onLoad(true);
	}
	function onLoadSBML(_xml:XML) {
		sbml_root = _xml;
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
