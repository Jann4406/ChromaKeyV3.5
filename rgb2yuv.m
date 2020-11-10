function ret = rgb2yuv(rgb)
    r = rgb(:, :, 1);
    g = rgb(:, :, 2);
    b = rgb(:, :, 3);
    y = 0.299.*r + 0.587.*g + 0.114.*b;
    u = -0.169.*r - 0.331.*g + 0.5.*b;
    v = 0.5.*r - 0.419.*g - 0.081.*b;
    ret = cat(3, y, u, v);
end