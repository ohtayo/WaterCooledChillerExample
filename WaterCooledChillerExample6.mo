within ZEBGuidelineMid;

partial model WaterCooledChillerExample6 "Primary only chiller plant system with water-side economizer"
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
    Placement(visible = true, transformation(extent = {{354, -235}, {334, -215}}, rotation = 0)));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(redeclare package Medium1 = MediumW, redeclare package Medium2 = MediumA, m2_flow_nominal = mAir_flow_nominal, m1_flow_nominal = mCHW_flow_nominal, m1_flow(start = mCHW_flow_nominal), m2_flow(start = mAir_flow_nominal), dp2_nominal = 249 * 3, UA_nominal = mAir_flow_nominal * 1006 * 5, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, dp1_nominal(displayUnit = "Pa") = 1000 + 89580) "Cooling coil" annotation(
    Placement(visible = true, transformation(extent = {{306, -180}, {286, -160}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant mFanFlo(k = mAir_flow_nominal) "Mass flow rate of fan" annotation(
    Placement(visible = true, transformation(extent = {{288, -206}, {308, -186}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, m_flow(start = mCHW_flow_nominal), dp(start = 325474), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) "Chilled water pump" annotation(
    Placement(visible = true, transformation(origin = {220, 70}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium = MediumW, V_start = 1) "Expansion vessel" annotation(
    Placement(visible = true, transformation(extent = {{256, -155}, {276, -135}}, rotation = 0)));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, PFan_nominal = 6000, TAirInWB_nominal(displayUnit = "degC") = 283.15, TApp_nominal = 6, dp_nominal = 14930 + 14930 + 74650, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) "Cooling tower" annotation(
    Placement(visible = true, transformation(origin = {280, 239}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, dp(start = 214992), use_inputFilter = false, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) "Condenser water pump" annotation(
    Placement(visible = true, transformation(origin = {360, 200}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 89580, y_start = 1, use_inputFilter = false) "Control valve for condenser water loop of chiller" annotation(
    Placement(visible = true, transformation(origin = {220, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930, use_inputFilter = false, from_dp = true) "Bypass control valve for economizer. 1: disable economizer, 0: enable economoizer" annotation(
    Placement(visible = true, transformation(origin = {220, -122}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi(redeclare package Medium = MediumW, V_start = 1) annotation(
    Placement(visible = true, transformation(extent = {{242, 143}, {262, 163}}, rotation = 0)));
  Buildings.Fluid.Chillers.ElectricEIR chi(redeclare package Medium1 = MediumW, redeclare package Medium2 = MediumW, m1_flow_nominal = mCW_flow_nominal, m2_flow_nominal = mCHW_flow_nominal, dp2_nominal = 0, dp1_nominal = 0, per = Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD(), energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial) annotation(
    Placement(visible = true, transformation(extent = {{280, 83}, {260, 103}}, rotation = 0)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val6(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930 + 89580, y_start = 1, use_inputFilter = false, from_dp = true) "Control valve for chilled water leaving from chiller" annotation(
    Placement(visible = true, transformation(origin = {362, 68}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare package Medium = MediumA, m_flow_nominal = mAir_flow_nominal) "Supply air temperature to data center" annotation(
    Placement(visible = true, transformation(origin = {270, -225}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEntChi(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal) "Temperature of chilled water entering chiller" annotation(
    Placement(visible = true, transformation(origin = {364, -148}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWLeaTow(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal) "Temperature of condenser water leaving the cooling tower" annotation(
    Placement(visible = true, transformation(origin = {340, 119}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant cooTowFanCon(k = 1) "Control singal for cooling tower fan" annotation(
    Placement(visible = true, transformation(origin = {224, 259}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal, dpValve_nominal = 20902, dpFixed_nominal = 14930, y_start = 0, use_inputFilter = false, from_dp = true) "Bypass valve for chiller." annotation(
    Placement(visible = true, transformation(origin = {292, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLeaCoi(redeclare package Medium = MediumW, m_flow_nominal = mCHW_flow_nominal) "Temperature of chilled water leaving the cooling coil" annotation(
    Placement(visible = true, transformation(origin = {220, -148}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")) annotation(
    Placement(transformation(extent = {{-360, -100}, {-340, -80}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation(
    Placement(transformation(extent = {{-332, -98}, {-312, -78}})));
  Modelica.Blocks.Sources.Constant TSetAirSup(k = 273.15 + 15) "Set point of the supply air temperature" annotation(
    Placement(visible = true, transformation(origin = {110, -95}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant val5Con(k = 1) "Control signal for valve 5" annotation(
    Placement(visible = true, transformation(origin = {190, 181}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant val6Con(k = 1) "Control signal for valve 6" annotation(
    Placement(visible = true, transformation(origin = {330, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCWCon(k = mCW_flow_nominal) "Control signal for condenser water pump" annotation(
    Placement(visible = true, transformation(origin = {330, 199}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCHWCon(k = 20 * 6485) "Control signal for chilled water pump" annotation(
    Placement(visible = true, transformation(origin = {172, 71}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant chiTSet(k = 273.15 + 5) "Set point for chilled water temperature " annotation(
    Placement(visible = true, transformation(origin = {260, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant chiOn annotation(
    Placement(visible = true, transformation(origin = {270, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(redeclare package Medium = MediumA, nPorts = 2, V = rooLen * rooWid * rooHei, m_flow_nominal = mAir_flow_nominal, energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, final T_start = 293.15, final prescribedHeatFlowRate = true) "Volume of air in the room" annotation(
    Placement(visible = true, transformation(origin = {230, -240}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRooAir "Temperature of the room" annotation(
    Placement(visible = true, transformation(extent = {{260, -292}, {280, -272}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QSou "Heat source of the room" annotation(
    Placement(visible = true, transformation(extent = {{182, -292}, {202, -272}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 36000, height = QRoo_flow, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(extent = {{140, -292}, {160, -272}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut annotation(
    Placement(visible = true, transformation(extent = {{134, -266}, {154, -246}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G = 10000 / 30) annotation(
    Placement(visible = true, transformation(extent = {{182, -266}, {202, -246}}, rotation = 0)));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU KMinusU(k = 1) annotation(
    Placement(visible = true, transformation(origin = {192, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Controls.Continuous.LimPID conPIDTAirSup(Td = 1, Ti = 120, controllerType = Modelica.Blocks.Types.SimpleController.PI, k = 0.1, reverseAction = true, strict = true) annotation(
    Placement(visible = true, transformation(origin = {160, -122}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow fanRet(redeclare package Medium = MediumA, T_start = 293.15, dp(start = 249), energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyState, m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false) "Return fan for air flow from the room" annotation(
    Placement(visible = true, transformation(extent = {{202, -235}, {182, -215}}, rotation = 0)));
  Buildings.Fluid.Actuators.Dampers.Exponential damRet(redeclare package Medium = MediumA, m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false) annotation(
    Placement(visible = true, transformation(origin = {150, -202}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Buildings.Fluid.Actuators.Dampers.Exponential damEA(redeclare package Medium = MediumA, m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false) annotation(
    Placement(visible = true, transformation(origin = {110, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Buildings.Fluid.Actuators.Dampers.Exponential damOA(redeclare package Medium = MediumA, m_flow(start = mAir_flow_nominal), m_flow_nominal = mAir_flow_nominal, use_inputFilter = false) annotation(
    Placement(visible = true, transformation(origin = {110, -176}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant damCon(k = 0.7) annotation(
    Placement(visible = true, transformation(origin = {30, -145}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU kMinusU(k = 1) annotation(
    Placement(visible = true, transformation(origin = {110, -128}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.Junction junRet(redeclare package Medium = MediumA, dp_nominal = {0, 0, 0}, m_flow_nominal = mAir_flow_nominal * {1, -1, -1}) annotation(
    Placement(visible = true, transformation(origin = {150, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = MediumA, nPorts = 2, use_C_in = false) annotation(
    Placement(visible = true, transformation(extent = {{48, -206}, {68, -186}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.Junction junOut(redeclare package Medium = MediumA, dp_nominal = {0, 0, 0}, m_flow_nominal = mAir_flow_nominal * {1, -1, 1}) annotation(
    Placement(visible = true, transformation(origin = {150, -176}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.RelativePressure PCHW annotation(
    Placement(visible = true, transformation(origin = {292, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  Buildings.Fluid.Movers.FlowControlled_dp pumCHW2(redeclare package Medium = MediumW, dp(start = 325474), energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, m_flow(start = mCHW_flow_nominal), m_flow_nominal = mCHW_flow_nominal, use_inputFilter = false) annotation(
    Placement(visible = true, transformation(origin = {-12, 54}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
  Modelica.Blocks.Sources.Constant val8Con(k = 1) annotation(
    Placement(visible = true, transformation(origin = {98, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCWcon2(k = mCW_flow_nominal) annotation(
    Placement(visible = true, transformation(origin = {98, 199}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant chi2On annotation(
    Placement(visible = true, transformation(origin = {38, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val8(redeclare package Medium = MediumW, dpFixed_nominal = 14930 + 89580, dpValve_nominal = 20902, from_dp = true, m_flow_nominal = mCHW_flow_nominal, use_inputFilter = false, y_start = 1) annotation(
    Placement(visible = true, transformation(origin = {128, 68}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow2(redeclare package Medium = MediumW, PFan_nominal = 6000, TAirInWB_nominal(displayUnit = "degC") = 283.15, TApp_nominal = 6, dp_nominal = 14930 + 14930 + 74650, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, m_flow_nominal = mCW_flow_nominal) "Cooling tower 2" annotation(
    Placement(visible = true, transformation(origin = {48, 229}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant chiTSet2(k = 273.15 + 5) annotation(
    Placement(visible = true, transformation(origin = {28, 69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW2(redeclare package Medium = MediumW, dp(start = 214992), energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial, m_flow_nominal = mCW_flow_nominal, use_inputFilter = false) annotation(
    Placement(visible = true, transformation(origin = {128, 200}, extent = {{-10, 10}, {10, -10}}, rotation = 270)));
  Buildings.Fluid.Storage.ExpansionVessel expVesChi2(redeclare package Medium = MediumW, V_start = 1) annotation(
    Placement(visible = true, transformation(extent = {{10, 143}, {30, 163}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant val7Con(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-42, 181}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val7(redeclare package Medium = MediumW, dpFixed_nominal = 89580, dpValve_nominal = 20902, m_flow_nominal = mCW_flow_nominal, use_inputFilter = false, y_start = 1) annotation(
    Placement(visible = true, transformation(origin = {-12, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constant5(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-18, 261}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TWCLeaTow2(redeclare package Medium = MediumW, m_flow_nominal = mCW_flow_nominal) annotation(
    Placement(visible = true, transformation(origin = {108, 119}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant pumCHWcon2(k = 20 * 6485) annotation(
    Placement(visible = true, transformation(origin = {-60, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Chillers.ElectricEIR chi2(redeclare package Medium1 = MediumW, redeclare package Medium2 = MediumW, dp1_nominal = 0, dp2_nominal = 0, energyDynamics = Modelica.Fluid.Types.Dynamics.SteadyStateInitial, m1_flow_nominal = mCW_flow_nominal, m2_flow_nominal = mCHW_flow_nominal, per = Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_19XR_742kW_5_42COP_VSD()) annotation(
    Placement(visible = true, transformation(extent = {{48, 83}, {28, 103}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.Junction junCHWSup(redeclare package Medium = MediumW, dp_nominal = {0, 0, 0}, m_flow_nominal = mCHW_flow_nominal * {1, -1, 1}) annotation(
    Placement(visible = true, transformation(origin = {362, -16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Buildings.Fluid.FixedResistances.Junction junCHWRet(redeclare package Medium = MediumW, dp_nominal = {0, 0, 0}, m_flow_nominal = mCHW_flow_nominal * {1, -1, -1}) annotation(
    Placement(visible = true, transformation(origin = {220, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
equation
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation(
    Line(points = {{266, -155}, {266, -164.5}, {286, -164.5}, {286, -164}}, color = {0, 127, 255}, thickness = 0.5));
  connect(cooTow.port_b, pumCW.port_a) annotation(
    Line(points = {{290, 239}, {369, 239}, {369, 210}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val5.port_a, chi.port_b1) annotation(
    Line(points = {{220, 170}, {220, 99}, {256, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(expVesChi.port_a, chi.port_b1) annotation(
    Line(points = {{252, 143}, {252, 99}, {260, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(cooCoi.port_b2, fanSup.port_a) annotation(
    Line(points = {{306, -176}, {365, -176}, {365, -225}, {354, -225}}, color = {0, 127, 255}, thickness = 0.5));
  connect(mFanFlo.y, fanSup.m_flow_in) annotation(
    Line(points = {{309, -196}, {344, -196}, {344, -213}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(TAirSup.port_a, fanSup.port_b) annotation(
    Line(points = {{280, -225}, {334, -225}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val1.port_a, TCHWLeaCoi.port_b) annotation(
    Line(points = {{220, -132}, {220, -138}}, color = {0, 127, 255}, thickness = 0.5));
  connect(TCWLeaTow.port_b, chi.port_a1) annotation(
    Line(points = {{330, 119}, {310, 119}, {310, 99}, {284, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(weaData.weaBus, weaBus) annotation(
    Line(points = {{-340, -90}, {-331, -90}, {-331, -88}, {-322, -88}}, color = {255, 204, 51}, thickness = 0.5, smooth = Smooth.None),
    Text(string = "%second", index = 1, extent = {{6, 3}, {6, 3}}));
  connect(cooTow.TAir, weaBus.TWetBul) annotation(
    Line(points = {{268, 243}, {-322, 243}, {-322, -88}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(val5.port_b, cooTow.port_a) annotation(
    Line(points = {{220, 190}, {220, 239}, {261, 239}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumCW.port_b, TCWLeaTow.port_a) annotation(
    Line(points = {{360, 190}, {360, 119}, {342, 119}}, color = {0, 127, 255}, thickness = 0.5));
  connect(chi.port_b2, val6.port_a) annotation(
    Line(points = {{280, 87}, {362, 87}, {362, 78}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val5Con.y, val5.y) annotation(
    Line(points = {{201, 181}, {213, 181}, {213, 179}}, color = {0, 0, 127}));
  connect(val6Con.y, val6.y) annotation(
    Line(points = {{341, 69}, {350, 69}, {350, 68}}, color = {0, 0, 127}));
  connect(pumCWCon.y, pumCW.m_flow_in) annotation(
    Line(points = {{341, 199}, {355, 199}}, color = {0, 0, 127}));
  connect(pumCHWCon.y, pumCHW.dp_in) annotation(
    Line(points = {{183, 71}, {214, 71}, {214, 70}}, color = {0, 0, 127}));
  connect(chiTSet.y, chi.TSet) annotation(
    Line(points = {{271, 69}, {281, 69}, {281, 89}}, color = {0, 0, 127}));
  connect(chiOn.y, chi.on) annotation(
    Line(points = {{281, 124}, {281, 111}, {279, 111}, {279, 96}}, color = {255, 0, 255}));
  connect(cooTow.y, cooTowFanCon.y) annotation(
    Line(points = {{268, 247}, {235, 247}, {235, 259}}, color = {0, 0, 127}));
  connect(TRooAir.port, vol.heatPort) annotation(
    Line(points = {{260, -282}, {242, -282}, {242, -240}}, color = {191, 0, 0}));
  connect(QSou.port, vol.heatPort) annotation(
    Line(points = {{202, -282}, {242, -282}, {242, -240}}, color = {191, 0, 0}));
  connect(ramp.y, QSou.Q_flow) annotation(
    Line(points = {{161, -282}, {181, -282}}, color = {0, 0, 127}));
  connect(theCon.port_a, TOut.port) annotation(
    Line(points = {{182, -256}, {154, -256}}, color = {191, 0, 0}));
  connect(theCon.port_b, vol.heatPort) annotation(
    Line(points = {{202, -256}, {242, -256}, {242, -240}}, color = {191, 0, 0}));
  connect(TOut.T, weaBus.TDryBul) annotation(
    Line(points = {{132, -256}, {-322, -256}, {-322, -88}}, color = {0, 0, 127}));
  connect(TAirSup.port_b, vol.ports[1]) annotation(
    Line(points = {{260, -225}, {232, -225}, {232, -230}}, color = {0, 127, 255}));
  connect(cooCoi.port_b1, TCHWLeaCoi.port_a) annotation(
    Line(points = {{286, -164}, {224, -164}, {224, -158}}, color = {0, 127, 255}));
  connect(chi.port_a2, pumCHW.port_b) annotation(
    Line(points = {{260, 87}, {224, 87}, {224, 79}}, color = {0, 127, 255}));
  connect(valByp.port_a, val1.port_b) annotation(
    Line(points = {{282, -74}, {226, -74}, {226, -112}}, color = {0, 127, 255}));
  connect(valByp.port_b, TCHWEntChi.port_b) annotation(
    Line(points = {{302, -74}, {364, -74}, {364, -138}}, color = {0, 127, 255}));
  connect(cooCoi.port_a1, TCHWEntChi.port_a) annotation(
    Line(points = {{306, -164}, {364, -164}, {364, -158}}, color = {0, 127, 255}));
  connect(TSetAirSup.y, conPIDTAirSup.u_s) annotation(
    Line(points = {{121, -95}, {132, -95}, {132, -122}, {148, -122}}, color = {0, 0, 127}));
  connect(conPIDTAirSup.y, val1.y) annotation(
    Line(points = {{171, -122}, {210, -122}}, color = {0, 0, 127}));
  connect(KMinusU.u, conPIDTAirSup.y) annotation(
    Line(points = {{180, -62}, {173.2, -62}, {173.2, -122}}, color = {0, 0, 127}));
  connect(KMinusU.y, valByp.y) annotation(
    Line(points = {{203, -62}, {290, -62}}, color = {0, 0, 127}));
  connect(TAirSup.T, conPIDTAirSup.u_m) annotation(
    Line(points = {{270, -214}, {270.5, -214}, {270.5, -170}, {162, -170}, {162, -134}}, color = {0, 0, 127}));
  connect(fanRet.m_flow_in, mFanFlo.y) annotation(
    Line(points = {{192, -213}, {309, -213}, {309, -196}}, color = {0, 0, 127}));
  connect(damCon.y, damOA.y) annotation(
    Line(points = {{41, -145}, {108, -145}, {108, -164}}, color = {0, 0, 127}));
  connect(damEA.y, damCon.y) annotation(
    Line(points = {{110, -238}, {90, -238}, {90, -145}, {42, -145}, {42, -145.5}, {43, -145.5}, {43, -145}}, color = {0, 0, 127}));
  connect(kMinusU.u, damCon.y) annotation(
    Line(points = {{98.2, -128}, {89.2, -128}, {89.2, -144.75}, {41.2, -144.75}, {41.2, -145}}, color = {0, 0, 127}));
  connect(kMinusU.y, damRet.y) annotation(
    Line(points = {{121, -128}, {132, -128}, {132, -201.5}, {140, -201.5}, {140, -202}}, color = {0, 0, 127}));
  connect(fanRet.port_a, vol.ports[2]) annotation(
    Line(points = {{202, -225}, {232, -225}, {232, -230}}, color = {0, 127, 255}));
  connect(junRet.port_2, damEA.port_a) annotation(
    Line(points = {{140, -226}, {116, -226}}, color = {0, 127, 255}));
  connect(junRet.port_3, damRet.port_a) annotation(
    Line(points = {{150, -216}, {150, -212}}, color = {0, 127, 255}));
  connect(junRet.port_1, fanRet.port_b) annotation(
    Line(points = {{160, -226}, {163, -226}, {163, -225}, {180, -225}}, color = {0, 127, 255}));
  connect(damOA.port_a, out.ports[1]) annotation(
    Line(points = {{100, -176}, {70, -176}, {70, -196}}, color = {0, 127, 255}));
  connect(damEA.port_b, out.ports[2]) annotation(
    Line(points = {{100, -226}, {70, -226}, {70, -196}}, color = {0, 127, 255}));
  connect(out.weaBus, weaBus);
  connect(damOA.port_b, junOut.port_1) annotation(
    Line(points = {{120, -176}, {144, -176}}, color = {0, 127, 255}));
  connect(junOut.port_2, cooCoi.port_a2) annotation(
    Line(points = {{160, -176}, {284, -176}}, color = {0, 127, 255}));
  connect(junOut.port_3, damRet.port_b) annotation(
    Line(points = {{150, -186}, {150, -192}}, color = {0, 127, 255}));
  connect(PCHW.port_a, valByp.port_b) annotation(
    Line(points = {{302, -102}, {302, -107}, {304, -107}, {304, -74}}, color = {0, 127, 255}));
  connect(PCHW.port_b, valByp.port_a) annotation(
    Line(points = {{282, -102}, {282, -107}, {284, -107}, {284, -74}}, color = {0, 127, 255}));
  connect(pumCHWcon2.y, pumCHW2.dp_in) annotation(
    Line(points = {{-49, 55}, {-24, 55}, {-24, 54}}, color = {0, 0, 127}));
  connect(val7Con.y, val7.y) annotation(
    Line(points = {{-31, 181}, {-19, 181}, {-19, 179}}, color = {0, 0, 127}));
  connect(cooTow2.port_b, pumCW2.port_a) annotation(
    Line(points = {{58, 229}, {128, 229}, {128, 210}}, color = {0, 127, 255}, thickness = 0.5));
  connect(chiTSet2.y, chi2.TSet) annotation(
    Line(points = {{39, 69}, {49, 69}, {49, 89}}, color = {0, 0, 127}));
  connect(chi2.port_b2, val8.port_a) annotation(
    Line(points = {{48, 87}, {130, 87}, {130, 78}}, color = {0, 127, 255}, thickness = 0.5));
  connect(chi2.port_a2, pumCHW2.port_b) annotation(
    Line(points = {{28, 87}, {-12, 87}, {-12, 64}}, color = {0, 127, 255}));
  connect(TWCLeaTow2.port_b, chi2.port_a1) annotation(
    Line(points = {{98, 119}, {78, 119}, {78, 99}, {52, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(val8Con.y, val8.y) annotation(
    Line(points = {{109, 69}, {122, 69}, {122, 68}}, color = {0, 0, 127}));
  connect(val7.port_a, chi2.port_b1) annotation(
    Line(points = {{-12, 170}, {-12, 99}, {24, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(pumCWcon2.y, pumCW2.m_flow_in) annotation(
    Line(points = {{109, 199}, {116, 199}, {116, 200}}, color = {0, 0, 127}));
  connect(val7.port_b, cooTow2.port_a) annotation(
    Line(points = {{-12, 190}, {-12, 229}, {38, 229}}, color = {0, 127, 255}, thickness = 0.5));
  connect(expVesChi2.port_a, chi2.port_b1) annotation(
    Line(points = {{20, 143}, {20, 99}, {28, 99}}, color = {0, 127, 255}, thickness = 0.5));
  connect(cooTow2.y, constant5.y) annotation(
    Line(points = {{36, 237}, {3.5, 237}, {3.5, 261}, {-7, 261}}, color = {0, 0, 127}));
  connect(chi2On.y, chi2.on) annotation(
    Line(points = {{49, 124}, {49, 111}, {47, 111}, {47, 96}}, color = {255, 0, 255}));
  connect(pumCW2.port_b, TWCLeaTow2.port_a) annotation(
    Line(points = {{128, 190}, {128, 119}, {110, 119}}, color = {0, 127, 255}, thickness = 0.5));
  connect(cooTow2.TAir, weaBus.TWetBul) annotation(
    Line(points = {{36, 234}, {-322, 234}, {-322, -88}}, color = {0, 0, 127}));
  connect(pumCHW2.port_a, junCHWRet.port_3) annotation(
    Line(points = {{-12, 44}, {-13, 44}, {-13, 2}, {-14, 2}, {-14, -37}, {108, -37}, {108, -36.5}, {210, -36.5}, {210, -38}}, color = {0, 127, 255}));
  connect(junCHWRet.port_2, pumCHW.port_a) annotation(
    Line(points = {{220, -28}, {220, 60}}, color = {0, 127, 255}));
  connect(junCHWRet.port_1, val1.port_b) annotation(
    Line(points = {{220, -48}, {220, -112}}, color = {0, 127, 255}));
  connect(junCHWSup.port_3, val8.port_b) annotation(
    Line(points = {{352, -16}, {128, -16}, {128, 58}}, color = {0, 127, 255}));
  connect(val6.port_b, junCHWSup.port_1) annotation(
    Line(points = {{362, 58}, {362, -6}}, color = {0, 127, 255}));
  connect(junCHWSup.port_2, TCHWEntChi.port_b) annotation(
    Line(points = {{362, -26}, {364, -26}, {364, -138}}, color = {0, 127, 255}));
  annotation(
    Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-400, -300}, {400, 300}})),
    experiment(StartTime = 13046400, Tolerance = 1e-6, StopTime = 13651200),
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
end WaterCooledChillerExample6;
