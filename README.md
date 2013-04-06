Sunny-Dolls
===========

晴天娃娃（Sunny Dolls）是一个报时和显示天气的APP。

其中报时的声音来自于[UNIQLO WAKE UP](https://itunes.apple.com/cn/app/uniqlo-wake-up/id515839388?mt=8)，一个十分优美的iOS闹铃APP，天气信息及图标来自于[Weather Underground](http://www.wunderground.com/)，app的icon来着于[界面設計師](http://apppsd.com/1371.html)。

本APP为本人学习练习使用，请勿传播。

![image](http://github.com/jnriver/Sunny-Dolls/raw/master/1.png)

默认地区设为珠海了。。如果想更改，打开终端输入`defaults write jnriver.Sunny-Dolls location {location}`，其中`{location}`为你想设置的城市的全拼，例如“defaults write jnriver.Sunny-Dolls zhuhai”
如果不确定是否能查看到自己所在城市，可以通过URL确认查询结果：http://api.wunderground.com/api/%@/forecast/lang:CN/q/CN/{location}.json，例如http://api.wunderground.com/api/%@/forecast/lang:CN/q/CN/zhuhai.json
