function crop_img1=crop_path(img1)
%PATH
i=1;
stop=0;
while (i<=size(img1,2) & stop==0)
    if (min(img1(:,i,1))<255 || min(img1(:,i,3))<255)
        stop=1;
        img1_x1=i;
    end
    i=i+1;
end
j=size(img1,2)-1;
stop=0;
while (j>=1 & stop==0)
    if (min(img1(:,j,1))<255 || min(img1(:,j,3))<255)
        stop=1;
        img1_x2=j;
    end
    j=j-1;
end
k=1;
stop=0;
while (k<=size(img1,1) & stop==0)
    if (min(img1(k,:,1))<255 || min(img1(k,:,3))<255)
        stop=1;
        img1_y1=k;
    end
    k=k+1;
end
l=size(img1,1)-1;
stop=0;
while (l>=1 & stop==0)
    if (min(img1(l,:,1))<255 || min(img1(l,:,3))<255)
        stop=1;
        img1_y2=l;
    end
    l=l-1;
end
crop_img1 = imcrop(img1,[img1_x1 img1_y1 img1_x2-img1_x1 img1_y2-img1_y1]);