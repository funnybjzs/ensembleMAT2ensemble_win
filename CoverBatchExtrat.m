function BatchExtractAndTrain(input,var)
outputdir=[var.outpath,input.image_type,'_gpumodels'];
mkdir(outputdir);
%-----file path--------
cover_img_path={};
cover_feature_file={};
cover_quantable_file={};
cover_size_file={};

%----------------cover data always have a batch only-----------

cover_img_path{1}=[input.image_path,input.image_type,'\',input.image_type,'_null_000'];
cover_feature_file{1}=[outputdir,'\',input.image_type,'_null_000_feature.ndm'];
if(strfind(input.image_type,'jpg'))
    cover_quantable_file{1}=[outputdir,'\',input.image_type,'_null_000_QTData.ndm'];  % only for jpeg images
end
cover_size_file{1}=[outputdir,'\',input.image_type,'_null_000_imageSize.ndm'];

% get features
if(strfind(input.image_type,'jpg')) %jpeg parts
    system(['.\DCTR_COMMAND\cuda_test_DCTRV12_v7.5 ', cover_img_path{1},' ',cover_feature_file{1},' ',cover_size_file{1},' ',cover_quantable_file{1},' ','names.txt']);
else % spatial parts
    system(['.\SRM_COMMAND\cuda_test_SRM12_v7.5 ', cover_img_path{1},' ',cover_feature_file{1},' ',cover_size_file{1},' ','names.txt']);
end

end