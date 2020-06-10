function show_images(img_path,img_THz)
SS = get(0,'screensize');
SS(3) = round(SS(3)*0.48);
SS(4) = round(SS(4)*0.89);
figure(2)
imshow(img_path);
set(gcf,'position',[SS(4) 45 SS(4) SS(3)]);
figure(1)
imshow(img_THz);
set(gcf,'position',[0 45 SS(4) SS(3)]);
end
