% -- fnolse(Im, type_noise)
%    Inputs: -Im the noisy image
%            -type_noise in { 'gaussian', 'salt & pepper', 'exponential', 
%               'poisson', 'speckle' }
%    Ouputs: v1D v2D (variance estimation in 1D and 2D)
%            comment2, comment1 : results with comments
%            image_v : variance corresponding to the norm of the four 
%               measures (2D version)
%            vip, vin : variances for salt&pepper noise (vip: salt component,
%               vin: pepper component)   
%
%    Noise estimator in images
%    C. Olivier LALIGANT, 2009-10
%
%    Ref :   O. Laligant, F. Truchetet, E. Fauvet, ''Noise estimation
%           from digital step-model signal'', IEEE Trans. Image Processing,
%           2013 Dec., 22(12):5158:67
%
%    No optimization !
%
%    Tested on octave (+package image) and Matlab V7R14
%
function [v2D, v1D, comment2, comment1, image_v, vip, vin] = fnolse(Im, type_noise)

%size(Im)
if(nargin == 2) 
else
	comment = sprintf('nolse(Image, ''type_noise''); \n');
	%disp(comment);
	comment = printf(' ''type_noise'' = {''gaussian'', ''salt & pepper'', ''exponential'', ''poisson'', ''speckle''} \n');
	%disp(comment);
	return;
end
border = 1; % border preservation
% verif. dim. for 1D estimators
[ni, nj] = size(Im);
a12=0; a34=0;
if((nj-2*border) > 1) a12=1;
end
if((ni-2*border) > 1) a34=1;
end
if( (a12==0) & (a34==0) ) disp('pb dimensions');
	return;
end 

% dim. verif. for 2D estimators
if((a12 == 0) | (a34 == 0))
	disp('1D Signal => nonvalid 2D operators !');
end

% --- y1 estimator ---
yjp = min(DjLp(Im), -DjRn(Im) );
y1 = min(DiLp(yjp), -DiRn(yjp));
v1 = mse(y1, border) * 4;
% 1D estimator
s2_1 = mse(yjp, border) / (pi/8);

% --- y2 estimator ---
yjn = -min(DjRp(Im), -DjLn(Im));
y2 = -min( DiRp(yjn), -DiLn(yjn) );
v2 = mse(y2, border) * 4; 
% 1D estimator
s2_2 = mse(yjn, border) / (pi/8);

% --- y3 estimator ---
yip = min( DiLp(Im), -DiRn(Im) );
y3 = min( DjLp(yip), -DjRn(yip) );
v3 = mse(y3, border) * 4;
% 1D estimator
s2_3 = mse(yip, border) / (pi/8);

% --- y4 estimator ---
yin = -min( DiRp(Im), -DiLn(Im) );
y4 = -min(DjRp(yin), -DjLn(yin));
v4 = mse(y4, border) *4;
% 1D estimator
s2_4 = mse(yin, border) / (pi/8);

% mean of the estimators
s2 = (a12*s2_1 + a12*s2_2 + a34*s2_3 + a34*s2_4)/(2*a12+2*a34);
v = (v1 + v2 + v3 + v4) / 4;
image_v = sqrt(y1.^2+y2.^2+y3.^2+y4.^2);
vp = (v1 + v3) / 4;
vn = (v2 + v4) / 4;

comment = sprintf('v1 2 3 4 : %f %f %f %f\n', v1, v2, v3, v4);
comment = sprintf('s1 2 3 4 : %f %f %f %f\n', s2_1, s2_2, s2_3, s2_4);

switch(type_noise) 
	case {'salt & pepper'}
        v1D = s2; % default
        v2D = 0; % default
 		e=1/0.82269;    % slope correction
		K =  1.2036;    % model correction
		vi = K * v^e;
		vip = K*(v^e/2*(1-e) + e*v^(e-1)*vp);
		vin = K*(v^e/2*(1-e) + e*v^(e-1)*vn);
		comment1 = sprintf('Salt & pepper (2D) nolse estimator : %f\n', s2);
		comment2 = sprintf('   salt : %f   pepper : %f\n', vip, vin);
	case {'speckle'}
		comment1 = sprintf('Speckle noise\n'); 
		comment2 = sprintf('2D nolse estimator: variance = %f\n', v);
        v1D = -1;
        v2D = v;
        vip = 0; vin = 0;
	case {'poisson'}
		comment1 = sprintf('Poisson noise\n'); 
		comment2 = sprintf('2D nolse estimator: lambda = %f\n', v);
        v1D = -1;
        v2D = v;
        vip = 0; vin = 0;
	case {'gaussian'}
		comment = sprintf('Gaussian noise\n');
		comment1 = sprintf('1D nolse estimator: variance = %f\n', s2);
		comment2 = sprintf('2D nolse estimator: variance = %f\n', v); 
        v1D = s2;
        v2D = v;
        vip = 0; vin = 0;
	case {'exponential'}
		comment = sprintf('Exponential noise : p(x)=1/2B.exp(-|x|/B)\n');
		m = mean(mean((yjp-yjn)*a12+(yip-yin)*a34))/(2*a12+2*a34);
        v1D = 8/3*m;
		comment1 = sprintf('1D nolse estimator = %f\n', v1D);
		m = mean(mean(y1-y2+y3-y4))/4;
        v2D = sqrt(2)*8/3*m;
        vip = 0; vin = 0;
		comment2 = sprintf('2D nolse estimator = %f\n', v2D); 
	otherwise
		disp('Noise not handled');
		comment1 = sprintf('other case: gaussian 1D nolse estimator : %f\n', s2);
		comment2 = sprintf('other case: gaussian 2D nolse estimator : %f\n', v);
        v1D = s2;
        v2D = v;
        vip = 0; vin = 0;
end

end%function %nolse

% operators D+, D- 
function yjLp = DjLp(Im)
	yjLp = thresh0(conv2(Im, [0 1 -1], 'same'));
end%function

function yjRn = DjRn(Im)
	yjRn = -thresh0(-conv2(Im, [1 -1 0], 'same'));
end%function

function yiLp = DiLp(Im)
	yiLp = thresh0(conv2(Im, [0; 1; -1], 'same'));
end%function

function yiRn = DiRn(Im)
	yiRn = -thresh0(-conv2(Im, [1;  -1; 0], 'same'));
end%function

function yjRp = DjRp(Im)
	yjRp = thresh0(conv2(Im, [1 -1 0], 'same'));
end%function

function yjLn = DjLn(Im)
	yjLn = -thresh0(-conv2(Im, [0 1 -1], 'same'));
end%function

function yiRp = DiRp(Im)
	yiRp = thresh0(conv2(Im, [1; -1; 0], 'same'));
end%function

function yiLn = DiLn(Im)
	yiLn = -thresh0(-conv2(Im, [0;  1; -1], 'same'));
end%function
% end operators D+, D-

function st = thresh0(s)
	st = s.*(sign(s)+1)/2;
end%function


