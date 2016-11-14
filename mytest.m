input.image_type='jpg_75_1500x1000';
input.image_path='Z:\';

var.outpath='D:\zhaoshuo\';
%read only
var.stego_algo={'F5','MME','JLSBM','JSteg','NSF5'};
var.stego_payload={'200','300','400'};
BatchExtractAndTrain(input,var);

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
