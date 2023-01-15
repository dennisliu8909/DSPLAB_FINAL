function [imageQ,Uw,Vw] = SVD_embeded(hiden_part, image_water)
    % SVD to hiden part and watermark
    image_water = im2double(image_water);
    [U1, S1, V1] = svd(hiden_part);
    [Uw, Sw, Vw] = svd(image_water);
    
    % Adjust the ratio of embed image component
    ALPHA = 0.05;
    threshold = 0.9;

    % Calculate # of dominate singular value
    total = 0;
    for i=1:1:128
        total = total + S1(i,i);    
    end
    dominate = total * threshold;
    num_sin_value = 0;
    cnt = 0;
    for i = 1:1:128
        num_sin_value = num_sin_value + 1;
        cnt = cnt + S1(i,i);
        if cnt >= dominate
            break
        end
    end

    for i = 1:1:num_sin_value
        S1(i,i) = S1(i,i) + ALPHA * Sw(i,i);
    end

    imageQ = U1*S1*V1';
end