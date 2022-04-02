# coding: utf-8
import os
import subprocess

# -------------------------------------------
# モデル名を指定してfmuコンパイルを実行
# -------------------------------------------

# ディレクトリとコンパイル対象の定義
jmodelica_dir = 'C:\JModelica.org-2.14' # JModelicaのインストールディレクトリ
pkg_dir = 'C:\JModelica.org-2.14\workspace' # パッケージのあるディレクトリ 
# FMU化対象のモデル名称
#model = 'Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl' # サンプルとして用いたデータセンター冷房のモデル
#model = 'ZEBGuidelineMid.WaterCooledChillerExample' # データセンター冷房モデルをたんにコピーしたもの
#model = 'ZEBGuidelineMid.WaterCooledChillerExample2' # 余計な設備と制御を除いたシンプルな熱源系のモデル
#model = 'ZEBGuidelineMid.WaterCooledChillerExample3' # 室モデルをカスタム可能とし，外壁熱負荷を追加
#model = 'ZEBGuidelineMid.WaterCooledChillerExample4' # AHUの給気温度制御を追加
#model = 'ZEBGuidelineMid.WaterCooledChillerExample5' # AHUに外気取り込みダクト・ダンパ・還気ファンを追加
#model = 'ZEBGuidelineMid.WaterCooledChillerExample6' # チラーをもう1つの系統分追加
model = 'ZEBGuidelineMid.WaterCooledChillerExample7' # 蓄熱槽とバルブを追加
fmu_filename = os.getcwd() + '\\' + model.replace('.', '_') + '.fmu' # fmuファイル名
compile_script = os.getcwd() + '\\' + 'compile_fmu.py' # コンパイルスクリプトの出力先

# fmuコンパイルスクリプトの作成
script_string=('# coding: utf-8\n'
        'import os\n'
        'os.environ[\'MODELICAPATH\'] = '
        'r\''
        'C:\JModelica.org-2.14\install\ThirdParty\MSL;'
        'C:\JModelica.org-2.14\install\ThirdParty;'
        + pkg_dir +'\'\n\n'
        'from pymodelica import compile_fmu\n'
        'fmu = compile_fmu(\''
        + model
        + '\', version=\'2.0\', target=\'cs\', compile_to=\''
        + fmu_filename
        + '\', compiler_log_level=\'w,i:compile_fmu.log\')\n'
        )

# スクリプトの書き出し
if os.path.isfile(compile_script):
    os.remove(compile_script)
with open(compile_script, mode='w') as f:
    f.write(script_string)

# fmuコンパイル実行
bat = jmodelica_dir + '\\IPython64.bat' # JModelicaのIPython64実行batファイルのパス
command = bat + ' ' + compile_script
result = subprocess.run(command, stdout=subprocess.PIPE, text=True)
print(result.stdout)

# -------------------------------------------
# コンパイルしたfmuを実行して結果をグラフ表示
# 以下を参照
# https://github.com/CATIA-Systems/FMPy/blob/master/fmpy/examples/custom_input.py
# -------------------------------------------
# import
from fmpy import read_model_description, extract
from fmpy.fmi2 import FMU2Slave
from fmpy.util import plot_result, download_test_file
import numpy as np
import shutil
import matplotlib.pyplot as plt

# simulation setting
start_time = 1.30464e+07 # 151日後=6/1 00:00
stop_time = 1.36512e+07 # 158日後=6/8 00:00
step_num = 5000
step_size = (stop_time - start_time) / step_num

# read the description
model_description = read_model_description(fmu_filename)

# collect the value references
vrs = {}
for variable in model_description.modelVariables:
    vrs[variable.name] = variable.valueReference
tempDryBulb = vrs['weaBus.TDryBul']      # 外気温度
tempAirSupply = vrs['TAirSup.T'] # 給気温度
tempRoomAir = vrs['roo.TRooAir'] # 室温 Example 1, 2
#tempRoomAir = vrs['TRooAir.T'] # 室温 Example 3
tempVolume2Chiller = vrs['chi.vol2.T'] # チラー冷水出口温度
tempVolume1Chiller = vrs['chi.vol1.T'] # チラー冷却水出口温度
tempWaterReturn = vrs['TCHWEntChi.T'] # チラー冷水入り口温度
tempWaterCT = vrs['TCWLeaTow.T'] # 冷却塔出口温度
powerCompressor = vrs['chi.P'] # コンプレッサ消費電力[W]
openingDegreeVal1 = vrs['val1.y'] # バルブ1開度

# extract the FMU
unzipdir = extract(fmu_filename)
fmu = FMU2Slave(guid=model_description.guid,
                unzipDirectory=unzipdir,
                modelIdentifier=model_description.coSimulation.modelIdentifier,
                instanceName='instance1')
# initialize
fmu.instantiate()
fmu.setupExperiment(startTime=start_time)
fmu.enterInitializationMode()
fmu.exitInitializationMode()
time = start_time

rows = []  # list to record the results

# simulation loop
while time < stop_time:

    # set the input
    # fmu.setReal([vr_inputs], [0.0 if time < 0.9 else 1.0])

    # perform one step
    fmu.doStep(currentCommunicationPoint=time, communicationStepSize=step_size)

    # get the values for 'inputs' and 'outputs[4]'
    input1, input2, input3, output1, output2, output3 = fmu.getReal([tempDryBulb, tempVolume2Chiller, openingDegreeVal1, tempRoomAir, powerCompressor, tempAirSupply])

    # append the results
    rows.append([time, input1, input2, input3, output1, output2, output3])

    # advance the time
    time += step_size

# shutdown
fmu.terminate()
fmu.freeInstance()
shutil.rmtree(unzipdir, ignore_errors=True)

result = np.array(rows)
fig = plt.figure(figsize=(20,40))
for i in range(len(result[0])):
    fig.add_subplot(len(result[0]), 1, i+1)
    plt.plot(result[0:500,0], result[0:500,i])


