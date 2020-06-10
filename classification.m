function final=classification(images,morphed_path)
img_path=images.a;
figure(4)
imshow(img_path);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
i=1;
matrix_key=struct;
waitfor(msgbox(sprintf('INSTRUCTIONS:\n1. SELECT ALL REGIONS (TYPES OF TISSUES) IN THE PATHOLOGY INCLUDING THE BACKGROUND')))
choice='YES';
while(strcmp(choice,'YES'))
    answer=cell(1,2);
    answer{1,1}=''; answer{1,2}='';
    while (strcmp((answer(1,1)),'') || strcmp(answer(1,2),''))
        prompt = {'Enter type of tissue:','Enter a number to identify the type of tissue in the matrix:'};
        dlg_title = 'Type of tissue';
        num_lines = 1;
        answer = inputdlg(prompt,dlg_title,num_lines)';
    end
    matrix_key.a(i,1:size(answer{1,1},2))=answer{1,1};
    matrix_key.b(i)=str2double(answer{1,2});
    [a,b]=ginput(1);
    colors(i,:)=img_path(round(b),round(a),:);
    i=i+1;
    choice='';
    while isempty(choice)
        choice = questdlg('DO YOU WANT TO INDICATE A DIFFERENT REGION?', ...
            'CLASSIFICATION', ...
            'YES','NO','NO');
    end
end
colors1=colors/max(max(colors));
% Classify the regions in the morphed pathology and create a matrix
for i=1:size(morphed_path,1)
     for j=1:size(morphed_path,2)
         for k=1:size(colors,1)
             A=[morphed_path(i,j,1),morphed_path(i,j,2),morphed_path(i,j,3)];
             B=double(colors1(k,:));
             d(k)=norm((A-B),2);
         end
         l=find(d==min(d));
         if(size(l,2)>1)
             l=l(1);
         end
         matrix(i,j)=matrix_key.b(l);
         final_morphed_path(i,j,:)=colors(l,:);
     end
end
final=struct;
final.a=matrix;
final.b=final_morphed_path;
final.c=matrix_key.a;
final.d=matrix_key.b;
end