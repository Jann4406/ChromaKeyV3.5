function ret = yuv2rgb(yuv)
    y = yuv(:, :, 1);
    u = yuv(:, :, 2);
    v = yuv(:, :, 3);
    r = y + 1.4075*v;
    g = y - 0.3455.*u - 0.7169.*v;
    b = y + 1.779.*u;
    ret = cat(3, r, g, b);
end