function y=shear(wind1,wind2)%计算垂直风切变,wind1、wind2为含两个变量的一维数组，第一个变量表示风速，第二个表示风向
%返回值为垂直风切变，标量
temp=wind1(1)^2+wind2(1)^2-2*wind1(1)*wind2(1)*cosd(abs(wind1(2)-wind2(2)));
y=sqrt(temp);
end