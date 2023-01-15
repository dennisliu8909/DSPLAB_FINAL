function [LL1,H1,V1,HH1, LL2, H2, V2, HH2] = DWT_layer2(image, wname)
    %% DWT of original image
    % first stage DWT
    [LL1,H1,V1,HH1] = dwt2(image,wname,'mode','per');
    
    % second stage DWT
    [LL2, H2, V2, HH2] = dwt2(LL1, wname,'mode','per');
    
end