%% ________________________example1 (DCTR for jpeg) for feature extracting and ensemble classifier training (saved as MDL file)-----------



%% -----------jpeg image DCTR and training ensemble-----------------


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

cover_img_path{1}='C:\samples\sample1\cover_0.5';
cover_feature_file{1}='C:\samples\sample1\cover_0.5\feature.ndm';
cover_quantable_file{1}='C:\samples\sample1\cover_0.5\QTData.ndm';  % only for jpeg images
cover_size_file{1}='C:\samples\sample1\cover_0.5\imageSize.ndm';


%-------------------this example assume 2 batches of stego samples-----------------

%----------the first batch of stego samples-----------
stego_img_path{1}='C:\samples\sample1\stego_0.5';
stego_feature_file{1}='C:\samples\sample1\stego_0.5\feature.ndm';
stego_quantable_file{1}='C:\samples\sample1\stego_0.5\QTData.ndm';
stego_size_file{1}='C:\samples\sample1\stego_0.5\imageSize.ndm';

%-----------the second batch of stego samples-----------
stego_img_path{2}='C:\samples\sample1\stego_3';
stego_feature_file{2}='C:\samples\sample1\stego_3\feature.ndm';
stego_quantable_file{2}='C:\samples\sample1\stego_3\QTData.ndm';
stego_size_file{2}='C:\samples\sample1\stego_3\imageSize.ndm';

%--------------MDL save path----------
mdl_save_path='C:\samples\sample1\classifier_test.mdl';

% ----------extracting DCTR--------------

%----------assume cuda_test_DCTRV12.exe in the current folder------------
system(['.\DCTR_COMMAND\cuda_test_DCTRV12 ', cover_img_path{1},' ',cover_feature_file{1},' ',cover_size_file{1},' ',cover_quantable_file{1},' ','names.txt']);

for stego_count=1:length(stego_img_path)
system(['.\DCTR_COMMAND\cuda_test_DCTRV12 ', stego_img_path{stego_count},' ',stego_feature_file{stego_count},' ',stego_size_file{stego_count},' ',stego_quantable_file{stego_count},' ','names.txt']);
end

[result_type,trained_ensemble]=ensembleMAT2ensemble(cover_feature_file,cover_quantable_file,cover_size_file,stego_feature_file,stego_quantable_file,stego_size_file,mdl_save_path);

fprintf([result_type{end},'\n\n\n\n']);

