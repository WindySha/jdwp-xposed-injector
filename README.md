## What is this
This is an injection tool that can inject any xposed modules apk into the debug android app, the native code in the xposed module can also be injected.
## Support
**Android Version:** 5-12  
**Architecture:** arm, arm64  
**App:** debuggable==true  
**injected code:** java, c/c++  
**Platform:** macOS
## Usage
Clone this project to your macOS.
```
$ cd jdwp-xposed-injector
$ injector.sh com.to_be_injected.packageName injected_xposed_module.apk
```
This first parameter is the package of the app that you want to inject to, the second parameter is the path of the xposed module apk file.

"fast_mode" can be added to avoid data copy if it is the second time injection.
```
$ injector.sh com.to_be_injected.packageName injected_xposed_module.apk fast_mode
```
## Xposed module sample
The `injected_xposed_module.apk` file is a xposed module sample build by project: https://github.com/WindySha/XposedModuleSample.  
The proejct XposedModuleSample includes using xposed api to hook java methods and using cydiaSubstrate to hook c/c++ functions.

## Known Issues
1. In some cases, the injection command may excute failed, if this happened, try it again.

## How it works
Comming so...
## Thanks
1. [xposed_module_loader](https://github.com/WindySha/xposed_module_loader)
2. [jdwp-shellifier](https://github.com/IOActive/jdwp-shellifier)
3. [SandHook](https://github.com/asLody/SandHook)
4. [XposedModuleSample](https://github.com/WindySha/XposedModuleSample)
