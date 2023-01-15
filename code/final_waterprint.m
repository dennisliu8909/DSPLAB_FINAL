%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script tests your implementation of seamCarving function, and you can 
% also use it for resizing your own images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clear all
clear; close all; clc;

%% User interface menu
stage = 0;
exit = 8;
while stage ~= exit
    stage = menu('Image Watermarking Procedure',...
    '1. Load Host Image',...
    '2. Select transformation (DWT / SVD)',...
    '3. Read the watermark ',...
    '4. Mark the host image and store embeded image',...
    '5. Attack/degrade the marked image',...
    '6. Detect and extract the watermark image',...
    '7. PSNR test',...
    '8. Exit ');    
    %% 1. Load data
    if (stage == 1)
        [file, path] = uigetfile(fullfile(pwd,'../data','*.jpg;*.png'), 'select a host image');
        image_path = fullfile(path,file);
        image = imread(image_path);
        image = im2double(image);
%         disp(image)
        figure('Name', "ori_img")
        imshow(image);
        channel = 3;
        alpha = 0.2;
        image_ch = image(:,:,channel);
        sz = size(image_ch);  
    end
    %% 2. Select Method(DWT/SVD...)
    if (stage == 2)
        method = menu('Method Selection', ...
                 '1. DWT + QIM', ...
                 '2. DWT + SVD', ...
                 '3. DWT + DCT + QIM',...
                 'Exit');
        if (method == 1)
            fprintf('Your selected method is: DWT + QIM');

            %%%%%%%%%%%%% DWT of original image %%%%%%%%%%%%%            
            wname = 'haar';
            [LL1,H1,V1,HH1, LL2, H2, V2, HH2, LL3, H3, V3, HH3] = DWT_layer3(image_ch , wname);
            hidden_part = LL2;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif (method == 2)
            fprintf('Your selected method is DWT + SVD');
            %%%%%%%%%%%%% DWT of original image %%%%%%%%%%%%%
            wname = 'haar';
            [LL1,H1,V1,HH1, LL2, H2, V2, HH2] = DWT_layer2(image_ch, wname);  
            hidden_part = H2;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif(method == 3)
            fprintf('Your selected method is: DWT + DCT + QIM');
            %%%%%%%%%%%%% DWT of original image %%%%%%%%%%%%%
            wname = 'haar';
            [LL1,H1,V1,HH1, LL2, H2, V2, HH2, LL3, H3, V3, HH3] = DWT_layer3(image_ch , wname);
            hidden_part = V2;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            fprintf('You should select one method!');
        end

    end
    %% 3. Select water mark
    if (stage == 3)        
        [file, path] = uigetfile(fullfile(pwd,'../data','*.jpg; *.png'));
        watermark_path = fullfile(path, file);
        image_water = imread(watermark_path);
        image_water = im2double(image_water);
        image_water = im2gray(image_water);
        image_water = imresize(image_water, [128,128]);
        
        [im_r, im_c] = size(hidden_part);
        [mark_r, mark_c, chl] = size(image_water);
        
        % make sure watermark can put into image
        
        if (max([mark_r mark_c]) > min([im_r im_c]))
            scale = min([im_r im_c]) / max([mark_r mark_c]);
            image_water = imresize(image_water, scale);
        else
            scale = 1;            
        end
        
        % watermark to binary
        [watermark_row, watermark_col] = size(image_water)
        
        image_water = imbinarize(image_water);
        image_water = ~image_water;        
        figure
        imshow(image_water);
    end    
    %% 4. insert the watermark to image
    if (stage == 4)
        if (method == 1)
            % quantize the HH3 part of original image
            delta = 1.4;
            embed_LL2_A = QIM_embeded(hidden_part, image_water, delta, alpha);            
            % Inverse DWT
            LL2_A = idwt2(LL3, H3, V3, HH3, wname);
            LL1_A = idwt2(embed_LL2_A, H2, V2, HH2, wname);
            embeded_image_ch = idwt2(LL1_A, H1, V1, HH1, wname);
            embeded_image = image;
            embeded_image(:,:,channel) = embeded_image_ch;
            figure('Name', "emb_img");
            imshow(embeded_image);
            imwrite(embeded_image, fullfile(pwd, '../result', 'embeded_img.jpg'));
        elseif(method==2)
            [embed_HH2,Uw,Vw] = SVD_embeded(hidden_part, image_water);

            % Inverse DWT
            LL1_A = idwt2(LL2, H2, V2, embed_HH2, wname, 'mode', 'per');
            embeded_image_ch = idwt2(LL1_A, H1, V1, HH1, wname, 'mode', 'per');
            embeded_image = image;
            embeded_image(:,:,channel) = embeded_image_ch;
            figure('Name', "emb_img");
            imshow(embeded_image);
            imwrite(embeded_image, fullfile(pwd, '../result', 'embeded_img.jpg'));
        elseif (method == 3)
            % quantize the HH3 part of original image
            delta = 3;
            % Conduct DCT to hidden part and use QIM to embed wateremark
            embed_dct_part = dct2(hidden_part);
            image_water_dct = dct2(image_water);
            embed_dct_part = embed_dct_part + image_water_dct * 0.01;
            % embed_dct_part = QIM_embeded(embed_dct_part, image_water, delta);   
            % inverse DCT
            embed_V2 = rescale(idct2(embed_dct_part));
            % Inverse DWT
            LL2_A = idwt2(LL3, H3, V3, HH3, wname);
            LL1_A = idwt2(LL2_A, H2, embed_V2, HH2, wname);
            embeded_image_ch = idwt2(LL1_A, H1, V1, HH1, wname);
            embeded_image = image;
            embeded_image(:,:,channel) = embeded_image_ch;
            figure('Name', "emb_img");
            imshow(embeded_image);
            imwrite(embeded_image, fullfile(pwd, '../result', 'embeded_img.jpg'));
        end
    end
    %% 5. Select attack for embeded image
    if (stage == 5)
        attack = menu('Attack selection', ...
            '1. No attack',...
            '2. Gaussian noise', ...
            '3. Resize attack', ...
            '4. Cropping attack',...            
            'Exit');
        if (attack == 1)
            reshape_scale = 1;
            embeded_image_ch = embeded_image(:,:,channel);        
        elseif (attack == 2)
            % Add some Gaussian noise
            reshape_scale = 1;
            embeded_image_G = awgn(embeded_image, 10,'measured');
            embeded_image_ch = embeded_image_G(:,:,channel);        
            % show Gaussian noise image
            figure('Name',"gaussian_noise_img")
            imshow(embeded_image_G);
        elseif (attack == 3)
            % Image Reshpae
            reshape_scale = 0.8;
            embeded_image_R = imresize(embeded_image, reshape_scale);
            embeded_image_ch = embeded_image_R(:,:,channel);
            % show Resize image
            figure('Name',"resize_img")
            imshow(embeded_image_R);
            
        elseif (attack == 4)
            % Image Crop            
            [H, W, C] = size(embeded_image);
            crop_length = 150;
            reshape_scale = 1;
            embeded_image_C = imcrop(embeded_image, [0, 0, (H-crop_length), (W-crop_length)]);
            embeded_image_ch = embeded_image_C(:,:,channel);
            % show Cropped image
            figure('Name',"crop_img")
            imshow(padarray(embeded_image_C, [150,150], 0, 'post'));
        end
    end
    %% 6. Detect Watermark from embeded image
    if (stage == 6)
        if (method == 1)
            % Conduct DWT to image again
            [LL1,H1,V1,HH1, target_LL2, H2, V2, HH2, LL3, H3, V3, HH3] = DWT_layer3(embeded_image_ch, wname);
            % fetch watermark from embeded image
            watermark_out = QIM_detected(target_LL2, image_water, delta, reshape_scale, alpha);
            figure('Name', "noise_watermark");
            imshow(watermark_out);
            imwrite(watermark_out, fullfile(pwd, '../result', 'watermark_out.jpg'));
            watermark_out = cast(watermark_out, 'double');
        elseif(method==2)
            % Conduct DWT to image again
            [LL1,H1,V1,HH1, LL2, H2, V2, target_HH2] = DWT_layer2(embeded_image_ch, wname);
            % fetch watermark from embeded image
            watermark_out = SVD_detected(target_HH2, Uw, Vw);
            figure('Name', "noise_watermark");
            imshow(watermark_out);
            imwrite(watermark_out, fullfile(pwd, '../result', 'watermark_out.jpg'));
            reshape_scale = 1;
            watermark_out = cast(watermark_out, 'double');
        elseif (method == 3)
            % Conduct DWT to image again
            [LL1,H1,V1,HH1, LL2, H2, target_V2, HH2, LL3, H3, V3, HH3] = DWT_layer3(embeded_image_ch, wname);
            % Conduct DCT to selected part
            select_part = dct2(target_V2);
            % fetch watermark from embeded image
            watermark_out = QIM_detected(select_part, image_water, delta, reshape_scale, alpha);
            figure('Name', "noise_watermark");
            imshow(watermark_out);
            imwrite(watermark_out, fullfile(pwd, '../result', 'watermark_out.jpg'));
        end
    end
    %% 7. PSNR test 
    if (stage == 7)
        sprintf("psnr host image=");
        disp(psnr(embeded_image, image));
        sprintf("psnr watermark");
        % image resize
        image_water_final = imresize(image_water, reshape_scale);
        image_water_final = cast(image_water_final, 'like', watermark_out);
        disp(psnr(watermark_out, image_water_final));
    end
end



% clear; close all; clc;

