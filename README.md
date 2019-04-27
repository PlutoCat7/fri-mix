# Fri-Mix工具使用说明

### Fri-Mix必须使用mix.plist来启动（支持相对和绝对路径）

##### <---- mix.plist ---->
</br>
FrameworkPaths 用来过滤掉一些系统和第三方的框架方法和属性
</br>
ShieldPaths 用来保护不希望被混淆的文件路径（可以是文件夹名称）
</br>
ShieldClass 用来保护不希望被混淆的类
</br>
MethodSuffix 混淆后的属性或方法后缀
</br>
MethodPrefix 混淆后的属性或方法前缀
</br>
RootPath 混淆工程路径
</br>
ReferencePath 参考路径支持.h .m .mm文件。参考的量一定要足够支撑替换最好比原工程多一千个
</br>
ProjectPrefix 类名前缀与工程前缀
</br>
AbsolutePath 是否为绝对路径
</br>
OpenLog 是否打开输出日志

