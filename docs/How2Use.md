# 如何使用原工程素材自行导入游戏实现汉化

## 一般规则

### 查找并编辑 TextMesh

Unity 引擎所开发的游戏，其是按场景加载的。而每一个场景及其所使用的素材都会被打包成一个个 level 和 assets 文件。而 level 和 assets 是一一对应的关系，有 level1 就会有其对应的 assets1 文件，包含该场景所用到的素材。

在林中之夜里，选项界面的文字大部分储存在 TextMesh 中，小部分储存在 MonoBehavior 中。确定好文本出现的场景及其场景所对应的文件后，在 TestMesh 中的可以使用 UABE 导出后直接修改文本再导入。而在 MonoBehavior 中的，为判断其是否找到对应文件，可用文件编辑器直接打开 level 或 assets 文件搜索关键字。匹配后配合 UnityEX 导出，编辑二进制，导入文件中。

### 直接编辑二进制

编辑二进制文件时，找到需要修改的文本后，注意前面还有 4 个字节（Byte）的前缀，其第 1 个字节为 **十六进制** 表示的文本长度，后 3 字节为十六进制表示的 0 。后面还有补 0 的后缀，使其**前缀**加**文本**加**后缀**的总字节数为 4 的**最小**倍数。
UTF8 编码下一个中文字用 3 个字节表示，一个英文字用 1 个字节表示。
为方便现以 4 个字节为 1 字（word）（现代 64 位计算机多以 8 字节为 1 字），修改样例如下：

>Yes(Y:59 e:65 s:73)

|第一字|第二字|
|---|---|
|03 00 00 00|59 65 73 00|

>取消(取：E58F96 消：E6B688)

|第一字|第二字|第三字|
|---|---|---|
|06 00 00 00|E5 8F 96 E6|B6 88 00 00|

在编辑二进制文本时有时会看到后缀多出来的 4 字节的 0，那不是文本的范围，请保留。在本项目中总字节数为 4 的 **最小** 倍数，即后缀补 0 数不超过 3 个字节。现在尚未发现修改二进制英文转中文的总字节数不超过原英文总字节数的限制，若要编辑，修改范围在遵守最小倍数的原则下，请放心增加或删除任意文字。

### 修改图片

在 Unity 中显示的图片，实际上是将图片转换成精灵图（Sprite）的形式显示，所以在查看资源时会有 Sprite 这一项内容。一般来说，只需要替换 Texture2D 文件，就可以在游戏中正常显示。但在林中之夜中，部分图片含有透明度，只替换 Texture2D 会导致显示精灵图时出现渲染错误，部分内容显示不出来。截至目前，探索出来的方法是同时修改 Texture2D 对应的 Sprite, 使用 UABE Export Dump 后修改渲染选项后 Import Dump。

~~好像看到 UnityEx Ultimate 版有对这种问题的解决方法，那么有没有好心人呢。~~

#### 具体修改细节

Dump 时选择以 json 文件导出，需要替换的名称是：

* 0 vector m_SubMeshes
* 0 vector m_IndexBuffer
* 1 VertexData m_VertexData

至于用什么来替换呢，在 [common/spriteSwitch.txt](/common/spriteSwitch.txt) 里的内容是游戏里一张 1920 x 1080 的不透明图片的 Sprite 渲染选项。目前使用这个来替换是没有问题的。

## 本项目资源介绍

|名称|类型|所属文件类别|导入所需工具|
|:---|---|---|---|
|TextAsset_UnityEx|对话文本文件|assets|UnityEX|
|TextMesh_UnityEx|暂停界面选项菜单|assets|UnityEX|
|TextMesh_UABE|标题界面选项，退出提示框，额外内容前言|level, extrasmenu|UABE|
|MonoBehaviour_UnityEX|概念艺术介绍，失落的星座选项|level|UnityEX|
|Sprite_UABE|精灵图渲染方式|assets|UABE|
|Texture2D_UABE|游戏内图片|assets|UABE|

更具体的对应关系参考 common 文件夹下各 Mapping 文件。

## 注意事项

### 使用脚本导入 UnityEx 格式资源

需要使用 UnityEx 导入的，将 Unity_Assets_Files 目录复制进 \*_Data 目录下。同时也需要将 UnityEX 软件和 common 里提供的批处理脚本(.bat)放入 *_Data 目录下。

> * \* 号表示任意字符串，在本项目指 Night in the Woods
> * UnityEx 俄文发布网页，[点这里](https://forum.zoneofgames.ru/topic/36240-unityex/)

执行批处理脚本，导入汉化资源。
