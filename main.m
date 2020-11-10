% File Type:     Matlab
% Author:        Hutao {hutaonice@gmail.com}
% Creation:      星期一 04/12/2019 15:55.
% Last Revision: 星期一 04/12/2019 15:55.

clear;clc;close all
dbstop if error

%% Config

Height = 1080;
Width = 1920;
clusters = 1;
sample_step = 5;
bg_img_path = '/home/x4406/Documents/nano_matting/cuda_version/bg.jpg';
img_path = '/home/x4406/Documents/nano_matting/cuda_version/8_an';


%% initialization

mask = false(1080, 1920);
mask(200:887, 234:1479) = true;
mask = imresize(mask, [Height, Width], 'nearest');
bg_rgb = imresize(imread(bg_img_path), [Height, Width],'bicubic');
img_files = dir(fullfile(img_path,'*.png'));
img = imresize(imread(fullfile(img_path, img_files(5).name)), [Height, Width]);%why is img_files(5).name
key_colors_yuv = find_key_color(img, mask, clusters, sample_step);

%% matting

cnt = 0;
while true
    cnt = mod(cnt + 1, length(img_files)) + 1;

    img = imresize(imread(fullfile(img_path, img_files(cnt).name)), [Height, Width]);
    img = double(img) ./ 255;
    [res_rgb, res_alpha] = ck_pixel2_plus(img, key_colors_yuv, 2);
    res_alpha = res_alpha .* double(mask);
    
    fused_rgb = TaotaoFuseBasic(res_rgb*255, bg_rgb, res_alpha);
    imshow(fused_rgb);
    drawnow
end
