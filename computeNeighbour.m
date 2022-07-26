function IDXV = computeNeighbour()
global Irows; global Icols;
global halfWindow; global localSearchArea;

linArrRow = 1:(Irows-halfWindow*2);
linArrCol = 1:(Icols-halfWindow*2);
[arrCol,arrRow] = meshgrid(linArrCol,linArrRow);
V = [arrRow(:),arrCol(:)];
IDXV = zeros(length(V),4*(localSearchArea+1) * (localSearchArea+1));
for i = 1:length(V)
    index = zeros(1,(localSearchArea+1)*(localSearchArea+1)*4);
    x = V(i,1);
    y = V(i,2);
    mx = max(1,x-localSearchArea);
    Mx = min(Irows-2*halfWindow,x+localSearchArea);
    my = max(1,y-localSearchArea);
    My = min(Icols-2*halfWindow,y+localSearchArea);
    [mgrx,mgry] = meshgrid(mx:Mx,my:My);
    pts = [mgrx(:),mgry(:)];
    for ii = 1:length(pts)
        index(ii) = sub2ind([Irows-halfWindow*2,Icols-halfWindow*2],pts(ii,1),pts(ii,2));
    end
    IDXV(i,:) = index;
end



end