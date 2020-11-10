% fg_rgb: H*W*C foreground image
% key_colors_yuv: clusters*C key color in yuv space
% threshold: 1*1 float a hyper parameter
% ret: green reduced image
% reta: result alpha
function [ret, reta] = ck_pixel2_plus(fg_rgb, key_colors_yuv, threshold)
    src_rgb = fg_rgb;

    sa = ones(numel(src_rgb)./3, 1);

    res_rgb = src_rgb;
    res_a = sa;

    ret = res_rgb;
    reta = res_a;

    fg_yuv = rgb2yuv(fg_rgb);
    y0 = key_colors_yuv(:, 1);
    u0 = key_colors_yuv(:, 2);
    v0 = key_colors_yuv(:, 3);
    y = fg_yuv(:, :, 1);
    u = fg_yuv(:, :, 2);
    v = fg_yuv(:, :, 3);

    flag = 0;
    if flag
        figure(1)
        plot(u(1:10:end), v(1:10:end), '.');
        hold on
        plot(u0(1), v0(1), 'ro')
        plot(u0(2), v0(2), 'ro')
        plot(u0(3), v0(3), 'ro')
        grid on
        axis equal
        axis([-0.5 0.5 -0.5 0.5])
    end

    ym = mean(y0(:));
    um = mean(u0(:));
    vm = mean(v0(:));
    u0v0m = sqrt([um, vm] * [um; vm]);

    x = ((v.*vm + u.*um)) ./ u0v0m;
    z = ((v.*um - u.*vm)) ./ u0v0m;

    alpha = deg2rad(80);

    pick = (abs(z) > x.*tan(alpha));
    pick = ~pick(:);

    x_ = z ./ tan(alpha);
    y_ = z;
%     kbg = (x - x_) ./ u0v0m;
    resy = y;% - kbg.*ym;
    resu = (x_.*um - y_.*vm) ./ u0v0m;
    resv = (x_.*vm + y_.*um) ./ u0v0m;

    % resa = 1 - kbg;
    tdist = taotao_dist([u(:), v(:)], [u0(:), v0(:)], threshold, u0v0m);

    % tdist = min(tdist(:), resa(:));

    resa = min(1, max(0, tdist));
    res_rgb = yuv2rgb(cat(3, resy, resu, resv));
    res_rgb = reshape(res_rgb, [], 3);
    
    g = res_rgb(:, 2);
    rbm = max(res_rgb(:, [1, 3]), [], 2);
    g = min(g, rbm);

    ret = reshape(ret, [], 3);
    ret(pick, :) = res_rgb(pick, :);
    ret(:, 2) = g;
    reta(pick) = resa(pick);
    ret = reshape(ret, size(fg_rgb, 1), [], 3);
    reta = reshape(reta, size(fg_rgb, 1), []);
end
