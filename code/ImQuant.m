function imageQ = ImQuant(image, quant_bit)
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

end
