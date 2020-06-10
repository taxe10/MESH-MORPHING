function show_images(img_path,img_THz)
figure(2)
imshow(img_path);
set(gcf,'position',[775 0 775 1000]);
figure(1)
imshow(img_THz);
set(gcf,'position',[0 0 775 1000]);
end