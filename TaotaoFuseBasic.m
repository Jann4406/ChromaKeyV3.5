function fused_img_rgb = ...
        TaotaoFuseBasic(fg_rgb, bg_rgb, Alpha)

    Alpha_rep = repmat(Alpha, 1, 1, size(fg_rgb, 3));
    fg_yuv = rgb2yuv(double(fg_rgb)./255);
    bg_yuv = rgb2yuv(double(bg_rgb)./255);
    
    fused_y = fg_yuv(:, :, 1).*Alpha + bg_yuv(:, :, 1).*(1-Alpha);
%     fused_y = imgaussfilt(fused_y, 1.5);
    Alpha = imgaussfilt(Alpha, 1.5);
    edge_pick = Alpha > 0.1 & Alpha < 0.8;

    fused_y_blur = imgaussfilt(fused_y, 3, 'filtersize', 5);

    fused_y(edge_pick) = fused_y_blur(edge_pick);
    
    
    fused_img_rgb = Alpha_rep .* double(fg_rgb) + ...
                        (1 - Alpha_rep) .* double(bg_rgb);
    fused_img_yuv = rgb2yuv(double(fused_img_rgb)./255);
    fused_img_yuv(:, :, 1) = fused_y;
    fused_img_rgb = uint8(yuv2rgb(fused_img_yuv).*255);

end
