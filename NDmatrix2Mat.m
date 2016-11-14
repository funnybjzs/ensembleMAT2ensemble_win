function A=NDmatrix2Mat(filename)

 if(isempty(filename))
     A=[];
     return;
 end
 
 fid=fopen(filename,'r');
 if(fid==-1)
   A=[];
   return;
 end
 
[height,data_count]=fread(fid,1,'uint32');
if((data_count~=1)||(height==0))
   A=[];
   fclose(fid);
   return;    
end


[width,data_count]=fread(fid,1,'uint32');
if((data_count~=1)||(width==0))
   A=[];
   fclose(fid);
   return;    
end

[channel,data_count]=fread(fid,1,'uint32');
if((data_count~=1)||(channel==0))
   A=[];
   fclose(fid);
   return;    
end

% channel=fread(fid,1,'uint32');
% width=fread(fid,1,'uint32'); 
% height=fread(fid,1,'uint32');



 A=zeros(height,width,channel);
 num_data_per_Chnl=height*width;
 for i=1:channel
     [matchannel,data_count]=fread(fid,[width,height],'double');
     if(data_count~= num_data_per_Chnl)
         A=[];
         fclose(fid);
         return;
     end
     A(:,:,i)=matchannel';
 end

fclose(fid);


end