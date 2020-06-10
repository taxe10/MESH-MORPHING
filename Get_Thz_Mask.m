close all
clear
clc
load('Mouse5B_Fresh.mat')   %Change to Mouse5B_Block.mat for block data
data=max(ScanData,[],3).*TissueMask;
data(data == 0) = NaN;
figure(1)
pcolor(data);
shading interp;
colormap jet
% caxis([0,0.6])              %Use this line if you need to change the
                            %color intensity of the image 
set(gca,'visible','off')
set(gca,'Units','pixels','Position',...
    [0 0 2*size(TissueMask,2) 2*size(TissueMask,1)])
set(gcf,'Units','pixels','Position',...
    [0 0 2*size(TissueMask,2) 2*size(TissueMask,1)])
print('Temp_fig_DO_NOT_USE','-dpng')
im1=imread('Temp_fig_DO_NOT_USE.png');
im1=imresize(im1,[size(TissueMask,1) size(TissueMask,2)]);
[filename,path] = uiputfile('*.png','SAVE THZ IMAGE AS:',path);
Name=strcat(path,filename);
imwrite(im1,Name)
delete('Temp_fig_DO_NOT_USE.png')
close all
