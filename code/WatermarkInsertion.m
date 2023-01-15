function [embeded_image, scale] = WatermarkInsertion(image, watermark, quant_bit)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantize the image to quant_num in the range for max(image) and min(image)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     im = [1, 2, 3; 4, 5, 6; 7, 8, 9];
%     image = im;
%     quant_bit = 10;
quant_num = 2 ^ quant_bit;

maxV = max(image, [], 'all');
minV = min(image, [], 'all');
% quantization num = (max - min) / q_num
Q_stair = (maxV - minV) / (quant_num - 1);
% substract base line
image = image - minV;
% quantize
imageQ = floor(image(:,:) ./ Q_stair);    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% insert watermark to quantized image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate quantization image mean value

quant_mean = mean(imageQ, 'all')
[im_r, im_c, channel] = size(imageQ)
[mark_r, mark_c] = size(watermark)

% make sure watermark can put into image

if (max([mark_r mark_c]) > min([im_r im_c]))
    scale = min([im_r im_c]) / max([mark_r mark_c]);
    watermark = imresize(watermark, scale);
else
    scale = 1;
end

[valid_r, valid_c] = size(watermark)
% use LSB two bits to hind watermark, the threshold is quantized mean value

for ch = 1:channel
    for row = 1:valid_r
        for col = 1:valid_c
            binary_imageQ_pixel = de2bi(imageQ(row, col, ch), 'left-msb');
            if (imageQ(row,col,ch) > quant_mean)
                binary_imageQ_pixel(end - 1) = watermark(row, col);
            else
                binary_imageQ_pixel(end) = watermark(row, col);
            end 
            imageQ(row, col, ch) = bin2dec(sprintf('%d', binary_imageQ_pixel));
        end
    end
end

% restore = q * step + min
  embeded_image = imageQ .* Q_stair + minV;

end

% imageQ(1,1)
% quant_mean = 512.22
% pixel = de2bi(imageQ(1,1), 'left-msb')
% pixel(end) = 1
% pixel(end-1) = 1
% ans = bin2dec(sprintf('%d', pixel))
% 
% embeded_image = quant_mean;