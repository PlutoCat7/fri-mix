# CJMix工具使用说明

#CJMix必须使用mix.plist来启动（支持相对和绝对路径）

<---- mix.plist ---->
FrameworkPaths 用来过滤掉一些系统和第三方的框架方法和属性
ShieldPaths 用来保护不希望被混淆的文件路径（可以是文件夹名称）
ShieldClass 用来保护不希望被混淆的类
MethodSuffix 混淆后的属性或方法后缀
MethodPrefix 混淆后的属性或方法前缀
RootPath 混淆工程路径
ReferencePath 参考路径支持.h .m .mm文件。参考的量一定要足够支撑替换最好比原工程多一千个
ProjectPrefix 类名前缀与工程前缀
AbsolutePath 是否为绝对路径
OpenLog 是否打开输出日志

