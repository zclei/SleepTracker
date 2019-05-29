function outi = binn_ratio(inpi,bs,di)
% 1-D binning
% inpi: imput data
% ds: binning size
% di: dimension
bs = uint16(bs);
if nargin<3
    di = 1;
else
    di_or = 1:length(size(inpi));
    di_tar = di_or;
    di_tar(di_tar==di) =1;
    di_tar(1) = di;
    inpi = permute(inpi,di_tar);
end
    
    [orw, orl, c]=size(inpi);
    
    
    res = double(rem(orw,bs));
    fiw=(orw-res)/double(bs);
    
%     outi=zeros(fiw,orl,c);
 
 
    
    ori=reshape(inpi(1:end-res,:),bs,fiw,orl,c);
    
    ori=squeeze(nanmean(ori));
    if res>1
        last = squeeze(nanmean(inpi(end-res+1:end,:)));
        ori = [ori;last];
    end
    
    if di==1
        outi = ori;
    else
        outi=permute(ori,di_tar);
    end
    
    clear orw orl fil c i;
    
    return
 
   
    
        
    
    
    
    
    
    
    
    
    
    
    
    
  
    