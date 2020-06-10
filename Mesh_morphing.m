function morphed_path=Mesh_morphing(images,Meshes)
img_path=images.a;
img_THz=images.b;

x_THz=Meshes.a;
y_THz=Meshes.b;
Mesh_THz=Meshes.c;
x_path=Meshes.d;
y_path=Meshes.e;
Mesh_Path=Meshes.f;

imgf=zeros(size(img_path))+255;

h = waitbar(0,'Please wait...');

for l=1:size(Mesh_Path,1)
    Source_points=Mesh_Path(l,:);
    Target_points=Mesh_THz(l,:);
    px_in=y_path(Source_points);
    py_in=x_path(Source_points);
    px_out=y_THz(Target_points);
    py_out=x_THz(Target_points);
    
    %Find the barycenter as a 4th point
    C_in = [mean(px_in),mean(py_in)];
    px_in=[px_in,round(C_in(1,1))];
    py_in=[py_in,round(C_in(1,2))];
    C_out = [mean(px_out),mean(py_out)];
    px_out=[px_out,round(C_out(1,1))];
    py_out=[py_out,round(C_out(1,2))];
    
    %Calculate matrix
    H=homography_matrix_SVD(px_in,py_in,px_out,py_out);
    img_warp = image_warping(img_path,H,px_in(1:3),py_in(1:3),px_out(1:3),py_out(1:3));
    
    for i=1:size(img_THz,1)
        for j=1:size(img_THz,2)
            if(inpolygon(i,j,px_out(1:3),py_out(1:3))==1)
                imgf(i,j,:)=img_warp(i,j,:);
            end
        end
    end
    waitbar(l/size(Mesh_Path,1))
end
close(h)
morphed_path=imgf(1:size(img_THz,1),1:size(img_THz,2),:);
% morphed_path=imresize(morphed_path,size(img_THz)/2);
end