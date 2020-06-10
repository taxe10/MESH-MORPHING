function Meshes=create_mesh(images)
img_path=images.a;
img_THz=images.b;
waitfor(msgbox(sprintf('INSTRUCTIONS:\n1. LEFT CLICK TO SELECT A POINT\n2. RIGHT CLICK TO DELETE THE LAST POINT\n3. PRESS ENTER TO FINISH\nPLEASE CONSIDER THAT YOU CAN ONLY DELETE THE LAST CREATED POINT')))
img_path_ref=img_path; %Reference when deleting
img_THz_ref=img_THz; %Reference when deleting
TH=1;
op=0;
i=1;
num1=round(size(img_THz,1)*0.005);
num2=round(size(img_path,1)*0.005);
while(op==0)
    if(TH==1)
        figure(1)
        set(gcf,'position',[0 0 775 1000]);
    else
        figure(2)
        set(gcf,'position',[775 0 775 1000]);
    end
    [a,b,button]=ginput(1);
    if (isempty(a) && TH==1) %Verifies if user pressed 'Enter' to stop
        op=1;
    else
        if(button==3) %Delete last point - press mouse - right button
            if(TH==1)
                i=i-1;
                figure(2)
                TH=0;
            else
                figure(1)
                TH=1;
            end
            [a,b,button]=ginput(1);
            if (TH==1)
                img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1)=img_THz_ref(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1);
                img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,2)=img_THz_ref(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,2);
                img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,3)=img_THz_ref(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,3);
            else
                img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1)=img_path_ref(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1);
                img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,2)=img_path_ref(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,2);
                img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,3)=img_path_ref(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,3);
            end
        end
        if (TH==1)
            x_THz(i)=round(a);
            y_THz(i)=round(b);
            %Colors the selected point
            z1=size(img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1));
            img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,1)=zeros(z1);
            img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,2)=zeros(z1);
            img_THz(y_THz(i)-num1:y_THz(i)+num1,x_THz(i)-num1:x_THz(i)+num1,3)=zeros(z1);
            imshow(img_THz);
            %Position the window
            set(gcf,'position',[0 0 775 1000])
            TH=0;
        else
            x_path(i)=round(a);
            y_path(i)=round(b);
            %Colors the selected point
            z=size(img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1));
            img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,1)=zeros(z);
            img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,2)=zeros(z);
            img_path(y_path(i)-num2:y_path(i)+num2,x_path(i)-num2:x_path(i)+num2,3)=zeros(z);
            imshow(img_path);
            %Position the window
            set(gcf,'position',[775 0 775 1000])
            i=i+1;
            TH=1;
        end
    end
end
%CREATE AUTOMATIC BOUNDARIES
bound='';
while isempty(bound)
    bound = questdlg('WOULD YOU LIKE TO CREATE AUTOMATIC BOUNDARIES?', ...
        'BOUNDARIES', ...
        'YES','NO','NO');
end
if(strcmp(bound,'YES'))
    x_THz=[x_THz,1+num1,1+num1,size(img_THz,2)-num1,size(img_THz,2)-num1];
    y_THz=[y_THz,1+num1,size(img_THz,1)-num1,size(img_THz,1)-num1,1+num1];
    x_path=[x_path,1+num2,1+num2,size(img_path,2)-num2,size(img_path,2)-num2];
    y_path=[y_path,1+num2,size(img_path,1)-num2,size(img_path,1)-num2,1+num2];
%     A=image_boundaries_THz(img_THz,x_THz,y_THz);
%     x_THz=A(1,:);
%     y_THz=A(2,:);
%     B=image_boundaries_path(img_path,x_path,y_path);
%     x_path=B(1,:);
%     y_path=B(2,:);
end
figure(1)
Mesh_THz = delaunayTriangulation(x_THz',y_THz');
Mesh_THz = Mesh_THz(:,:);
hold on, triplot(Mesh_THz,x_THz,y_THz,'Color', [0.4 0.4 0.4],'linewidth',3), hold off
figure(2)
Mesh_Path = Mesh_THz(:,:);
hold on, triplot(Mesh_Path,x_path,y_path,'Color', [0.4 0.4 0.4],'linewidth',3), hold off
%check for overlap
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
%save and return structure
Meshes=struct;
Meshes.a=x_THz;
Meshes.b=y_THz;
Meshes.c=Mesh_THz;
Meshes.d=x_path;
Meshes.e=y_path;
Meshes.f=Mesh_Path;
end