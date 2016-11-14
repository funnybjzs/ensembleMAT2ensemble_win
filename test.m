

quantable=zeros(8,8,230);
img_size=zeros(1,2,230);
for i=1:230
    quantable(:,:,i)=obj.quant_tables{1};
    img_size(:,:,i)=[2848,4288];
end

img_size(:,:,10)=[4288,2848];
img_size(:,:,108)=[4288,2848];
img_size(:,:,112)=[4288,2848];
img_size(:,:,67)=[4288,2848];
Mat2NDmatrix('C:\samples\sample1\qtable_cover.ndm',quantable);
Mat2NDmatrix('C:\samples\sample1\size_cover.ndm',img_size);



cover_feature_file={};
cover_quantable_file={};
cover_size_file={};
stego_feature_file={};
stego_quantable_file={};
stego_size_file={};

cover_feature_file{1}='C:\samples\sample1\cover_0.5\feature.ndm';
%cover_quantable_file{1}='C:\samples\sample1\cover_0.5\QTData.ndm';
cover_size_file{1}='C:\samples\sample1\cover_0.5\imageSize.ndm';
stego_feature_file{1}='C:\samples\sample1\stego_0.5\feature.ndm';
%stego_quantable_file{1}='C:\samples\sample1\stego_0.5\QTData.ndm';
stego_size_file{1}='C:\samples\sample1\stego_0.5\imageSize.ndm';
stego_feature_file{2}='C:\samples\sample1\stego_0.5\feature.ndm';
%stego_quantable_file{2}='C:\samples\sample1\stego_0.5\QTData.ndm';
stego_size_file{2}='C:\samples\sample1\stego_0.5\imageSize.ndm';
mdl_save_path='C:\samples\sample1\classifier_test.mdl';


[result_type,trained_ensemble]=ensembleMAT2ensemble(cover_feature_file,cover_quantable_file,cover_size_file,stego_feature_file,stego_quantable_file,stego_size_file,mdl_save_path);
cover=NDmatrix2Mat('C:\samples\sample1\cover_0.5\feature.ndm');
cover=chnls2rows(cover);
results = ensemble_testing(cover,trained_ensemble);

 cover_lable=NDmatrix2Mat('C:\samples\sample1\cover_lable.ndm');
cover_lable=chnls2rows(cover_lable);

 cover_Deci=NDmatrix2Mat('C:\samples\sample1\cover_deci.ndm');
cover_Deci=chnls2rows(cover_Deci);

A=[cover_Deci,((500-abs(results.votes))/2+abs(results.votes))/500];
B=[cover_lable,results.predictions];
