function y=uv2wind(u,v)%函数输出两个结果，y(1)为风速大小，y(2)为风向（0-360°，0°为北风，90°为东风，依次顺时针旋转360°，与气象常用规定同）
%东北风（0，90），东南风（90，180），西南风（180，270），西北风（270，360）
if u==0&&v<0%北风
    y(1)=-v;
    y(2)=0;
elseif u<0&&v<0%东北风
    y(1)=sqrt(u^2+v^2);
    y(2)=90-atand(abs(v/u));
elseif u<0&&v==0%东风
    y(1)=u;
    y(2)=90;
elseif u<0&&v>0%东南风
    y(1)=sqrt(u^2+v^2);
    y(2)=90+atand(abs(v/u));
elseif u==0&&v>0%南风
    y(1)=v;
    y(2)=180;
elseif u>0&&v>0%西南风
    y(1)=sqrt(u^2+v^2);
    y(2)=270-atand(abs(v/u));
elseif u>0&&v==0%西风
    y(1)=u;
    y(2)=270;
elseif u>0&&v<0%西北风
    y(1)=sqrt(u^2+v^2);
    y(2)=270+atand(abs(v/u));
elseif u==0&&v==0
    y(1)=0;
    y(2)=0;
end
end