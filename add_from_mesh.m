function Meshes=add_from_mesh(images,Meshes)
SS = get(0,'screensize');
SS(3) = round(SS(3)*0.48);
SS(4) = round(SS(4)*0.89);
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
set(gcf,'position',[0 45 SS(4) SS(3)]);
hold on; triplot(Mesh_THz,x_THz,y_THz,'Color', [0.4 0.4 0.4],'linewidth',3); hold off
figure(2)
imshow(img_path);
set(gcf,'position',[SS(4) 45 SS(4) SS(3)]);
hold on; triplot(Mesh_Path,x_path,y_path,'Color', [0.4 0.4 0.4],'linewidth',3); hold off
waitfor(msgbox(sprintf('INSTRUCTIONS:\n1. LEFT CLICK TO ADD A POINT IN THE THZ IMAGE\n2. LEFT CLICK TO ADD A POINT IN THE PATHOLOGY IMAGE\nPLEASE CONSIDER THAT YOU CAN ONLY ADD ONE POINT AT A TIME')))
add='YES';
while strcmp(add,'YES')
    i=size(x_THz,2)+1;
    figure(2)
    imshow(img_path);
    set(gcf,'position',[SS(4) 45 SS(4) SS(3)]);
    figure(1)
    imshow(img_THz);
    set(gcf,'position',[0 45 SS(4) SS(3)]);
    drawnow
    figure(1)
    [a,b]=ginput(1);
    x_THz(i)=round(a);
    y_THz(i)=round(b);
    %Colors the selected point
    z=size(img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1));
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1)=zeros(z);
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,2)=zeros(z);
    img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,3)=zeros(z);
    imshow(img_THz);
    %Position the window
    set(gcf,'position',[0 45 SS(4) SS(3)]);
    drawnow;
    figure(2)
    [a,b]=ginput(1);
    x_path(i)=round(a);
    y_path(i)=round(b);
    %Colors the selected point
    z=size(img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1));
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1)=zeros(z);
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,2)=zeros(z);
    img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,3)=zeros(z);
    imshow(img_path);
    %Position the window
    set(gcf,'position',[SS(4) 45 SS(4) SS(3)]);
    %Show current mesh
    figure(1)
    imshow(img_THz);
    set(gcf,'position',[0 45 SS(4) SS(3)]);
    Mesh_THz = delaunayTriangulation(x_THz',y_THz');
    Mesh_THz = Mesh_THz(:,:);
    hold on, triplot(Mesh_THz,x_THz,y_THz,'Color', [0.4 0.4 0.4],'linewidth',3), hold off
    figure(2)
    imshow(img_path);
    set(gcf,'position',[SS(4) 45 SS(4) SS(3)]);
    Mesh_Path = Mesh_THz(:,:);
    hold on, triplot(Mesh_Path,x_path,y_path,'Color', [0.4 0.4 0.4],'linewidth',3), hold off
    add='';
    while isempty(add)
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
        add = questdlg('KEEP ADDING?', ...
            'ADD CONTROL POINTS', ...
            'YES','NO','NO');
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
