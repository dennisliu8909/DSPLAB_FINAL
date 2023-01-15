%% rgb2yuv 
% 1. matrix: [a,b,c] = [a b c]
%    matrix: [a;b;c] = [a b c]'
%
% 2. zeros: create an array of 0
% zeros(3) = [ 0 0 0 
%              0 0 0 
%              0 0 0 ]
% zeros(2,5) = [ 0 0 0 0 0
%                0 0 0 0 0 ]
% data type of zeros() is preset "double".
% To use other data type such as 'uint8' => zeros(2,5,'uint8')
% show the result on command window to help yourself understand 

%% data type
% 1. data type of RGB channel is preset "uint8", range 0-255
% assume that Y = R+G+B; if R+G+B > 255, Y will be assigned the maximum 255,
% so we need to calculate in data type "double" using im2double()

%% function
% input---source image: I
% output---image in YUV: I_yuv
function I_yuv = rgb2yuv(I)
    
    % Convert from [0, 255] to [0, 1] (uint8 to double)
    I = im2double(I);  
    
    % RGB channel
    R = I(:, :, 1);
    G = I(:, :, 2);
    B = I(:, :, 3);
    % get height, width, channel of the image
    [height, width, channel] = size(I);

    % initial the intensity array Y using zeros()
    Y = zeros(height, width);
    U = zeros(height, width);
    V = zeros(height, width);

    % weight of RGB channel
    matrix = [0.299 0.587 0.114;
              -0.169 -0.331 0.5;
              0.5 -0.419 -0.081];

    % The range is scaled to [0, 1], so scale 128 to 128/255 as well
    offset = [0 128/255 128/255]';

    % implement the rgb to yuv convertion
    %%% your code here
    %%
    for h = 1:height
        for w = 1:width
            RGB = [R(h, w) G(h, w) B(h, w)]';            
            onepixel = matrix * RGB + offset;
            Y(h, w) = onepixel(1);            
            U(h, w) = onepixel(2);
            V(h, w) = onepixel(3);
        end
    end
    %%
    % save YUV to output image
    I_yuv(:, :, 1) = Y;
    I_yuv(:, :, 2) = U;
    I_yuv(:, :, 3) = V;
end
