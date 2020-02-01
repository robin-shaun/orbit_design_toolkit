# 轨道设计工具包
#该库使用Matlab的编写，面向对象编程，一共有X个库
## 0.单位制
该工具包使用国际制单位。为了设计者直观理解，角度用deg，deg转rad全部封装进了库里，不需要设计者考虑。
## 1.天文学常数
例如调用光速：`constants.AstroConstants.c`
## 2.时间系统
时间系统对象的初始化输入为UTC(协调世界时间)和地理经度。时间数据类型为datetime或double（秒）。
UTC可以是数组，地理经度目前要求是标量。
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

## 3.轨道确定
### 3.1测站数据预处理
根据
- 测站纬度、真太阳时、海拔（或高程）
- 航天器方位角、高低角、距离、方位角变化率、高低角变化率和距离变化率

算出
- 测站位置（在地心惯性系下）
- 航天器方向余弦（测站地平坐标系下）
- 航天器位置（在地心惯性系下）
- 航天器速度（在地心惯性系下）

注意，纬度和海拔数据必须是标量，其余可以是数组
```
preprocessing = orbitDefine.Preprocessing(latitude,timesystem.s/3600*15,altitude,azimuth,elevation,distance,Dazimuth,Delevation,Ddistance)

preprocessing = 

  Preprocessing with properties:

        Glatitude: 0.1024
                s: [30×1 double]
         altitude: 0
          azimuth: [30×1 double]
        elevation: [30×1 double]
         distance: [30×1 double]
         Dazimuth: [30×1 double]
       Delevation: [30×1 double]
        Ddistance: [30×1 double]
       stationPos: [30×3 double]
    spacecraftDir: [30×3 double]
    spacecraftPos: [30×3 double]
    spacecraftVel: [30×3 double]
```

### 3.2根据单组位置和速度定轨
```
orbitDefine.usingSinglePosVel(r0,v0,UTC(1))

ans = 

  usingSinglePosVel with properties:

        a: 9.2000e+06
       e_: [3×1 double]
        e: 0.1200
    Omega: 126.0000
    omega: 36.9999
        i: 96.5000
      tao: 2019-11-27 18:28:09
       f0: 51.1051
       E0: 7.0366
       M0: 6.9545
        h: [3×1 double]
        p: 9.0675e+06
```
### 3.3根据多组位置定轨
```
orbit=orbitDefine.usingMultiPos(preprocessing.spacecraftPos,UTC)

orbit = 

  usingMultiPos with properties:

        a: 8.2099e+06
        e: 0.0491
    Omega: 60.2193
    omega: 134.1086
        i: 54.9040
      tao: 2019-11-27 19:56:00
       f0: 213.2022
       E0: 214.7746
       M0: 216.3779
        p: 8.1901e+06
```
