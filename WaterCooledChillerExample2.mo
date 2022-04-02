within ZEBGuidelineMid;

partial model WaterCooledChillerExample2 "Primary only chiller plant system with water-side economizer"
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = roo.QRoo_flow / (1005 * 15) "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal = 80E3 "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal = 10 "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal = 10 "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = 2 * roo.QRoo_flow / (4200 * 20) "Nominal mass flow rate at chilled water";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = 2 * roo.QRoo_flow / (4200 * 6) "Nominal mass flow rate at condenser water";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 500 "Nominal pressure difference";
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(redeclare package Medium = MediumA, m_flow_nominal = mAir_flow_nominal, dp(start = 249), m_flow(start = mAir_flow_nominal), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, T_start = 293.15) "Fan for air flow through the data center" annotation(
    Placement(transformation(extent = {{348, -235}, {328, -215}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(redeclare package Medium1 = MediumW, redeclare package Medium2 = MediumA, m2_flow_nominal = mAir_flow_nominal, m1_flow_nominal = mCHW_flow_nominal, m1_flow(start = mCHW_flow_nominal), m2_flow(start = mAir_flow_nominal), dp2_nominal = 249 * 3, UA_nominal = mAir_flow_nominal * 1006 * 5, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, dp1_nominal(displayUnit = "Pa") = 1000 + 89580) "Cooling coil" annotation(
    Placement(transformation(extent = {{300, -180}, {280, -160}})));
  Modelica.Blocks.Sources.Constant mFanFlo(k = mAir_flow_nominal) "Mass flow rate of fan" annotation(
    Placement(transformation(extent = {{298, -210}, {318, -190}})));
  Buildings.Examples.ChillerPlant.BaseClasses.SimplifiedRoom roo(redeclare package Medium = MediumA, nPorts = 2, rooLen = 50, rooWid = 30, rooHei = 3, m_flow_nominal = mAir_flow_nominal, QRoo_flow = 500000) "Room model" annotation(
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, origin = {248, -238})));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, m_flow(start = mCHW_flow_nominal), dp(start = 325474), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) "Chilled water pump" annotation(
    Placement(transformation(extent = {{10, 10}, {-10, -10}}, rotation = 270, origin = {218, -120})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium = MediumW, V_start = 1) "Expansion vessel" annotation(
    Placement(transformation(extent = {{248, -147}, {268, -127}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, PFan_nominal = 6000, TAirInWB_nominal(displayUnit = "degC") = 283.15, TApp_nominal = 6, dp_nominal = 14930 + 14930 + 74650, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) "Cooling tower" annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {269, 239})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, dp(start = 214992), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) "Condenser water pump" annotation(
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 270, origin = {358, 200})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 89580, y_start = 1, use_inputFilter = false) "Control valve for condenser water loop of chiller" annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {218, 180})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, use_inputFilter = false) "Bypass control valve for economizer. 1: disable economizer, 0: enable economoizer" annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {218, -40})));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium = MediumW, V_start = 1) annotation(
    Placement(transformation(extent = {{236, 143}, {256, 163}})));
  Buildings.Fluid.Chillers.ElectricEIR chi(redeclare package Medium1 = MediumW, redeclare package Medium2 = MediumW, m1_flow_nominal = mCW_flow_nominal, m2_flow_nominal = mCHW_flow_nominal, dp2_nominal = 0, dp1_nominal = 0, per = Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD(), energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) annotation(
    Placement(transformation(extent = {{274, 83}, {254, 103}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val6(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930 + 89580, y_start = 1, use_inputFilter = false, from_dp = true) "Control valve for chilled water leaving from chiller" annotation(
    Placement(transformation(extent = {{-10, 10}, {10, -10}}, rotation = 270, origin = {358, 40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare package Medium = MediumA, m_flow_nominal = mAir_flow_nominal) "Supply air temperature to data center" annotation(
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, origin = {288, -225})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEntChi(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal) "Temperature of chilled water entering chiller" annotation(
    Placement(transformation(extent = {{10, 10}, {-10, -10}}, rotation = 270, origin = {218, 0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal) "Temperature of condenser water leaving the cooling tower" annotation(
    Placement(transformation(extent = {{10, -10}, {-10, 10}}, origin = {330, 119})));
  Modelica.Blocks.Sources.Constant cooTowFanCon(k = 1) "Control singal for cooling tower fan" annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {230, 271})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930, y_start = 0, use_inputFilter = false, from_dp = true) "Bypass valve for chiller." annotation(
    Placement(transformation(extent = {{-10, -10}, {10, 10}}, origin = {288, 20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLeaCoi(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal) "Temperature of chilled water leaving the cooling coil" annotation(
    Placement(transformation(extent = {{10, 10}, {-10, -10}}, rotation = 270, origin = {218, -80})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")) annotation(
    Placement(transformation(extent = {{-360, -100}, {-340, -80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
    Placement(transformation(extent = {{-332, -98}, {-312, -78}})));
  Modelica.Blocks.Sources.Constant val1Con(k = 1) "Control signal for valve 1" annotation(
    Placement(visible = true, transformation(origin = {176, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant val5Con(k = 1) "Control signal for valve 5" annotation(
    Placement(visible = true, transformation(origin = {182, 181}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant val6Con(k = 1) "Control signal for valve 6" annotation(
    Placement(visible = true, transformation(origin = {322, 41}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant valBypCon(k = 0) "Control signal for bypass valve" annotation(
    Placement(visible = true, transformation(origin = {256, 37}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCWCon(k = mCW_flow_nominal) "Control signal for condenser water pump" annotation(
    Placement(visible = true, transformation(origin = {320, 199}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCHWCon(k = 20 * 6485) "Control signal for chilled water pump" annotation(
    Placement(visible = true, transformation(origin = {164, -123}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant chiTSet(k = 273.15 + 10) "Set point for chilled water temperature " annotation(
    Placement(visible = true, transformation(origin = {254, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant chiOn annotation(
    Placement(visible = true, transformation(origin = {266, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation(
    Line(points = {{258, -147}, {258, -164}, {280, -164}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(cooTow.port_b, pumCW.port_a) annotation(
    Line(points = {{279, 239}, {358, 239}, {358, 210}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(val5.port_a, chi.port_b1) annotation(
    Line(points = {{218, 170}, {218, 99}, {254, 99}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(expVesChi.port_a, chi.port_b1) annotation(
    Line(points = {{246, 143}, {246, 99}, {254, 99}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(cooCoi.port_b2, fan.port_a) annotation(
    Line(points = {{300, -176}, {359, -176}, {359, -225}, {348, -225}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(mFanFlo.y, fan.m_flow_in) annotation(
    Line(points = {{319, -200}, {338, -200}, {338, -213}}, color = {0, 0, 127}, smooth = Smooth.None, pattern = LinePattern.Dash));
  connect(TAirSup.port_a, fan.port_b) annotation(
    Line(points = {{298, -225}, {328, -225}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(roo.airPorts[1], TAirSup.port_b) annotation(
    Line(points = {{250.475, -229.3}, {250.475, -225}, {278, -225}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(roo.airPorts[2], cooCoi.port_a2) annotation(
    Line(points = {{246.425, -229.3}, {246.425, -225}, {218, -225}, {218, -176}, {280, -176}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(TCHWLeaCoi.port_a, pumCHW.port_b) annotation(
    Line(points = {{218, -90}, {218, -110}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(TCHWEntChi.port_b, valByp.port_a) annotation(
    Line(points = {{218, 10}, {218, 20}, {278, 20}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(TCHWEntChi.port_a, val1.port_b) annotation(
    Line(points = {{218, -10}, {218, -30}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(val1.port_a, TCHWLeaCoi.port_b) annotation(
    Line(points = {{218, -50}, {218, -70}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(TCWLeaTow.port_b, chi.port_a1) annotation(
    Line(points = {{320, 119}, {300, 119}, {300, 99}, {274, 99}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(weaData.weaBus, weaBus) annotation(
    Line(points = {{-340, -90}, {-331, -90}, {-331, -88}, {-322, -88}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(cooTow.TAir, weaBus.TWetBul) annotation(
    Line(points = {{257, 243}, {82, 243}, {82, 268}, {-322, 268}, {-322, -88}}, color = {0, 0, 127}, smooth = Smooth.None, pattern = LinePattern.Dash),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(valByp.port_b, val6.port_b) annotation(
    Line(points = {{298, 20}, {358, 20}, {358, 30}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(TCHWEntChi.port_b, chi.port_a2) annotation(
    Line(points = {{218, 10}, {218, 88}, {254, 88}, {254, 87}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(val5.port_b, cooTow.port_a) annotation(
    Line(points = {{218, 190}, {218, 239}, {259, 239}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(pumCW.port_b, TCWLeaTow.port_a) annotation(
    Line(points = {{358, 190}, {358, 119}, {340, 119}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(chi.port_b2, val6.port_a) annotation(
    Line(points = {{274, 87}, {358, 87}, {358, 50}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(pumCHW.port_a, cooCoi.port_b1) annotation(
    Line(points = {{218, -130}, {218, -164}, {280, -164}}, color = {0, 127, 255}, smooth = Smooth.None, thickness = 0.5));
  connect(cooCoi.port_a1, val6.port_b) annotation(
    Line(points = {{300, -164}, {358, -164}, {358, 30}}, color = {0, 127, 255}, thickness = 0.5));
  connect(valBypCon.y, valByp.y) annotation(
    Line(points = {{267, 37}, {288, 37}, {288, 32}}, color = {0, 0, 127}));
  connect(val5Con.y, val5.y) annotation(
    Line(points = {{194, 182}, {206, 182}, {206, 180}}, color = {0, 0, 127}));
  connect(val6Con.y, val6.y) annotation(
    Line(points = {{333, 41}, {346, 41}, {346, 40}}, color = {0, 0, 127}));
  connect(pumCWCon.y, pumCW.m_flow_in) annotation(
    Line(points = {{332, 200}, {346, 200}}, color = {0, 0, 127}));
  connect(val1Con.y, val1.y) annotation(
    Line(points = {{188, -38}, {206, -38}, {206, -40}}, color = {0, 0, 127}));
  connect(pumCHWCon.y, pumCHW.dp_in) annotation(
    Line(points = {{176, -122}, {206, -122}, {206, -120}}, color = {0, 0, 127}));
  connect(chiTSet.y, chi.TSet) annotation(
    Line(points = {{266, 70}, {276, 70}, {276, 90}}, color = {0, 0, 127}));
  connect(chiOn.y, chi.on) annotation(
    Line(points = {{278, 124}, {278, 111}, {276, 111}, {276, 96}}, color = {255, 0, 255}));
  connect(cooTow.y, cooTowFanCon.y) annotation(
    Line(points = {{258, 248}, {242, 248}, {242, 272}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-400, -300}, {400, 300}})),
    experiment(StartTime=13046400, Tolerance=1e-6, StopTime=13651200),
    Documentation(info = "<HTML>
<p>
This model is the chilled water plant with discrete time control and
trim and respond logic for a data center. The model is described at
<a href=\"Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
</html>", revisions = "<html>
<ul>
<li>
September 21, 2017, by Michael Wetter:<br/>
Set <code>from_dp = true</code> in <code>val6</code> and in <code>valByp</code>
which is needed for Dymola 2018FD01 beta 2 for
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl</a>
to converge.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
January 13, 2015 by Michael Wetter:<br/>
Moved model to <code>BaseClasses</code> because the continuous and discrete time
implementation of the trim and respond logic do not extend from a common class,
and hence the <code>constrainedby</code> operator is not applicable.
Moving the model here allows to implement both controllers without using a
<code>replaceable</code> class.
</li>
<li>
January 12, 2015 by Michael Wetter:<br/>
Made media instances replaceable, and used the same instance for both
water loops.
This was done to simplify the numerical benchmarks.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 25, 2014, by Michael Wetter:<br/>
Updated model with new expansion vessel.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
Removed the filtered speed calculation for the valves to reduce computing time by 25%.
</li>
<li>
October 16, 2012, by Wangda Zuo:<br/>
Reimplemented the controls.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end WaterCooledChillerExample2;
