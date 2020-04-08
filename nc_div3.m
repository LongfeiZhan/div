clc
clear
%绘制散度图
path1='C:\Users\lj\Desktop\div\20200406\';
path2='c:\data\ArcgisData\China_basic_map\';
run('C:\Program Files\MATLAB R2017a\toolbox\nctoolbox-1.1.3\setup_nctoolbox.m')
filename1=[path1 'uwnd.mon.1981-2010.ltm.nc'];%uwnd.mon.1981-2010.ltm
filename2=[path1 'vwnd.mon.1981-2010.ltm.nc'];
ncid1= netcdf.open(filename1,'NOWRITE');
info=ncinfo(filename1);
lat=ncread(filename1,'lat');%-90:2.5:90°N,73
lon=ncread(filename1,'lon');%0:2.5:357.5;144
level=ncread(filename1,'level');%17,10-200hPa
for ii=1:12%循环月份
    u=ncread(filename1,'uwnd',[41,4,10,ii],[82,34,1,1],[1,1,1,1]);
    v=ncread(filename2,'vwnd',[41,4,10,ii],[82,34,1,1],[1,1,1,1]);
    u1=reshape(u(:,:,1,1),82,34)';
    u1=flip(u1);
    v1=reshape(v(:,:,1,1),82,34)';
    v1=flip(v1);
    [lon1,lat1]=meshgrid([100:2.5:300],[0:2.5:80]);
    r=6371.393*1.e03;
    pi=3.1415926;
    div=zeros(33,81);
    for i=1:33
        for j=1:81
            du=u1(i,j+1)-u1(i,j);
            dv=v1(i+1,j)-v1(i,j);
            da=2.5;%角度分辨率
            dx=r*cosd(lat1(i))*da/180*pi;
            dy=r*da/180*pi;
            div(i,j)=du/dx+dv/dy;
        end
    end
    figure(1)
    % set(gcf,'Position',[100 250 350 300],'color','w');
    set(gcf,'Position',[100 100 550 450],'color','w');
    set(gca,'Position',[.13 .1 0.73 .81]);
    hold on
    contourf(lon1,lat1,div*10^5)%,[-14:2:14],'LineColor','k','ShowText','on','TextList',[-14:2:14]);
    colormap(jet)
    % h=colorbar('ytick',[-14:2:14],'FontName','Times New Roman','fontsize',8,'location','EastOutside','box','on');%'yticklabel',,{'-14','-12','-10','-8','-6','-4','-2','0','2','4','6','8','10','12','14'}
    % caxis([-15 15])
    h=colorbar('position',[0.88 0.1 0.03 0.81]);
    hold on
    %绘制世界地图
    map_path = shaperead([path2 'cntry02.shp']);
    map_X = [map_path(:).X];   % read x of the contour of province
    map_Y = [map_path(:).Y];   % read y of the contour of province
    plot(map_X,map_Y,'Linestyle','-','linewidth',0.5,'color',[.5 .5 .5]) % draw political line[.5 .5 .5]
    hold on
    %绘制风场
    hold on
    quiver(lon1,lat1,u1([1:33],[1:81])/5,v1([1:33],[1:81])/5,'Linewidth',0.5,'MaxHeadSize',0.05,'AutoScaleFactor',1,'AutoScale','off','color','k')
    set(gca,'xlim',[100 300],'XTick',100:20:300,'XTickLabel',strcat(num2str((100:20:300)'),'°E'),'xminortick','off');%['106°E';'108°E';'110°E';'112°E';'114°E';'116°E';'118°E']set(gca,'XTick',105:1:110.5,'XTickLabel',strcat(num2str((105:1:111)'),'°E'))
    set(gca,'ylim',[0 80],'yTick',0:10:80,'yTickLabel',strcat(num2str((0:10:80)'),'°N'),'yminortick','off');%['22°N';'24°N';'26°N';'28°N';'30°N';'32°N';'34°N']
    set(gca,'FontSize',8,'ticklength',[0.015,04],'tickdir','out','box','on');%刻度线长度设置,刻度朝外,半框
    title([ '200hPa divergence/10^{-5}s^{-1}'],'FontName','Times New Roman','fontsize',10)
    hold on
    print( 1, '-dpng', '-r600',['C:\Users\lj\Desktop\div\pic\'  num2str(ii) '月_200hPa_div.png'])
    saveas(1,['C:\Users\lj\Desktop\div\pic\' num2str(ii) '月_200hPa_div.fig'])
    close(1)
end