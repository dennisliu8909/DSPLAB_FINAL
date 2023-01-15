function imageQ = ImQuantization(image, quant_num)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantize the image to quant_num in the range for max(image) and min(image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im = [1, 2, 3; 4, 5, 6; 7, 8, 9];
image = im;

maxV = max(image, [], 'all')
minV = min(image, [], 'all')
Q_stair = (maxV - minV) / quant_num;

im_Q = image(:,:) ./ Q_stair

% imageQ = image(:,:) / 

end
