function C = station2inertial(s,B)
% 测站地平坐标系到地心惯性坐标系的转换,输入单位为deg
s = s/180*pi;
B = B/180*pi;
C=[-sin(s),-cos(s)*sin(B),cos(s)*cos(B);cos(s),-sin(s)*sin(B),sin(s)*cos(B);0,cos(B),sin(B)];
end