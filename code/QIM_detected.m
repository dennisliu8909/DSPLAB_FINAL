function watermark_out = QIM_detected(target, message, delta, reshape_scale, alpha)
%% Target_quantization part Requantize
watermark_out = imresize(message, reshape_scale);
[valid_row, valid_col]= size(target);
message0 = zeros([valid_row, valid_col]);
message1 = ones([valid_row, valid_col]);

emb0 = QIM_embeded(target, message0, delta, (-alpha/delta));
emb1 = QIM_embeded(target, message1, delta, (-alpha/delta));

distance0 = abs(target - emb0);
distance1 = abs(target - emb1);

for r = 1:valid_row
    for c = 1:valid_col
        if (distance0(r,c) > distance1(r,c))
            watermark_out(r,c) = 1;
        else
            watermark_out(r,c) = 0;
        end
    end       
end


%     [H, W] = size(imresize(message, reshape_scale));
%     watermark_out = zeros([H,W]);        
%     
% 
%     for row = 1:H
%         for col = 1:W
%             px = mod(round(target(row,col)/ delta - 0.5),2);
%             watermark_out(row,col) = px;
%         end
%     end

end
