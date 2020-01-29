%%协调世界时（UTC）转换到国际原子时（TAI）
function TAI = UTC2TAI(UTC)
%最新跳秒需从https://www.iers.org/IERS/EN/DataProducts/EarthOrientationData/eop.html#BulC中获得
%2017年1月1日，leapsecond=37s
leapsecond = 37;
TAI = UTC + leapsecond; 
end