function img_warp = image_warping(img,H,px_in,py_in,px_out,py_out)
img1=im2double(img);
img_warp=zeros(size(img));
for i=1:size(img,1)
    for j=1:size(img,2)
        if (inpolygon(i,j,px_in,py_in)==1)
            v1 = [i;j;1];
            v2 = H*v1;
            v3 = v2/v2(3,1);
            if (round(v3(1,1))==0 || round(v3(2,1))==0)
                continue;
            else
                if (inpolygon(round(v3(1,1)),round(v3(2,1)),px_out,py_out)==1)
                    img_warp(round(v3(1,1)),round(v3(2,1)),:)=img1(i,j,:);
                end
            end
        else
            continue;
        end
    end
end
end