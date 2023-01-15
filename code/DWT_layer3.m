function [LL1,H1,V1,HH1, LL2, H2, V2, HH2, LL3, H3, V3, HH3] = DWT_layer3(image, wname)
%% DWT of original image
[LL1,H1,V1,HH1] = dwt2(image,wname,'mode','per');
% first stage DWT
% size(LL1)
% figure
% subplot(2,2,1);
% imshow(LL1)
% subplot(2,2,2);
% imshow(H1)
% subplot(2,2,3);
% imshow(V1)
% subplot(2,2,4);
% imshow(HH1)
% second stage DWT
[LL2, H2, V2, HH2] = dwt2(LL1, wname,'mode','per');
% size(LL2)
% figure
% subplot(2,2,1);
% imshow(LL2)
% subplot(2,2,2);
% imshow(H2)
% subplot(2,2,3);
% imshow(V2)
% subplot(2,2,4);
% imshow(HH2)
% Third stage DWT
[LL3, H3, V3, HH3] = dwt2(LL2, wname,'mode','per');
% size(LL3)
% figure
% subplot(2,2,1);
% imshow(LL3)
% subplot(2,2,2);
% imshow(H3)
% subplot(2,2,3);
% imshow(V3)
% subplot(2,2,4);
% imshow(HH3)

end