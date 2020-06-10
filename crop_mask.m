function crop_img2=crop_mask(TissueMask)
%THz
img2_1=TissueMask;
for i1=1:size(img2_1,1)
    img2(size(img2_1,1)-i1+1,:)=img2_1(i1,:);
end
imshow(img2);
imwrite(1-img2,'P_Tissue_Mask.png');        
m=1;
stop=0;
while (m<=size(img2,2) & stop==0)
    if (max(img2(:,m))==1)
        stop=1;
        img2_x1=m;
    end
    m=m+1;
end
n=size(img2,2)-1;
stop=0;
while (n>=1 & stop==0)
    if (max(img2(:,n))==1)
        stop=1;
        img2_x2=n;
    end
    n=n-1;
end
o=1;
stop=0;
while (o<=size(img2,1) & stop==0)
    if (max(img2(o,:))==1)
        stop=1;
        img2_y1=o;
    end
    o=o+1;
end
p=size(img2,1)-1;
stop=0;
while (p>=1 & stop==0)
    if (max(img2(p,:))==1)
        stop=1;
        img2_y2=p;
    end
    p=p-1;
end

crop_img2 = img2(img2_y1:img2_y2,img2_x1:img2_x2);