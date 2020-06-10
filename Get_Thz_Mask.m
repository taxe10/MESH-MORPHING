figure(1)
%TissueMask = TissueMask_new;
%data=max(ScanData,[],3).*TissueMask;
data=IntegratedData.*TissueMask;
data(data == 0) = NaN;
pcolor(data);
shading interp;
colormap jet
caxis([0,0.6])
%caxis([0.18,0.24])
set(gca,'visible','off')
set(gca,'Units','pixels','Position',[0 0 2*size(TissueMask,2) 2*size(TissueMask,1)])
set(gcf,'Units','pixels','Position',[0 0 2*size(TissueMask,2) 2*size(TissueMask,1)])
print('Figure1','-dpng')
im1=imread('Figure1.png');
im1=imresize(im1,[size(TissueMask,1) size(TissueMask,2)]);
[filename,path] = uiputfile('*.png','SAVE MORPHED PATHOLOGY AS:',path);
Name=strcat(path,filename);
imwrite(im1,Name)