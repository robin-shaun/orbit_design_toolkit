function [ U ] = fcn_U( kai,alfha )
%普适函数
%输入：普适变量kai，半长轴倒数alfha
if alfha==0
    U0=1;
    U1=kai;
    U2=kai^2/2;
    U3=kai^3/6;
elseif alfha>0
    U0=cos(sqrt(alfha)*kai);
    U1=sin(sqrt(alfha)*kai)/sqrt(alfha);
    U2=(1-cos(sqrt(alfha)*kai))/alfha;
    U3=(sqrt(alfha)*kai-sin(sqrt(alfha)*kai))/(alfha^1.5);
else
    alfha=-alfha;
    U0=cosh(sqrt(alfha)*kai);
    U1=sinh(sqrt(alfha)*kai)/sqrt(alfha);
    U2=(cosh(sqrt(alfha)*kai)-1)/alfha;
    U3=(sinh(sqrt(alfha)*kai)-sqrt(alfha)*kai)/(alfha^1.5);
end
U=[U0 U1 U2 U3];
end