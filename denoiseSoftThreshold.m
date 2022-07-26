function [Imv,Image] = denoiseSVD(patch,factor)
%Denoise patch with SVD soft-thresholding
global Stack; global NSIG;
if 1 % my method
     [U,S,V] = svd(patch,'econ');
     mdS = max(diag(S));
     lambda = mdS * factor;
     %lambda = lambda * 255.0;
     temp = S - lambda;
     ind = find( temp>0);
     svp = length(ind);
     SigmaX = max(temp(ind),0);
     Image = U(:,1:svp)*diag(SigmaX)*V(:,1:svp)';
     Imv = Image(:);
end
if 0 %WNNM
    [U,S,V] = svd(patch,'econ'); 
    TempC  = C*sqrt(Stack)*2*NSIG^2;
    temp=(SigmaY-eps).^2-4*(C-eps*S);
    ind=find (temp>0);
    svp=length(ind);
    SigmaX=max(S(ind)-eps+sqrt(temp(ind)),0)/2;   
    Image = U(:,1:svp)*diag(SigmaX)*V(:,1:svp)';
    Imv = Image(:);
end




end