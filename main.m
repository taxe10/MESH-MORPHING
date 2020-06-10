close all
clear
clc
op=0;
Path_img_name=0;
THz_img_name=0;
final=[];
morphed_path=[];
keep=0;
while op==0
    filename=0;
    choice = questdlg('WHAT DO YOU NEED TO DO?', ...
        'MORPHING', ...
        'CREATE MESH','MODIFY MESH','MORPH PATHOLOGY','MORPH PATHOLOGY');
    if isempty(choice)
        return
    end
    if(op==0)
        if keep==0
            [Path_img_name,path_Path] = uigetfile('*.png','SELECT THE PATHOLOGY IMAGE');
            Path_img_name=strcat(path_Path,Path_img_name);
            if isempty(Path_img_name)
                return
            end
            [THz_img_name,path_THz] = uigetfile('*.png','SELECT THE TERAHERTZ IMAGE',path_Path);
            THz_img_name=strcat(path_THz,THz_img_name);
            if isempty(THz_img_name)
                return
            end
            try
                % Pathology Mask
                img_path=imread(Path_img_name);
                choice1='';
                while isempty(choice1)
                    choice1 = inputdlg('SCALE PATHOLOGY RESOLUTION BY: ');
                end
                choice1=str2num(cell2mat(choice1));
                if(choice1~=0)
                    img_path=imresize(img_path,choice1);
                end
                % Tissue Mask
                img_THz=imread(THz_img_name); %+200
                choice2='';
                while isempty(choice2)
                    choice2 = inputdlg('SCALE THZ RESOLUTION BY: ');
                end
                choice2=str2num(cell2mat(choice2));
                if(choice2~=0)
                    img_THz=imresize(img_THz,choice2);
                end
                images=struct;
                images.a=img_path;
                images.b=img_THz;
            catch
                ErrorMessage=lasterr;
                errordlg(ErrorMessage);
                return
            end
        end
        try
            show_images(img_path,img_THz);
        catch
            ErrorMessage=lasterr;
            errordlg(ErrorMessage);
            return
        end
        if strcmp(choice,'CREATE MESH')
            Meshes=create_mesh(images);
        else
            load_op='';
            while isempty(load_op)
                load_op = questdlg('LOAD PRIOR MESH?', ...
                    'LOAD', ...
                    'YES','NO','NO');
            end
            if(strcmp(load_op,'YES'))
                while filename==0
                    [filename,path] = uigetfile('*.mat','SELECT THE PRIOR DATA');
                    filename=strcat(path,filename);
                end
                try
                    Meshes=[];
                    load(filename);
                catch
                    ErrorMessage=lasterr;
                    errordlg(ErrorMessage);
                    return
                end
            end
            %verify the variables are included
            try
                Meshes;
            catch
                ErrorMessage=lasterr;
                errordlg('THERE ARE SOME MISSING VARIABLES. TRY CREATING A NEW MESH OR LOADING A NEW SET OF DATA');
                return
            end
            if strcmp(choice,'MORPH PATHOLOGY')
                morphed_path=Mesh_morphing(images,Meshes);
                choice='';
                beep
                while isempty(choice)
                    choice = questdlg('CREATE MATRIX?', ...
                        'MORPHING', ...
                        'YES','NO','NO');
                end
                if (strcmp(choice,'YES'))
                    final=classification(images,morphed_path);
                    figure(3)
                    imshow(final.b);
                else
                    figure(3)
                    imshow(morphed_path);
                end
                set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
            else
                choice2='';
                while isempty(choice2)
                    choice2 = questdlg('DO YOU NEED TO?', ...
                        'MODIFY MESH', ...
                        'ADD A NEW POINT','DELETE AN EXISTING POINT','DELETE AN EXISTING POINT');
                end
                if (strcmp(choice2,'DELETE AN EXISTING POINT'))
                    Meshes=delete_from_mesh(images,Meshes);
                else
                    Meshes=add_from_mesh(images,Meshes);
                end
            end
        end
        saveop='';
        while isempty(saveop)
            saveop = questdlg('SAVE PROGRESS?', ...
                'MORPHING', ...
                'YES','NO','NO');
        end
        if (strcmp(saveop,'YES'))
            [filename,path] = uiputfile('*.mat','SAVE MESHES AS:');
            path1=strcat(path,filename);
            if isempty(filename)
                return
            end
            save(path1,'Meshes');
            if (isempty(final)==0)
                [filename,path] = uiputfile('*.mat','SAVE MATRIX AS:',path);
                if isempty(filename)
                    return
                end
                path1=strcat(path,filename);
                matrix=final.a;
                matrix_key_tissue=final.c;
                matrix_key_number=final.d;
                save(path1,'matrix','matrix_key_tissue','matrix_key_number');
                [filename,path] = uiputfile('*.png','SAVE MORPHED PATHOLOGY AS:',path);
                if isempty(filename)
                    return
                end
                path1=strcat(path,filename);
                imwrite(final.b,path1);
            else
                if(isempty(morphed_path)==0)
                    [filename,path] = uiputfile('*.png','SAVE MORPHED PATHOLOGY AS:',path);
                    if isempty(filename)
                        return
                    end
                    path1=strcat(path,filename);
                    imwrite(morphed_path,path1);
                end
            end
        end
        choice='';
        while isempty(choice)
            choice = questdlg('CONTINUE?', ...
                'MORPHING', ...
                'YES','NO','NO');
        end
        if (strcmp(choice,'NO'))
            op=1;
            close all
        else
            choice='';
            while isempty(choice)
                choice = questdlg('KEEP THE CURRENT DATA?', ...
                    'MORPHING', ...
                    'YES','NO','NO');
            end
            if (strcmp(choice,'NO'))
                clear;
                Path_img_name=0;
                THz_img_name=0;
                op=0;
                final=[];
                morphed_path=[];
                keep=0;
            else
                keep=1;
            end
        end
        
    end
end