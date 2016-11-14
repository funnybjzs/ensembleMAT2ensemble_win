function output_mat=chnls2rows(input_mat)
if(isempty(input_mat))
output_mat=[];
return;
end

output_mat = zeros(size(input_mat,3),size(input_mat,2),'double');
for i = 1:size(input_mat,3)
    output_mat(i,:) = input_mat(1,:,i);
end