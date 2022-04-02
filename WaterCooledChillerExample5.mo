within ZEBGuidelineMid;

partial model WaterCooledChillerExample5 "Primary only chiller plant system with water-side economizer"
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.Height rooHei = 3 "Height of the room";
  parameter Modelica.SIunits.Length rooWid = 30 "Width of the room";
  parameter Modelica.SIunits.Length rooLen = 50 "Length of the room";
  parameter Modelica.SIunits.Power QRoo_flow = 200000 "Heat generation of the computer room";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = QRoo_flow / (1005 * 15) "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal = 80E3 "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal = 10 "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal = 10 "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = 2 * QRoo_flow / (4200 * 20) "Nominal mass flow rate at chilled water";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = 2 * QRoo_flow / (4200 * 6) "Nominal mass flow rate at condenser water";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 500 "Nominal pressure difference";
  Buildings.Fluid.Movers.FlowControlled_m_flow fanSup(redeclare package Medium = MediumA, m_flow_nominal = mAir_flow_nominal, dp(start = 249), m_flow(start = mAir_flow_nominal), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, T_start = 293.15) "Supply fan for air flow through the room" annotation(
    Placement(visible = true, transformation(extent = {{284, -235}, {264, -215}}, rotation = 0)));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(redeclare package Medium1 = MediumW, redeclare package Medium2 = MediumA, m2_flow_nominal = mAir_flow_nominal, m1_flow_nominal = mCHW_flow_nominal, m1_flow(start = mCHW_flow_nominal), m2_flow(start = mAir_flow_nominal), dp2_nominal = 249 * 3, UA_nominal = mAir_flow_nominal * 1006 * 5, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, dp1_nominal(displayUnit = "Pa") = 1000 + 89580) "Cooling coil" annotation(
    Placement(visible = true, transformation(extent = {{236, -180}, {216, -160}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant mFanFlo(k = mAir_flow_nominal) "Mass flow rate of fan" annotation(
    Placement(visible = true, transformation(extent = {{218, -206}, {238, -186}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, m_flow(start = mCHW_flow_nominal), dp(start = 325474), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) "Chilled water pump" annotation(
    Placement(visible = true, transformation(origin = {154, 70}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium = MediumW, V_start = 1) "Expansion vessel" annotation(
    Placement(visible = true, transformation(extent = {{186, -155}, {206, -135}}, rotation = 0)));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, PFan_nominal = 6000, TAirInWB_nominal(displayUnit = "degC") = 283.15, TApp_nominal = 6, dp_nominal = 14930 + 14930 + 74650, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) "Cooling tower" annotation(
    Placement(visible = true, transformation(origin = {205, 239}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, dp(start = 214992), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) "Condenser water pump" annotation(
    Placement(visible = true, transformation(origin = {294, 200}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 89580, y_start = 1, use_inputFilter = false) "Control valve for condenser water loop of chiller" annotation(
    Placement(visible = true, transformation(origin = {154, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930, use_inputFilter = false, from_dp = true) "Bypass control valve for economizer. 1: disable economizer, 0: enable economoizer" annotation(
    Placement(visible = true, transformation(origin = {154, -122}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium = MediumW, V_start = 1) annotation(
    Placement(visible = true, transformation(extent = {{172, 143}, {192, 163}}, rotation = 0)));
  Buildings.Fluid.Chillers.ElectricEIR chi(redeclare package Medium1 = MediumW, redeclare package Medium2 = MediumW, m1_flow_nominal = mCW_flow_nominal, m2_flow_nominal = mCHW_flow_nominal, dp2_nominal = 0, dp1_nominal = 0, per = Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD(), energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) annotation(
    Placement(visible = true, transformation(extent = {{210, 83}, {190, 103}}, rotation = 0)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val6(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930 + 89580, y_start = 1, use_inputFilter = false, from_dp = true) "Control valve for chilled water leaving from chiller" annotation(
    Placement(visible = true, transformation(origin = {292, 68}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare package Medium = MediumA, m_flow_nominal = mAir_flow_nominal) "Supply air temperature to data center" annotation(
    Placement(visible = true, transformation(origin = {200, -225}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEntChi(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal) "Temperature of chilled water entering chiller" annotation(
    Placement(visible = true, transformation(origin = {294, -150}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal) "Temperature of condenser water leaving the cooling tower" annotation(
    Placement(visible = true, transformation(origin = {266, 119}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant cooTowFanCon(k = 1) "Control singal for cooling tower fan" annotation(
    Placement(visible = true, transformation(origin = {148, 271}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930, y_start = 0, use_inputFilter = false, from_dp = true) "Bypass valve for chiller." annotation(
    Placement(visible = true, transformation(origin = {228, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLeaCoi(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal) "Temperature of chilled water leaving the cooling coil" annotation(
    Placement(visible = true, transformation(origin = {154, -148}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")) annotation(
    Placement(transformation(extent = {{-360, -100}, {-340, -80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
    Placement(transformation(extent = {{-332, -98}, {-312, -78}})));
  Modelica.Blocks.Sources.Constant TSetAirSup(k = 273.15 + 15) "Set point of the supply air temperature" annotation(
    Placement(visible = true, transformation(origin = {42, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant val5Con(k = 1) "Control signal for valve 5" annotation(
    Placement(visible = true, transformation(origin = {118, 181}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant val6Con(k = 1) "Control signal for valve 6" annotation(
    Placement(visible = true, transformation(origin = {256, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCWCon(k = mCW_flow_nominal) "Control signal for condenser water pump" annotation(
    Placement(visible = true, transformation(origin = {256, 199}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCHWCon(k = 20 * 6485) "Control signal for chilled water pump" annotation(
    Placement(visible = true, transformation(origin = {88, 71}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant chiTSet(k = 273.15 + 5) "Set point for chilled water temperature " annotation(
    Placement(visible = true, transformation(origin = {190, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant chiOn annotation(
    Placement(visible = true, transformation(origin = {202, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA, 
    nPorts = 2,
    V = rooLen * rooWid * rooHei, 
    m_flow_nominal = mAir_flow_nominal, 
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=293.15,
    final prescribedHeatFlowRate=true) "Volume of air in the room" 
    annotation(
    Placement(visible = true, transformation(origin = {162, -240},extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir "Temperature of the room" annotation(
    Placement(visible = true, transformation(extent = {{190, -292}, {210, -272}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QSou "Heat source of the room" annotation(
    Placement(visible = true, transformation(extent = {{112, -292}, {132, -272}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 36000, height = QRoo_flow, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(extent = {{70, -292}, {90, -272}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut annotation(
    Placement(visible = true, transformation(extent = {{64, -266}, {84, -246}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000 / 30) annotation(
    Placement(visible = true, transformation(extent = {{112, -266}, {132, -246}}, rotation = 0)));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU KMinusU(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {130, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Controls.Continuous.LimPID conPIDTAirSup(Td = 1, Ti = 120, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = 0.1, reverseAction = true, strict = true)  annotation(
    Placement(visible = true, transformation(origin = {92, -122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow fanRet(redeclare package Medium = MediumA, T_start = 293.15, dp(start = 249), energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false) "Return fan for air flow from the room" annotation(
    Placement(visible = true, transformation(extent = {{132, -235}, {112, -215}}, rotation = 0)));
  Buildings.Fluid.Actuators.Dampers.Exponential damRet(redeclare package Medium = MediumA,m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false)  annotation(
    Placement(visible = true, transformation(origin = {82, -202}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Actuators.Dampers.Exponential damEA(redeclare package Medium = MediumA,m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false) annotation(
    Placement(visible = true, transformation(origin = {38, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Buildings.Fluid.Actuators.Dampers.Exponential damOA(redeclare package Medium = MediumA,m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false) annotation(
    Placement(visible = true, transformation(origin = {38, -176}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant damCon(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {-40, -145}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU kMinusU(k = 1) annotation(
    Placement(visible = true, transformation(origin = {40, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.Junction junRet(redeclare package Medium = MediumA, dp_nominal = {0, 0, 0}, m_flow_nominal = mAir_flow_nominal * {1, -1, -1}) annotation(
    Placement(visible = true, transformation(origin = {82, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = MediumA, nPorts = 2, use_C_in = false) annotation(
    Placement(visible = true, transformation(extent = {{-22, -206}, {-2, -186}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.Junction junOut(redeclare package Medium = MediumA, dp_nominal = {0, 0, 0}, m_flow_nominal = mAir_flow_nominal * {1, -1, 1}) annotation(
    Placement(visible = true, transformation(origin = {82, -176}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.RelativePressure PCHW annotation(
    Placement(visible = true, transformation(origin = {226, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation(
    Line(points = {{196, -155}, {196, -164.5}, {216, -164.5}, {216, -164}}, color = {0, 127, 255}, thickness = 0.5));
  connect(cooTow.port_b, pumCW.port_a) annotation(
    Line(points = {{215, 239}, {294, 239}, {294, 210}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val5.port_a, chi.port_b1) annotation(
    Line(points = {{154, 170}, {154, 99}, {190, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(expVesChi.port_a, chi.port_b1) annotation(
    Line(points = {{182, 143}, {182, 99}, {190, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(cooCoi.port_b2, fanSup.port_a) annotation(
    Line(points = {{236, -176}, {295, -176}, {295, -225}, {284, -225}}, color = {0, 127, 255}, thickness = 0.5));
  connect(mFanFlo.y, fanSup.m_flow_in) annotation(
    Line(points = {{239, -196}, {274, -196}, {274, -213}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(TAirSup.port_a, fanSup.port_b) annotation(
    Line(points = {{210, -225}, {264, -225}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val1.port_a, TCHWLeaCoi.port_b) annotation(
    Line(points = {{154, -132}, {154, -138}}, color = {0, 127, 255}, thickness = 0.5));
  connect(TCWLeaTow.port_b, chi.port_a1) annotation(
    Line(points = {{256, 119}, {236, 119}, {236, 99}, {210, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(weaData.weaBus, weaBus) annotation(
    Line(points = {{-340, -90}, {-331, -90}, {-331, -88}, {-322, -88}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(cooTow.TAir, weaBus.TWetBul) annotation(
    Line(points = {{193, 243}, {-322, 243}, {-322, -88}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(valByp.port_b, val6.port_b) annotation(
    Line(points = {{238, 30}, {292, 30}, {292, 58}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val5.port_b, cooTow.port_a) annotation(
    Line(points = {{154, 190}, {154, 239}, {195, 239}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumCW.port_b, TCWLeaTow.port_a) annotation(
    Line(points = {{294, 190}, {294, 119}, {276, 119}}, color = {0, 127, 255}, thickness = 0.5));
  connect(chi.port_b2, val6.port_a) annotation(
    Line(points = {{210, 87}, {292, 87}, {292, 78}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val5Con.y, val5.y) annotation(
    Line(points = {{129, 181}, {141, 181}, {141, 179}}, color = {0, 0, 127}));
  connect(val6Con.y, val6.y) annotation(
    Line(points = {{267, 69}, {280, 69}, {280, 68}}, color = {0, 0, 127}));
  connect(pumCWCon.y, pumCW.m_flow_in) annotation(
    Line(points = {{267, 199}, {281, 199}}, color = {0, 0, 127}));
  connect(pumCHWCon.y, pumCHW.dp_in) annotation(
    Line(points = {{99, 71}, {142, 71}, {142, 70}}, color = {0, 0, 127}));
  connect(chiTSet.y, chi.TSet) annotation(
    Line(points = {{201, 69}, {211, 69}, {211, 89}}, color = {0, 0, 127}));
  connect(chiOn.y, chi.on) annotation(
    Line(points = {{213, 124}, {213, 111}, {211, 111}, {211, 96}}, color = {255, 0, 255}));
  connect(cooTow.y, cooTowFanCon.y) annotation(
    Line(points = {{193, 247}, {158, 247}, {158, 270}}, color = {0, 0, 127}));
  connect(TRooAir.port, vol.heatPort) annotation(
    Line(points = {{190, -282}, {172, -282}, {172, -240}}, color = {191, 0, 0}));
  connect(QSou.port, vol.heatPort) annotation(
    Line(points = {{132, -282}, {172, -282}, {172, -240}}, color = {191, 0, 0}));
  connect(ramp.y, QSou.Q_flow) annotation(
    Line(points = {{91, -282}, {111, -282}}, color = {0, 0, 127}));
  connect(theCon.port_a, TOut.port) annotation(
    Line(points = {{112, -256}, {84, -256}}, color = {191, 0, 0}));
  connect(theCon.port_b, vol.heatPort) annotation(
    Line(points = {{132, -256}, {172, -256}, {172, -240}}, color = {191, 0, 0}));
  connect(TOut.T, weaBus.TDryBul) annotation(
    Line(points = {{62, -256}, {-322, -256}, {-322, -88}}, color = {0, 0, 127}));
  connect(TAirSup.port_b, vol.ports[1]) annotation(
    Line(points = {{190, -225}, {162, -225}, {162, -230}}, color = {0, 127, 255}));
  connect(cooCoi.port_b1, TCHWLeaCoi.port_a) annotation(
    Line(points = {{216, -164}, {154, -164}, {154, -158}}, color = {0, 127, 255}));
  connect(chi.port_a2, pumCHW.port_b) annotation(
    Line(points = {{190, 87}, {154, 87}, {154, 79}}, color = {0, 127, 255}));
  connect(pumCHW.port_a, val1.port_b) annotation(
    Line(points = {{154, 60}, {154, -112}}, color = {0, 127, 255}));
  connect(valByp.port_a, val1.port_b) annotation(
    Line(points = {{218, 30}, {154, 30}, {154, -112}}, color = {0, 127, 255}));
  connect(valByp.port_b, TCHWEntChi.port_b) annotation(
    Line(points = {{238, 30}, {294, 30}, {294, -140}}, color = {0, 127, 255}));
  connect(cooCoi.port_a1, TCHWEntChi.port_a) annotation(
    Line(points = {{236, -164}, {294, -164}, {294, -160}}, color = {0, 127, 255}));
  connect(TSetAirSup.y, conPIDTAirSup.u_s) annotation(
    Line(points = {{53, -95}, {64, -95}, {64, -122}, {80, -122}}, color = {0, 0, 127}));
  connect(conPIDTAirSup.y, val1.y) annotation(
    Line(points = {{103, -122}, {142, -122}}, color = {0, 0, 127}));
  connect(KMinusU.u, conPIDTAirSup.y) annotation(
    Line(points = {{118, 42}, {103, 42}, {103, -122}}, color = {0, 0, 127}));
  connect(KMinusU.y, valByp.y) annotation(
    Line(points = {{141, 42}, {228, 42}}, color = {0, 0, 127}));
  connect(TAirSup.T, conPIDTAirSup.u_m) annotation(
    Line(points = {{200, -214}, {200.5, -214}, {200.5, -170}, {92, -170}, {92, -134}}, color = {0, 0, 127}));
  connect(fanRet.m_flow_in, mFanFlo.y) annotation(
    Line(points = {{122, -213}, {239, -213}, {239, -196}}, color = {0, 0, 127}));
  connect(damCon.y, damOA.y) annotation(
    Line(points = {{-29, -145}, {38, -145}, {38, -164}}, color = {0, 0, 127}));
  connect(damEA.y, damCon.y) annotation(
    Line(points = {{38, -238}, {18, -238}, {18, -145}, {-30, -145}, {-30, -145.5}, {-29, -145.5}, {-29, -145}}, color = {0, 0, 127}));
  connect(kMinusU.u, damCon.y) annotation(
    Line(points = {{28, -128}, {19, -128}, {19, -144.75}, {-29, -144.75}, {-29, -145}}, color = {0, 0, 127}));
  connect(kMinusU.y, damRet.y) annotation(
    Line(points = {{51, -128}, {62, -128}, {62, -201.5}, {70, -201.5}, {70, -202}}, color = {0, 0, 127}));
  connect(fanRet.port_a, vol.ports[2]) annotation(
    Line(points = {{132, -225}, {162, -225}, {162, -230}}, color = {0, 127, 255}));
  connect(junRet.port_2, damEA.port_a) annotation(
    Line(points = {{72, -226}, {48, -226}}, color = {0, 127, 255}));
  connect(junRet.port_3, damRet.port_a) annotation(
    Line(points = {{82, -216}, {82, -212}}, color = {0, 127, 255}));
  connect(junRet.port_1, fanRet.port_b) annotation(
    Line(points = {{92, -226}, {95, -226}, {95, -225}, {112, -225}}, color = {0, 127, 255}));
  connect(damOA.port_a, out.ports[1]) annotation(
    Line(points = {{28, -176}, {-2, -176}, {-2, -196}}, color = {0, 127, 255}));
  connect(damEA.port_b, out.ports[2]) annotation(
    Line(points = {{28, -226}, {-2, -226}, {-2, -196}}, color = {0, 127, 255}));
  connect(out.weaBus, weaBus);
  connect(damOA.port_b, junOut.port_1) annotation(
    Line(points = {{48, -176}, {72, -176}}, color = {0, 127, 255}));
  connect(junOut.port_2, cooCoi.port_a2) annotation(
    Line(points = {{92, -176}, {216, -176}}, color = {0, 127, 255}));
  connect(junOut.port_3, damRet.port_b) annotation(
    Line(points = {{82, -186}, {82, -192}}, color = {0, 127, 255}));
  connect(PCHW.port_a, valByp.port_b) annotation(
    Line(points = {{236, 2}, {236, -3}, {238, -3}, {238, 30}}, color = {0, 127, 255}));
  connect(PCHW.port_b, valByp.port_a) annotation(
    Line(points = {{216, 2}, {216, -3}, {218, -3}, {218, 30}}, color = {0, 127, 255}));
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
end WaterCooledChillerExample5;
