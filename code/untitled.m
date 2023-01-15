function [outputArg1,outputArg2] = untitled(inputArg1,inputArg2)

%% read watermark
img_w = imread('../data/nthu.jpg');
img_w = im2gray(im2double(img_w));
img_w = imbinarize(img_w);
% img partition 4
img_w4x4 = mat2cell(img_w, size(img_w,1)/2 * ones(1,2), size(img_w,2)/2 * ones(1,2), size(img_w,3));
img_w1 = img_w4x4{1,1};
img_w2 = img_w4x4{1,2};
img_w3 = img_w4x4{2,1};
img_w4 = img_w4x4{2,2};
% % dct2 to watermark
% % img_w = dct2(img_w);
% % class(img_w)
% embed watermark to dct image
emb_part1(:,:,channel) = QIM_embeded(emb_part1(:,:,channel), img_w1, delta);
emb_part2(:,:,channel) = QIM_embeded(emb_part2(:,:,channel), img_w2, delta);
emb_part3(:,:,channel) = QIM_embeded(emb_part3(:,:,channel), img_w3, delta);
emb_part4(:,:,channel) = QIM_embeded(emb_part4(:,:,channel), img_w4, delta);

%% show embeded part
for c = 1:chnl
    emb_part1(:,:,c) = rescale(idct2(emb_part1(:,:,c)));
    emb_part2(:,:,c) = rescale(idct2(emb_part2(:,:,c)));
    emb_part3(:,:,c) = rescale(idct2(emb_part3(:,:,c)));
    emb_part4(:,:,c) = rescale(idct2(emb_part4(:,:,c)));
end
figure
imshow(emb_part3)

%% show whole embeded image
img4x4{1,1} = emb_part1;
img4x4{1,2} = emb_part2;
img4x4{2,1} = emb_part3;
img4x4{2,2} = emb_part4;
embed_img = cell2mat(img4x4);
figure
imshow(embed_img);

%% resize attack
% Image Reshpae
reshape_scale = 1;
embed_img_R = imresize(embed_img, reshape_scale);
%% Gaussian attack
% embeded_image_G = awgn(embed_img,10,'measured');
%% Fetch the watermark from embeded image
emb_img4x4 = mat2cell(embed_img_R, size(embed_img_R,1)/2 * ones(1,2), size(embed_img_R,2)/2 * ones(1,2), size(embed_img_R,3))
emb_part1 = emb_img4x4{1,1};
emb_part2 = emb_img4x4{1,2};
emb_part3 = emb_img4x4{2,1};
emb_part4 = emb_img4x4{2,2};
embed_img_ch1 = emb_part1(:,:,channel);
embed_img_ch2 = emb_part2(:,:,channel);
embed_img_ch3 = emb_part3(:,:,channel);
embed_img_ch4 = emb_part4(:,:,channel);

% show Resize image
figure('Name',"resize_img")
imshow(embed_img_R);
target1 = dct2(embed_img_ch1);
target2 = dct2(embed_img_ch2);
target3 = dct2(embed_img_ch3);
target4 = dct2(embed_img_ch4);
watermark_out1 = QIM_detected(target1, img_w, delta, reshape_scale);
watermark_out2 = QIM_detected(target2, img_w, delta, reshape_scale);
watermark_out3 = QIM_detected(target3, img_w, delta, reshape_scale);
watermark_out4 = QIM_detected(target4, img_w, delta, reshape_scale);
C = {watermark_out1,watermark_out2; watermark_out3, watermark_out4};
watermark_out = cell2mat(C);
figure
imshow(watermark_out);

end