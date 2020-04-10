clc
clear
%绘制0-6km垂直风切变，用1000hPa近似地面，用500hPa近似6km
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
    u=ncread(filename1,'uwnd',[41,4,1,ii],[81,33,1,1],[1,1,1,1]);%1000hPa
    v=ncread(filename2,'vwnd',[41,4,1,ii],[81,33,1,1],[1,1,1,1]);
    u1=reshape(u(:,:,1,1),81,33)';
    u1=flip(u1);
    v1=reshape(v(:,:,1,1),81,33)';
    v1=flip(v1);
    u=ncread(filename1,'uwnd',[41,4,6,ii],[81,33,1,1],[1,1,1,1]);%500hPa
    v=ncread(filename2,'vwnd',[41,4,6,ii],[81,33,1,1],[1,1,1,1]);
    u2=reshape(u(:,:,1,1),81,33)';
    u2=flip(u2);
    v2=reshape(v(:,:,1,1),81,33)';
    v2=flip(v2);
    shear1=zeros(33,81);
    [lon1,lat1]=meshgrid([100:2.5:300],[0:2.5:80]);
    for i=1:33
        for j=1:81
            y1=uv2wind(u1(i,j),v1(i,j));
            %计算0-1km垂直风切边
            y2=uv2wind(u2(i,j),v2(i,j));%调用函数，计算风速风向
            shear1(i,j)=shear(y1,y2);%调用函数，计算垂直风切边
        end
    end
    figure(1)
    % set(gcf,'Position',[100 250 350 300],'color','w');
    set(gcf,'Position',[100 100 550 450],'color','w');
    set(gca,'Position',[.13 .1 0.73 .81]);
    hold on
    contourf(lon1,lat1,shear1)%,[-14:2:14],'LineColor','k','ShowText','on','TextList',[-14:2:14]);
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
    [cs1,h1]=contour(lon1,lat1,shear1);%[-40:10:100]
    set(h1,'linecolor','k','linewidth',0.5,'ShowText','on')%,'TextStep',get(h,'LevelStep')*2,'TextList',[-40:20:100]
    clabel(cs1,h1,'labelspacing',150,'FontName','Times New Roman','fontsize',8,'color','k','rotation',0)
    hold on
    set(gca,'xlim',[100 300],'XTick',100:20:300,'XTickLabel',strcat(num2str((100:20:300)'),'°E'),'xminortick','off');%['106°E';'108°E';'110°E';'112°E';'114°E';'116°E';'118°E']set(gca,'XTick',105:1:110.5,'XTickLabel',strcat(num2str((105:1:111)'),'°E'))
    set(gca,'ylim',[0 80],'yTick',0:10:80,'yTickLabel',strcat(num2str((0:10:80)'),'°N'),'yminortick','off');%['22°N';'24°N';'26°N';'28°N';'30°N';'32°N';'34°N']
    set(gca,'FontSize',8,'ticklength',[0.015,04],'tickdir','out','box','on');%刻度线长度设置,刻度朝外,半框
    title([ '1000-500hPa Vertical Wind Shear/m\cdots^{s}'],'FontName','Times New Roman','fontsize',10)
    hold on
    print( 1, '-dpng', '-r600',['C:\Users\lj\Desktop\div\pic\'  num2str(ii) '月_Vertical_Wind_Shear.png'])
    saveas(1,['C:\Users\lj\Desktop\div\pic\' num2str(ii) '月_Vertical_Wind_Shear.fig'])
    close(1)
end
