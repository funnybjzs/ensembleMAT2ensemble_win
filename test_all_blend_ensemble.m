%% this function ¡°test_all_blend_ensemble¡± is used for testuing function ensemble_training_AllBlend
% input : feature_file_path, a string varieble indicating the path that feature files were stroed. Note that the name of feature files (with extended name .ndm) should follow certain format as following described;
%  A_B(for jpeg only)_C_D_E.ndm
%  All items (A,B,C,D,E) in the feature filename were seperated by underlines, they are:
% A : image formate.
% B : quality factor for jpeg image, this item is valid only for jpeg image, and is absent for spatial image.
% C : size of image, in factor it is a reference size, which means this file may contain features from images of different sizes, reference size usually is their average value both for height and width
% D : stego name, and for caover images, it is "null"
% E £ºembedding rate (payload) of stego images. For exameple, 0.4 bpp(or bpac for jpeg) is ¡°400¡±, and for cover, it is "000".
% please do not use other underline sytax in items, because this program parse the file name by the underlines between items.
% for example: 
% for stego images of JPEG formate quality 85, size 1000x500£¬ embedded by steganography F5 with 0.3 bpac£¬ it is ¡°jpg_85_1000x500_F5_300.ndm¡±
% for cover images of JPEG formate quality 85, size 1000x500£¬ it is ¡°jpg_85_1000x500_null_000.ndm¡±
% for spatial stego images of png format, size 1000x500£¬ embedded by steganography LSB with 0.3 bpp, it is ¡°png_1000x500_LSB_300.ndm¡±
%  for spatial cover images of png format, size 1000x500, it is ¡°png_1000x500_null_000.ndm¡±

% train_portion: indicate how much portion of samples is used as training sample, and rest samples as testing sample. take values in (0,1), we suggest it to be a value between (0.5, 0.8).
% the program will randomly take out samples according to this portion value. for every feature array, we take out the samples in the same position (sample index).

% please make sure that feature files in foldier "feature_file_path" contain the same number of images.

%this program will print the testing result on the screeen.


%%
function test_all_blend_ensemble(feature_file_path,train_portion)

filelist = dir([feature_file_path,'*.ndm']);
filenum = size(filelist,1);

stego_feature={};
cover_feature={};

stego_names_item={};

for k =1:1:filenum
    feature_file_name=filelist(k).name;
    name_items=feature_file_name_parse(feature_file_name);
    if(strcmp(name_items(end),'feature.ndm'))
        if(strcmp(name_items(end-1),'000')&&strcmp(name_items(end-2),'null'))
            cover_feature{end+1}=NDmatrix2Mat([feature_file_path,feature_file_name]);
            cover_feature{end}=chnls2rows(cover_feature{end});
        else
            stego_feature{end+1}=NDmatrix2Mat([feature_file_path,feature_file_name]);
            stego_feature{end}=chnls2rows(stego_feature{end});
            stego_names_item{end+1}=name_items;
        end
    end
end

permute_idx=randperm(size(cover_feature{1},1));
train_idx=permute_idx(1:floor(length(permute_idx)*train_portion));
test_idx=permute_idx(floor(length(permute_idx)*train_portion)+1:end);

train_cover=cover_feature{1}(train_idx,:);
test_cover{1}=cover_feature{1}(test_idx,:);
clear cover_feature;
num_train_cover=size(train_cover,1);
num_test_cover=size(test_cover,1);

train_stego=zeros(num_train_cover*numel(stego_feature),size(train_cover,2));
test_stego={};

for stego_count=0:numel(stego_feature)-1;
    train_stego(stego_count*num_train_cover+1:(stego_count+1)*num_train_cover,:)=stego_feature{stego_count+1}(train_idx,:);
    test_stego{end+1}=stego_feature{stego_count+1}(test_idx,:);
end


[trained_ensemble,results] = ensemble_training_AllBlend(train_cover,train_stego);


results=ensemble_testing(test_cover{1},trained_ensemble);
cover_results{1}.predict_lable=results;
cover_results{1}.accuracy=double(sum(cover_results{1}.predict_lable.predictions==-1))/length(cover_results{1}.predict_lable.predictions);

stego_result={};
for stego_count=1:numel(stego_feature)
    stego_result{stego_count}.predict_lable=ensemble_testing(test_stego{stego_count},trained_ensemble);
    stego_result{stego_count}.accuracy=double(sum(stego_result{stego_count}.predict_lable.predictions==1))/length(stego_result{stego_count}.predict_lable.predictions);
    stego_result{stego_count}.stego_payload_rate=stego_names_item{stego_count}{end-1};
    stego_result{stego_count}.stego_name=stego_names_item{stego_count}{end-2};
    stego_result{stego_count}.img_size=stego_names_item{stego_count}{end-3};
end


fprintf('test ensemble all blend training, %d cover training samples, %d cover test samples:\n',num_train_cover,num_test_cover);

fprintf('cover : %f\n',cover_results{1}.accuracy/100);

for stego_count=1:numel(stego_feature)
    fprintf('%s %s %s\n',stego_result{stego_count}.stego_name,stego_result{stego_count}.stego_payload_rate,stego_result{stego_count}.accuracy/100);
end

end



function name_items=feature_file_name_parse(filename)
   interval_index=strfind(filename,'_');
   name_items={};
   name_items{end+1}=filename(1:interval_index(1)-1);
   for item_count=1:1:length(interval_index)-1
       name_items{end+1}=filename(interval_index(item_count)+1:interval_index(item_count+1)-1);
   end
    name_items{end+1}=filename(interval_index(end)+1:end);
end    
    
    