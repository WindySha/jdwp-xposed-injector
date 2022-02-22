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
[一种基于JDWP动态注入代码的方案](https://windysha.github.io/2022/02/19/%E4%B8%80%E7%A7%8D%E5%9F%BA%E4%BA%8EJDWP%E5%8A%A8%E6%80%81%E6%B3%A8%E5%85%A5%E4%BB%A3%E7%A0%81%E7%9A%84%E6%96%B9%E6%A1%88/)
## Thanks
1. [xposed_module_loader](https://github.com/WindySha/xposed_module_loader)
2. [jdwp-shellifier](https://github.com/IOActive/jdwp-shellifier)
3. [SandHook](https://github.com/asLody/SandHook)
4. [XposedModuleSample](https://github.com/WindySha/XposedModuleSample)
