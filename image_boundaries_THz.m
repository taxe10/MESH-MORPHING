function R=image_boundaries_THz(img,x,y)
i=1;
y_upper_limit=-1;
while (i<=size(img,1) && y_upper_limit==-1)
    if(mean(img(i,:))~=255)
        y_upper_limit=i;
    end
    i=i+1;
end
j=size(img,1);
y_bottom_limit=-1;
while (j>0 && y_bottom_limit==-1)
    if(mean(img(j,:))~=255)
        y_bottom_limit=j;
    end
    j=j-1;
end
i=1;
x_left_limit=-1;
while (i<=size(img,2) && x_left_limit==-1)
    if(mean(img(:,i))~=255)
        x_left_limit=i;
    end
    i=i+1;
end
j=size(img,2);
x_right_limit=-1;
while (j>0 && x_right_limit==-1)
    if(mean(img(:,j))~=255)
        x_right_limit=j;
    end
    j=j-1;
end
x=[x,x_left_limit,x_left_limit,x_right_limit,x_right_limit];
y=[y,y_upper_limit,y_bottom_limit,y_bottom_limit,y_upper_limit];
R=[x;y];
end