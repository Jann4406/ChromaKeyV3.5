% File Type:     Matlab
% Author:        Hutao {hutaonice@gmail.com}
% Creation:      星期五 04/12/2019 14:10.
% Last Revision: 星期三 04/12/2019 20:03.

% img: H*W*C RGB image
% mask: H*W logical
% clusters: 1*1 uint number of clusters needed
% sample_step: 1*1 uint jumping distance of sampling image

function key_colors_yuv = find_key_color(img, mask, clusters, sample_step)
    mask_idx = find(mask);%size(mask_idx) = 857248;

    assert(all(size(mask) == size(squeeze(img(:, :, 1)))), 'img must have the same h w with mask');
    assert(length(mask_idx) >= clusters, 'abnormal mask');

    sampled_mask_idx = mask_idx(1:sample_step:end);%size(sampled_mask_idx) = 171450;

    n_samples = length(sampled_mask_idx);
    % samples = zeros(3, n_samples);

    img = reshape(img, [], 3);%transform 1080*1920*3 matrix to 2073600*3 matrix.[R G B]
    
    samples = double(img(sampled_mask_idx, :))./255;%size(img(sampled_mask_idx, :)) = 171450*3;
    
%     disp(size(img()));
%     disp(size(img(:)));
%     disp(size(img([5,6,7],:)));
%     disp(img([5,6,7],:));
%     disp(size(img(sampled_mask_idx, :)));
    
    [idx, C, sumD, D] = kmeans(samples, clusters);
    
% K-means聚类算法采用的是将N*P的矩阵X划分为K个类，使得类内对象之间的距离最大，而类之间的距离最小。
% 使用方法：
% Idx=Kmeans(X,K)
% [Idx,C]=Kmeans(X,K)
% [Idc,C,sumD]=Kmeans(X,K)
% [Idx,C,sumD,D]=Kmeans(X,K)
% 各输入输出参数介绍：
% X---N*P的数据矩阵
% K---表示将X划分为几类，为整数
% Idx---N*1的向量，存储的是每个点的聚类标号
% C---K*P的矩阵，存储的是K个聚类质心位置
% sumD---1*K的和向量，存储的是类内所有点与该类质心点距离之和
% D---N*K的矩阵，存储的是每个点与所有质心的距离

    [sumD, sort_idx] = sort(sumD, 'descend');

    cumS = cumsum(sumD);

    threshold = 0;
    for i = 1:length(sumD)
        if sumD(i) / n_samples < 1 / clusters, break; end
        threshold = sumD(i);
        if cumS(i) / n_samples > 0.75, break; end
    end

    C = C(sort_idx, :);

    C(sumD < threshold, :) = [];

    key_colors_yuv = reshape(rgb2yuv(reshape(C, 1, [], 3)), [], 3);
end

