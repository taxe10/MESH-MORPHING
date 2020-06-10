[Path_img_name,path_Path] = uigetfile('*.png','SELECT THE PATHOLOGY IMAGE');
Path_img_name=strcat(path_Path,Path_img_name);
if isempty(Path_img_name)
    return
end
[THz_img_name,path_THz] = uigetfile('*.mat','SELECT THE TERAHERTZ MASK',path_Path);
THz_img_name=strcat(path_THz,THz_img_name);
if isempty(THz_img_name)
    return
end
load(THz_img_name)
% TissueMask = TissueMask_new;
img = imread(Path_img_name);
crop_img2=crop_mask(TissueMask);
%img = flipdim(img ,2); %flip image if necessary
for k=1:359
    rotated_img = imrotate(img,k,'bilinear','loose');
    for i=1:size(rotated_img,1)
        for j=1:size(rotated_img,2)
            if(rotated_img(i,j,1)<255 && rotated_img(i,j,2)<255 && rotated_img(i,j,3)<255)
                rotated_img(i,j,1)=255;
                rotated_img(i,j,2)=255;
                rotated_img(i,j,3)=255;
            end
        end
    end
    crop_img1=crop_path(rotated_img);    
    corrected_img1 = imresize(crop_img1,[size(crop_img2,1) size(crop_img2,2)]);
    img1_1=im2bw(corrected_img1,0.5);
    for i=1:size(img1_1,1)
        for j=1:size(img1_1,2)
            if(img1_1(i,j)==1)
                img1(i,j)=0;
            else
                img1(i,j)=1;
            end
        end
    end
%     imshow(img1);
    c = normxcorr2(1-img1(:,:),1-crop_img2(:,:));
    maxcorr(k)= max(c(:));
end
angle=find(maxcorr==max(maxcorr));
rotated_img = imrotate(img,angle,'bilinear','loose');
imshow(rotated_img);
[filename,path] = uiputfile('*.png','SAVE MORPHED PATHOLOGY AS:');
path1=strcat(path,filename);
imwrite(rotated_img,path1);