function y=shear(wind1,wind2)%���㴹ֱ���б�,wind1��wind2Ϊ������������һά���飬��һ��������ʾ���٣��ڶ�����ʾ����
%����ֵΪ��ֱ���б䣬����
temp=wind1(1)^2+wind2(1)^2-2*wind1(1)*wind2(1)*cosd(abs(wind1(2)-wind2(2)));
y=sqrt(temp);
end