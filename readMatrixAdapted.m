function check = readMatrixAdapted()
%data read
global rcMatrix; global indMatrix; global Irows; global Icols; global halfWindow;
if 1 %leggo la 600 x 600 STEP e ne estraggo gli indici
    %fid = './optimisedPatches/xStep_row600x600_step2.txt';
    fid = './optimisedPatches/xStep_row600x600_step3.txt';
    y = dlmread(fid);
    dimy = y(1:Irows-halfWindow*2,1:Icols-halfWindow*2);
    if 1 %adaptation to edge
       fR = dimy(1,:);
       for i = length(fR):-1:1
           if fR(i) == 0
               dimy(:,i) = dimy(:,1);
           else
               break
           end
       end
       fC = dimy(:,1);
       for i = length(fC):-1:1
           if fC(i) == 0
               dimy(i,:) = dimy(1,:);
           else
               break
           end
       end                    
    end
    indMatrix = find(dimy);
    [tempa,tempb] = find(dimy);
    rcMatrix = [tempa,tempb];
end
check = true;
end
