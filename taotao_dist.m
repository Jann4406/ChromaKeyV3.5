function dist = taotao_dist(X, key, dt, nm)
    dist_fun = @(X, T) (sqrt(sum((X-T).^2, 2))./nm);
    sigmoid = @(X) (1 ./ (1 + exp(-3.*(X + dt))));
    n = size(key, 1);
    e = 0;
    for i = 1:n
        e = e - 1./(dist_fun(X, reshape(key(i, :), 1, 2)).^2 + 1e-8);
    end
    e = e / n;
    dist = sigmoid(e);
end
