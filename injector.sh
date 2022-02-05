#!/bin/bash
echo "[ Java And C/C++ Code Injection for Android Debug App By Windysha(https://github.com/WindySha)]"

packageName=$1
xposed_module_plugin_apk_path=$2
# dex以及so文件是否已经复制到应用的data/data目录下，一般，第一次执行某个app才需要复制，第二次可不用复制，可以将第三个参数设为fast_mode
asset_files_copy_mode=$3
is_fast_mode=1

if [ "${packageName}" == "" ]; then
  echo "please input the package name that you want inject code.!!!"
  exit 0
fi

echo "[**] Start package: $packageName"
adb shell am force-stop $packageName
adb shell am set-debug-app -w $packageName
adb shell monkey -p $packageName -c android.intent.category.LAUNCHER 1

tmp_path="/data/local/tmp/"

plugin_apk_file_name=${xposed_module_plugin_apk_path##*/}
xposed_plugin_apk_name="xposed_plugin.apk"
if [ -f $xposed_module_plugin_apk_path ]; then
   adb push $xposed_module_plugin_apk_path $tmp_path
   # rename plguin name to xposed_plugin.apk
   adb shell mv $tmp_path$plugin_apk_file_name $tmp_path$xposed_plugin_apk_name
else
   echo "Plugin file not exist: $xposed_module_plugin_apk_path"
fi

work_dir=$(cd `dirname $0`; pwd)
native_injector_name="libnative-injector.so"
native_injector_path="/libs/${native_injector_name}"

native_injector_name_64="libnative-injector-64.so"
native_injector_path_64="/libs/${native_injector_name_64}"

xposed_loader_dex_name="classes.dex"
xposed_loader_dex_path="/libs/xposed_loader/${xposed_loader_dex_name}"

xposed_loader_so_name="libsandhook.so"
xposed_loader_so_path="/libs/xposed_loader/${xposed_loader_so_name}"

xposed_loader_64_so_name="libsandhook-64.so"
xposed_loader_64_so_path="/libs/xposed_loader/${xposed_loader_64_so_name}"

path_array=($native_injector_path $xposed_loader_dex_path $native_injector_path_64 $xposed_loader_so_path $xposed_loader_64_so_path)

echo "mode : $asset_files_copy_mode"

if [ "${asset_files_copy_mode}" != "fast_mode" ]; then
  is_fast_mode=0
  for value in "${path_array[@]}"; do
    if [ ! -f $work_dir$value ]; then # 判断文件是否存在
      echo "File $work_dir$value do not exist, please check it!!!"
      exit 1
    else
      echo "Start Pushing $work_dir$value to $tmp_path"
      adb push $work_dir$value $tmp_path
    fi
  done
fi

tcp_port=8900
F=/var/tmp/jdwpPidFile-$(date +%s)
echo "[**] Retrieving pid of running JDWP-enabled app"
adb jdwp >"$F" &
sleep 1
kill -9 $!
jdwp_pid=$(tail -1 "$F")
rm "$F"
echo "[**] JDWP pid is $F. Will forward tcp:$tcp_port to jdwp:$jdwp_pid"
adb kill-server # 此处需要重启adb，否则会出现android studio跟server socket握手的情况
adb forward tcp:"$tcp_port" jdwp:$jdwp_pid

echo "[**] Starting jdwp-shellifier.py to load library"
# Attach break point to: android.app.LoadedApk.makeApplication, it runs before Application attachBaseContext and onCreate.
python "$work_dir/jdwp-shellifier.py" --target 127.0.0.1 --port "$tcp_port" --break-on android.app.LoadedApk.makeApplication --mode $is_fast_mode --loadlib $tmp_path$native_injector_name --loadlib64 $tmp_path$native_injector_name_64 --loaderDexPath $tmp_path$xposed_loader_dex_name --loaderSoPath $tmp_path$xposed_loader_so_name --loader64SoPath $tmp_path$xposed_loader_64_so_name --pluginPath $tmp_path$xposed_plugin_apk_name
