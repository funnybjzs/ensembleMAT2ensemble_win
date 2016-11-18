function BatchExtractAndTrain(input,var)
outputdir=[var.outpath,input.image_type,'_gpumodels'];
mkdir(outputdir);
%-----file path--------
cover_img_path={};
cover_feature_file={};
cover_quantable_file={};
cover_size_file={};

stego_img_path={};
stego_feature_file={};
stego_quantable_file={};
stego_size_file={};

%----------------cover data always have a batch only-----------

cover_img_path{1}=[input.image_path,input.image_type,'\',input.image_type,'_null_000'];
cover_feature_file{1}=[outputdir,'\',input.image_type,'_null_000_feature.ndm'];
if(strfind(input.image_type,'jpg'))
    cover_quantable_file{1}=[outputdir,'\',input.image_type,'_null_000_QTData.ndm'];  % only for jpeg images
end
cover_size_file{1}=[outputdir,'\',input.image_type,'_null_000_imageSize.ndm'];

for i=1:length(var.stego_algo)
    for j=1:length(var.stego_payload)
        stego_img_path{(i-1)*length(var.stego_payload)+j}=[input.image_path,input.image_type,'\',input.image_type,'_',var.stego_algo{i},'_',var.stego_payload{j}];
        stego_feature_file{(i-1)*length(var.stego_payload)+j}=[outputdir,'\',input.image_type,'_',var.stego_algo{i},'_',var.stego_payload{j},'_feature.ndm'];
        if(strfind(input.image_type,'jpg'))
            stego_quantable_file{(i-1)*length(var.stego_payload)+j}=[outputdir,'\',input.image_type,'_',var.stego_algo{i},'_',var.stego_payload{j},'_QTData.ndm'];
        end
        stego_size_file{(i-1)*length(var.stego_payload)+j}=[outputdir,'\',input.image_type,'_',var.stego_algo{i},'_',var.stego_payload{j},'_imageSize.ndm'];
    end
end

%---debug---
varnum1=length(var.stego_algo)*length(var.stego_payload);
for i=1:length(var.stego_algo2)
    for j=1:length(var.stego_payload2)
        stego_img_path{varnum1+(i-1)*length(var.stego_payload2)+j}=[input.image_path,input.image_type,'\',input.image_type,'_',var.stego_algo2{i},'_',var.stego_payload2{j}];
        stego_feature_file{varnum1+(i-1)*length(var.stego_payload2)+j}=[outputdir,'\',input.image_type,'_',var.stego_algo2{i},'_',var.stego_payload2{j},'_feature.ndm'];
        if(strfind(input.image_type,'jpg'))
            stego_quantable_file{varnum1+(i-1)*length(var.stego_payload2)+j}=[outputdir,'\',input.image_type,'_',var.stego_algo2{i},'_',var.stego_payload2{j},'_QTData.ndm'];
        end
        stego_size_file{varnum1+(i-1)*length(var.stego_payload2)+j}=[outputdir,'\',input.image_type,'_',var.stego_algo2{i},'_',var.stego_payload2{j},'_imageSize.ndm'];
    end
end



mdl_save_path=[outputdir,'\',input.image_type,'.mdl'];
% results=zeros(1,length(stego_img_path));

% get features
% if(strfind(input.image_type,'jpg')) %jpeg parts
%     %system(['.\DCTR_COMMAND\cuda_test_DCTRV12 ', cover_img_path{1},' ',cover_feature_file{1},' ',cover_size_file{1},' ',cover_quantable_file{1},' ','names.txt']);
%     %stego
%     while(length(find(results==1))~=length(var.stego_algo)*length(var.stego_payload))
%         for stego_count=1:length(stego_img_path)
%              if(numel(dir([stego_img_path{stego_count},'\*.jpg']))==12194&&results(stego_count)==0)
%                 system(['.\DCTR_COMMAND\cuda_test_DCTRV12_v7.5 ', stego_img_path{stego_count},' ',stego_feature_file{stego_count},' ',stego_size_file{stego_count},' ',stego_quantable_file{stego_count},' ','names.txt']);
%                 results(stego_count)=1;
%             end
%         end
%     end
% else % spatial parts
%     %system(['.\SRM_COMMAND\cuda_test_SRM12 ', cover_img_path{1},' ',cover_feature_file{1},' ',cover_size_file{1},' ','names.txt']);
%     %stego    
%     while(length(find(results==1))~=length(var.stego_algo)*length(var.stego_payload))
%         for stego_count=1:length(stego_img_path)
%              if(numel(dir([stego_img_path{stego_count},'\*.jpg']))==12194&&results(stego_count)==0)
%                 system(['.\cuda_test_SRM12_v7.5 ', stego_img_path{stego_count},' ',stego_feature_file{stego_count},' ',stego_size_file{stego_count},' ','names.txt']);
%                 results(stego_count)=1;
%              end             
%         end
%     end
% end

[result_type,trained_ensemble]=ensembleMAT2ensemble(cover_feature_file,cover_quantable_file,cover_size_file,stego_feature_file,stego_quantable_file,stego_size_file,mdl_save_path);
fprintf([result_type{end},'\n\n\n\n']);

end