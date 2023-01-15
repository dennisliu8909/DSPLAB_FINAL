function imageQ = QIM_embeded(image, message, delta, alpha)

imageQ = image;
[message_r, message_c] = size(message);

for r = 1:message_r
    for c = 1:message_c
        imageQ(r, c) = round(image(r, c) / delta) * delta + ((-1) ^ (message(r,c))) * (delta / 4);
        imageQ(r, c) = imageQ(r, c) + alpha  * (image(r, c) - imageQ(r, c));        
    end
end

%     imageQ = image;
%     [H, W] = size(message);
%     
% 
%     for row=1:H
%         for col=1:W
%             quant_to = round(imageQ(row,col)/delta);
%             if mod(quant_to,2) == message(row, col)
%                 quant_vector = 0;
%             else 
%                 quant_vector = -1;
%             end
% 
%             imageQ(row,col) = (quant_to + 0.5 + quant_vector) * delta;
%         end 
%     end

end