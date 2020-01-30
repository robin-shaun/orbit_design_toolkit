# 轨道设计工具包
#该库使用Matlab的编写，面向对象编程，一共有X个类
## 1.天文学常数
例如调用光速：`constants.AstroConstants.c`
## 2.时间系统
时间系统对象的初始化输入为UTC(协调世界时间)和地理经度。时间数据类型为datetime和（相对）儒略日。
```
UTC = datetime(2019,11,27,21,10,10);
lambda = 24.583;
timesystem  = timeSystem.TimeSystem(UTC,lambda)
```
```
timesystem = 

  TimeSystem with properties:

        UTC: 2019-11-27 21:10:10
    lambdaG: 24.5830
     lambda: 24.5830
        TAI: 2019-11-27 21:10:11
         TT: 2019-12-30 01:35:08
        TDT: 2019-12-30 01:35:08
         ET: 2019-12-30 01:35:08
        UT1: 2019-11-27 21:10:10
      Smean: 6.2995e+08
          S: 6.2995e+08
      smean: 6.2995e+08
          s: 6.2995e+08
```