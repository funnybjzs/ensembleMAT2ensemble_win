input.image_path='e:\';
image_type='jpg';
image_size='320x240';
qf_start=70;
qf_end=70;
%extract cover
var.outpath='e:\';
% var.stego_algo={'null'};
% var.stego_payload={'000'};
% for i=qf_start:qf_end
%     input.image_type=[image_type,'_',num2str(i),'_',image_size];
%     CoverBatchExtrat(input,var);
% end

%extract stego
for i=qf_start:qf_end
    input.image_type=[image_type,'_',num2str(i),'_',image_size];
%     var.stego_algo={'F5','MME','JLSBM','JSteg','NSF5'};
%     var.stego_payload={'200','300','400'};
    var.stego_algo2={'JUNIWARD','UED'};
    var.stego_payload2={'400','500'};
    var.stego_algo={};
    var.stego_payload={};
   BatchExtractAndTrain(input,var);
end

% input.image_type='png_1500x1000';
% input.image_path='Z:\';
% 
% var.outpath='Z:\';
% %read only
% var.stego_algo={'LSBR','LSBM'};
% var.stego_payload={'200','300','400'};
% BatchExtractAndTrain(input,var);
% 
% input.image_type='png_3000x2000';
% BatchExtractAndTrain(input,var);
% 
% input.image_type='png_4500x3000';
% input.image_path='Y:\';
% var.outpath='Y:\';
% BatchExtractAndTrain(input,var);
