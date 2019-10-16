        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                    RFID���ݲ���ƽ̨                         %
        %ͼ�񱣴桢�رա�������ʾ�������뾶���á������������꼰��������     %                                                        
        %                      �汾V1.0                                 %
        %                    2013��12��9��                              %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
        
function picprocess()
%% ������ʾ�Ĵ��ڣ����ƶ�����Ļ�м�
clc;
clear;
hFigure = figure('Visible','on','Position',[0 0 600 500],'Resize','off',...
    'DockControls','off','Menubar','none','Name','���ݲ�����',...
    'NumberTitle', 'off','WindowButtonDownFcn',@btnDown,...
   'WindowButtonUpFcn',@btnUp,'CloseRequestFcn', @closeQuest);
movegui(hFigure,'center');
%% ������ʾ�������ᣬ������ʾͼƬ�ͻ�������
hAxes = axes('Visible','on','Position',[0.12 0.22 0.7 0.7],'Drawmode','fast');
axis([0 100 0 100]);

%%�洢Ĭ�ϵĲ����뾶
setappdata(hFigure,'R_Width',50);
axes_1 = {'RFID','x','y'};
setappdata(hFigure,'axes_1',axes_1);
%% �洢���귶Χ�������ж�����Ƿ���ͼƬ��
setappdata(hFigure,'xLim',get(hAxes,'xLim'));
setappdata(hFigure,'yLim',get(hAxes,'yLim'));
%% ����uicontrol����
set(0,'DefaultUicontrolFontSize',13);  % ����uicontrol�ռ��Ĭ�������С
uicontrol('String','��ʼ','Position',[70 25 80 40],'Callback',@reader);  
% ��ʼ��������
uicontrol('String','���ð뾶','Position',[510 185 80 40],'Callback',@Range);
%���ò����뾶��ȷ����Χ
uicontrol('String','ʹ��˵��','Position',[510 250 80 40],'Callback',@Instructions);
%ʹ��˵��
uicontrol('String','����ͼ��','Position',[330 25 80 40],'Callback',{@savePic,hAxes});
%�������ݲ�����ͼ��
uicontrol('String','������ʾ','Position',[200 25 80 40],'Callback',@get_data_xls);
%��ʾ����������
uicontrol('String','���ñ�ע','Position',[510 120 80 40],'Callback',@change_tittle);
%��������
uicontrol('String','�˳�','Position',[460 25 80 40],'Callback','close(gcbf)');
%�رմ���
%%����x,y��UI�ؼ�
set(0,'DefaultuicontrolBackgroundColor',get(hFigure,'color'));
uicontrol('Style','text','string','x����','fontsize',16,'Position',[515 430 60 32]);

uicontrol('Style','text','string','y����','fontsize',16,'Position',[515 345 60 32]);

%% ��ʾ����
set(hFigure,'Visible','on');

end




function Range(~,~)
prompt='���ò����뾶��';
name='�뾶����';
answer=inputdlg(prompt,name);

if ~isempty(answer)%�򵥻��ˡ�OK����ť�����²����뾶
R_Width = floor(str2double(answer));%��ȡ�û�����뾶ֵ����ȡ��
    if ~isnan(R_Width)&&R_Width>0&&R_Width<5000
        setappdata(gcf,'R_Width',R_Width);%���°뾶
    end
end
end




function reader(~,~)
cla;
axes_1 =getappdata(gcf,'axes_1');
title(axes_1{1},'Fontname','Times New Roman');
xlabel(axes_1{2},'Fontname','Times New Roman');
ylabel(axes_1{3},'Fontname','Times New Roman');
set(get(gca,'xlabel'),'fontsize',13);
set(get(gca,'ylabel'),'fontsize',13);
set(get(gca,'title'),'fontsize',13);
delete data.xls;          %���excel����
delete truedata.xls;
delete RFIDdata.xls;
n = 0;
R_Width = getappdata(gcf,'R_Width');  %��ȡ�뾶��С
reader = 1;
while reader == 1
    axis([0 100 0 100]);
    title(axes_1{1},'Fontname','Times New Roman');
    xlabel(axes_1{2},'Fontname','Times New Roman');
    ylabel(axes_1{3},'Fontname','Times New Roman');
    set(get(gca,'xlabel'),'fontsize',13);
    set(get(gca,'ylabel'),'fontsize',13);
    set(get(gca,'title'),'fontsize',13);
    [rxi,ryi,reader] = ginput(1);
    plot(rxi,ryi,'kx')
    hold on;
    n = n+1;
    readerxy(:,n) = [rxi;ryi];
    text(rxi,ryi,'');
    uicontrol('style','edit','enable','inactive','BackgroundColor',...
    'w','horizontal','right','position',[510 390 70 35],'string',...
    num2str(readerxy(1,n),6));
    uicontrol('style','edit','enable','inactive','BackgroundColor',...
    'w','horizontal','right','position',[510 305 70 35],'string',...
    num2str(readerxy(2,n),6));
    xlswrite('data.xls',readerxy);
        
        
end


X1 = [0:1:100];
X2 = [0:1:100];
[X,Y] = meshgrid(X1,X2);

 Z = zeros(size(X));

readerlocation=readerxy;%% RFID Readerde λ��
readermc=R_Width.*ones(size(readerxy(1,:)));%%%�趨������Χ

for i=1:length(readermc)
    
 Z = Z+exp(-((X-readerlocation(1,i)).*(X-readerlocation(1,i))+...
     (Y-readerlocation(2,i)).*(Y-readerlocation(2,i)))/readermc(i));

end
[c,h]=contourf(X,Y,Z);
ch=get(h,'children');
% set(min(ch),'FaceColor','w','FaceAlpha',0.1)
%%%%%%%%%%����Ŀ�����ʵ�켣
n=0;
but = 1;
while but == 1
    [xi,yi,but] = ginput(1);
    plot(xi,yi,'ro')
    n = n+1;
    xy(:,n) = [xi;yi];
    uicontrol('style','edit','enable','inactive','BackgroundColor',...
      'w','horizontal','right','position',[510 390 70 35],'string',...
       num2str(xy(1,n),6));
    uicontrol('style','edit','enable','inactive','BackgroundColor',...
       'w','horizontal','right','position',[510 305 70 35],'string',...
    num2str(xy(2,n),6));
    xlswrite('truedata.xls',xy);
end
% Interpolate with a spline curve and finer spacing.
t=1:n;
tss = 1: 0.1: n;
xyss = spline(t,xy,tss);
plot(xyss(1,:),xyss(2,:),'--');
hold on
%%%%%%%����ʵ�켣�ϼ����������
%%%%%�õ���������
ap=4;r=3;
for i=1:length(readerxy(1,:))
    for j=1:length(xyss(1,:))
   d(i,j)=sqrt((xyss(:,j)-readerxy(:,i))'*(xyss(:,j)-readerxy(:,i))); 
   if rand(1)>exp(-d(i,j).^2/2/15/15);%%% �����϶��ܲ�����Ŀ�굽���е��Ķ����ľ��룬
       d(i,j)=NaN;                    %%%%% ����Щû�б�������
   end
   dmm(i,j)= d(i,j)+randn(1)*(0.2303*ap/r)*d(i,j);
  
    end
end

ts=[];dm=[];xys=[];
for ii=1:length(tss);
    for jj=1:length(dmm(:,1));
        if isnan(dmm(jj,ii))
            
        else
            ts=[ts tss(ii)];
            dm=[dm dmm(:,ii)];
            xys=[xys xyss(:,ii)];
         
            break
        end
    end
end

plot(xys(1,:),xys(2,:),'k*');
xlswrite('RFIDdata.xls',xys);
 %for m=1:length(xys(1,:))
  %   for n=1:length(xys(:,1))
         
end
    
     
function btnUp(hObject,~)
%���ڵ�WindowButtonUpFcn�ص�����
% % ����ͷ�ʱ�����±�ʶ����ispressed��ֵΪfalse
setappdata(hObject,'isPressed',false);
end

function Instructions(~,~)
f = figure('Color',[0.8,0.8,0.8],'Position',[960 350 385 330],...
    'NumberTitle','off','Name','���ݷ�������ʹ��˵��');
set(f,'Toolbar','none','Menubar','none');
axis off;
text('string','1.���������ñ�ע����ť��������������ͱ��⣻',...
    'fontsize',13,'position',[-0.15 1]);
text('string','2.���������ð뾶����ť�������ò�����Χ��',...
    'fontsize',13,'position',[-0.15 0.89]);
text('string','3.��������ʼ����ť���Բɼ����ݣ����У������',...
    'fontsize',13,'position',[-0.15 0.78]);
text('string','�����ݣ��Ҽ�ֹͣ�ɼ����������������Ŀ���',...
    'fontsize',13,'position',[-0.15 0.67]);
text('string','�ƶ��켣��ֵ���Ҽ�������','fontsize',13,'position',...
    [-0.15 0.56]);
text('string','4.��������ʾ���ݡ�������ʾ����Ĳɼ�����ʱ��',...
    'fontsize',13,'position',[-0.15 0.45]);
text('string','����ֵ��','fontsize',13,'position',[-0.15 0.34]);
text('string','5.���������桱ͼ�������.JPG��.BPM��ʽ����',...
    'fontsize',13,'position',[-0.15 0.23]);
text('string','ͼ��', 'fontsize',13,'position',[-0.15 0.12]);
text('string','6.�������رա���ť��ر����ݲ���ƽ̨������գ�',...
    'fontsize',13,'position',[-0.15 0.01]);

end

function savePic(~,~,hAxes)
%���水ť�Ļص�����
% % �����Ƚ�����Ի��򣬻�ȡ�����ͼƬ·�����ļ���
[fName,pName,index] = uiputfile({'*.jpg';'*.bmp'},'ͼƬ���Ϊ');
if index == 1||index==2 %�������ļ�����ΪJPG��BMP
    % % ����һ�����صĴ��ڣ��������Ḵ�ƽ�ȥ��������ΪͼƬ
    hFig=figure('Visible','off');%����һ�����ش���
    copyobj(hAxes,hFig); %�������ἰ���Ӷ����Ƶ��´�����
    str = [pName fName];%��ȡҪ�����ͼƬ·�����ļ���
    if index ==1
        print(hFig,'-djpeg',str);%����ΪJPGͼƬ
    else
        print(hFig,'-dbmp',str);%����ΪbmpͼƬ
    end
    delete(hFig); %ɾ�����������ش���
    % %����һ����Ϣ�Ի�����ʾ�ļ�����ɹ�
   hMsg = msgbox(['ͼƬ����ɹ�!'],'��ʾ');
    % % 1��������Ϣ�Ի���û�йرգ��Զ��ر�
    pause(1);
    if ishandle(hMsg)  %��Ϣ�Ի���û���ֶ��ر�
        delete(hMsg);%�Զ��ر���Ϣ�Ի���
    end
end
end

function change_tittle(~,~)    
cla;
prompt={'���ñ������ƣ�','���ú��������ƣ�','�������������ƣ�'};
name='���ñ�ע';
numlines=1;
defaultanswer={'RFID','x','y'};             %����Ĭ��x,y,��������
answer1=inputdlg(prompt,name,numlines,defaultanswer);


if ~isempty(answer1)%�򵥻��ˡ�OK����ť�����²����뾶
        title(answer1{1},'Fontname','Times New Roman');
        xlabel(answer1{2},'Fontname','Times New Roman');
        ylabel(answer1{3},'Fontname','Times New Roman');
        set(get(gca,'xlabel'),'fontsize',13);
        set(get(gca,'ylabel'),'fontsize',13);
        set(get(gca,'title'),'fontsize',13);
        axes_1= answer1;
        setappdata(gcf,'axes_1',axes_1);
end
end

function btnDown(hObject,~)
%���ڵ�WindowButtonDownFcn�ص�����
%Ӧ������isPressed������������Ƿ���
%�������ͼƬ�ϰ��£���ʼ��������
% % ��ȡ�����᷶Χ�͵�ǰ�����꣬�ж���굱ǰ�Ƿ���ͼƬ��
xLim = getappdata(hObject,'xLim');
yLim = getappdata(hObject,'yLim');
pos = get(gca,'CurrentPoint');
if(pos(1,1)>xLim(1))&&(pos(1,1)<xLim(2))&&(pos(1,2)>yLim(1))...
    &&(pos(1,2)<yLim(2))%�������ͼƬ��
    set(hObject,'Pointer','hand');%������Ϊ����
  
else
    set(hObject,'Pointer','arrow');%������ΪĬ��ֵ
     % % ��ȡ��굱ǰ�����꣬����ί�û�����
    

end
end


function get_data_xls(~,~)

f = figure('Color',[0.8,0.8,0.8],'Position',[300 300 500 405],...
    'NumberTitle','off','Name','data');
set(0,'DefaultuicontrolBackgroundColor',get(f,'color'));
uicontrol('Style','text','string','����������','fontsize',13,...
    'Position',[38 375 100 25]);
uicontrol('Style','text','string','�����켣��ʼֵ','fontsize',13,....
    'Position',[38 258 150 25]);
uicontrol('Style','text','string','RFID����������','fontsize',13,....
    'Position',[38 141 150 25]);
[~,~,raw] = xlsread('data.xls'); %��ȡExcel�ļ���������Ϊ~��ʾ����ʹ�øñ���
 ColumnName = raw(1,:);          %��ȡ����
 data= raw(1:end,:);             %��ȡ�������
for i = 1:numel(data)            %������������������NAN���滻Ϊ�ո��ַ�
    if isnan(data{i})
        data{i} ='';
    end
end

rnames = {'X','Y'};
uitable('Parent',f,'Data',data,'RowName',rnames,'Position',...
    [40 288 430 85],'Fontsize',10);  %�������

%  truedata   %

[~,~,raw] = xlsread('truedata.xls'); %��ȡExcel�ļ���������Ϊ~��ʾ����ʹ�øñ���
ColumnName = raw(1,:);           %��ȡ����
data1 = raw(1:end,:);             %��ȡ�������
for i = 1:numel(data1)            %������������������NAN���滻Ϊ�ո��ַ�
    if isnan(data1{i})
        data1{i} ='';
    end
end

rnames1 = {'X','Y'};
uitable('Parent',f,'Data',data1,'RowName',rnames1,'Position',...
    [40 171 430 85],'Fontsize',10);  %�������

% RFIDdata %
[~,~,raw] = xlsread('RFIDdata.xls'); %��ȡExcel�ļ���������Ϊ~��ʾ����ʹ�øñ���
 ColumnName = raw(1,:);          %��ȡ����
 data2= raw(1:end,:);             %��ȡ�������
for i = 1:numel(data2)            %������������������NAN���滻Ϊ�ո��ַ�
    if isnan(data2{i})
        data2{i} ='0';
    end
end

rnames = {'X','Y','X','Y','X','Y','X','Y','X','Y',};
uitable('Parent',f,'Data',data2,'RowName',rnames,'Position',...
    [40 14 430 125],'Fontsize',10);  %�������
end





function closeQuest(hObject,~)
%% ����һ�����ʶԻ��򣬽�һ��ȷ���Ƿ�Ҫ�رմ���
sel = questdlg('ȷ���˳���ǰ���ڣ�','�˳�ȷ��','Yes','No','No');
 switch sel
    case'Yes'  %�û������ˡ�Yes����ť
        delete(hObject);
   case'No'  %�û������ˡ�No����ť
      return;
 end
 clear all;
 close all;
 clc;
end

