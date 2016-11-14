%% ________________________example2 (SRM for spatial) for feature extracting and ensemble classifier training (saved as MDL file)-----------



%% -----------spatial image SRM and training ensemble-----------------


%-----file path--------
cover_feature_file={};
cover_quantable_file={}; %keep it a empty cell for spatial images
cover_size_file={};
stego_feature_file={};
stego_quantable_file={}; %keep it a empty cell for spatial images
stego_size_file={};
cover_img_path={};
stego_img_path={};



cover_img_path{1}='C:\samples\sample1\cover_0.5';
cover_feature_file{1}='C:\samples\sample1\cover_0.5\feature.ndm';

cover_size_file{1}='C:\samples\sample1\cover_0.5\imageSize.ndm';


%-------------------assume 2 batches of stego samples-----------------

%----------the first stego samples-----------
stego_img_path{1}='C:\samples\sample1\stego_0.5';
stego_feature_file{1}='C:\samples\sample1\stego_0.5\feature.ndm';

stego_size_file{1}='C:\samples\sample1\stego_0.5\imageSize.ndm';

%-----------the second stego samples-----------
stego_img_path{2}='C:\samples\sample1\stego_0.5';
stego_feature_file{2}='C:\samples\sample1\stego_0.5\feature.ndm';

stego_size_file{2}='C:\samples\sample1\stego_0.5\imageSize.ndm';

%--------------MDL save path----------
mdl_save_path='C:\samples\sample1\classifier_test.mdl';

% ----------extracting DCTR--------------

%----------assume cuda_test_DCTRV12.exe in the current folder------------
system(['.\SRM_COMMAND\cuda_test_SRM12 ', cover_img_path{1},' ',cover_feature_file{1},' ',cover_size_file{1},' ','names.txt']);

for stego_count=1:length(stego_img_path)
system(['.\SRM_COMMAND\cuda_test_SRM12 ', stego_img_path{stego_count},' ',stego_feature_file{stego_count},' ',stego_size_file{stego_count},' ','names.txt']);
end

%cover_quantable_file and stego_quantable_file should be input into
%ensembleMAT2ensemble, but they are empty cells respectively.
[result_type,trained_ensemble]=ensembleMAT2ensemble(cover_feature_file,cover_quantable_file,cover_size_file,stego_feature_file,stego_quantable_file,stego_size_file,mdl_save_path);

fprintf([result_type{end},'\n\n\n\n']);
