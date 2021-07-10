function Meshes=delete_from_mesh(images,Meshes)
img_path=images.a;
img_THz=images.b;
img_path_ref=img_path; %Reference when deleting
img_THz_ref=img_THz; %Reference when deleting
x_THz=Meshes.a;
y_THz=Meshes.b;
Mesh_THz=Meshes.c;
x_path=Meshes.d;
y_path=Meshes.e;
Mesh_Path=Meshes.f;
num1=round(size(img_THz,1)*0.005);
num2=round(size(img_path,1)*0.005);
for i=1:size(x_THz,2)
    %Colors the points in the meshes
    z=size(img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1));
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1)=zeros(z);
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,2)=zeros(z);
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,3)=zeros(z);
    z=size(img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1));
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1)=zeros(z);
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,2)=zeros(z);
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,3)=zeros(z);
end
figure(1)
imshow(img_THz);
set(gcf,'position',[0 0 775 1000]);
hold on; triplot(Mesh_THz,x_THz,y_THz,'Color', [0.4 0.4 0.4],'linewidth',3); hold off
figure(2)
imshow(img_path);
set(gcf,'position',[775 0 775 1000]);
hold on; triplot(Mesh_Path,x_path,y_path,'Color', [0.4 0.4 0.4],'linewidth',3); hold off
waitfor(msgbox(sprintf('INSTRUCTIONS:\n1. LEFT CLICK TO DELETE A POINT\n2. WHEN DELETING A CONTROL POINT FROM ONE IMAGE, THE PAIR CONTROL POINT IN THE OTHER IMAGE WILL BE REMOVED AS WELL\nYOU CAN ONLY DELETE ONE POINT AT A TIME')))
del='YES';
if (size(x_THz,2)<=3)
    waitfor(msgbox(sprintf('YOU HAVE REACH THE MINIMUM NUMBER OF POINTS REQUIRED TO FORM A TRIANGULATION')));
    del='NO';
end
while strcmp(del,'YES')
    figure(1)
    imshow(img_THz);
    set(gcf,'position',[0 0 775 1000]);
    figure(2)
    imshow(img_path);
    set(gcf,'position',[775 0 775 1000]);
    fig='';
    while isempty(fig)
        fig = questdlg('FROM WHICH PICTURE DO YOU NEED TO DELETE A CONTROL POINT?', ...
            'DELETE CONTROL POINTS', ...
            'THZ IMAGE','PATHOLOGY IMAGE','PATHOLOGY IMAGE');
    end
    if (strcmp(fig,'THZ IMAGE'))
        drawnow;
        figure(1)
        [a,b]=ginput(1);
        x=round(a);
        y=round(b);
        d = pdist([x,y;x_THz',y_THz'],'euclidean');
        i=find(d==min(d(1:size(x_THz,2))));
    else
        drawnow;
        figure(2)
        [a,b]=ginput(1);
        x=round(a);
        y=round(b);
        d = pdist([x,y;x_path',y_path'],'euclidean');
        i=find(d==min(d(1:size(x_path,2))));
    end
    i=round(i);
    %De-colors the selected point
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1)=img_THz_ref(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1);
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,2)=img_THz_ref(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,2);
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,3)=img_THz_ref(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,3);
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1)=img_path_ref(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1);
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,2)=img_path_ref(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,2);
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,3)=img_path_ref(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,3);
    x_THz(i)=[];
    y_THz(i)=[];
    x_path(i)=[];
    y_path(i)=[];
    figure(1)
    imshow(img_THz);
    set(gcf,'position',[0 0 775 1000]);
    Mesh_THz = delaunayTriangulation(x_THz',y_THz');
    Mesh_THz = Mesh_THz(:,:);
    hold on, triplot(Mesh_THz,x_THz,y_THz,'Color', [0.4 0.4 0.4],'linewidth',3), hold off
    figure(2)
    imshow(img_path);
    set(gcf,'position',[775 0 775 1000]);
    Mesh_Path = Mesh_THz(:,:);
    hold on, triplot(Mesh_Path,x_path,y_path,'Color', [0.4 0.4 0.4],'linewidth',3), hold off
    if (size(x_THz,2)>3)
        pol_tot = polyshape(x_path(Mesh_Path(1,:)),y_path(Mesh_Path(1,:)));
        i = 2;
        int_ind = 0;
        while i <= size(Mesh_Path,1)
            pol_add = polyshape(x_path(Mesh_Path(i,:)),y_path(Mesh_Path(i,:)));
            int = intersect(pol_tot,pol_add);
            if int.NumRegions == 0
                pol_tot = union(pol_tot,pol_add);
                i = i + 1;
            else
                int_ind = 1;
                break;
            end
        end
        if int_ind == 1
            waitfor(msgbox('MESH OVERLAP'));
        end
        del='';
        while isempty(del)
            del = questdlg('KEEP DELETING?', ...
                'DELETE CONTROL POINTS', ...
                'YES','NO','NO');
        end
    else
        waitfor(msgbox(sprintf('YOU HAVE REACH THE MINIMUM NUMBER OF POINTS REQUIRED TO FORM A TRIANGULATION')));
        del='NO';
    end
end
%save and return structure
Meshes=struct;
Meshes.a=x_THz;
Meshes.b=y_THz;
Meshes.c=Mesh_THz;
Meshes.d=x_path;
Meshes.e=y_path;
Meshes.f=Mesh_Path;
end
