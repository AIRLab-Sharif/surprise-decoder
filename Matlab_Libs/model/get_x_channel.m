function X = get_x_channel(x, Param, channel_number)

    X = x(:, channel_number, Param.steps.ind_all);
    X = reshape(permute(X, [1, 3, 2]), size(X, 1), []);

end
