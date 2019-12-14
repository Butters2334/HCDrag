# HCDrag
使用OC编写的简单双向可拖动进度条


```
//初始化传入进度条数组
self.dView.progressRateNumber = @[@10,@30,@60];
self.dView.progressRateColor  = @[[UIColor blueColor],[UIColor greenColor],[UIColor redColor]];;
[self.dView resetView];
```

```
//让控件直接响应delegate(初始化需要)
[self.dView resetProgressRateNumber];
```

![screen0.png](https://github.com/anmac/HCDrag/blob/master/SimulatorScreenShot/screen0.png)
![screen0.png](https://github.com/anmac/HCDrag/blob/master/SimulatorScreenShot/screen1.png)
![screen0.png](https://github.com/anmac/HCDrag/blob/master/SimulatorScreenShot/screen2.png)
![screen0.png](https://github.com/anmac/HCDrag/blob/master/SimulatorScreenShot/screen3.png)


