# coding: utf-8
import os
os.environ['MODELICAPATH'] = r'C:\JModelica.org-2.14\install\ThirdParty\MSL;C:\JModelica.org-2.14\install\ThirdParty;C:\JModelica.org-2.14\workspace'

from pymodelica import compile_fmu
fmu = compile_fmu('ZEBGuidelineMid.WaterCooledChillerExample7', version='2.0', target='cs', compile_to='c:\JModelica.org-2.14\workspace\ZEBGuidelineMid\ZEBGuidelineMid_WaterCooledChillerExample7.fmu', compiler_log_level='w,i:log.txt')
