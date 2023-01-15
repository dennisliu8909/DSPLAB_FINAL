function watermark_out = WatermarkFetch(target_V3, quant_bit, watermark_row, watermark_col)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quantize original image first
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imageQ = ImQuant(target_V3, quant_bit);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fetch watermark out from embeded image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[row, col, channel] = size(imageQ)

mean_value = mean(imageQ, 'all')
watermark_out = zeros(watermark_row, watermark_col);

for ch = 1:channel
    for r = 1:watermark_row
        for c = 1:watermark_col
            current_binary_pixel = de2bi(imageQ(r,c,ch), "left-msb");
            if (imageQ(r,c,ch) > mean_value)
                watermark_out(r,c) = current_binary_pixel(end - 1);
            else
                watermark_out(r,c) = current_binary_pixel(end);
            end

        end
    end
end

end