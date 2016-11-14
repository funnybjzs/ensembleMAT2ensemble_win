


function [result_type,trained_ensemble]=ensembleMAT2ensemble(cover_feature_file,cover_quantable_file,cover_size_file,stego_feature_file,stego_quantable_file,stego_size_file,mdl_save_path)
%% ---------------initially set result_type empty
result_type={};
trained_ensemble=[];

%% ---------check input variables if they are cell type------------
if(~iscell(cover_feature_file))
    result_type{end+1}='error:variable cover_feature_file must be a cell';
    return;
end

if(~iscell(cover_quantable_file))
    result_type{end+1}='error:variable cover_quantable_file must be a cell';
    return;
end

if(~iscell(cover_size_file))
    result_type{end+1}='error:variable cover_size_file must be a cell';
    return;
end

if(~iscell(stego_feature_file))
    result_type{end+1}='error:variable stego_feature_file must be a cell';
    return;
end

if(~iscell(stego_quantable_file))
    result_type{end+1}='error:variable stego_quantable_file must be a cell';
    return;
end

if(~iscell(stego_size_file))
    result_type{end+1}='error:variable stego_size_file must be a cell';
    return;
end

%% ----------------------------------load cover data--------

if(isempty(cover_feature_file))
    result_type{end+1}='error:variable cover_feature_file is empty';
    return;
end
cover_feature=NDmatrix2Mat(cover_feature_file{1});
if(isempty(cover_feature))
    result_type{end+1}='error:open cover feature file error';
    return
end

if(~isempty(cover_quantable_file))   %-----cover_quantable_file should be a empty cell {} for spatial images
    cover_quantable=NDmatrix2Mat(cover_quantable_file{1});
    if(isempty(cover_quantable))
        result_type{end+1}='error:open cover quant table file error';
    end
end

if(isempty(cover_size_file))
    result_type{end+1}='error:variable cover_size_file is empty';
    return;
end
cover_size=NDmatrix2Mat(cover_size_file{1});
if(isempty(cover_size))
    result_type{end+1}='error:open cover size file error';
    return
end

%% -----------------------load stego data----------------------------------

number_stego_files=length(stego_feature_file);
if(number_stego_files==0)
    result_type{end+1}='error:variable cover_feature_file is empty';
end
    
if(~isempty(stego_quantable_file))          %-----stego_quantable_file should be a empty cell {} for spatial images
    if(length(stego_quantable_file)~=number_stego_files)
        result_type{end+1}='error:the number of elements in stego_feature_file do not equal to that in stego_feature_file';
        return;
    end
end

 if(length(stego_size_file)~=number_stego_files)
        result_type{end+1}='error:the number of elements in stego_size_file do not equal to that in stego_feature_file';
        return;
 end
 
 stego_feature={};
 stego_quantable={};
 stego_size={};
 for(stego_file_count=1:1:number_stego_files)
     stego_feature{end+1}=NDmatrix2Mat(stego_feature_file{stego_file_count});
     if(isempty(stego_feature{end}))
         result_type{end+1}=['error: failed to load the ',num2str(stego_file_count),'th stego feature file'];
         return;
     end
 end

 if(~isempty(stego_quantable_file))   %-----stego_quantable_file should be a empty cell {} for spatial images
     for(stego_file_count=1:1:number_stego_files)
         stego_quantable{end+1}=NDmatrix2Mat(stego_quantable_file{stego_file_count});
         if(isempty(stego_quantable{end}))
             result_type{end+1}=['error: failed to load the',num2str(stego_file_count),'th stego quantable file'];
             return;
         end
     end
 end
 
 for(stego_file_count=1:1:number_stego_files)
     stego_size{end+1}=NDmatrix2Mat(stego_size_file{stego_file_count});
     if(isempty(stego_size{end}))
         result_type{end+1}=['error: failed to load the',num2str(stego_file_count),'th stego size file'];
         return;
     end
 end
 
 
 %% --------------check the image format consistency between cover and stego----------
 if(isempty(cover_quantable_file)~=isempty(stego_quantable_file))
     result_type{end+1}='error:the image format of cover and stego should always the same';
     return;
 end
 
%% ------------------------check cover data--------------------------------------------------- 
    
 number_cover_samples=size(cover_feature,3);
 
if(~iscell(cover_quantable_file))
      result_type{end+1}='error:cover_quantable_file should be a cell type varieble';
      return;
end


 
if(~isempty(cover_quantable_file))
    if(size(cover_quantable,3)~=number_cover_samples)
        result_type{end+1}='error:the number of cover size do not match the number of cover feature sample';
        return;
    end
    if(size(cover_quantable,1)~=8||size(cover_quantable,2)~=8)
        result_type{end+1}='error:each cover quantable must be a 8x8 matrix';
        return
    end
end



if(size(cover_size,1)~=1||size(cover_size,2)~=2)
    result_type{end+1}='error:each cover size must be a 1x2 vector';
    return
end    

    
%% ------------------------check stego data--------------------------------------------------- 
feature_dimension=size(cover_feature,2);

for stego_file_count=1:number_stego_files
    if(size(stego_feature{stego_file_count},1)~=1||size(stego_feature{stego_file_count},3)~=number_cover_samples)
        result_type{end+1}=['error: the number of samples in the ',num2str(stego_file_count),' th stego file do not equals to number of cover samples'];
        return
    end
    if(size(stego_feature{stego_file_count},2)~=feature_dimension)
        result_type{end+1}=['error: the feature dimension of the ',num2str(stego_file_count),' th stego file do not coincident with cover samples'];
        return
    end
    
    if(~isempty(stego_quantable_file))
        if(size(stego_quantable{stego_file_count},3)~=number_cover_samples)
            result_type{end+1}=['error: the number of quantables of the ',num2str(stego_file_count),' th stego file do not coincident with the number of cover samples'];
            return
        end
        
        if(size(stego_quantable{stego_file_count},2)~=8||size(stego_quantable{stego_file_count},1)~=8)
            result_type{end+1}=['error: the quantables of the ',num2str(stego_file_count),' th stego file is not 8x8'];
            return
        end
    end
    
    
    if(size(stego_size{stego_file_count},3)~=number_cover_samples)
        result_type{end+1}=['error: the number of size of the ',num2str(stego_file_count),' th stego file do not coincident with the number of cover samples'];
        return
    end
    
    if(size(stego_size{stego_file_count},1)~=1||size(stego_size{stego_file_count},2)~=2)
        result_type{end+1}=['error: the size of the ',num2str(stego_file_count),' th stego file is not 1x2'];
        return
    end
end


%% ----------------- prepare training data (sampling size data, quantable data and feature data for multuiple stego feature files)----------------------------------------

cover_train=cover_feature;
if(~isempty(cover_quantable_file))
    cover_train_quantable=cover_quantable;
else
    cover_train_quantable=zeros(8,8);
end
cover_train_size=cover_size;

stego_train=zeros(size(cover_feature));

if(~isempty(stego_quantable_file))
    stego_train_quantable=zeros(size(cover_quantable));
end

stego_train_size=zeros(size(cover_train_size));

if(~isempty(stego_quantable_file))
    for stego_file_count=1:number_stego_files
        stego_train(:,:,stego_file_count:number_stego_files:end)=stego_feature{stego_file_count}(:,:,stego_file_count:number_stego_files:end);
        stego_train_quantable(:,:,stego_file_count:number_stego_files:end)=stego_quantable{stego_file_count}(:,:,stego_file_count:number_stego_files:end);
        stego_train_size(:,:,stego_file_count:number_stego_files:end)=stego_size{stego_file_count}(:,:,stego_file_count:number_stego_files:end);
    end
else
    for stego_file_count=1:number_stego_files
        stego_train(:,:,stego_file_count:number_stego_files:end)=stego_feature{stego_file_count}(:,:,stego_file_count:number_stego_files:end);
        stego_train_size(:,:,stego_file_count:number_stego_files:end)=stego_size{stego_file_count}(:,:,stego_file_count:number_stego_files:end);
    end
    stego_train_quantable=zeros(8,8);
end

clear cover_feature cover_quantable cover_size;
clear stego_feature stego_quantable stego_size;

%% ---------------------------calculate classifier model parameters for matching image----------------------------

if(isempty(cover_quantable_file))
    img_quantable=zeros(8,8);
else
    img_quantable=(sum(cover_train_quantable,3)+sum(stego_train_quantable,3))/(size(cover_train_quantable,3)+size(stego_train_quantable,3));
    img_quantable=round(img_quantable);
    img_quantable=abs(img_quantable);
end

cover_train_size=chnls2rows(cover_train_size);
stego_train_size=chnls2rows(stego_train_size);
cover_train_size=abs(cover_train_size);
stego_train_size=abs(stego_train_size);


img_size=[cover_train_size;stego_train_size];
[min_value,min_index]=min(img_size,[],2);
[max_value,max_index]=max(img_size,[],2);

img_size=abs(img_size);
img_size=[min_value,max_value];

img_size=sum(img_size,1)/size(img_size,1);
img_size=round(img_size);


if(~isempty(cover_quantable_file))
    img_quality_factor=GetQualityFactor(img_quantable);
else
    img_quality_factor=0;
end
%%  --------------------------------------training classifier-----------------------------------

cover_train=chnls2rows(cover_train);
stego_train=chnls2rows(stego_train);

[trained_ensemble,results]=ensemble_training(cover_train,stego_train);

%%  ----------------------------------------save result to MDL file--------------------------------

fid=fopen(mdl_save_path,'w+');

if(img_quality_factor==0)
    model_type=3;
    model_type=uint32(model_type);
    fwrite(fid,model_type,'uint32');
else
    model_type=1;
    model_type=uint32(model_type);
    fwrite(fid,model_type,'uint32');
end
 
 height_min=img_size(1);
 height_min=uint32(height_min);
 fwrite(fid,height_min,'uint32');

 height_max=img_size(1);    
 height_max=uint32(height_max);    
 fwrite(fid,height_max,'uint32');

 height_refer=img_size(1);    
 height_refer=uint32(height_refer);    
 fwrite(fid,height_refer,'uint32');
 
  width_min=img_size(2);    
 width_min=uint32(width_min);    
 fwrite(fid,width_min,'uint32');

 width_max=img_size(2);    
 width_max=uint32(width_max);    
 fwrite(fid,width_max,'uint32');
 
 width_refer=img_size(2);
 width_refer=uint32(width_refer);
 fwrite(fid,width_refer,'uint32');
 
 
 qt=img_quantable;
 qt=qt';
 qt=qt(:);
 qt=double(qt);
 for i=1:64
     fwrite(fid,qt(i),'double');
 end
 img_quality_factor=double(img_quality_factor);
 fwrite(fid,img_quality_factor,'double');

 qt_previous=double(zeros(1,64));
 
 qt_previous_factor=0;
 qt_previous_factor=double(qt_previous_factor);
  for i=1:64
     fwrite(fid,qt_previous(i),'double');
  end
  fwrite(fid,qt_previous_factor,'double');
  
  
  texture=0;                   %this parameter yet have not been used in classifier model matching in this version
  texture=double(texture);
  fwrite(fid,texture,'double');
  
  feature_dimension=uint32(feature_dimension);
  fwrite(fid,feature_dimension,'uint32');
  
  rand_dim=length(trained_ensemble{1}.subspace);
  rand_dim=uint32(rand_dim);
  fwrite(fid,rand_dim,'uint32');
  
 num_classifiers=length(trained_ensemble);
 num_classifiers=uint32(num_classifiers);
 fwrite(fid,num_classifiers,'uint32');  
 
 neglabel=-1; 
 poslabel=1;
 neglabel=double(neglabel);
 poslabel=double(poslabel);
 fwrite(fid,neglabel,'double');
 fwrite(fid,poslabel,'double');
 
 standlize_type=0;
 standlize_type=uint8(standlize_type);
 fwrite(fid,standlize_type,'uint8');
 
 for clasifier_count=1:length(trained_ensemble)
     bias=trained_ensemble{clasifier_count}.b;
     fwrite(fid,bias,'double');
     fwrite(fid,neglabel,'double');
     fwrite(fid,poslabel,'double');
     regularize_factor=0.0000001;
     regularize_factor=double(regularize_factor);
     fwrite(fid,regularize_factor,'double');
     num_dim=length(trained_ensemble{clasifier_count}.w);
     fwrite(fid,1,'uint32');
     fwrite(fid,num_dim,'uint32');
     fwrite(fid,1,'uint32');
     w=trained_ensemble{clasifier_count}.w;
     for i=1:num_dim
         fwrite(fid,w(i),'double');
     end
     
     columnindex=trained_ensemble{clasifier_count}.subspace;
     columnindex=uint32(columnindex);
     Num_columnindex=length(columnindex);
     Num_columnindex=uint32(Num_columnindex);
     Num_rowindex=0;
     Num_rowindex=uint32(Num_rowindex);
     Num_channelindex=0;
     Num_channelindex=uint32(Num_channelindex);
     fwrite(fid,Num_columnindex,'uint32');
     for column_index_count=1:Num_columnindex
         fwrite(fid,columnindex(column_index_count),'uint32');
     end
     fwrite(fid,Num_rowindex,'uint32');
     fwrite(fid,Num_channelindex,'uint32');
     step_columnindex=0;
     step_columnindex=uint32(step_columnindex);
     step_rowindex=0;
     step_rowindex=uint32(step_rowindex);
     step_channelindex=0;
     step_channelindex=uint32(step_channelindex);
     fwrite(fid,step_columnindex,'uint32');
     fwrite(fid,step_rowindex,'uint32');
     fwrite(fid,step_channelindex,'uint32');
     
     
     
 end
 
 
 fclose(fid);
 
 
 result_type{end+1}='success';
  
  
    
    
    
    

